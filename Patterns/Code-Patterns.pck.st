'From Cuis7.1 [latest update: #6378] on 18 May 2024 at 4:27:24 pm'!
'Description Useful Cuis code patterns, intended to help the programmer exploit some of the features of Cuis classes. These examples separate model from view and feature two styles: coupled and decoupled.

The coupled style employs the "dependency mechanism" and exposes the model to changes in the view and to views which were unanticipated. The primary methods of the dependency mechanism are #changed: and #update: .

The decoupled style employs the "observer pattern" which ensures that the model can remain unaffected by changes to the view or by additional views. The primary methods of the observer pattern are #triggerEvent: and #when:send:to: . This is the preferred style for Cuis, although both styles can be found in the base.
'!
!provides: 'Code-Patterns' 1 5!
SystemOrganization addCategory: #'Code-Patterns'!


!classDefinition: #SampleAbstractModel category: #'Code-Patterns'!
Workspace subclass: #SampleAbstractModel
	instanceVariableNames: 'authors authorIndex selectedAuthor quotes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'SampleAbstractModel class' category: #'Code-Patterns'!
SampleAbstractModel class
	instanceVariableNames: ''!

!classDefinition: #CoupledModel category: #'Code-Patterns'!
SampleAbstractModel subclass: #CoupledModel
	instanceVariableNames: 'window textPane'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'CoupledModel class' category: #'Code-Patterns'!
CoupledModel class
	instanceVariableNames: 'window'!

!classDefinition: #DecoupledModel category: #'Code-Patterns'!
SampleAbstractModel subclass: #DecoupledModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'DecoupledModel class' category: #'Code-Patterns'!
DecoupledModel class
	instanceVariableNames: ''!

!classDefinition: #AnotherView category: #'Code-Patterns'!
WorkspaceWindow subclass: #AnotherView
	instanceVariableNames: 'textPane'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'AnotherView class' category: #'Code-Patterns'!
AnotherView class
	instanceVariableNames: ''!

!classDefinition: #ButtonedView category: #'Code-Patterns'!
WorkspaceWindow subclass: #ButtonedView
	instanceVariableNames: 'buttons textPane'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'ButtonedView class' category: #'Code-Patterns'!
ButtonedView class
	instanceVariableNames: ''!

!classDefinition: #CoupledView category: #'Code-Patterns'!
WorkspaceWindow subclass: #CoupledView
	instanceVariableNames: 'textMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'CoupledView class' category: #'Code-Patterns'!
CoupledView class
	instanceVariableNames: ''!

!classDefinition: #DecoupledView category: #'Code-Patterns'!
WorkspaceWindow subclass: #DecoupledView
	instanceVariableNames: 'textPane'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'DecoupledView class' category: #'Code-Patterns'!
DecoupledView class
	instanceVariableNames: ''!

!classDefinition: #DependencyExamples category: #'Code-Patterns'!
Object subclass: #DependencyExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Code-Patterns'!
!classDefinition: 'DependencyExamples class' category: #'Code-Patterns'!
DependencyExamples class
	instanceVariableNames: ''!


!SampleAbstractModel commentStamp: 'dhn 12/6/2015 15:21' prior: 0!
An abstract class containing methods common to some example models. Used to emphasize commonality and distinctions of the coupled and decoupled models.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!CoupledModel commentStamp: 'dhn 11/27/2015 16:07' prior: 0!
An example model class, used to deploy a SystemWindow when only one view of this instance is anticipated. This is not the more desirable design, compared to a decoupled one. If unanticipated views become necessary, their presence will entail changes to this model.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!DecoupledModel commentStamp: 'dhn 11/17/2015 15:26' prior: 0!
An example model class which is unaware of its view or views. As additional views are deployed, their presence will entail no changes to this model.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!AnotherView commentStamp: 'dhn 11/17/2015 15:08' prior: 0!
A view which takes advantage of the Cuis SystemWindow behavior.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!ButtonedView commentStamp: 'dhn 11/17/2015 15:08' prior: 0!
A view which takes advantage of the Cuis SystemWindow behavior.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!CoupledView commentStamp: 'dhn 11/17/2015 15:08' prior: 0!
A view which takes advantage of the Cuis SystemWindow behavior.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!DecoupledView commentStamp: 'dhn 11/17/2015 15:08' prior: 0!
A view which takes advantage of the Cuis SystemWindow behavior.

The methods of this class are suitable for copying into classes being developed. It is expected that many of the method comments will be removed or modified after they are incorporated in the new code. This class comment should also be changed.!

!DependencyExamples commentStamp: 'dhn 1/12/2016 14:12' prior: 0!
Observer Pattern and Dependency Mechanism examples.

DependencyExamples relatedViews.			"Observer Pattern"
DependencyExamples unrelatedViews.		"Observer Pattern"
DependencyExamples coupledView.			"Dependency Mechanism"
!

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 1/4/2016 12:27'!
authorIndex
	"Answer the value of authorIndex"

	authorIndex ifNil: [authorIndex _ 0]. 	"nil is unacceptable during model initialization"
	^ authorIndex! !

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 15:00'!
authors
	"Answer the value of authors"

	^ authors! !

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 15:00'!
authors: anObject
	"Set the value of authors"

	authors _ anObject! !

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 15:00'!
quotes
	"Answer the value of quotes"

	^ quotes! !

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 15:00'!
quotes: anObject
	"Set the value of quotes"

	quotes _ anObject! !

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 15:00'!
selectedAuthor
	"Answer the value of selectedAuthor"

	^ selectedAuthor! !

!SampleAbstractModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 19:56'!
selectedAuthor: anObject
	"Set the value of selectedAuthor"

	selectedAuthor _ anObject.
	self changed: #authorIndex 	"enables deselection of the list by using the mouse"! !

!SampleAbstractModel methodsFor: 'initialization' stamp: 'dhn 12/6/2015 15:00'!
editorClass

	^ TextEditor! !

!SampleAbstractModel methodsFor: 'initialization' stamp: 'dhn 12/6/2015 21:12'!
initialize
	super initialize.
	self quotes: self setQuotes.
	self authors: (OrderedCollection with: 'Eddie' with: 'Winnie' with: 'Yogi' with: 'Willy' with: 'George').
	authorIndex _ 0 	"no authors selected in the list"
	! !

!SampleAbstractModel methodsFor: 'initialization' stamp: 'dhn 12/6/2015 15:00'!
setQuotes
	"Answer a dictionary of quotes"
	
	^ (Dictionary new)
		at: 'Yogi' put: 'When you come to a fork in the road, take it.';
		at: 'Eddie' put: 'One never knows, do one?';
		at: 'George' put: 'England and America are two countries separated by the same language.';
		at: 'Winnie' put: 'This report, by its very length, defends itself against the risk of being read.';
		at: 'Willy' put: 'There is a tide in the affairs of men
Which, taken at the flood, leads on to fortune...';
		yourself! !

!SampleAbstractModel methodsFor: 'operating' stamp: 'dhn 7/3/2016 18:25'!
fullAttribution
	"Answer the quote with the author's full name"
	| ix |

	ix _ self authorIndex.
	^ String streamContents: [:text |
		(ix ~= 0)
			ifTrue: [
				self selectedAuthor: (self authors at: ix).
				text 
					nextPutAll: (self quotes at: self selectedAuthor);
					newLine; newLine; tab; tab;
					nextPutAll: '- ';
					nextPutAll: (self fullNames at: self selectedAuthor)]
			ifFalse: [text nextPutAll: '']]! !

!SampleAbstractModel methodsFor: 'operating' stamp: 'dhn 12/8/2015 12:35'!
fullNames
	"Answer a dictionary which translates list names to full names"
	
	^ (Dictionary new)
		at: 'Yogi' put: 'Yogi Berra';
		at: 'Eddie' put: 'Eddie Murphy';
		at: 'George' put: 'George Bernard Shaw';
		at: 'Winnie' put: 'Winston Churchill';
		at: 'Willy' put: 'William Shakespeare';
		yourself! !

!CoupledModel methodsFor: 'accessing' stamp: 'dhn 12/8/2015 13:03'!
authorIndex: anObject
	"Set the value of authorIndex"

	authorIndex _ anObject.
	textPane model actualContents: self fullAttribution.
	self selectedAuthor: 
		(authors at: anObject ifAbsent: nil)! !

!CoupledModel methodsFor: 'accessing' stamp: 'dhn 12/8/2015 12:47'!
textPane
	"Answer the value of textPane"

	^ textPane! !

!CoupledModel methodsFor: 'accessing' stamp: 'dhn 12/8/2015 12:47'!
textPane: anObject
	"Set the value of textPane"

	textPane _ anObject! !

!CoupledModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 20:46'!
window
	"Answer the value of window"

	^ window! !

!CoupledModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 20:46'!
window: anObject
	"Set the value of window"

	window _ anObject! !

!CoupledModel methodsFor: 'initialization' stamp: 'dhn 12/6/2015 21:06'!
initialize

	super initialize! !

!DecoupledModel methodsFor: 'accessing' stamp: 'dhn 12/6/2015 15:16'!
authorIndex: anObject
	"Set the value of authorIndex"

	authorIndex _ anObject.
	self triggerEvent: #authorChange. 	"to whom it may concern: a new author has been selected"
	self selectedAuthor: 
		(authors at: anObject ifAbsent: nil)! !

!DecoupledModel methodsFor: 'initialization' stamp: 'dhn 12/6/2015 15:15'!
initialize
	super initialize! !

!AnotherView methodsFor: 'initialization' stamp: 'jmv 5/17/2024 17:55:33'!
buildMorphicWindow
	"Specify the layout of the view"
	| listM |
	
	self layoutMorph beRow 	"make use of the layoutMorph already in SystemWindow; change it from column to row"
		name: #'Pattern Row'. 	"give the layoutMorph a name which will appear in the halos"

	listM := (PluggableListMorph
				withModel: model 	"the object specified in self class open"
				listGetter: #authors 	"the method in 'model' which answers the list content"
				indexGetter: #authorIndex 	"the method in 'model' which answers the selection made in the list"
				indexSetter: #authorIndex:	)"the method in 'model' which sets the list index"
					name: #author. 	"give the PluggableListMorph a name which will appear in the halos"

	textPane := (TextModelMorph 
		withModel: (TextModel withText: 'foo')) 	"note the different model specification"
			askBeforeDiscardingEdits: false;	"discard changes to the text"
			name: #quote. 	"give the TextModelMorph a name which will appear in the halos"

	self layoutMorph 	"add the above morphs to the window"
		addMorph: listM layoutSpec: (LayoutSpec proportionalWidth: 0.2);
		addAdjusterAndMorph: textPane layoutSpec: (LayoutSpec useAll)
! !

!AnotherView methodsFor: 'updating' stamp: 'dhn 12/8/2015 14:27'!
whatWasSaid
	"Set the contents of the text pane"

	textPane model actualContents: model fullAttribution 	"note that the textPane model differs from the model for this view"! !

!AnotherView class methodsFor: 'instance creation' stamp: 'dhn 1/12/2016 13:19'!
open
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	AnotherView open.
"
	| mod win |

	win _ (AnotherView
		open: (mod _ DecoupledModel new) "an instance of the model"
		label: 'Another Window on the Decoupled Model') 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Theme current fileList. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"

	mod when: #authorChange send: #whatWasSaid to: win. 	"add an entry to the actionMap of the model"
	
	win morphExtent: 400@200.
	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!AnotherView class methodsFor: 'instance creation' stamp: 'dhn 1/8/2016 15:12'!
openOn: aModel
"	Answer an instance of this class on aModel.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	AnotherView openOn: <some model>.
"
	| win |

	win _ (AnotherView
		open: aModel "an instance of the model"
		label: 'Another Window on the Decoupled Model') 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Theme current fileList. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"

	aModel when: #authorChange send: #whatWasSaid to: win. 	"add an entry to the actionMap of the model"
	
	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!ButtonedView methodsFor: 'initialization' stamp: 'dhn 6/8/2020 09:34:34'!
buildMorphicWindow
	"Specify the layout of the view"
	| bbb |
	
	self layoutMorph 	"make use of the layoutMorph already in SystemWindow; assume it to be 'column' "
		name: #'Pattern Column'. 	"give the layoutMorph a name which will appear in the halos"

	bbb _ LayoutMorph newRow
				separation: 10@5;
				axisEdgeWeight: #center;
				name: #buttons. 	"give the PluggableListMorph a name which will appear in the halos"
	bbb addAllMorphs: self setUpButtons.

	textPane _ (TextModelMorph 
		withModel: (TextModel withText: 'foo')) 	"note the different model specification"
			askBeforeDiscardingEdits: false;	"discard changes to the text"
			name: #quote. 	"give the TextModelMorph a name which will appear in the halos"

	self layoutMorph 	"add the above morphs to the window"
		addMorph: bbb layoutSpec: (LayoutSpec proportionalHeight: 0.2);
		addAdjusterAndMorph: textPane layoutSpec: (LayoutSpec useAll)
! !

!ButtonedView methodsFor: 'initialization' stamp: 'dhn 1/4/2016 18:56'!
setUpButtons
	"Answer a set of buttons"
	| b1 b2 b3 b4 b5 all |
	
	b1 _ PluggableButtonMorph model: self action: #pressed1 label: (model authors at: 1). 
	b2 _ PluggableButtonMorph model: self action: #pressed2 label: (model authors at: 2). 
	b3 _ PluggableButtonMorph model: self action: #pressed3 label: (model authors at: 3). 
	b4 _ PluggableButtonMorph model: self action: #pressed4 label: (model authors at: 4). 
	b5 _ PluggableButtonMorph model: self action: #pressed5 label: (model authors at: 5).
	
	all _ {b1. b2. b3. b4. b5} reverse.
	all do: [:ea | ea morphExtent: 100@30].
	
	^ all ! !

!ButtonedView methodsFor: 'updating' stamp: 'dhn 1/4/2016 19:09'!
pressed1
	"Set text pane to the quote"
	
	model authorIndex: 1.
	
	self whatWasSaid
! !

!ButtonedView methodsFor: 'updating' stamp: 'dhn 1/4/2016 19:09'!
pressed2
	"Set text pane to the quote"
	
	model authorIndex: 2.
	
	self whatWasSaid
! !

!ButtonedView methodsFor: 'updating' stamp: 'dhn 1/4/2016 19:09'!
pressed3
	"Set text pane to the quote"
	
	model authorIndex: 3.
	
	self whatWasSaid
! !

!ButtonedView methodsFor: 'updating' stamp: 'dhn 1/4/2016 19:10'!
pressed4
	"Set text pane to the quote"
	
	model authorIndex: 4.
	
	self whatWasSaid
! !

!ButtonedView methodsFor: 'updating' stamp: 'dhn 1/4/2016 19:10'!
pressed5
	"Set text pane to the quote"
	
	model authorIndex: 5.
	
	self whatWasSaid
! !

!ButtonedView methodsFor: 'updating' stamp: 'dhn 1/4/2016 16:22'!
whatWasSaid
	"Set the contents of the text pane"

	textPane model actualContents: model fullAttribution 	"note that the textPane model differs from the model for this view"! !

!ButtonedView class methodsFor: 'instance creation' stamp: 'dhn 1/12/2016 13:19'!
open
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	ButtonedView open.
"
	| mod win |

	win _ (ButtonedView
		open: (mod _ DecoupledModel new) "an instance of the model"
		label: self title) 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Theme current fileList. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"

	mod when: #authorChange send: #whatWasSaid to: win. 	"add an entry to the actionMap of the model"
	
	win morphExtent: 600@200.
	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!ButtonedView class methodsFor: 'instance creation' stamp: 'dhn 1/8/2016 15:12'!
openOn: aModel
"	Answer an instance of this class on aModel.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	ButtonedView openOn: <some model>.
"
	| win |

	win _ (ButtonedView
		open: aModel "an instance of the model"
		label: self title) 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Theme current fileList. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"

	aModel when: #authorChange send: #whatWasSaid to: win. 	"add an entry to the actionMap of the model"
	
	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!ButtonedView class methodsFor: 'instance creation' stamp: 'dhn 1/4/2016 16:25'!
title

	^ 'Buttons Up on the Decoupled Model'! !

!CoupledView methodsFor: 'initialization' stamp: 'jmv 5/17/2024 17:54:20'!
buildMorphicWindow
	"Specify the layout of the view"
	| listM |
	
	listM := (PluggableListMorph
				withModel: model 	"the object specified in self class open"
				listGetter: #authors 	"the method in 'model' which answers the list content"
				indexGetter: #authorIndex 	"the method in 'model' which answers the selection made in the list"
				indexSetter: #authorIndex:	)"the method in 'model' which sets the list index"
					name: #author. 	"give the PluggableListMorph a name which will appear in the halos"

	textMorph := (TextModelMorph 
		withModel: (TextModel withText: 'foo')) 	"note the different model specification"
			askBeforeDiscardingEdits: false;	"discard changes to the text"
			name: #quote. 	"give the TextModelMorph a name which will appear in the halos"

	(self layoutMorph beRow 	"make use of the layoutMorph already in SystemWindow; change it from column to row"
		name: #'Pattern Row') 	"give the layoutMorph a name which will appear in the halos"
		
		setProperty: #handlesKeyboard toValue: #xxx; 	"enable a quiet start from World->New morph... menu"
		"the property must be present; its actual value does not matter for this purpose except that it cannot be nil"
		
		addMorph: listM fixedWidth: 200;
		addAdjusterAndMorph: textMorph
			layoutSpec: (LayoutSpec useAll).
			
	self model window: self
! !

!CoupledView methodsFor: 'accessing' stamp: 'dhn 12/8/2015 13:01'!
textMorph
	"Answer the value of textMorph"

	^ textMorph! !

!CoupledView methodsFor: 'accessing' stamp: 'dhn 12/8/2015 13:01'!
textMorph: anObject
	"Set the value of textMorph"

	textMorph _ anObject! !

!CoupledView class methodsFor: 'instance creation' stamp: 'dhn 1/12/2016 13:17'!
open
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	CoupledView open.
"
	| win mod |

	win _ (self
		open: (mod _ CoupledModel new) "an instance of the model"
		label: 'A Title for a Window on the Coupled Model') 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Color lightBlue. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"
	
	mod textPane: win textMorph.		"get access to the text pane"

	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!DecoupledView methodsFor: 'initialization' stamp: 'jmv 5/17/2024 17:55:51'!
buildMorphicWindow
	"Specify the layout of the view"
	| listM |
	
	self layoutMorph beRow 	"make use of the layoutMorph already in SystemWindow; change it from column to row"
		name: #'Pattern Row'. 	"give the layoutMorph a name which will appear in the halos"

	listM := (PluggableListMorph
				withModel: model 	"the object specified in self class open"
				listGetter: #authors 	"the method in 'model' which answers the list content"
				indexGetter: #authorIndex 	"the method in 'model' which answers the selection made in the list"
				indexSetter: #authorIndex:)	"the method in 'model' which sets the list index"
					name: #author. 	"give the PluggableListMorph a name which will appear in the halos"

	textPane := (TextModelMorph 
		withModel: (TextModel withText: 'foo')) 	"note the different model specification"
			askBeforeDiscardingEdits: false;	"discard changes to the text"
			name: #quote. 	"give the TextModelMorph a name which will appear in the halos"

	self layoutMorph 	"add the above morphs to the window"
		addMorph: listM layoutSpec: (LayoutSpec proportionalWidth: 0.2);
		addAdjusterAndMorph: textPane layoutSpec: (LayoutSpec useAll)
! !

!DecoupledView methodsFor: 'updating' stamp: 'dhn 12/6/2015 13:54'!
newText
	"Set the contents of the text pane"

	textPane model actualContents: model fullAttribution 	"note that the textPane model differs from the model for this view"! !

!DecoupledView class methodsFor: 'instance creation' stamp: 'dhn 1/12/2016 13:16'!
open
"	Answer an instance of this class.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	DecoupledView open.
"
	| mod win |

	win _ (self
		open: (mod _ DecoupledModel new) "an instance of the model"
		label: 'A Title for a Window on the Decoupled Model') 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Theme current transcript. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"

	mod when: #authorChange send: #newText to: win. 	"add an entry to the actionMap of the model"
	
	win morphExtent: 400@200.
	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!DecoupledView class methodsFor: 'instance creation' stamp: 'dhn 1/8/2016 15:11'!
openOn: aModel
"	Answer an instance of this class on aModel.
	To start from a Browser or a WorkSpace, do (cmd-d) the following:

	DecoupledView openOn: <some model>.
"
	| win |

	win _ (self
		open: aModel "an instance of the model"
		label: 'A Title for a Window on the Decoupled Model') 	"the initial title; can be changed later with #setLabel: "
			setWindowColor:  Theme current transcript. 	"the initial color of the window title bar and frame; other choices below"	
	"#open:label: sends #buildMorphicWindow to the instance of this class, to allow customization of the view"

	aModel when: #authorChange send: #newText to: win. 	"add an entry to the actionMap of the model"
	
	^ win
	
	"the following answer specific colors which match Cuis themes: 
									Theme current browser 
									Theme current changeList 
									Theme current changeSorter 
									Theme current fileContentsBrowser 
									Theme current packageList 
									Theme current debugger 
									Theme current fileList 
									Theme current messageNames 
									Theme current messageSet 
									Theme current object 
									Theme current testRunner 
									Theme current textEditor 
									Theme current transcript 
									Theme current versionsBrowser 
									Theme current workspace 
	or, use a Color class method"
! !

!DependencyExamples class methodsFor: 'examples' stamp: 'dhn 1/4/2016 16:21'!
coupledView
	"
	self coupledView.
	"

	CoupledView open! !

!DependencyExamples class methodsFor: 'examples' stamp: 'dhn 1/8/2016 14:09'!
relatedViews
	"Demonstrate multiple views on the same model, which is independent of their existence. 
	A change in one view is repeated in the other views.
	
	self relatedViews.
	"
	| mod |
	
	mod _ DecoupledModel new.
	ButtonedView openOn: mod.
	AnotherView openOn: mod.
	DecoupledView openOn: mod! !

!DependencyExamples class methodsFor: 'examples' stamp: 'dhn 1/4/2016 15:15'!
unrelatedViews
	"Demonstrate multiple views on the same model, which is independent of their existence. 
	A change in one view causes no change in the other view.
	
	self unrelatedViews.
	"

	AnotherView openOn: DecoupledModel new.
	DecoupledView openOn: DecoupledModel new! !
