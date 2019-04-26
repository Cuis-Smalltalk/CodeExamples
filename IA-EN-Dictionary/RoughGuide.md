Cuis-Smalltalk-IA-EN-Dictionary
===============================
````Smalltalk
	Feature require: #'IA-EN-Dictionary'
	IEDictWindow open.
````

# Techniques of Interest

- Shows how to set up a specialized SystemWindow using method `buildMorphicWindow`.

- Uses `LayoutMorph`s and `LayoutSpec`s

- Shows a useful application built with a small amount of code.

- Uses events to communicate between a SystemWindow and its _model_.

- `IEDictWindow>>fontPreferenceChanged` updates sizes when the font preference changes.


See tutorial in https://github.com/Cuis-Smalltalk-Learning/Learning-Cuis
- https://github.com/Cuis-Smalltalk-Learning/Learning-Cuis/blob/master/SamplePackage1.md
