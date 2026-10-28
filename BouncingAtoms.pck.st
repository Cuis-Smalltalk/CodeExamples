'From Cuis7.9 [latest update: #8296] on 28 October 2026 at 3:59:31 pm'!
'Description A port of Bouncing Atoms with the atoms in a SystemWindow. A pop-up menu enables selection of options, including an active plot of infection history, also in a SystemWindow.'!
!provides: 'BouncingAtoms' '1.42.0'!
!requires: 'UI-Widgets' '1.0.0' '*.*.*'!
!requires: 'Morphic-Deprecated' '1.0.0' '*.*.*'!
!requires: 'UI-Shapes' '1.48.0' '1.*.*'!
SystemOrganization addCategory: #BouncingAtoms!


!classDefinition: #BouncingAtomsMorph category: #BouncingAtoms!
BorderedBoxMorph subclass: #BouncingAtomsMorph
	instanceVariableNames: 'infectionHistory transmitInfection recentTemperatures temperature historyWindow nAtoms fpsEnabled fps fpsCurrentFrameCount fpsCurrentFrameCountTime resume'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BouncingAtoms'!
!classDefinition: 'BouncingAtomsMorph class' category: #BouncingAtoms!
BouncingAtomsMorph class
	instanceVariableNames: ''!

!classDefinition: #AtomMorph category: #BouncingAtoms!
EllipseMorph subclass: #AtomMorph
	instanceVariableNames: 'velocity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BouncingAtoms'!
!classDefinition: 'AtomMorph class' category: #BouncingAtoms!
AtomMorph class
	instanceVariableNames: ''!

!classDefinition: #HeaterCoolerAtom category: #BouncingAtoms!
AtomMorph subclass: #HeaterCoolerAtom
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BouncingAtoms'!
!classDefinition: 'HeaterCoolerAtom class' category: #BouncingAtoms!
HeaterCoolerAtom class
	instanceVariableNames: ''!

!classDefinition: #InfectionGraph category: #BouncingAtoms!
FunctionGraphMorph subclass: #InfectionGraph
	instanceVariableNames: 'data points yScaleFactor startTime deltaT ticN tics yFactor xFactor resumed hoverPoint'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BouncingAtoms'!
!classDefinition: 'InfectionGraph class' category: #BouncingAtoms!
InfectionGraph class
	instanceVariableNames: ''!


!BouncingAtomsMorph commentStamp: 'dhn 7/4/2015 17:01' prior: 0!
This morph shows how simulation of an ideal gas might work. When the morph gets step messages, it makes all its atom submorphs move along their velocity vectors, bouncing when they hit the window sides. It also exercises the Morphic damage reporting and display architecture. Here are some things to try:

  1. Resize this morph as the atoms bounce around.
  2. Use the pop-up menu, try the available choices.
  3. Switch the shape of atoms from ellipse to rectangle.
  4. Start an infection.
  5. Show infection history.
  6. Start another infection with the history window open.
  7. Set the atom count, then
     add a Heater/Cooler Atom(s), then
     start an infection and note the effect as atoms pass over the Heater/Cooler Atom(s).
  8. Repeatedly start an infection with the same atoms from step 7.!

!AtomMorph commentStamp: '<historical>' prior: 0!
AtomMorph represents an atom used in the simulation of
an ideal gas. It's container is typically a BouncingAtomsMorph.

Try:

	BouncingAtomsMorph  initializedInstance openInWorld

to open the gas simulation or:

	AtomMorph example

to open an instance in the current world!

!HeaterCoolerAtom commentStamp: 'dhn 7/4/2015 13:53' prior: 0!
A heater atom or a cooler atom, its temperature determined by the sign of its velocityDelta property.!

!InfectionGraph commentStamp: 'dhn 5/11/2016 15:55' prior: 0!
Normalize the number of infected atoms, treat them as a time series, and plot them in a graph.!

!BouncingAtomsMorph methodsFor: 'other' stamp: 'jmv 3/Sep/2024, 3:25:34 am (UTC)'!
addAtoms: n
	"Add a bunch of new atoms."

	nAtoms := n.
	n timesRepeat: [
		| a |
		a := AtomMorph new.
		self addMorph: a.
		a randomPositionIn: self localBounds maxVelocity: 10.].
	historyWindow ifNotNil: [historyWindow yScaleFactor: n].
	self stopStepping.
! !

!BouncingAtomsMorph methodsFor: 'other' stamp: 'dhn 8/Oct/2015, 1:29:00 am (UTC)'!
collisionPairs
	"Return a list of pairs of colliding atoms, which are assumed to be
circles of known radius. This version uses the morph's positions--i.e.
the top-left of their bounds rectangles--rather than their centers."

	| count sortedAtoms radius twoRadii radiiSquared collisions p1 continue j p2 distSquared m1 m2 |
	count := submorphs size.
	sortedAtoms := submorphs 
				asSortedCollection: [:mt1 :mt2 | mt1 morphPosition x < mt2 morphPosition x].
	radius := 8.
	twoRadii := 2 * radius.
	radiiSquared := radius squared * 2.
	collisions := OrderedCollection new.
	1 to: count - 1
		do: 
			[:i | 
			m1 := sortedAtoms at: i.
			p1 := m1 morphPosition.
			continue := (j := i + 1) <= count.
			[continue] whileTrue: [
				m2 := sortedAtoms at: j.
				p2 := m2 morphPosition.
				continue := p2 x - p1 x <= twoRadii  
					ifTrue: [
						distSquared := (p1 x - p2 x) squared + (p1 y - p2 y) squared.
						distSquared < radiiSquared 
							ifTrue: [
								((m1 class == HeaterCoolerAtom) and: m2 class == HeaterCoolerAtom)
									ifFalse: [
										collisions add: (Array with: m1 with: m2).
										m1 valueOfProperty: #velocityDelta ifPresentDo: [:x |
											m2 velocity:  m2 velocity * (100 + x) / 100.0].
										m2 valueOfProperty: #velocityDelta ifPresentDo: [:x |
											m1 velocity:  m1 velocity * (100 + x) / 100.0]]].
								(j := j + 1) <= count]
							ifFalse: [false]]].
	^collisions! !

!BouncingAtomsMorph methodsFor: 'other' stamp: 'dhn 20/Jun/2016, 1:50:00 am (UTC)'!
reportInfection
	"Produce a graph of infection history"
	| count |
	self collisionPairs do: [:pair | | infected |
		infected := false.
		pair do: [:atom | atom infected ifTrue: [infected := true]].
		infected
			ifTrue: [pair do: [:atom | atom infected: true]]].

	count := 0.
	self submorphsDo: [:m | m infected ifTrue: [count := count + 1]].
	count > 0 ifTrue: [infectionHistory addLast: count].
	historyWindow ifNotNil: [
		historyWindow 
			data: infectionHistory;
			yScaleFactor: nAtoms;
			plotData].
	count = nAtoms ifTrue: [
		transmitInfection := false.
		self stopStepping].
! !

!BouncingAtomsMorph methodsFor: 'other' stamp: 'dgd 22/Feb/2003, 8:36:00 pm (UTC)'!
updateTemperature: currentTemperature 
	"Record the current temperature, which is taken to be the number of atoms that have bounced in the last cycle. To avoid too much jitter in the reading, the last several readings are averaged."

	recentTemperatures isNil 
		ifTrue: 
			[recentTemperatures := OrderedCollection new.
			20 timesRepeat: [recentTemperatures add: 0]].
	recentTemperatures removeLast.
	recentTemperatures addFirst: currentTemperature.
	temperature := recentTemperatures sum asFloat / recentTemperatures size! !

!BouncingAtomsMorph methodsFor: 'submorphs-add/remove' stamp: ''!
addMorphFront: aMorph
	"Called by the 'embed' meta action. We want non-atoms to go to the back."
	"Note: A user would not be expected to write this method. However, a sufficiently advanced user (e.g, an e-toy author) might do something equivalent by overridding the drag-n-drop messages when they are implemented."

	(aMorph isMemberOf: AtomMorph)
		ifTrue: [super addMorphFront: aMorph]
		ifFalse: [super addMorphBack: aMorph].! !

!BouncingAtomsMorph methodsFor: 'initialization' stamp: 'dgd 7/Mar/2003, 9:14:00 pm (UTC)'!
defaultColor
"answer the default color/fill style for the receiver"
	^ Color
		r: 0.8
		g: 1.0
		b: 0.8! !

!BouncingAtomsMorph methodsFor: 'initialization' stamp: 'dhn 11/Jun/2016, 6:26:00 pm (UTC)'!
initialize
	"initialize the state of the receiver"
	super initialize.
	fpsEnabled _ false.
	fps _ 0.
	fpsCurrentFrameCount _ 0.
	fpsCurrentFrameCountTime _ 0.
	resume _ true.
	self reset.! !

!BouncingAtomsMorph methodsFor: 'initialization' stamp: 'jmv 16/Jun/2015, 4:58:00 pm (UTC)'!
reset
	infectionHistory := OrderedCollection new.
	infectionHistory add: 0.
	transmitInfection _ false.
! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'dhn 20/May/2015, 6:08:00 pm (UTC)'!
drawAsRect
	"Toggle the #drawAsRect property"
	self 
		setProperty: #drawAsRect 
		toValue: (self valueOfProperty: #drawAsRect) not
! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'dhn 24/Apr/2015, 1:05:00 am (UTC)'!
handlesMouseDown: aMouseButtonEvent
	^ true! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'jmv 3/Sep/2024, 3:25:38 am (UTC)'!
installHeaterCooler
	"Replace a regular atom with a heater/cooler atom"
	| non x |

	non := self submorphs select: [:a | (a hasProperty: #velocityDelta) not].
	non ifNotEmpty: [	
		
		non shuffled first delete.	"Take away an atom"
		nAtoms := nAtoms - 1.

		x := HeaterCoolerAtom new.
		x randomPositionIn: self localBounds maxVelocity: 10.
		self addMorph: x]	"Add an atom"
! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'dhn 11/Jun/2016, 6:41:00 pm (UTC)'!
mouseButton2Activity
	"Show a pop-up menu"
	| tuples list index |
	
	tuples _ #(
		#('Set Atom Count...' 			#setAtomCount) 
		#('Start Infection' 				#startInfection) 
		#('Show Infection History' 		#showInfectionHistory) 
		#('Toggle Atom as Rectangle' 	#drawAsRect) 
		#('Heater/Cooler Atom' 		#installHeaterCooler) 
		#('Toggle FPS' 					#toggleFPS) 
		#('Pause/Resume' 				#pauseResume)).
		
	list _ tuples collect: [ :ea | ea first ].
	index _ (PopUpMenu labelArray: list) startUpWithCaption: 'Bouncing Atoms'.
	index > 0 ifTrue: [ self perform: ((tuples at: index) at: 2) ].! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'dhn 11/Jun/2016, 6:37:00 pm (UTC)'!
pauseResume
	"Toggle the action"
	
	resume _ resume not! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'jmv 12/Sep/2024, 7:25:33 pm (UTC)'!
setAtomCount

	| countString count |
	countString := StringRequestMorph 
		request: 'Number of atoms?' 
		initialAnswer: self submorphCount printString.
	countString isEmpty ifTrue: [^ self].
	self removeAllMorphs.
	count := countString asNumber.
	self addAtoms: count.
	self reset.
	self startStepping.! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'jmv 2/Jan/2017, 4:09:53 pm (UTC)'!
showInfectionHistory
	"Show a graph of the infection history"
	historyWindow _ InfectionGraph new.
	historyWindow 
		data: infectionHistory;
		yScaleFactor: nAtoms;
		domain: (0 to: 10);
		yRange: (0 to: 10);
		setXYFactors;
		plotData.
	(historyWindow embeddedInMorphicWindowLabeled: 'Infection History') openInWorld
! !

!BouncingAtomsMorph methodsFor: 'menu' stamp: 'dhn 4/Jun/2016, 2:45:00 am (UTC)'!
startInfection
	"Introduce one infected atom in the collection"
	| non |
	
	non _ self submorphs select: [:a | (a hasProperty: #velocityDelta) not].
	non ifNotEmpty: [	
		non do: [:ea | ea infected: false].	"disinfect"
		non shuffled first infected: true].	"randomly infect one"
	
	infectionHistory := OrderedCollection new.
	infectionHistory add: 0.
	transmitInfection := true.
	self startStepping.
! !

!BouncingAtomsMorph methodsFor: 'drawing' stamp: 'jmv 16/Aug/2015, 2:50:00 am (UTC)'!
drawOn: aCanvas
	super drawOn: aCanvas.
	fpsEnabled ifTrue: [
		aCanvas fillRectangle: (10@10 extent: 20@15) color: Color lightGray.
		aCanvas
			drawString: fps asString
			at: 10 @ 10
			font: nil
			color: Color black ].! !

!BouncingAtomsMorph methodsFor: 'testing' stamp: 'jmv 16/Aug/2015, 6:41:00 pm (UTC)'!
is: aSymbol
	^aSymbol == #BouncingAtomsMorph or: [ super is: aSymbol ]! !

!BouncingAtomsMorph methodsFor: 'testing' stamp: 'pb 17/Jul/2015, 4:07:00 am (UTC)'!
stepTime
	"desired step time in milliseconds: 0 to update as often as possible, 17 for ~60fps, 33 for ~30fps.  Note: at 30fps and above, Morphic will not reliably match the requested framerate"
	^ 33.! !

!BouncingAtomsMorph methodsFor: 'stepping and presenter' stamp: 'dhn 11/Jun/2016, 7:13:00 pm (UTC)'!
stepAt: millisecondSinceLast
	"Bounce those atoms!!"
	| r bounces |
	
	historyWindow ifNotNil: [historyWindow resumed: resume].
	
	resume ifTrue: [
		bounces := 0.
		r := 0 @ 0 corner: self morphExtent - (8 @ 8).
		self submorphsDo: [ :m |
			(m is: #AtomMorph) ifTrue: [
				(m bounceIn: r) ifTrue: [ bounces := bounces + 1 ]]].
		"compute a 'temperature' that is proportional to the number of bounces
		 divided by the circumference of the enclosing rectangle"
		self updateTemperature: 10000.0 * bounces / (r width + r height).
		transmitInfection ifTrue: [ self reportInfection ].
		fpsEnabled ifTrue: [
			fpsCurrentFrameCountTime < 1000
				ifTrue: [
					fpsCurrentFrameCount := fpsCurrentFrameCount + 1.
					fpsCurrentFrameCountTime _ fpsCurrentFrameCountTime + millisecondSinceLast.
					]
				ifFalse: [
					fps := fpsCurrentFrameCount.
					fpsCurrentFrameCount := 1.
					fpsCurrentFrameCountTime _ 0 ]].
		self redrawNeeded]
	
! !

!BouncingAtomsMorph methodsFor: 'submorphs-accessing' stamp: 'jmv 16/Aug/2015, 4:15:00 am (UTC)'!
submorphsDrawingOutsideReverseDo: aBlock
	"All our submorphs are inside us"! !

!BouncingAtomsMorph methodsFor: 'as yet unclassified' stamp: 'pb 17/Jul/2015, 2:59:00 am (UTC)'!
toggleFPS
	fpsEnabled _ fpsEnabled not! !

!BouncingAtomsMorph methodsFor: 'stepping' stamp: 'pb 2/Jul/2015, 8:00:00 am (UTC)'!
wantsSteps
	^ true! !

!BouncingAtomsMorph class methodsFor: 'class initialization' stamp: 'dhn 8/Nov/2015, 3:34:00 am (UTC)'!
how
"
	Start from World->New morph... menu or:
	BouncingAtomsMorph open.
"! !

!BouncingAtomsMorph class methodsFor: 'class initialization' stamp: 'jmv 10/May/2016, 4:40:00 pm (UTC)'!
initializedInstance
	"Establish the window with some bouncing atoms"
	| win morph |
	
	morph _ self new.
	win _ morph embeddedInMorphicWindowLabeled: 'Bouncing Atoms'.
	win setProperty: #minimumExtent toValue: 88@85.
	morph setProperty: #drawAsRect toValue: false.
	
	"ensure good initial atom distribution and movement"
	morph morphExtent: win morphExtent.
	morph addAtoms: 30.
	
	^ win! !

!BouncingAtomsMorph class methodsFor: 'class initialization' stamp: 'dhn 8/Nov/2015, 3:34:00 am (UTC)'!
open
"
	Start from World->New morph... menu or:
	BouncingAtomsMorph open.
"

	self initializedInstance openInHand! !

!AtomMorph methodsFor: 'private' stamp: 'jm 11/Aug/1998, 12:40:00 am (UTC)'!
bounceIn: aRect
	"Move this atom one step along its velocity vector and make it bounce if it goes outside the given rectangle. Return true if it is bounced."

	| p vx vy px py bounced |
	p := self morphPosition.		"dhn 4/4/2015"
	vx := velocity x.		vy := velocity y.
	px := p x + vx.		py := p y + vy.
	bounced := false.
	px > aRect right ifTrue: [
		px := aRect right - (px - aRect right).
		vx := velocity x negated.
		bounced := true].
	py > aRect bottom ifTrue: [
		py :=  aRect bottom - (py - aRect bottom).
		vy := velocity y negated.
		bounced := true].
	px < aRect left ifTrue: [
		px := aRect left - (px - aRect left).
		vx := velocity x negated.
		bounced := true].
	py < aRect top ifTrue: [
		py :=  aRect top - (py - aRect top).
		vy := velocity y negated.
		bounced := true].
	self morphPosition: px @ py.	"dhn 4/4/2015"
	bounced ifTrue: [self velocity: vx @ vy].
	^ bounced
! !

!AtomMorph methodsFor: 'initialization' stamp: 'dgd 7/Mar/2003, 9:13:00 pm (UTC)'!
defaultBorderWidth
"answer the default border width for the receiver"
	^ 0! !

!AtomMorph methodsFor: 'initialization' stamp: 'dgd 7/Mar/2003, 9:13:00 pm (UTC)'!
defaultColor
"answer the default color/fill style for the receiver"
	^ Color blue! !

!AtomMorph methodsFor: 'initialization' stamp: 'jmv 16/Jun/2015, 4:58:00 pm (UTC)'!
initialize
	"Make a new atom with a random position and velocity."
	super initialize.
""
	self morphExtent: 8 @ 7.
	self
		randomPositionIn: (0 @ 0 corner: 300 @ 300)
		maxVelocity: 10! !

!AtomMorph methodsFor: 'initialization' stamp: 'jmv 16/Jun/2015, 4:57:00 pm (UTC)'!
randomPositionIn: aRectangle maxVelocity: maxVelocity
	"Give this atom a random position and velocity."

	| origin xtent |
	origin := aRectangle origin.
	xtent := (aRectangle extent - self morphExtent) rounded.
	self morphPosition:	
		(origin x + xtent x atRandom) @
		(origin y + xtent y atRandom).
	velocity :=
		(maxVelocity - (2 * maxVelocity) atRandom) @
		(maxVelocity - (2 * maxVelocity) atRandom).
! !

!AtomMorph methodsFor: 'drawing' stamp: 'jmv 3/Sep/2024, 3:25:42 am (UTC)'!
drawOn: aCanvas
	"Note: Set 'drawAsRect' to true to make the atoms draw faster. When testing the speed of other aspects of Morphic, such as its damage handling efficiency for large numbers of atoms, it is useful to make drawing faster."

	| drawAsRect |
	drawAsRect := owner valueOfProperty: #drawAsRect.
	drawAsRect 
		ifNil: [super drawOn: aCanvas]
		ifNotNil: [
			drawAsRect 	"rectangles are faster to draw"
				ifTrue: [aCanvas fillRectangle: self localBounds color: color]
				ifFalse: [super drawOn: aCanvas]]! !

!AtomMorph methodsFor: 'accessing' stamp: ''!
infected

	^ color = Color red! !

!AtomMorph methodsFor: 'accessing' stamp: 'dhn 4/Jun/2015, 12:57:00 am (UTC)'!
infected: aBoolean

	(self valueOfProperty: #velocityDelta) ifNil: [
		aBoolean
			ifTrue: [self color: Color red]
			ifFalse: [self color: Color blue]]! !

!AtomMorph methodsFor: 'accessing' stamp: ''!
velocity

	^ velocity! !

!AtomMorph methodsFor: 'accessing' stamp: ''!
velocity: newVelocity

	velocity := newVelocity.! !

!AtomMorph methodsFor: 'testing' stamp: 'jmv 16/Aug/2015, 6:40:00 pm (UTC)'!
is: aSymbol
	^aSymbol == #AtomMorph or: [ super is: aSymbol ]! !

!AtomMorph methodsFor: 'updating' stamp: 'jmv 16/Aug/2015, 6:41:00 pm (UTC)'!
redrawNeeded

	(owner is: #BouncingAtomsMorph) ifFalse: [
		super redrawNeeded ]! !

!AtomMorph class methodsFor: 'examples' stamp: 'dhn 5/Apr/2015, 12:41:00 am (UTC)'!
example
	"
	AtomMorph example
	"
	|a b|
	a _ AtomMorph new openInWorld. 
	a color: Color random.
	b _ Display boundingBox.
 	[1000 timesRepeat:  [a bounceIn: b.  (Delay forMilliseconds: 20) wait]. 
	 a delete] fork.! !

!AtomMorph class methodsFor: 'new-morph participation' stamp: 'di 22/Jun/1997, 4:07:00 pm (UTC)'!
includeInNewMorphMenu
	"Not to be instantiated from the menu"
	^ false! !

!HeaterCoolerAtom methodsFor: 'private' stamp: 'dhn 17/Jun/2015, 5:59:00 pm (UTC)'!
bounceIn: aRect

	^ super bounceIn: aRect
! !

!HeaterCoolerAtom methodsFor: 'initialization' stamp: 'dhn 8/Oct/2015, 2:14:00 am (UTC)'!
defaultColor
	"Set the color of the receiver based on property #velocityDelta"
	
	self valueOfProperty: #velocityDelta ifPresentDo: [:x |
	x < 0
		ifTrue: [^ Color white ]
		ifFalse: [^ Color lightRed]]! !

!HeaterCoolerAtom methodsFor: 'initialization' stamp: 'jmv 12/Sep/2024, 7:25:37 pm (UTC)'!
initialize
	| f x |
	f := StringRequestMorph
		request: '-100 < factor < 100 % Cooler/Hotter' 
		initialAnswer: '-10'.
	x := f asNumber.
	(x > -100 and: x < 100) 
		ifTrue: [self setProperty: #velocityDelta toValue: x]
		ifFalse: [self setProperty: #velocityDelta toValue: 0].
	color := self defaultColor.
	super initialize.
	self borderWidth: 1
! !

!HeaterCoolerAtom methodsFor: 'drawing' stamp: 'dhn 18/Jun/2015, 1:02:00 am (UTC)'!
drawOn: aCanvas

	super drawOn: aCanvas! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 12/May/2016, 5:50:00 pm (UTC)'!
asNormalizedPoints: aCollection
	"Answer an array of points which are mapped on [0, T] in both dimensions, where T is a multiple of 10"
	| yArray xArray result |
	
	aCollection size == 2 ifTrue: [
		self ticN: 1000.
		self startTime: Time localMillisecondClock.
		tics _ OrderedCollection new].
	((deltaT _ Time localMillisecondClock - self startTime) > self ticN) ifTrue: [
		self tics add: aCollection size.
		ticN _ ticN + 1000].
	yArray _ yFactor * (self normalize: aCollection asOrderedCollection with: yScaleFactor).
	xArray _ xFactor * (self normalize: (0 to: aCollection size) asArray).
	
	result _ OrderedCollection new.
	1 to: yArray size	do: [ :i | result add: (xArray at: i) @ (yArray at: i) ].
	
	^ result.! !

!InfectionGraph methodsFor: 'drawing' stamp: 'BAP 9/Aug/2024, 12:52:42 pm (UTC)'!
drawOn: aCanvas
	| fully |
	fully := 10 raisedTo: yMax log asInteger.

	aCanvas line: (self toMorphic:0@yMin) to: (self toMorphic: 0 @ yMax) width: 2 color: Color lightGray.
	aCanvas line: (self toMorphic: xMin@0) to: (self toMorphic: xMax@0) width: 2 color: Color lightGray.
	aCanvas line: (self toMorphic: 0@fully) to: (self toMorphic: xMax@fully) width: 2 color: Color lightRed.

	points ifNotNil: [
		1 to: points size - 1 do: [:n | | p fromPoint toPoint |
			fromPoint := (self toMorphic: (p := points at: n)).
			toPoint := (self toMorphic: (points at: n + 1)).
			aCanvas 	"continue the graph"
				line: fromPoint 	"from point"
				to: toPoint 	"to point"
				width: 2 color: Color black.
			(self tics includes: n) ifTrue: [
				aCanvas 	"plot the tic"
					line: (self toMorphic: (p x) @ 0) 
					to: (self toMorphic: (p x) @ (self class ticLength)) 
					width: 2 color: Color lightGray].
			hoverPoint ifNotNil: [|font hoverString|
				((hoverPoint x  >= fromPoint x) and: [hoverPoint x <= toPoint x])  ifTrue: [
					font := (FontFamily familyName: 'DejaVu Sans' pointSize: 12).
					aCanvas
						line:  hoverPoint x@(self yToMorphic: yMin)
						to: hoverPoint x@fromPoint y
						width: 2
						color: Color green.
						hoverString := (p x truncateTo: 0.1) asString, ' @ ', (p y truncateTo: 0.1) asString.
					aCanvas
						drawString: hoverString
						at: (hoverPoint x - ((font widthOfString: hoverString)/2))@(fromPoint y- font lineSpacing )
						font: font
						color: Color green
						embossed: true]]]]! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 23/May/2015, 6:50:00 pm (UTC)'!
normalize: aCollection
	"Answer aCollection divided by its maximum"
	| max |
	max _ aCollection inject: 0 into: [:a :c | (a > c)
		ifTrue: [a]
		ifFalse: [c]].
	^ OrderedCollection new
		addAll: aCollection / (max * 1.0)! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 27/May/2015, 3:09:00 am (UTC)'!
normalize: aCollection with: aFactor
	"Answer aCollection divided by its maximum and scaled by maximum/aFactor"
	| max |
	max _ aCollection inject: 0 into: [:a :c | (a > c)
		ifTrue: [a]
		ifFalse: [c]].
	^ OrderedCollection new
		addAll: (aCollection / (max * 1.0)) * (max / aFactor)! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 20/Jun/2016, 3:46:00 am (UTC)'!
plotData
	"Re-normalize data"

	data size > 1 ifTrue: [
		points _ self asNormalizedPoints: data.
		self redrawNeeded]! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 12/May/2016, 5:39:00 pm (UTC)'!
startTime
	"Answer the value of startTime"
	
	startTime ifNil: [startTime _ Time localMillisecondClock].
	^ startTime! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 12/May/2016, 5:49:00 pm (UTC)'!
ticN
	"Answer the value of ticN"
	
	ticN ifNil: [ticN _ 1000].
	^ ticN! !

!InfectionGraph methodsFor: 'drawing' stamp: 'dhn 12/May/2016, 5:19:00 pm (UTC)'!
tics
	"Answer the value of tics"
	
	tics ifNil: [tics _ OrderedCollection new].
	^ tics! !

!InfectionGraph methodsFor: 'accessing' stamp: 'dhn 23/May/2015, 11:09:00 pm (UTC)'!
data: aCollection

	data _ aCollection
! !

!InfectionGraph methodsFor: 'accessing' stamp: 'dhn 11/Jun/2016, 7:13:00 pm (UTC)'!
resumed: anObject
	"Set the value of resumed"

	resumed _ anObject! !

!InfectionGraph methodsFor: 'accessing' stamp: 'dhn 11/May/2016, 9:06:00 am (UTC)'!
startTime: anObject
	"Set the value of startTime"

	startTime _ anObject! !

!InfectionGraph methodsFor: 'accessing' stamp: 'dhn 12/May/2016, 5:15:00 pm (UTC)'!
ticN: anObject
	"Set the value of ticN"

	ticN _ anObject! !

!InfectionGraph methodsFor: 'accessing' stamp: 'dhn 26/May/2015, 7:25:00 pm (UTC)'!
yScaleFactor: aNumber

	yScaleFactor _ aNumber
! !

!InfectionGraph methodsFor: 'event handling testing' stamp: 'pb 16/Jul/2017, 10:35:43 pm (UTC)'!
handlesMouseHover
	^ true! !

!InfectionGraph methodsFor: 'event handling testing' stamp: 'pb 18/Jul/2017, 1:11:48 pm (UTC)'!
handlesMouseOver: aMorphicEvent
	^ true! !

!InfectionGraph methodsFor: 'events' stamp: 'pb 16/Jul/2017, 10:44:18 pm (UTC)'!
mouseHover: event localPosition: localPosition
	hoverPoint := localPosition.
	self redrawNeeded ! !

!InfectionGraph methodsFor: 'events' stamp: 'pb 18/Jul/2017, 1:12:45 pm (UTC)'!
mouseLeave: evt
	hoverPoint := nil.
	self redrawNeeded ! !

!InfectionGraph methodsFor: 'initialization' stamp: 'dhn 12/May/2016, 4:17:00 am (UTC)'!
setXYFactors
	"Set the values of xFactor and yFactor"

	xFactor _ 10 raisedTo: xMax log asInteger.
	yFactor _ 10 raisedTo: yMax log asInteger
! !

!InfectionGraph class methodsFor: 'display' stamp: 'dhn 11/May/2016, 11:01:00 pm (UTC)'!
ticLength
	"Answer the length of tic marks"
	
	^ 0.2! !
