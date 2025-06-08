'From Cuis7.5 [latest update: #7262] on 8 June 2025 at 3:21:13 pm'!
'Description Enter a word in English or Interlingua and find the corresponding Interlingua or English usage. '!
!provides: 'IA-EN-Dictionary' 1 3!
!requires: 'UI-Entry' 1 56 nil!
SystemOrganization addCategory: #'IA-EN-Dictionary'!


!classDefinition: #IEDict category: #'IA-EN-Dictionary'!
Object subclass: #IEDict
	instanceVariableNames: 'searchString searchResult resultIndex'
	classVariableNames: 'DictData'
	poolDictionaries: ''
	category: 'IA-EN-Dictionary'!
!classDefinition: 'IEDict class' category: #'IA-EN-Dictionary'!
IEDict class
	instanceVariableNames: ''!

!classDefinition: #IEDictWindow category: #'IA-EN-Dictionary'!
SystemWindow subclass: #IEDictWindow
	instanceVariableNames: 'textEntryMorph resultMorph promptMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IA-EN-Dictionary'!
!classDefinition: 'IEDictWindow class' category: #'IA-EN-Dictionary'!
IEDictWindow class
	instanceVariableNames: ''!


!IEDict commentStamp: '<historical>' prior: 0!
I embody a specialized Dictionary of Interlingua<-->English.

Class intention
	I am not like a regular dictionary because I maintain my definitions 
	in an array of two element arrays #('interlingua definition' 'English definition'). 
	All definitions which contain a search match are returned.

Instance intention
      I am the model of an IEDictWindow
!

!IEDictWindow commentStamp: '<historical>' prior: 0!
GUI for Interlingua <--> English lookup

    IEDictWindow open
!

!IEDict methodsFor: 'initialization' stamp: 'KenD 6/7/2025 15:02:05'!
initialize

	super initialize.
	searchString := 'salute'.
	searchResult := #().
	resultIndex  := 0.! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 6/7/2025 14:49:36'!
resultIndex
	
	^resultIndex ! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 6/7/2025 14:50:04'!
resultIndex: anInteger
	
	resultIndex := anInteger! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 6/7/2025 14:49:13'!
searchResult
	
	^searchResult ! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 6/7/2025 15:12:32'!
searchResult: newResult

	searchResult := newResult.
	self triggerEvent: #newSearchResult! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 6/7/2025 14:47:16'!
searchString
	
	^ searchString! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 6/7/2025 14:47:56'!
searchString: aRegularExpressionString
	
	searchString := aRegularExpressionString! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 6/7/2025 15:15:56'!
englishContainsClick
	
	self searchResult:  (IEDict englishContains: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 6/7/2025 15:03:03'!
englishStartsClick
	
	self searchResult:  (IEDict englishStarts: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 6/7/2025 15:02:46'!
interlinguaContainsClick
	
	self searchResult:  (IEDict interlinguaContains: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 6/7/2025 15:02:54'!
interlinguaStartsClick
	
	self searchResult:  (IEDict interlinguaStarts: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 6/7/2025 15:03:31'!
resultAsList
	"Answer a list of form 'this <---> that' "
	
	^ self searchResult collect:[ :elt | (elt at: 1) , ' <---> ', (elt at: 2) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 6/6/2025 14:22:20'!
englishContains: aString
	"Answer all definition pairs which contain aString looking in the English side"

	| matchStr |
	matchStr :=  ('*' , aString , '*' ) .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 2) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 6/6/2025 14:22:47'!
englishStarts: aString
	"Answer all definition pairs which starts with aString looking in the English side"

	| matchStr |
	matchStr :=  aString , '*'  .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 2) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 6/6/2025 14:21:42'!
interlinguaContains: aString
	"Answer all definition pairs which contain aString looking in the Interlingua side"

	| matchStr |
	matchStr :=  ('*' , aString , '*' ) .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 1) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 6/6/2025 14:22:01'!
interlinguaStarts: aString
	"Answer all definition pairs which starts with aString looking in the Interlingua side"

	| matchStr |
	matchStr :=  aString , '*'  .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 1) ]! !

!IEDict class methodsFor: 'class initialization' stamp: 'KenD 6/6/2025 14:17:42'!
initialize
	"Read in my data"
"
	IEDict initialize.
"
	| curIndex aLine |
	DictData := Array new: 31034. "We know the exact size (wc -l iedict.txt) less 1"

	(self package fullFileName asFileEntry parent  // 'iedict.txt') readStreamDo: [ :fileStream |
		fileStream nextLine. "Skip initial comment line"
		curIndex := 1.
		aLine := fileStream nextLine. 
		[aLine isNil] whileFalse: [
			DictData at: curIndex 
				  put: ((aLine findBetweenSubStrs: ':') 
						collect: [:str| str withBlanksTrimmed]). 
			aLine := fileStream nextLine. 
			curIndex := 1 + curIndex.
		]
	] ! !

!IEDict class methodsFor: 'documentation' stamp: 'KenD 6/8/2025 15:19:56'!
whyMe
	"Answer what you always wanted to know..."

	^'Interlingua is an auxiliary language made from common elements of 
the romance languages and English. The language has been in use since the 1950''s 
and is very readable.

You can find out much more at http://www.interlingua.com
	
The dictionary presented here is based on a 30,000 entry dictionary available 
from Paul Denisowski (paul@denisowski.org)  at  
	http://www.denisowski.org/Interlingua/Interlingua.html

Interlingua Sample:
	
Pro personas qui es familiar con le vocabulario panoccidental Interlingua es 
comprensibile a prime vista. Per un texto in Interlingua on pote attinger un 
grande publico multinational cultivate. Pro altere personas Interlingua 
offere un utile introduction al tresor de vocabulos scientific, technic e 
cultural. Illo anque facilita le lectura de linguas romanic. Interlingua pote 
esser un profitabile factor supplementari in studios linguistic. 

Le internationalitate del vocabulario e le simplicitate del grammatica 
possibilisa al lector o studiante tosto occupar le position de un active 
usator de Interlingua.
...
Lingua natural
e musical
de parolas international
e un grammatica phenomenal!!

Comprehensibile facilemente
in le mundo per tote le gente:
apprender lo es un acto intelligente!!

Le medio de comprehension
pro le solution del confusion
in le global communication!!
'! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 6/7/2025 15:17:42'!
englishContainsClick

	^self model searchString: self searchString; englishContainsClick! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 6/7/2025 14:25:36'!
englishStartsClick

	self model searchString: self searchString; englishStartsClick

! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 6/8/2025 15:14:25'!
fontPreferenceChanged

  super fontPreferenceChanged.
  self promptMorph 
	layoutSpec: (LayoutSpec 
			proportionalWidth: 0.3; 
			fixedWidth: (self promptMorph measureContents x)).
  self layoutMorph submorphs last "text entry layout"
	layoutSpec: (LayoutSpec
			proportionalWidth: 1 
			fixedHeight: self defaultSeparation * 2
				     + self textSizeUnit).
					
  self morphExtent: (self morphExtent max: self initialExtent).

! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 6/7/2025 14:24:58'!
interlinguaContainsClick

	self model searchString: self searchString; interlinguaContainsClick
! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 6/7/2025 14:25:10'!
interlinguaStartsClick

	self model searchString: self searchString; interlinguaStartsClick
! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 6/7/2025 15:14:02'!
searchResultsChanged
	"Display updated search results"
	
	resultMorph updateList ! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 6/8/2025 11:57:25'!
buildMorphicWindow
	"Build and layout the window and answer it."
	
	self layoutMorph
		beColumn; "the default"
		separation: self defaultSeparation;
		layoutSpec: LayoutSpec useAll;
		addMorph: self makeEntryArea;
		addMorph: self makeButtonArea;
		addMorph: self makeResultsArea.
		
	model when: #newSearchResult send: #searchResultsChanged to: self.
	model interlinguaContainsClick. "set initial text"
	
	self color: self backgroundColor.
	
	^ self! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 6/7/2025 14:21:30'!
makeButtonArea
	"Answer a LayoutMorph with our four buttons -- a column of two rows"
	
	|  buttonHeight buttonLayout interlinguaButtonLayout englishButtonLayout buttonArea |
	buttonHeight := self textSizeUnit * 2.
	buttonLayout := LayoutSpec proportionalWidth: 0.3 fixedHeight: buttonHeight.
	
	interlinguaButtonLayout := LayoutMorph newRow. "a row of two buttons"

	interlinguaButtonLayout 
		axisEdgeWeight: #center; 
		separation: 2;
		addMorph: 
			(PluggableButtonMorph 
				model: self 
				action: #interlinguaContainsClick  
				label: 'Interlingua Contains')  layoutSpec: buttonLayout;
		addMorph: 
			(PluggableButtonMorph 
				model: self 
				action: #interlinguaStartsClick  
				label: 'Interlingua Starts') layoutSpec: buttonLayout.

	englishButtonLayout := LayoutMorph newRow. "a row of two buttons"
									.
	englishButtonLayout 
		axisEdgeWeight: #center; 
		separation: 2;
		addMorph: 
			(PluggableButtonMorph 
				model: self 
				action: #englishContainsClick  
				label: 'English Contains') layoutSpec: buttonLayout;				
		addMorph: 
			(PluggableButtonMorph 
				model: self
				action: #englishStartsClick  
				label: 'English Starts') layoutSpec: buttonLayout.

	buttonArea := LayoutMorph newColumn.
	^ buttonArea 
			layoutSpec: (LayoutSpec proportionalWidth: 1;
						fixedHeight: 4 * self textSizeUnit);
			addMorph: interlinguaButtonLayout ;
			addMorph: englishButtonLayout ;
			yourself! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 6/7/2025 13:01:19'!
makeEntryArea
	"Answer a LayoutMoph containing the prompt and text entry area"
	
	| entryLayout entryHeigth |
	entryHeigth := self defaultSeparation * 2 + self textSizeUnit.
	
	entryLayout := LayoutMorph newRow.
	
	promptMorph := (LabelMorph contents: 'Enter Text: ') 
				emphasis: AbstractFont boldCode; 
				yourself.
	promptMorph  layoutSpec: 
		(LayoutSpec proportionalWidth: 0.3; 
			    fixedWidth: (promptMorph measureContents x)).
	"initial entry area text"			
	textEntryMorph := (TextEntryMorph contents: 'salute').
	textEntryMorph
		"Same action as IA-Contains button"
		crAction: [self interlinguaContainsClick]; 
		layoutSpec: 
			(LayoutSpec proportionalWidth: 0.9).
			
	^ entryLayout 
		separation: self defaultSeparation;
		layoutSpec: (LayoutSpec proportionalWidth: 1
					fixedHeight: entryHeigth);
		addMorph: promptMorph;
		addMorph: textEntryMorph;
		axisEdgeWeight: #rowLeft
		yourself! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 6/7/2025 14:40:44'!
makeResultsArea
	"Answer a LayoutMoph containing the results of the query"
	
	resultMorph := PluggableListMorph
				withModel: model 
				listGetter: #resultAsList
				indexGetter: #resultIndex
				indexSetter: #resultIndex: .
					
	^resultMorph 
		     layoutSpec: (LayoutSpec proportionalWidth: 1.0
					    proportionalHeight: 0.98);  
		     color: (Theme current textHighlight);
		     yourself! !

!IEDictWindow methodsFor: 'geometry' stamp: 'KenD 6/7/2025 14:45:57'!
defaultSeparation
	"Answer the number of pixels between fields/layouts"
	
	^ 5 "pixels"! !

!IEDictWindow methodsFor: 'geometry' stamp: 'KenD 6/8/2025 14:55:00'!
initialExtent

	^ (40 @ 20) * self textSizeUnit ! !

!IEDictWindow methodsFor: 'geometry' stamp: 'KenD 6/7/2025 14:46:07'!
textSizeUnit
	"Answer the scaling factor for sizing; note  method #fontPreferenceChanged"

	^ (Preferences at: #standardListFont) lineSpacing! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 6/7/2025 15:08:25'!
promptMorph
	^ promptMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 6/7/2025 15:08:32'!
resultMorph
	^ resultMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 6/7/2025 15:10:14'!
searchString

	^ textEntryMorph contents asString! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 6/7/2025 15:09:08'!
textEntryMorph
	^textEntryMorph! !

!IEDictWindow methodsFor: 'color' stamp: 'KenD 6/8/2025 11:56:25'!
backgroundColor

	^  Theme current transcript muchLighter! !

!IEDictWindow methodsFor: 'color' stamp: 'KenD 6/8/2025 12:36:59'!
windowColor
	"Use current theme"
	
	^Theme current transcript! !

!IEDictWindow class methodsFor: 'menu and shortcuts' stamp: 'KenD 6/8/2025 11:44:42'!
worldMenuOptions

	"Answer the information required to add me
	 to the World menu-->Open.. submenu.
	 This is presented as a Dictionary"
	^ `{{	#submenuOf 	-> TheWorldMenu openLabel.
		#itemGroup 	-> 10.
		#itemOrder 	-> 20.
		#label 		-> 'IA<-->EN'.
		#object 	-> IEDictWindow.
		#selector 	-> #open.
		#icon		-> #findIcon.
		#balloonText	-> 'Interlingua<-->English Lookup'.
	   } asDictionary}`! !

!IEDictWindow class methodsFor: 'instance creation' stamp: 'KenD 6/8/2025 14:55:46'!
open
"
	IEDictWindow open.
"
	| newSelf |
	newSelf := self open: (IEDict new) label: 'Interlingua <--> English'.
	"Override default color resets in SystemWindow>>openInWorld"
	newSelf color: newSelf backgroundColor.
	newSelf layoutMorph submorphs last "the text entry layout morph"
		color: (Theme current textHighlight lighter).
	^ newSelf! !
IEDict initialize!
