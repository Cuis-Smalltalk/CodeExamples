'From Cuis7.5 [latest update: #7681] on 3 November 2025 at 4:19:18 pm'!
'Description '!
!provides: 'Morphic-Shapes' 1 1!
SystemOrganization addCategory: #'Morphic-Shapes'!


!classDefinition: #CurvedArrow category: #'Morphic-Shapes'!
PlacedMorph subclass: #CurvedArrow
	instanceVariableNames: 'points strokeWidth color dashedStrokeBits dashBitLength dashOffset'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Shapes'!
!classDefinition: 'CurvedArrow class' category: #'Morphic-Shapes'!
CurvedArrow class
	instanceVariableNames: ''!


!CurvedArrow methodsFor: 'initialization' stamp: 'jmv 11/3/2025 10:30:23'!
initializeDefaults
	points := {100@100 . 200@100 . 300@300 . 600@300}.
	strokeWidth := 4.
	color := Color magenta.
	dashedStrokeBits := 2r111110000.
	dashBitLength := 2.
	dashOffset := 0.! !

!CurvedArrow methodsFor: 'initialization' stamp: 'jmv 10/22/2025 15:43:45'!
points: aCollection strokeWidth: aNumber dashedStrokeBits: bits dashedBitLength: l color: aColor
	"
	CurvedArrow new openInWorld
	"
	points := aCollection.
	strokeWidth := aNumber.
	dashedStrokeBits := bits.
	dashBitLength := l.
	color := aColor.! !

!CurvedArrow methodsFor: 'drawing' stamp: 'jmv 11/3/2025 10:30:08'!
drawOn: aCanvas
	"
	CurvedArrow allInstancesDo: [ :a | a delete ]
	CurvedArrow new openInWorld
	"
	| p4 d d1 d2 p5 |
	aCanvas strokeWidth: strokeWidth color: color dashedStrokeBits: dashedStrokeBits dashBitLength: dashBitLength dashBitOffset: dashOffset do: [
		aCanvas cubicBezier: points ].
	p4 := points fourth.
	d := (p4 - points third) normalized * strokeWidth * 8.
	d1 := d rotatedBy: Float pi / 10 negated + Float pi.
	d2:= d rotatedBy: Float pi / 10 + Float pi.
	p5 := p4 + d.
	
	aCanvas strokeWidth: 3 color: color fillColor: color do: [
		aCanvas moveTo: p5;
			lineTo: p5 + d1;
			lineTo: p5 + d2;
			lineTo: p5 ]
	! !

!CurvedArrow methodsFor: 'stepping' stamp: 'jmv 11/3/2025 11:07:16'!
step
	dashOffset := dashOffset - 1.
	self redrawNeeded.! !

!CurvedArrow methodsFor: 'stepping' stamp: 'jmv 11/3/2025 12:27:25'!
stepTime
	^300! !

!CurvedArrow methodsFor: 'stepping' stamp: 'jmv 11/3/2025 12:27:11'!
wantsSteps

	^ true! !

!CurvedArrow class methodsFor: 'instance creation' stamp: 'jmv 10/22/2025 15:45:10'!
new
	"
	CurvedArrow new openInWorld
	"
	^super new initializeDefaults! !

!CurvedArrow class methodsFor: 'instance creation' stamp: 'jmv 10/22/2025 15:55:17'!
points: aCollection strokeWidth: aNumber color: aColor
	"
	(CurvedArrow
		points: {100@100 . 200@100 . 300@300 . 600@300}
		strokeWidth: 6
		color: Color red)
			openInWorld
	"
	^self new points: aCollection strokeWidth: aNumber dashedStrokeBits: 0 dashedBitLength: 0 color: aColor! !

!CurvedArrow class methodsFor: 'instance creation' stamp: 'jmv 10/22/2025 15:55:45'!
points: aCollection strokeWidth: aNumber dashedStrokeBits: bits dashedBitLength: l color: aColor
	"
	(CurvedArrow
		points: {100@100 . 200@100 . 300@300 . 600@300}
		strokeWidth: 6
		dashedStrokeBits: 2r1110000 dashedBitLength: 4
		color: Color red)
			openInWorld
	"
	^self new points: aCollection strokeWidth: aNumber dashedStrokeBits: bits dashedBitLength: l color: aColor! !
