'From Cuis7.9 [latest update: #8296] on 29 October 2026 at 1:09:43 pm'!
'Description A very simple morph to demo stepping, and for knowing about stepping (and world update) frame rates.'!
!provides: 'FrameRateMorph' '0.0.1'!
SystemOrganization addCategory: #FrameRateMorph!


!classDefinition: #FrameRateMorph category: #FrameRateMorph!
BorderedBoxMorph subclass: #FrameRateMorph
	instanceVariableNames: 'lastStepDelta meanStepDelta'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FrameRateMorph'!
!classDefinition: 'FrameRateMorph class' category: #FrameRateMorph!
FrameRateMorph class
	instanceVariableNames: ''!


!FrameRateMorph commentStamp: '<historical>' prior: 0!
A very simple morph to demo stepping, and for knowing about stepping (and world update) frame rates.

FrameRateMorph new openInHand!

!FrameRateMorph methodsFor: 'drawing' stamp: 'KenD 29/Oct/2026, 8:08:25 pm (UTC)'!
drawOn: aCanvas
	super drawOn: aCanvas.
	meanStepDelta ifNotNil: [
		aCanvas drawString: lastStepDelta rounded printString at: 10@4 font: FontFamily defaultFamilyAndPointSize color: Color black.
		aCanvas drawString: meanStepDelta rounded printString at: 10@20 font: FontFamily defaultFamilyAndPointSize color: Color black.
		"aCanvas drawString: lastStepStamp printString at: bounds topLeft + (0@28) font: FontFamily defaultFamilyAndPointSize color: Color black "
		]! !

!FrameRateMorph methodsFor: 'stepping' stamp: 'jmv 28/Feb/2016, 2:52:00 am (UTC)'!
stepAt: millisecondSinceLast

	| n |
	lastStepDelta _ millisecondSinceLast.
	"This factor is a damper, to show a sort of mean of the n latest step deltas"
	meanStepDelta
		ifNil: [ meanStepDelta _ 0. n _ 0 ]
		ifNotNil: [
"			n _ (meanStepDelta / lastStepDelta between: 0.5 and: 2)
				ifTrue: [ 10 ]
				ifFalse: [10 ]."
			n _ 20 ].
	meanStepDelta _ meanStepDelta * n + lastStepDelta / (n+1).
	self redrawNeeded! !

!FrameRateMorph methodsFor: 'stepping' stamp: 'jmv 12/Jun/2012, 6:34:00 am (UTC)'!
stepTime

	^20! !

!FrameRateMorph methodsFor: 'stepping' stamp: 'jmv 11/Jun/2012, 4:20:00 pm (UTC)'!
wantsSteps
	"Return true if the receiver wants to its #step or #stepAt: methods be run"

	^true! !
