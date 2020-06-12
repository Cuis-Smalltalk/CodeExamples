'From Cuis 5.0 [latest update: #4219] on 12 June 2020 at 11:50:41 am'!
'Description Comparing the Dependency Mechanism to the Observer Pattern which uses #triggerEvent: and #when:send:to:'!
!provides: 'TrafficLight' 1 83!
SystemOrganization addCategory: #'TrafficLight-Model'!
SystemOrganization addCategory: #'TrafficLight-Views'!


!classDefinition: #Models category: #'TrafficLight-Model'!
ActiveModel subclass: #Models
	instanceVariableNames: 'lights'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Model'!
!classDefinition: 'Models class' category: #'TrafficLight-Model'!
Models class
	instanceVariableNames: ''!

!classDefinition: #DependencyModel category: #'TrafficLight-Model'!
Models subclass: #DependencyModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Model'!
!classDefinition: 'DependencyModel class' category: #'TrafficLight-Model'!
DependencyModel class
	instanceVariableNames: ''!

!classDefinition: #Light category: #'TrafficLight-Model'!
Models subclass: #Light
	instanceVariableNames: 'status'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Model'!
!classDefinition: 'Light class' category: #'TrafficLight-Model'!
Light class
	instanceVariableNames: ''!

!classDefinition: #Light1 category: #'TrafficLight-Model'!
Light subclass: #Light1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Model'!
!classDefinition: 'Light1 class' category: #'TrafficLight-Model'!
Light1 class
	instanceVariableNames: ''!

!classDefinition: #Light2 category: #'TrafficLight-Model'!
Light subclass: #Light2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Model'!
!classDefinition: 'Light2 class' category: #'TrafficLight-Model'!
Light2 class
	instanceVariableNames: ''!

!classDefinition: #ObserverModel category: #'TrafficLight-Model'!
Models subclass: #ObserverModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Model'!
!classDefinition: 'ObserverModel class' category: #'TrafficLight-Model'!
ObserverModel class
	instanceVariableNames: ''!

!classDefinition: #LenseMorph category: #'TrafficLight-Views'!
EllipseMorph subclass: #LenseMorph
	instanceVariableNames: 'onColor offColor model'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Views'!
!classDefinition: 'LenseMorph class' category: #'TrafficLight-Views'!
LenseMorph class
	instanceVariableNames: ''!

!classDefinition: #TrafficLight category: #'TrafficLight-Views'!
LayoutMorph subclass: #TrafficLight
	instanceVariableNames: 'model ndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Views'!
!classDefinition: 'TrafficLight class' category: #'TrafficLight-Views'!
TrafficLight class
	instanceVariableNames: ''!

!classDefinition: #Example1 category: #'TrafficLight-Views'!
TrafficLight subclass: #Example1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Views'!
!classDefinition: 'Example1 class' category: #'TrafficLight-Views'!
Example1 class
	instanceVariableNames: ''!

!classDefinition: #Example2 category: #'TrafficLight-Views'!
TrafficLight subclass: #Example2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Views'!
!classDefinition: 'Example2 class' category: #'TrafficLight-Views'!
Example2 class
	instanceVariableNames: ''!

!classDefinition: #Example3 category: #'TrafficLight-Views'!
TrafficLight subclass: #Example3
	instanceVariableNames: 'panel lenses order'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Views'!
!classDefinition: 'Example3 class' category: #'TrafficLight-Views'!
Example3 class
	instanceVariableNames: 'panel'!

!classDefinition: #Example4 category: #'TrafficLight-Views'!
TrafficLight subclass: #Example4
	instanceVariableNames: 'panel lenses order'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TrafficLight-Views'!
!classDefinition: 'Example4 class' category: #'TrafficLight-Views'!
Example4 class
	instanceVariableNames: 'panel'!


!Models commentStamp: 'dhn 3/3/2019 17:27:32' prior: 0!
Abstract class for TrafficLight models.!

!DependencyModel commentStamp: '<historical>' prior: 0!
A model for the Dependency Mechanism.!

!Light commentStamp: 'dhn 11/13/2015 10:08' prior: 0!
An abstract class for lights.!

!Light1 commentStamp: '<historical>' prior: 0!
A model which uses the Dependency Mechanism[1].

A "light" simulation with the ability to be turned on and off. Changes in state are communicated to other objects (unknown to Light1 instances) using the Dependency Mechanism. The #update: method of Light1 detects if a change to "on" is intended for this instance and if not, turns itself "off".

[1] see "Dependency Maintenance" in:

LaLonde and Pugh, "Inside Smalltalk, Volume II", 1.4 Dependency Maintenance
!

!Light2 commentStamp: '<historical>' prior: 0!
A model which uses the Observer Pattern[1].

A "light" simulation with the ability to be turned on and off. When an instance of Light2 receives the #turnOn message, it sends #triggerEvent: with the #turnedOn parameter. Views which need to react to this event send #when:send:to:with: messages to this model with #turnedOn as the parameter. The message #when:send:to:with: is sent during initialization.

[1] https://en.wikipedia.org/wiki/Observer_pattern!

!ObserverModel commentStamp: '<historical>' prior: 0!
A model for the Observer Pattern.!

!LenseMorph commentStamp: 'dhn 12/11/2015 22:23' prior: 0!
View for a traffic light lense.!

!TrafficLight commentStamp: '<historical>' prior: 0!
Abstract class for the traffic light examples.!

!Example1 commentStamp: '<historical>' prior: 0!
An array of lights which can be commanded individually to turn on similar to the Blue Book[1] traffic light. When this occurs, the Dependency Mechanism[2] is used to cause all other lights to turn off.

Copy the following to a Workspace, do (cmd-d) each statement individually, and observe the Transcript:

t  := Example1 newRow.
t change.	"repeat"

[1] Goldberg and Robson, "Smalltalk-80, the Language and its Implementation", pp 240 - 243
[2] LaLonde and Pugh, "Inside Smalltalk, Volime II", 1.4 Dependency Maintenance, p 12
!

!Example2 commentStamp: '<historical>' prior: 0!
An array of lights which can be commanded individually to turn on similar to the Blue Book[1] traffic light. When this occurs, the Observer Pattern[2] is used to cause all other lights to turn off.

The Observer Pattern enables the following:

    A one-to-many dependency between objects, without making the objects tightly coupled.
    When one object changes state an open-ended number of dependent objects are updated automatically.
    One object can notify an open-ended number of other objects.


Copy the following to a Workspace, do (cmd-d) each statement individually, and observe the Transcript:

t  := Example2 newRow.
t change.	"repeat"

[1] Goldberg and Robson, "Smalltalk-80, the Language and its Implementation", pp 240 - 243
[2] https://en.wikipedia.org/wiki/Observer_pattern
!

!Example3 commentStamp: '<historical>' prior: 0!
A view representing one face of a traffic light, containing an array of lights which can be cycled via the "change" button. The Dependency Mechanism is used for communication among the lights such that only one can be on at the time.

Example3 open.
Example3 open: 'Example Ave.'.
!

!Example4 commentStamp: 'dhn 3/16/2019 20:31:12' prior: 0!
A view representing one face of a traffic light, containing an array of lights which can be cycled via the "change" button. The Observer Pattern is used for communication among the lights such that only one can be on at the time.

Example4 open.
Example4 open: 'Example Ave.'.
!

!Models methodsFor: 'operate' stamp: 'dhn 3/1/2019 19:57:04'!
showLights
	"Display the state of the lights"
	| str |

	str _ String new writeStream.
	lights do: [:ea | str nextPutAll: ea isOn asString; space].
	{str contents} print! !

!Models methodsFor: 'accessing' stamp: 'dhn 3/10/2019 17:55:56'!
lights
	"Answer the value of lights"

	^ lights! !

!Models class methodsFor: 'instance creation' stamp: 'dhn 5/29/2020 12:54:29'!
with: numberOfLights
	"Answer an instance of the receiver with a specified number of lights"
	
	^ self new lights: numberOfLights! !

!DependencyModel methodsFor: 'initialize-release' stamp: 'dhn 3/11/2019 15:05:13'!
lights: numberOfLights
	"Establish the lights array"
	
	lights _ Array new: (numberOfLights max: 1).
	lights at: 1 put: Light1 setOn.
	2 to: numberOfLights do: [ :index | lights at: index put: Light1 setOff]! !

!Light methodsFor: 'testing' stamp: 'dhn 11/13/2015 10:10'!
isOff
	"Answer whether the receiver is off"
	
	^ status not! !

!Light methodsFor: 'testing' stamp: 'dhn 11/13/2015 10:11'!
isOn
	"Answer whether the receiver is on"
	
	^ status! !

!Light methodsFor: 'private' stamp: 'dhn 11/13/2015 10:13'!
setOff
	"Set the state of the receiver to off"

	status _ false! !

!Light methodsFor: 'private' stamp: 'dhn 11/13/2015 10:13'!
setOn
	"Set the state of the receiver to on"

	status _ true! !

!Light methodsFor: 'status' stamp: 'dhn 11/13/2015 10:09'!
turnOff
	"Change status from on to off, unless already off"
	
	self isOn
		ifTrue: [status _ false]! !

!Light class methodsFor: 'instance creation' stamp: 'dhn 5/29/2020 12:53:33'!
setOff
	"Establish a new instance of the receiver, in the off state"

	^ self new setOff! !

!Light class methodsFor: 'instance creation' stamp: 'dhn 5/29/2020 12:53:43'!
setOn
	"Establish a new instance of the receiver, in the on state"

	^ self new setOn! !

!Light1 methodsFor: 'status' stamp: 'dhn 3/14/2019 17:23:18'!
turnOn
	"Change status from off to on and communicate the fact to dependents"
	
	self isOff
		ifTrue: [
			status _ true. 
			self changed  "communicate to other objects which might be interested"
			]
	"#changed will trigger an event which can be detected by any dependent with an #update: method"! !

!Light1 methodsFor: 'update' stamp: 'dhn 5/29/2020 13:05:40'!
update: aLight
	"Respond to an event signalling 'change'. If the receiver and aLight are  identical, do nothing; otherwise, turn off. This  ensures that only one light in a collection can be 'on'."
	
	aLight == self ifFalse: [self turnOff]! !

!Light2 methodsFor: 'status' stamp: 'dhn 3/15/2019 13:08:28'!
turnOff
	"Turn off the receiver"
	
	super turnOff! !

!Light2 methodsFor: 'status' stamp: 'dhn 12/10/2015 15:18'!
turnOn
	"Change status from off to on and communicate the fact to other objects, unless already on"
	
	self isOff
		ifTrue: [
			status _ true. 
			self triggerEvent: #turnedOn 		"communicate to other objects which might be interested"
			]
! !

!ObserverModel methodsFor: 'initialize-release' stamp: 'dhn 3/10/2019 17:54:15'!
lights: numberOfLights
	"Establish the lights array with each light dependent on the others"
	
	lights _ Array new: (numberOfLights max: 1).
	lights at: 1 put: Light2 setOn.
	2 to: numberOfLights do: [ :index | lights at: index put: Light2 setOff]! !

!LenseMorph methodsFor: 'operating' stamp: 'dhn 12/12/2015 11:12'!
changeToOff
	"Set color to the 'off' color"
	
	self color: offColor! !

!LenseMorph methodsFor: 'operating' stamp: 'dhn 3/14/2019 17:59:19'!
changeToOn
	"Set color to the 'on' color"
	
	self color: onColor! !

!LenseMorph methodsFor: 'operating' stamp: 'dhn 3/14/2019 18:32:43'!
update: aSymbol
	"Change when signalled by the model"

	owner submorphs do: [:ea |
	ea model isOn
		ifTrue: [ea changeToOn]
		ifFalse: [ea changeToOff]]! !

!LenseMorph methodsFor: 'accessing' stamp: 'dhn 3/4/2019 18:04:30'!
model
	"Answer the value of model"

	^ model! !

!LenseMorph methodsFor: 'accessing' stamp: 'dhn 3/4/2019 18:04:30'!
model: anObject
	"Set the value of model"

	model _ anObject! !

!LenseMorph methodsFor: 'accessing' stamp: 'dhn 12/11/2015 22:58'!
offColor

	^ offColor! !

!LenseMorph methodsFor: 'accessing' stamp: 'dhn 12/11/2015 22:42'!
offColor: anObject
	"Set the value of offColor"

	offColor _ anObject! !

!LenseMorph methodsFor: 'accessing' stamp: 'dhn 12/11/2015 22:26'!
onColor
	"Answer the value of onColor"

	^ onColor! !

!LenseMorph methodsFor: 'accessing' stamp: 'dhn 12/11/2015 22:26'!
onColor: anObject
	"Set the value of onColor"

	onColor _ anObject! !

!LenseMorph class methodsFor: 'instance creation' stamp: 'dhn 12/11/2015 22:51'!
onColor: aColor offColor: bColor
	"Answer an instance  of this class with ivars  onColor set to aColor and offColor set to bColor"
	
	^ (self new 
		onColor: aColor;
		offColor: bColor)
			color: Color lightGray! !

!TrafficLight methodsFor: 'accessing' stamp: 'dhn 3/17/2019 14:49:10'!
model
	"Answer the value of model"

	^ model! !

!TrafficLight methodsFor: 'accessing' stamp: 'dhn 3/17/2019 14:49:10'!
model: anObject
	"Set the value of model"

	model _ anObject! !

!TrafficLight methodsFor: 'accessing' stamp: 'dhn 3/17/2019 14:53:46'!
ndex
	"Answer the value of ndex"

	^ ndex ifNil: [0]! !

!TrafficLight methodsFor: 'accessing' stamp: 'dhn 3/17/2019 14:49:10'!
ndex: anObject
	"Set the value of ndex"

	ndex _ anObject! !

!TrafficLight methodsFor: 'initialization' stamp: 'jmv 6/11/2020 16:43:20'!
paneLabel: aString
	"Answer the layout for an example"
	| pane sM label block off |

	pane _ (LayoutMorph newColumn separation: 0) name: 'Lense Panel'.
	pane 
		color: Color transparent;
		morphExtent: 115@275.
							
	sM _ StringMorph contents: aString.
	sM
		name: 'street';
		font: (FontFamily defaultFamilyPointSize: 15).
							
	label _ (LayoutMorph newRow  name: #Label)
		layoutSpec: (LayoutSpec proportionalHeight: 0.10).
	label 
		color: Color lightBlue;
		axisEdgeWeight: #center;
		addMorph: sM.
	
	self lenses: ((LayoutMorph newColumn separation: 0@10) name: 'Lenses').
	self lenses color: Color transparent.

	off _ Color lightGray.
	self lenses 
		addMorph: ((LenseMorph onColor: Color red  offColor: off) 
			model: (model lights first);
			name: 'Red Lense');
		addMorph: ((LenseMorph onColor: Color yellow  offColor: off) 
			model: (model lights second);
			name: 'Yellow Lense');
		addMorph: ((LenseMorph onColor: Color green  offColor: off) 
			model: (model lights third);
			name: 'Green Lense').

	block _ (LayoutMorph newColumn separation: 20@0) name: #block.
	block 
		color: Color black;
		addMorph: self lenses.

	^ pane
		addMorph: label;
		addMorph: block! !

!TrafficLight methodsFor: 'operate' stamp: 'dhn 3/17/2019 14:55:55'!
change
	"Cause lights to change; show in Transcript"
	
	self cycle.
	
	model showLights! !

!TrafficLight methodsFor: 'operate' stamp: 'dhn 3/17/2019 15:42:32'!
quit

	self owner == self world
		ifTrue: [self delete]
		ifFalse: [self owner delete]! !

!TrafficLight class methodsFor: 'new-morph participation' stamp: 'dhn 3/18/2019 12:42:10'!
includeInNewMorphMenu
	"Not to be instantiated from the menu"
	^ false! !

!Example1 methodsFor: 'operation' stamp: 'dhn 3/10/2019 21:09:53'!
cycle
	"Turn on the next light"
	
	self ndex: (self ndex + 1).
	(model lights atWrap: ndex) turnOn! !

!Example1 methodsFor: 'initialization' stamp: 'dhn 5/29/2020 17:51:30'!
initialize
	"Set the value of model and establish dependencies among the lights"
	
	super initialize.
	model _ DependencyModel with: 3.
	model lights do: [ :eachLight |
		model lights do: [ :dependentLight |
			eachLight ~~ dependentLight
				ifTrue: [eachLight addDependent: dependentLight]]]! !

!Example2 methodsFor: 'operation' stamp: 'dhn 3/15/2019 12:41:29'!
cycle
	"Turn on the next light"
	
	self ndex: (self ndex + 1).
	(model lights atWrap: ndex) turnOn! !

!Example2 methodsFor: 'initialization' stamp: 'dhn 5/29/2020 17:51:59'!
initialize
	"Set the value of model and establish communication among the lights"
	
	super initialize.
	model _ ObserverModel with: 3.
	model lights do: [ :eachLight |
		model lights do: [ :otherLight |
			eachLight ~~ otherLight
				ifTrue: [eachLight when: #turnedOn send: #turnOff  to: otherLight]]]! !

!Example3 methodsFor: 'operate' stamp: 'dhn 3/14/2019 19:44:19'!
cycle
	"Turn on the next light"
	| lite |
	
	self ndex: (self ndex + 1).
	lite _ order atWrap: ndex.
	(model lights at: lite) turnOn! !

!Example3 methodsFor: 'initialization' stamp: 'dhn 6/8/2020 09:58:49'!
initialize
	| buttonArea |
	
	super initialize.
	model _ DependencyModel with: 3.
	order _ (1 to: model lights size) reversed.
	model lights do: [ :eachLight |
		model lights do: [ :dependentLight |
			eachLight ~~ dependentLight
				ifTrue: [eachLight addDependent: dependentLight]]].
	panel _ self paneLabel: ''.
	buttonArea  _ (LayoutMorph newRow name: #Buttons)
		layoutSpec: (LayoutSpec proportionalHeight: 0.20);
		color: Color black;
		axisEdgeWeight: #center.
	buttonArea 
		addMorph: ((PluggableButtonMorph model: self action: #quit label: 'quit') color: Color green);
		addMorph: ((PluggableButtonMorph model: self action: #cycle label: 'change') color: Color green).
	panel addMorph: buttonArea.
	self 
		morphExtent: 165@275;
		addMorph: panel.
	(1 to: model lights size) do: [:n | 
		(model lights reverse at: n) addDependent: (lenses submorphs at: n)].
	ndex _ 3.
	self cycle! !

!Example3 methodsFor: 'accessing' stamp: 'dhn 3/11/2019 11:00:27'!
lenses
	"Answer the value of lenses"

	^ lenses! !

!Example3 methodsFor: 'accessing' stamp: 'dhn 3/11/2019 11:00:27'!
lenses: anObject
	"Set the value of lenses"

	lenses _ anObject! !

!Example3 methodsFor: 'accessing' stamp: 'dhn 3/10/2019 21:21:06'!
panel
	"Answer the value of panel"

	^ panel! !

!Example3 methodsFor: 'accessing' stamp: 'dhn 3/10/2019 21:21:06'!
panel: anObject
	"Set the value of panel"

	panel _ anObject! !

!Example3 class methodsFor: 'instance creation' stamp: 'dhn 3/6/2019 21:45:05'!
open
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	Example3 open.
	
"

	self newRow openInHand! !

!Example3 class methodsFor: 'instance creation' stamp: 'dhn 3/8/2019 17:22:16'!
open: aName
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	Example3 open: 'Some Street'.
	
"
	| win str |

	win _ self newRow.
	str _ win findDeepSubmorphThat: [ :m | 
		(m name = 'street')]
		ifAbsent: [ 'none' ].
	str contents: aName.
	win openInHand! !

!Example3 class methodsFor: 'new-morph participation' stamp: 'dhn 3/18/2019 12:43:06'!
includeInNewMorphMenu
	"Return true for all classes that can be instantiated from the menu"
	^ true! !

!Example4 methodsFor: 'operate' stamp: 'dhn 3/15/2019 13:20:55'!
cycle
	"Turn on the next light"
	| lite |
	
	self ndex: (self ndex + 1).
	lite _ order atWrap: ndex.
	(model lights at: lite) turnOn! !

!Example4 methodsFor: 'initialization' stamp: 'dhn 6/8/2020 09:58:22'!
initialize
	| buttonArea |
	
	super initialize.
	model _ ObserverModel with: 3.
	order _ (1 to: model lights size) reversed.
	model lights do: [ :eachLight |
		model lights do: [ :otherLight |
			eachLight ~~ otherLight
				ifTrue: [eachLight when: #turnedOn send: #turnOff  to: otherLight]]].
	panel _ self paneLabel: ''.
	buttonArea  _ (LayoutMorph newRow name: #Buttons)
		layoutSpec: (LayoutSpec proportionalHeight: 0.20);
		color: Color black;
		axisEdgeWeight: #center.
	buttonArea 
		addMorph: ((PluggableButtonMorph model: self action: #quit label: 'quit') color: Color green);
		addMorph: ((PluggableButtonMorph model: self action: #cycle label: 'change') color: Color green).
	panel addMorph: buttonArea.
	self 
		morphExtent: 165@275;
		addMorph: panel.
	lenses submorphs do: [:ea | ea model when: #turnedOn send: #update: to: ea with: #turnedOn].
	ndex _ 3.
	self cycle! !

!Example4 methodsFor: 'accessing' stamp: 'dhn 3/15/2019 13:20:55'!
lenses
	"Answer the value of lenses"

	^ lenses! !

!Example4 methodsFor: 'accessing' stamp: 'dhn 3/15/2019 13:20:55'!
lenses: anObject
	"Set the value of lenses"

	lenses _ anObject! !

!Example4 methodsFor: 'accessing' stamp: 'dhn 3/15/2019 13:20:55'!
panel
	"Answer the value of panel"

	^ panel! !

!Example4 methodsFor: 'accessing' stamp: 'dhn 3/15/2019 13:20:55'!
panel: anObject
	"Set the value of panel"

	panel _ anObject! !

!Example4 class methodsFor: 'instance creation' stamp: 'dhn 5/29/2020 12:30:15'!
open
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	Example4 open.
	
"

	self newRow openInHand! !

!Example4 class methodsFor: 'instance creation' stamp: 'dhn 5/29/2020 12:30:31'!
open: aName
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	Example4 open: 'Some Street'.
	
"
	| win str |

	win _ self newRow.
	str _ win findDeepSubmorphThat: [ :m | 
		(m name = 'street')]
		ifAbsent: [ 'none' ].
	str contents: aName.
	win openInHand! !

!Example4 class methodsFor: 'new-morph participation' stamp: 'dhn 3/18/2019 12:43:38'!
includeInNewMorphMenu
	"Return true for all classes that can be instantiated from the menu"
	^ true! !
