# Traffic Light
This package contains several examples of objects which communicate without using the class hierarchy. Based on the Light and TrafficLight classes in the Blue Book [1] communication among "lights" is done by either the Dependency Mechanism [2] or the Observer Pattern [3]. The advantage of doing this is that the objects can be independent yet communicate.

### Example1 
employs the Dependency Mechanism in the same way as the Blue Book, using the #changed and #update: methods, for a collection of lights only one of which can be on. A light is unaware of how many others are in the collection.

### Example2 
employs a more recent scheme called the Observer Pattern. It uses #triggerEvent and #when:send:to: for a collection of lights. As in Example1, the Observer Pattern makes possible changes to the lights such that when one is turned on, all others are turned off.

## Models and Views
The Dependency Mechanism and the Observer Pattern can also be used to achieve separation of models and views. Models can then be independent of views yet provide methods which views can use to obtain data. Views know about the models they use, but models neither know about their users nor of their existence.

### Example3 
is a view of one face of a traffic light, with a change button, which employs the Dependency Mechanism.

### Example4
is a view of one face of a traffic light, with a change button, which employs the Observer Pattern.

### Comparison of the Two Schemes
Either the Dependency Mechanism or the Observer Pattern can be used to accomplish communication among objects without using the class hierarchy in the normal way. They differ in the methods used. At minimum, the Dependency Mechanism requires the #addDependent:, #changed, and #update: methods. In contrast, the Observer Pattern uses the #when:send:to: family and the #triggerEvent: methods. There is no equivalent to the #addDependent: method and no requirement to have an #update: method. The name of the method "sent" in the Observer Pattern is unrestricted. Models in both schemes must be in the ActiveModel hierarchy.


[1] Goldberg and Robson, "Smalltalk-80, the Language and its Implementation", pp 240 - 243

[2] LaLonde and Pugh, "Inside Smalltalk, Volime II", 1.4 Dependency Maintenance, p 12

[3] https://paginas.fe.up.pt/~aaguiar/as/gof/hires/pat5gfso.htm
