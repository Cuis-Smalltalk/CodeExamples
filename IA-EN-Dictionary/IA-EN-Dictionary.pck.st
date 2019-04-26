'From Cuis 5.0 of 7 November 2016 [latest update: #3430] on 21 October 2018 at 3:26:50 pm'!
'Description Enter a word in English or Interlingua and find the corresponding Interlingua or English usage.'!
!provides: 'IA-EN-Dictionary' 1 17!
!requires: 'Morphic-Widgets-Extras' 1 7 nil!
!requires: 'Cuis-Base' 50 3430 nil!
SystemOrganization addCategory: #'IA-EN-Dictionary'!


!classDefinition: #IEDictWindow category: #'IA-EN-Dictionary'!
SystemWindow subclass: #IEDictWindow
	instanceVariableNames: 'entryTextMorph promptMorph resultMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IA-EN-Dictionary'!
!classDefinition: 'IEDictWindow class' category: #'IA-EN-Dictionary'!
IEDictWindow class
	instanceVariableNames: ''!

!classDefinition: #IEDict category: #'IA-EN-Dictionary'!
Object subclass: #IEDict
	instanceVariableNames: 'searchString searchResult resultIndex'
	classVariableNames: 'DictData'
	poolDictionaries: ''
	category: 'IA-EN-Dictionary'!
!classDefinition: 'IEDict class' category: #'IA-EN-Dictionary'!
IEDict class
	instanceVariableNames: 'result'!


!IEDictWindow commentStamp: '<historical>' prior: 0!
GUI for Interlingua <-> English lookup 


    IEDictWindow open!

!IEDict commentStamp: '<historical>' prior: 0!
I embody a specialized Dictionary of Interlingua->English.

Class intention
	I am not like a regular dictionary because I maintain my definitions in an array of two element
	arrays #('interlingua definition' 'English definition').  All definitions which contain a search match
	are returned.

Instance intention
      I am the model of an IEDictWindow


WORKSPACE:

IEDict initialize.

IEDict interlinguaContains: 'provider'.
IEDict interlinguaStarts: 'provider'.
IEDict interlinguaStarts: 'omni'.
IEDict englishContains: 'day'.
IEDict englishStarts: 'day'.

IEDictWindow open. "-> opens a new IEDictWindow"!

!IEDictWindow methodsFor: 'color' stamp: 'KenD 10/20/2016 14:50:51'!
backgroundColor

	^  Theme current transcript muchLighter! !

!IEDictWindow methodsFor: 'color' stamp: 'KenD 10/16/2016 15:58:12'!
windowColor
	"Use current theme"
	
	^Theme current transcript ! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 10/20/2016 14:49:57'!
buildMorphicWindow
	"Build and lay out the window and answer it."

	self layoutMorph 
		beColumn;  "the default"
		separation: self defaultSeparation;
		layoutSpec: LayoutSpec useAll;
		addMorph: self makeEntryArea;
		addMorph: self makeButtonArea;
		addMorph: self makeResultsArea.
		
	model when: #newSearchResult send: #searchResultsChanged to: self.
	model interlinguaContainsClick. "set initial text"
	
	"window color is set in SystemWindow>>openInWorld and self class open"
	^ self
! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 10/16/2016 16:03:37'!
makeButtonArea
	"Answer a LayoutMorph with our four buttons -- a column of two rows"
	
	|  buttonHeight buttonLayout interlinguaButtonLayout englishButtonLayout buttonArea |
	buttonHeight := self textSizeUnit * 2.
	buttonLayout := LayoutSpec proportionalWidth: 0.3 fixedHeight: buttonHeight.
	
	interlinguaButtonLayout := LayoutMorph newRow. "a row of two buttons"

	interlinguaButtonLayout 
		padding: #center; 
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
		padding: #center; 
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
			layoutSpec: (LayoutSpec proportionalWidth: 1; fixedHeight: 4 * self textSizeUnit);
			addMorph: interlinguaButtonLayout ;
			addMorph: englishButtonLayout ;
			yourself
			! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 10/16/2016 17:54:17'!
makeEntryArea
	"Answer a LayoutMoph containing the prompt and text entry area"
	
	| entryLayout entryHeigth |
	entryHeigth := self defaultSeparation * 2 + self textSizeUnit.
	
	entryLayout := LayoutMorph newRow.
	
	promptMorph := (StringMorph contents: 'Enter Text: ') 
					emphasis: AbstractFont boldCode ; 
					yourself.
	promptMorph  layoutSpec: 
		(LayoutSpec proportionalWidth: 0.3; 
						fixedWidth: (promptMorph measureContents x)).
			
	entryTextMorph _ (OneLineEditorMorph contents: 'salute'). "initial text"
	entryTextMorph 
		crAction: [self interlinguaContainsClick]; "Same action as IA-Contains button"
		layoutSpec: 
			(LayoutSpec proportionalWidth: 0.9).
			
	^ entryLayout 
		separation: self defaultSeparation;
		layoutSpec: (LayoutSpec proportionalWidth: 1 fixedHeight: entryHeigth);
		addMorph: promptMorph;
		addMorph: entryTextMorph;
		padding: #left
		yourself
! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'KenD 11/7/2016 14:25:13'!
makeResultsArea
	"Answer a LayoutMoph containing the results of the query"
	
	resultMorph := (PluggableListMorph
		model: model 
		listGetter: #resultAsList
		indexGetter: #resultIndex
		indexSetter: #resultIndex:
		mainView: self
		menuGetter: #resultsMenu
		keystrokeAction: #resultsKey:from:).
		
	^ resultMorph 
		layoutSpec: (LayoutSpec proportionalWidth: 1.0 proportionalHeight: 0.98);  
		color: (Theme current textHighlight);
		yourself! !

!IEDictWindow methodsFor: 'menu' stamp: 'KenD 11/7/2016 14:20:04'!
copyResultsToClipboard

	self resultMorph copyListToClipboard! !

!IEDictWindow methodsFor: 'menu' stamp: 'KenD 11/7/2016 14:19:56'!
copySelectedResultToClipboard

	| selectionIndex |
	selectionIndex := self model resultIndex.
	
	selectionIndex isZero 
		ifTrue:
			[self flash] "nothing selected"
		ifFalse:
			[Clipboard storeObject: (self resultMorph getListItem: selectionIndex) asString]
! !

!IEDictWindow methodsFor: 'menu' stamp: 'KenD 11/7/2016 14:19:47'!
resultsMenu

	| aMenu |
	aMenu _ MenuMorph new defaultTarget: self.
	aMenu addList: #(
		('copy selected (c)'	copySelectedResultToClipboard)
		('copyAll (a)'	     		copyResultsToClipboard)
		).
	^ aMenu! !

!IEDictWindow methodsFor: 'geometry' stamp: 'KenD 10/15/2016 13:39:57'!
defaultSeparation
	"Answer the number of pixels between fields/layouts"
	
	^ 5! !

!IEDictWindow methodsFor: 'geometry' stamp: 'KenD 10/16/2016 16:02:59'!
initialExtent

	^ (30 @ 16) * self textSizeUnit ! !

!IEDictWindow methodsFor: 'geometry' stamp: 'KenD 10/15/2016 09:51:09'!
textSizeUnit
	"Answer the scaling factor for sizing; note  method #fontPreferenceChanged"

	^ AbstractFont default height! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 10/16/2016 14:35:48'!
englishContainsClick

	self model searchString: self searchString; englishContainsClick! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 10/16/2016 14:36:04'!
englishStartsClick

	self model searchString: self searchString; englishStartsClick! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 10/18/2016 13:48:56'!
fontPreferenceChanged

  super fontPreferenceChanged.
  self promptMorph 
		layoutSpec: (LayoutSpec 
						proportionalWidth: 0.3; 
						fixedWidth: 
							(self promptMorph measureContents x)).
  self layoutMorph submorphs last "text entry layout"
	layoutSpec: (LayoutSpec
					proportionalWidth: 1 
					fixedHeight: self defaultSeparation * 2 + self textSizeUnit).
					
	self morphExtent: (self morphExtent max: self initialExtent).! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 10/16/2016 14:36:49'!
interlinguaContainsClick

	self model searchString: self searchString; interlinguaContainsClick! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 10/16/2016 14:36:26'!
interlinguaStartsClick

	self model searchString: self searchString; interlinguaStartsClick! !

!IEDictWindow methodsFor: 'events' stamp: 'KenD 10/16/2016 14:07:35'!
searchResultsChanged
	"Display updated search results"
	
	resultMorph updateList ! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 1/3/2013 18:26'!
entryTextMorph
	
	^entryTextMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 10/16/2016 15:07:29'!
promptMorph

	^ promptMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 10/16/2016 13:29:56'!
resultMorph

	^ resultMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'KenD 10/16/2016 13:25:57'!
searchString

	^ entryTextMorph contents asString ! !

!IEDictWindow class methodsFor: 'instance creation' stamp: 'KenD 10/20/2016 14:51:39'!
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
	^ newSelf
! !

!IEDictWindow class methodsFor: 'documentation' stamp: 'KenD 10/16/2016 13:41:17'!
whyMe

	^ IEDict whyMe 	! !

!IEDictWindow class methodsFor: 'menu-world' stamp: 'KenD 10/17/2018 23:41:06'!
worldMenuForOpenGroup
	"Answer the information required to add me to the World menu-->Open.. submenu"
	"i.e. an array with one item: a Dictionary"
	| arr |
	arr := `{{
			#itemGroup 		-> 		10.
			#itemOrder 		-> 		20.
			#label 			->			'IA<-->EN'.
			#object 			-> 		IEDictWindow.
			#selector 		-> 		#open.
			#balloonText 	-> 		'Interlingua<-->English Lookup'.
		} asDictionary}`.
	(arr at: 1) at: #icon put: self searchIcon.
	^arr

! !

!IEDictWindow class methodsFor: 'accessing' stamp: 'KenD 10/17/2018 23:36:58'!
searchIcon

	^ Theme content from: 'Theme' get: {'16x16'. 'actions'. 'system-search.png'}.! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 10/16/2016 13:55:46'!
englishContainsClick
	
	self searchResult:  (IEDict englishContains: (self searchString)).
	self resultIndex: 0.
! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 10/16/2016 13:55:55'!
englishStartsClick
	
	self searchResult:  (IEDict englishStarts: (self searchString)).
	self resultIndex: 0.
! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 10/16/2016 13:55:59'!
interlinguaContainsClick
	
	self searchResult:  (IEDict interlinguaContains: (self searchString)).
	self resultIndex: 0.
! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 10/16/2016 13:56:02'!
interlinguaStartsClick
	
	self searchResult:  (IEDict interlinguaStarts: (self searchString)).
	self resultIndex: 0.
! !

!IEDict methodsFor: 'ui support' stamp: 'KenD 10/16/2016 13:56:29'!
resultAsList
	"Answer a list of form 'this <---> that' "
	
	^ self searchResult collect:[ :elt | (elt at: 1) , ' <---> ', (elt at: 2) ]! !

!IEDict methodsFor: 'initialization' stamp: 'KenD 10/17/2016 15:51:58'!
initialize

	super initialize.
	searchString := 'salute'.
	searchResult := #().
	resultIndex    := 0.! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 10/15/2016 14:33:12'!
resultIndex

	^ resultIndex ! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 10/15/2016 14:33:30'!
resultIndex: anInteger

	resultIndex := anInteger! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 10/16/2016 13:56:15'!
searchResult

	^ searchResult ! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 10/16/2016 14:17:07'!
searchResult: newResult

	searchResult := newResult.
	self triggerEvent: #newSearchResult ! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 10/16/2016 13:52:51'!
searchString
	
	^ searchString! !

!IEDict methodsFor: 'accessing' stamp: 'KenD 10/16/2016 13:53:23'!
searchString: aRegularExpressionString
	
	searchString := aRegularExpressionString! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 10/14/2016 14:59:22'!
englishContains: aString
	"Answer all definition pairs which contain aString looking in the English side"

	| matchStr |
	matchStr :=  ('*' , aString , '*' ) .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 2) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 10/14/2016 14:58:57'!
englishStarts: aString
	"Answer all definition pairs which starts with aString looking in the English side"

	| matchStr |
	matchStr :=  aString , '*'  .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 2) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 10/14/2016 14:58:32'!
interlinguaContains: aString
	"Answer all definition pairs which contain aString looking in the Interlingua side"

	| matchStr |
	matchStr :=  ('*' , aString , '*' ) .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 1) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'KenD 10/14/2016 14:58:11'!
interlinguaStarts: aString
	"Answer all definition pairs which starts with aString looking in the Interlingua side"

	| matchStr |
	matchStr :=  aString , '*'  .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 1) ]! !

!IEDict class methodsFor: 'class initialization' stamp: 'KenD 10/13/2016 16:03:38'!
initialize
	"Read in my data"
"
	IEDict initialize.
"
	| curIndex aLine |
	DictData := Array new: 30811. "We know the exact size (wc -l iedict.txt) less 1"

(self package fullFileName asFileEntry parent  // 'iedict.txt') readStreamDo: [ :fileStream |

	fileStream nextLine. "Skip initial comment line"
	curIndex := 1.
	aLine := fileStream nextLine. 
	[aLine isNil] whileFalse: [
		DictData at: curIndex put: ((aLine findBetweenSubStrs: ':') collect: [:str| str withBlanksTrimmed]). 
		aLine := fileStream nextLine. 
		curIndex := 1 + curIndex.
	]
]! !

!IEDict class methodsFor: 'documentation' stamp: 'KenD 10/16/2016 13:38:47'!
whyMe
	"Answer what you always wanted to know..."

	^'Interlingua is an auxiliary language made from common elements of the romance languages and English. The language has been in use since the 1950''s and is very readable.

You can find out much more at http://www.interlingua.com
	
The dictionary presented here is based on a 30,000 entry dictionary available from Paul Denisowski (paul@denisowski.org)  at  
	http://www.denisowski.org/Interlingua/Interlingua.html

Interlingua Sample:
	
Pro personas qui es familiar con le vocabulario panoccidental Interlingua es comprensibile a prime vista. Per un texto in Interlingua on pote attinger un grande publico multinational cultivate. Pro altere personas Interlingua offere un utile introduction al tresor de vocabulos scientific, technic e cultural. Illo anque facilita le lectura de linguas romanic. Interlingua pote esser un profitabile factor supplementari in studios linguistic. Le internationalitate del vocabulario e le simplicitate del grammatica possibilisa al lector o studiante tosto occupar le position de un active usator de Interlingua.
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
'

! !
IEDict initialize!
