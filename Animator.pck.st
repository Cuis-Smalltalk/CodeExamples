'From Cuis7.9 [latest update: #8296] on 28 October 2026 at 12:54:10 pm'!
'Description Simple animation for random Morph instances'!
!provides: 'Animator' '1.25.0'!
!requires: 'Cuis-Base' '7.9.8296' '7.*.*'!
!requires: 'UI-Shapes' '1.48.0' '1.*.*'!
!requires: 'Graphics-Files-Additional' '1.30.0' '1.*.*'!
SystemOrganization addCategory: #Animator!


!classDefinition: #Animator category: #Animator!
Object subclass: #Animator
	instanceVariableNames: 'actor action stepTime doneProc stepping'
	classVariableNames: 'Animators ButterflyForms'
	poolDictionaries: ''
	category: 'Animator'!
!classDefinition: 'Animator class' category: #Animator!
Animator class
	instanceVariableNames: ''!


!Animator commentStamp: '<historical>' prior: 0!
My instances animate individual Morphs without subclassing via stepping.
This means animations are asynchronous/non-blocking.

actor -- the morph acted upon
action -- a one argument closure which gets the actor morph as an argument
stepTime -- the step time increment
doneProc -- a one arg closure which answers false if animation is to continue

-- see examples in class siide


Note: Blue Butterfly used in 'Animator class>>imageCyclingExample' 
is a scale reduced image set originally derived from one by Dontmind8.com
with a Creative Commons 4 licence file (reproduced below)

-------------------
-------------------
IMPORTANT NOTICE: This license only applies if you downloaded this content as
a free user. 

---------------------

You must attribute the digital products to Dontmind8.com:

In order to use a content or a part of it, you must attribute it to Dontmind8.com,
so we will be able to continue creating new digital resources every day.


How to attribute it?

For websites:

Please, copy this code on your website to accredit the author:
<a href="http://www.Dontmind8.com">From Dontmind8</a>

For printing:

Paste this text on the final work so the authorship is known.
- For example, in the acknowledgements chapter of a book:
"From Dontmind8.com"


You are free to use this digital product:

- For both personal and commercial projects and to modify it.
- In a website or presentation template or application or as part of your design.

You are not allowed to:

- Sub-license, resell or rent it.
- Include it in any online or offline archive or database.

The terms of the license are described in https://creativecommons.org/licenses/by/4.0/


The terms described in the above link have precedence over the terms described
in the present document. In case of disagreement, the Creative Commons Attribution 4.0 Terms of Use will prevail.
-------------------!

!Animator methodsFor: 'accessing' stamp: 'KenD 10/May/2021, 6:39:56 pm (UTC)'!
action

	"Add a guard for un-owned Morphs"
	^ [ :aMorph | aMorph ifNotNil: [ aMorph owner ifNotNil: [action value: aMorph]]]! !

!Animator methodsFor: 'accessing' stamp: 'KenD 20/Sep/2013, 11:53:00 am (UTC)'!
action: aOneArgClosure

	action := aOneArgClosure! !

!Animator methodsFor: 'accessing' stamp: 'KenD 20/Sep/2013, 11:51:00 am (UTC)'!
actor

	^ actor! !

!Animator methodsFor: 'accessing' stamp: 'KenD 20/Sep/2013, 11:52:00 am (UTC)'!
actor: aMorph

	actor := aMorph! !

!Animator methodsFor: 'accessing' stamp: 'KenD 27/Feb/2015, 9:45:00 pm (UTC)'!
doneProc

	^doneProc! !

!Animator methodsFor: 'accessing' stamp: 'KenD 27/Feb/2015, 9:45:00 pm (UTC)'!
doneProc: aOneArgClosure

	doneProc := aOneArgClosure! !

!Animator methodsFor: 'accessing' stamp: 'KenD 20/Sep/2013, 11:53:00 am (UTC)'!
stepTime

	^ stepTime! !

!Animator methodsFor: 'accessing' stamp: 'KenD 20/Sep/2013, 11:54:00 am (UTC)'!
stepTime: millisecondsToNextStep

	stepTime := millisecondsToNextStep! !

!Animator methodsFor: 'accessing' stamp: 'KenD 21/Aug/2015, 12:18:00 am (UTC)'!
world
	"I am not directly associated with any particular world"
	
	^ nil ! !

!Animator methodsFor: 'initialize-release' stamp: 'KenD 6/May/2019, 5:35:17 pm (UTC)'!
actor: aMorph action: aOneArgClosure stepTime: milllisecondsBetweenSteps

	self actor: aMorph;
	      action: aOneArgClosure;
	      stepTime: milllisecondsBetweenSteps;
		 doneProc: [ :iaMorph | false ].  "never done -> loops continuously"
	aMorph setProperty: #animator toValue: self.
	^self
! !

!Animator methodsFor: 'initialize-release' stamp: 'KenD 6/May/2019, 9:58:28 pm (UTC)'!
actor: aMorph action: oneArgClosure stepTime: milllisecondsBetweenSteps doneProc: predicateClosure

	self actor: aMorph;
	      action: oneArgClosure;
	      stepTime: milllisecondsBetweenSteps;
		 doneProc: predicateClosure.
	aMorph setProperty: #animator toValue: self.
	^self
	! !

!Animator methodsFor: 'stepping' stamp: 'jmv 15/May/2015, 12:32:00 am (UTC)'!
isStepping
	stepping  ifNil: [stepping _ false ].
	^stepping ! !

!Animator methodsFor: 'stepping' stamp: 'KenD 20/Sep/2013, 12:27:00 pm (UTC)'!
shouldGetStepsFrom: aWorld

	^ true! !

!Animator methodsFor: 'stepping' stamp: 'jmv 15/May/2015, 12:32:00 am (UTC)'!
startStepping
	"Start stepping the receiver"
	
	| w |
	w _ self runningWorld.
	w ifNotNil: [
		  w startStepping: self 
		   	at: Time localMillisecondClock 
			selector: #step 
			stepTime: self stepTime.
		stepping _ true].
		! !

!Animator methodsFor: 'stepping' stamp: 'KenD 27/Feb/2015, 9:50:00 pm (UTC)'!
step

	self action value: self actor.
	(self doneProc value: self actor)
		ifTrue: [self stopStepping].! !

!Animator methodsFor: 'stepping' stamp: 'jmv 15/May/2015, 12:31:00 am (UTC)'!
stopStepping
	"Stop getting sent the 'step' message."

	| w |
	w _ self runningWorld.
	w ifNotNil: [w stopSteppingMorph: self].
	stepping _ false! !

!Animator class methodsFor: 'instance creation' stamp: 'KenD 20/Sep/2013, 12:01:00 pm (UTC)'!
actor: aMorph action: aOneArgClosure

	^ self new actor: aMorph action: aOneArgClosure stepTime: self defaultStepTime ! !

!Animator class methodsFor: 'instance creation' stamp: 'KenD 6/May/2019, 9:55:20 pm (UTC)'!
actor: aMorph action: aOneArgClosure stepTime: milllisecondsBetweenSteps

	^ self new actor: aMorph action: aOneArgClosure stepTime: milllisecondsBetweenSteps doneProc: self alwaysFalse! !

!Animator class methodsFor: 'instance creation' stamp: 'KenD 6/May/2019, 9:49:54 pm (UTC)'!
actor: aMorph action: aOneArgClosure stepTime: milllisecondsBetweenSteps doneProc: predicateClosure

	| newInst |
	newInst := self new actor: aMorph 
					action: aOneArgClosure 
					stepTime: milllisecondsBetweenSteps 
					doneProc: predicateClosure.
	"animator property allows access through Morph and keeps instance from GC"
	aMorph setProperty: #animator toValue: newInst.
	^newInst ! !

!Animator class methodsFor: 'doneTestProc' stamp: 'KenD 27/Feb/2015, 10:24:00 pm (UTC)'!
alwaysFalse
	"Answer a closure which takes a morph and always answers false.
	 Used for continuous loop animations."
	
	^ [ :aMorph | false ]! !

!Animator class methodsFor: 'doneTestProc' stamp: 'KenD 13/May/2015, 7:21:00 pm (UTC)'!
doneAfterNTimes: anInteger
	"Answers a closure which reduces a counter by 1 each time called.
	The closure answers false if counter > 0"

	| counter count |
	count := anInteger. "remember for later"
	counter := count.
	^ [ :aMorph | 
		counter := counter - 1.
		(counter <= 0) "true when count exhausted"
		ifTrue: [ counter := count. true ] "enable reuse"
		ifFalse: [ false ]
	  ]! !

!Animator class methodsFor: 'actionProc' stamp: 'KenD 27/Feb/2015, 10:05:00 pm (UTC)'!
blinkAction
	"Answers a closure which takes a morph and makes it blink
	 by hiding ans showing it."
	
	| toggle |
	toggle := true.
	^ [ :aMorph | 
			toggle := toggle not.
			toggle ifTrue:  [ aMorph hide]
					ifFalse: [ aMorph show ]
	  ]! !

!Animator class methodsFor: 'actionProc' stamp: 'KenD 27/Feb/2015, 10:04:00 pm (UTC)'!
cycleColors: aColorCollection forSelector: collorSetter
	"Answers a closure which takes a morph and cycles the
	 morph's Color through aColorCollection"
	
	| colorIndex |
	colorIndex := 0.
	^ [ :aMorph | 
			colorIndex := colorIndex + 1.
			colorIndex > aColorCollection size ifTrue:  [ colorIndex := 1 ].
			aMorph perform: collorSetter with: (aColorCollection at: colorIndex).
			aMorph redrawNeeded.
	  ]! !

!Animator class methodsFor: 'actionProc' stamp: 'KenD 5/May/2019, 8:43:55 pm (UTC)'!
cycleImagesFrom: aFormsArray
	"Answers a closure which takes an ImageMorph and sets its form, circularly"
	
	| pathIndex |
	pathIndex := 0.
	^ [ :aMorph | 
			pathIndex := pathIndex + 1.
			pathIndex > aFormsArray size ifTrue:  [ pathIndex := 1 ].
			aMorph image: (aFormsArray at: pathIndex).
			aMorph redrawNeeded.
	  ]! !

!Animator class methodsFor: 'actionProc' stamp: 'KenD 27/Feb/2015, 10:01:00 pm (UTC)'!
followPathAction: aPointCollection
	"Answers a closure which takes a morph and sets its morphPosition
	to each point in aPointCollection, circularly"
	
	| pathIndex |
	pathIndex := 0.
	^ [ :aMorph | 
			pathIndex := pathIndex + 1.
			pathIndex > aPointCollection size ifTrue:  [ pathIndex := 1 ].
			aMorph morphPosition: (aPointCollection at: pathIndex).
			aMorph redrawNeeded.
	  ]! !

!Animator class methodsFor: 'actionProc' stamp: 'KenD 27/Feb/2015, 10:03:00 pm (UTC)'!
growShrinkAction: growSizeinPixels numSteps: numSteps
	"Answers a closure which takes a morph and sets its morphExtent 
	 to grow then shrink in numSteps, keeping the morph centered on
	 its original morphPosition."
	
	| count isGrowing delta  |
	count := 0.
	isGrowing := true.
	growSizeinPixels even  "Want even number of pixels for centering"
		ifTrue: [ delta := growSizeinPixels ]
		ifFalse: [ delta := growSizeinPixels + 1 ].
	^ [ :aMorph | 
			isGrowing ifTrue:  [
				count := count + 1.
				aMorph morphExtent: aMorph morphExtent + delta.
				aMorph morphPosition: aMorph morphPosition - (delta / 2). "recenter"
				count >= numSteps ifTrue: [ isGrowing := false ].
			]
			ifFalse: [
				count := count - 1.
				aMorph morphExtent: aMorph morphExtent - delta.
				aMorph morphPosition: aMorph morphPosition + (delta / 2). "recenter"
				count < 1 ifTrue: [ isGrowing := true ].
			]
	  ]! !

!Animator class methodsFor: 'actionProc' stamp: 'KenD 20/Sep/2013, 10:26:00 pm (UTC)'!
simpleMoveBounceAction: aPoint
	"Move around and vector off container edges"
	
	| ownerExtent deltaPoint |
	deltaPoint := aPoint.
	
	^ [ :aMorph |
		aMorph morphPosition: aMorph morphPosition + deltaPoint.
		ownerExtent := aMorph owner morphExtent.
		(aMorph morphPosition x <= 0) "Hit left wall"
			ifTrue: [ 
				aMorph morphPosition: 0 @ (aMorph morphPosition y). 
				deltaPoint := deltaPoint x negated @ deltaPoint y 
		].
		(aMorph morphPosition y <= 0) "Hit top wall"
			ifTrue: [ 
				aMorph morphPosition: (aMorph morphPosition x) @ 0. 
				deltaPoint := deltaPoint x  @  deltaPoint y negated.
		].
		((aMorph morphPosition x + aMorph morphExtent x) >= ownerExtent x) "Hit right wall"
			ifTrue: [ 
				aMorph morphPosition: (ownerExtent x - aMorph morphExtent x) 
										@ (aMorph morphPosition y). 
				deltaPoint := deltaPoint x negated @ deltaPoint y 
		].
		((aMorph morphPosition y + aMorph morphExtent y) >= ownerExtent y) "Hit bottom wall"
			ifTrue: [ 
				aMorph morphPosition: (aMorph morphPosition x) 
										@ (ownerExtent y - aMorph  morphExtent y). 
				deltaPoint := deltaPoint x  @ deltaPoint y negated.
		].
	]
! !

!Animator class methodsFor: 'examples' stamp: 'KenD 13/May/2015, 9:08:00 pm (UTC)'!
blinkingExample    "Blinking"
"
	self blinkingExample.
	
	Animator stopStepping.
"
	| morph animator |
	morph := ImageMorph initializedInstance openInWorld.
	morph morphPosition: 200 @ 100.
	animator := Animator actor: morph 
						 action: self blinkAction.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 13/May/2015, 9:08:00 pm (UTC)'!
bouncingBallExample    "Bounces off walls of container"
"
	self bouncingBallExample.
	
	Animator stopStepping.
"
	
	| morph animator |
	morph := EllipseMorph initializedInstance openInWorld.
	animator := Animator
						 actor: morph 
						 action: (Animator simpleMoveBounceAction: 20@30 )
						 stepTime: 60.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 28/Oct/2026, 7:51:26 pm (UTC)'!
colorCyclingExample  "Color Cycling"
"
	self colorCyclingExample.  
"
	| morph colors animator |
	morph := BorderedBoxMorph initializedInstance.
	morph borderWidth: 6;
		      morphPosition: 100@200.
	colors := { Color green. Color red. Color blue. Color yellow.  }.
	animator :=  
		Animator actor: morph 
					   action: (Animator cycleColors: colors 
											  forSelector: #borderColor:)
					   stepTime: 300.
	morph openInWorld.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 28/Oct/2026, 7:48:49 pm (UTC)'!
composedActionExample1  "Compose actions:  grow&shring + path"
"
	self composedActionExample1.  
	
	Animator stopStepping.
"
	| morph actions animator |
	morph := BorderedBoxMorph initializedInstance.
	morph morphPosition: 120@120;
	 		 openInWorld.
	actions := { 
	    self growShrinkAction: 20 numSteps: 6.
	    self followPathAction: 
			{ 120@120. 140@126. 180@130. 
			   190@140. 190@180. 170@200.  140@190.  130@160. 134@140. } .
			}.
	animator := self actor: morph 
			  			 action: [ : someMorph | actions do: [ :action | action value: someMorph ] ]
						stepTime: 200.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 13/May/2015, 9:08:00 pm (UTC)'!
composedActionExample2  "Compose actions -- alternative:  grow&shring + path"
"
	self composedActionExample2.  
	
	Animator stopStepping.
"
	| morph originalAction newAction animator |
	morph := EllipseMorph initializedInstance.
	morph morphPosition: 120@120;
	 		 openInWorld.
			
	animator := self actor: morph 
			  			 action: (Animator growShrinkAction: 20 numSteps: 6)
						 stepTime: 200.
	"compose actions"
	originalAction := animator action.
	newAction := Animator followPathAction: 
			{ 120@120. 140@126. 180@130. 
			   190@140. 190@180. 170@200.  140@190.  130@160. 134@140. } .
	"Update with composed action"
	animator action: [ :m | originalAction value: m. newAction value: m ].
	
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 28/Oct/2026, 7:51:40 pm (UTC)'!
growAndShrinkExample    "Grow &Shrink"
"
	self growAndShrinkExample.
	
	Animator stopStepping.
"
	| morph animator |
	morph := BorderedBoxMorph initializedInstance openInWorld.
	morph morphPosition: 200 @ 100.
	animator := Animator
						 actor: morph 
						 action: (Animator growShrinkAction: 20 numSteps: 6)
						 stepTime: 100.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 5/May/2019, 8:50:10 pm (UTC)'!
imageCyclingExample
	"Blue Butterfly"
"
	Animator imageCyclingExample.
	
	Animator stopStepping.
"
	| morph animator |
	morph := (ImageMorph new image: (ButterflyForms at: 1)) openInWorld.
	morph morphPosition: 200 @ 100.
	animator := Animator
						 actor: morph 
						 action: (Animator cycleImagesFrom: ButterflyForms)
						 stepTime: 100.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 6/May/2019, 5:02:04 am (UTC)'!
moveMorphExample
	"Nota Bene: Asynchronous"
"
	Animator moveMorphExample.
"
	Animator 
		slide: (ImageMorph initializedInstance openInWorld) 
		from: (10@10) "Origin initially at 0@0"
		to: (200@400)
		nSteps: 10
		delay: 20. "milliseconds"! !

!Animator class methodsFor: 'examples' stamp: 'KenD 12/May/2015, 10:29:00 pm (UTC)'!
pathExample    "Follow a path, once"
"
	self pathExample.
	
"
	
	| morph pathPoints animator |
	morph := ImageMorph initializedInstance openInWorld.
	pathPoints := { 20@20. 40@26. 80@30. 90@40. 90@80. 
						70@100.  40@90.  30@60. 34@40. }.
	animator := self actor: morph 
						 action: (self followPathAction: pathPoints)
						 stepTime: 100
						 doneProc: (Animator doneAfterNTimes: (pathPoints size)).
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'examples' stamp: 'KenD 26/Feb/2015, 9:55:00 pm (UTC)'!
pathLoopExample    "Follow a path, repeatedly"
"
	self pathLoopExample.
	
	Animator stopStepping.
"
	
	| morph animator |
	morph := ImageMorph initializedInstance openInWorld.
	animator := self actor: morph 
						 action: (self followPathAction: 
			{ 20@20. 40@26. 80@30. 90@40. 90@80. 70@100.  40@90.  30@60. 34@40. } )
						 stepTime: 100.
	animator startStepping.
	^ animator ! !

!Animator class methodsFor: 'accessing' stamp: 'KenD 20/Sep/2013, 11:57:00 am (UTC)'!
defaultStepTime
	"Twice a second"

	^ 500 "milliSeconds"! !

!Animator class methodsFor: 'stepping' stamp: 'KenD 20/Sep/2013, 10:57:00 pm (UTC)'!
restartStepping
	"Start all my instances"

	Smalltalk garbageCollectMost. "Clean out stale instances"
	self allInstancesDo: [ :a | a startStepping ].! !

!Animator class methodsFor: 'stepping' stamp: 'KenD 20/Sep/2013, 7:04:00 pm (UTC)'!
stopStepping
	"Stop all my instances"

	self allInstancesDo: [ :a | a stopStepping ].! !

!Animator class methodsFor: 'moveMorph' stamp: 'KenD 28/Feb/2015, 3:02:00 am (UTC)'!
slide: aMorph from: startPoint to: endPoint nSteps: numberOfMoveSteps delay: milliSeconds
	"Move aMorph along a straightline path from startPoint to endPoint"

	| delta point pathPoints animator  | 
	point := startPoint.
	delta := (endPoint - startPoint) / numberOfMoveSteps.
	pathPoints := OrderedCollection new.
	numberOfMoveSteps timesRepeat: [ pathPoints add: (point := point + delta)].
	pathPoints := pathPoints collect: [ :pt | pt rounded ].
	animator := Animator 
						actor: aMorph
						action: (Animator followPathAction: pathPoints)
						stepTime: milliSeconds 
						doneProc: (Animator doneAfterNTimes: numberOfMoveSteps).
	animator startStepping.! !

!Animator class methodsFor: 'class initialization' stamp: 'KenD 6/May/2019, 4:53:32 am (UTC)'!
initialize
"
	Animator initialize.
"
	| filePrefix |
	
	filePrefix := (CodePackage installedPackages at: #'Animator')
		fullFileName pathAndLocalName at: 1.
	
	ButterflyForms := Array new: 15.
	1 to: 9 do: [ :n | ButterflyForms 
		at: n 
		put: (Form fromFileNamed: filePrefix, '/BlueButterfly/b0', n asString, '.png')].
	10 to: 15 do: [ :n | ButterflyForms 
		at: n 
		put: (Form fromFileNamed: filePrefix, '/BlueButterfly/b', n asString, '.png')]! !
Animator initialize!
