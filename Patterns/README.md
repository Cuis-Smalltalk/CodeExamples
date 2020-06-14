## Patterns
Useful Cuis code patterns, intended to help the programmer exploit some of the features of Cuis classes. These examples separate model from view and feature two styles: coupled and decoupled.

The coupled style employs the "dependency mechanism" and exposes the model to changes in the view and to views which were unanticipated. The primary methods of the dependency mechanism are #changed: and #update: .

The decoupled style employs the "observer pattern" which ensures that the model can remain unaffected by changes to the view or by additional views. The primary methods of the observer pattern are #triggerEvent: and #when:send:to: . This is the preferred style for Cuis, although both styles can be found in the base.

Install the package, then:


>DependencyExamples relatedViews.			"Observer Pattern"
>
>DependencyExamples unrelatedViews.		"Observer Pattern"
>
>DependencyExamples coupledView.			"Dependency Mechanism"

Tested in Cuis 5.0  rev 4208 on 6/14/2020
