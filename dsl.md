# Isis Script DSL

The different aspects of the Isis Script DSL are explained in the following sections.  

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Namespaces](#namespaces)
- [Entities](#entities)
  - [Inheritance](#inheritance)
  - [Injections](#injections)
  - [Properties](#properties)
    - [Property Rules](#property-rules)
      - [Hide](#hide)
      - [Disable](#disable)
      - [Validate](#validate)
    - [Derived Property](#derived-property)
    - [Modify](#modify)
    - [Clear](#clear)
    - [Drop-Downs](#drop-downs)
    - [Auto-Complete](#auto-complete)
    - [Default](#default)
    - [Property Event](#property-event)
  - [Collections](#collections)
    - [Collection Rules](#collection-rules)
      - [Hide](#hide-1)
      - [Disable](#disable-1)
      - [Validate[AddTo|RemoveFrom]](#validateaddtoremovefrom)
    - [Derived Collection](#derived-collection)
    - [AddTo](#addto)
    - [RemoveFrom](#removefrom)
    - [Collection Event](#collection-event)
  - [Actions](#actions)
    - [Action Rules](#action-rules)
      - [Hide](#hide-2)
      - [Disable](#disable-2)
      - [Validate](#validate-1)
    - [Action Parameters](#action-parameters)
      - [Default](#default-1)
      - [Drop-Downs](#drop-downs-1)
      - [Auto-Complete](#auto-complete-1)
      - [Validate](#validate-2)
    - [Action Event](#action-event)
- [Services](#services)
  - [Inheritance](#inheritance-1)
  - [Injections](#injections-1)
  - [Actions](#actions-1)
- [Behaviours](#behaviours)
  - [Inheritance](#inheritance-2)
  - [Injections](#injections-2)
  - [Actions](#actions-2)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Namespaces

To define a namespace for an Isis Script object the corresponding Java notion of packages and imports are supported. So the keywords `package` and `import` are used in the same way as in Java classes:

	package org.vaulttec.types
	
	import org.vaulttec.types.other.SomeSuperType
	
	entity SomeType extends SomeSuperType {
	}


## Entities

Persistent domain objects (entities) are defined with the keyword `entity`. They have a unique name and are preceeded by Isis or selected JDO annotations.

	@... // Isis and JDO annotations 
	entity SomeType {
	}


### Inheritance

By using the keyword `extends` an entity can inherit from another entity:

	entity SomeType extends SomeSuperType {
	}


### Injections

With the keyword `inject` an Isis service can be autowired (field injection) into an entity:

	entity SomeType {
		inject OtherTypeRepository others;
	}


### Properties

The keyword `property` is used to define a Java bean property (a field with corresponding getter and setter) for an entity:

	entity SomeType {
		@... // Isis and JDO annotations 
		property int someProperty
	}

A property can have additional features (supporting methods), e.g. default values or validation rules:

	entity SomeType {
		property int someProperty {
			default {
				1
			}
			validate {
				if (value < 0 && value > 10)
					"Proposed value out of bounds"
				else
					null
				}
			}
		}
	}

These features are described in the following chapters.


#### Property Rules

For properties imperative rules for visibility, usability and validity can be defined. These business rules provide additional checking and behaviour to be performed when the user interacts with those object members.


##### Hide

The keyword `hide` defines a boolean expression for hiding the property:

	property int someProperty {
		hide {
			isBlacklisted()
		}
	}


##### Disable

The keyword `disable` defines an expression for disabling (making read-only) the property. It returns a string with the reason for disabling or `null` if not disabled:

	property int someProperty {
		disable {
			if (isBlacklisted())
				"Cannot change for blacklisted entities")
			else
				null
		}
	}


##### Validate

The keyword `validate` defines an expression which validates a proposed value (parameter named `value`). It returns a string which is the reason the modification is vetoed or `null` if not vetoed:

	property int someProperty {
		validate {
			if (value < 0 && value > 10)
				"Proposed value out of bounds"
			else
				null
		}
	}


#### Derived Property

The keyword `derived` defines an expression which is used as getter of a non-persistent (derived) property. Derived properties have no instance variable and setter.

	property int someProperty {
		derived {
			someCalculation()
		}
	}

For these properties only the business rule `hide` is allowed.


#### Modify

The keyword `modify` defines an expression to update a property with a given value (parameter name `value`):

	property int someProperty {
		modify {
			doSomeStuff()
			setSomeProperty(value)
			doSomeOtherStuff()
		}
	}

Using this method allows business logic to be placed apart from the setter.


#### Clear

The keyword `clear` defines an expression to set a property to `null`:

	property String someProperty {
		clear {
			doSomeStuff()
			setSomeProperty(null)
			doSomeOtherStuff()
		}
	}

Using this method allows business logic to be placed apart from the setter.


#### Drop-Downs

The keyword `choices` defines an expression which returns a collection of values for this property. These values are used for populating drop-down list boxes:

	property int someProperty {
		choices {
			#[1, 2, 3]
		}
	}


#### Auto-Complete

The keyword `complete` defines an expression which returns a collection of values from a properties drop-down list box for a given search string (parameter name is `search`):

	property int someProperty {
		@MinLength(3)
		complete {
			switch search {
				case 'min' : #[1, 2]
				case 'max' : #[2, 3]
				default : #[]
			}
		}
	}

The optional annotation `@MinLength` specifies the minimum number of characters that must be entered before the auto-complete method is called.


#### Default

The keyword `default` defines an expression which returns the initial argument value for this property:

	property int someProperty {
		default {
			2
		}
	}


#### Property Event

With the keyword `event` a custom domain event (subtype of `PropertyDomainEvent`) can be defined: 

	@Property(domainEvent = SomeEvent)
	property int someProperty {
		event SomeEvent
	}


### Collections

The keyword `collection` is used to define a collection property (with its type and initial value) for an entity:

	entity SomeType {
		@... // Isis and JDO annotations
		collection Set<OtherType> someCollection = new TreeSet<>() {
		}
	}

A collection can have additional attributes (supporting methods), e.g. disable:

	entity SomeType {
		collection Set<OtherType> someCollection = new TreeSet<>() {
			disable {
				if (isBlacklisted())
					"Cannot changed for blacklisted entities")
				else
					null
			}
		}
	}

These features are described in the following chapters.

#### Collection Rules

For collection imperative rules for visibility, usability and validity can be defined. These business rules provide additional checking and behaviour to be performed when the user interacts with those object collections.


##### Hide

The keyword `hide` defines a boolean expression for hiding the collection:

	collection Set<OtherType> someCollection = new TreeSet<>() {
		hide {
			isBlacklisted()
		}
	}


##### Disable

The keyword `disable` defines an expression for disabling the collection.
It returns a string with the reason for disabling or `null` if not disabled:

	collection Set<OtherType> someCollection = new TreeSet<>() {
		disable {
			if (isBlacklisted())
				"Not allowed for blacklisted entities")
			else
				null
		}
	}


##### Validate[AddTo|RemoveFrom]

The keyword `validate[AddTo|RemoveFrom]` defines an expression which validates a proposed argument (parameter name `element`). It returns a string which is the reason the modification is vetoed or `null` if not vetoed:

	collection Set<OtherType> someCollection = new TreeSet<>() {
		validateAddTo {
			if (someCollection.contains(element))
				"Element is already added"
			else
				null
		}
		validateRemoveFrom {
			if (element.isInUse())
				"Element is still in use"
			else
				null
		}
	}


#### Derived Collection

The keyword `derived` defines an expression which is used as getter of a non-persistent (derived) collection. Derived collections have no instance variable and setter.

	collection Set<OtherType> someCollection = new TreeSet<>() {
		derived {
			someCalculation()
		}
	}

For these collections only the business rule `hide` is allowed.


#### AddTo

The keyword `addTo` defines an expression to add a given element (parameter name `element`) to the collection:

	collection Set<OtherType> someCollection = new TreeSet<>() {
		addTo {
			doSomeStuff()
			getSomeCollection().add(element)
			doSomeOtherStuff()
		}
	}

Using this method allows business logic to be placed apart from the update of the collection.


#### RemoveFrom

The keyword `removeFrom` defines an expression to remove a given element (parameter name `element`) from the collection:

	collection Set<OtherType> someCollection = new TreeSet<>() {
		removeFrom {
			doSomeStuff()
			getSomeCollection().remove(element)
			doSomeOtherStuff()
		}
	}

Using this method allows business logic to be placed apart from the update of the collection.


#### Collection Event

With the keyword `event` a custom domain event (subtype of `CollectionDomainEvent`) can be defined: 

	@Collection(domainEvent = SomeEvent)
	collection Set<OtherType> someCollection = new TreeSet<>() {
		event SomeEvent
	}


### Actions

The keyword `action` is used to define a method for an entity. The method expression (which evaluates the return value of the action) is defined with the keyword `body`:

	entity SomeType {
		@... // Isis and JDO annotations
		action boolean someAction {
			body {
				true
			}
		}
	}

An action can have additional attributes (supporting methods), e.g. disable:

	entity SomeType {
		action boolean someAction {
			body {
				true
			}
			disable {
				if (isBlacklisted())
					"Cannot executed for blacklisted entities")
				else
					null
			}
		}
	}

These features are described in the following chapters.

#### Action Rules

For actions imperative rules for visibility, usability and validity can be defined. These business rules provide additional checking and behaviour to be performed when the user interacts with those object actions.


##### Hide

The keyword `hide` defines a boolean expression for hiding the action:

	action boolean someAction {
		hide {
			isBlacklisted()
		}
	}


##### Disable

The keyword `disable` defines an expression for disabling the action.
It returns a string with the reason for disabling or `null` if not disabled:

	action boolean someAction {
		disable {
			if (isBlacklisted())
				"Not allowed for blacklisted entities")
			else
				null
		}
	}


##### Validate

The keyword `validate` defines an expression which validates a complete set of proposed action arguments (parameters are the same as for the action). It returns a string which is the reason the modification is vetoed or `null` if not vetoed:

	action Order placeOrder {
		validate {
			if (quantity > product.orderLimit)
				"May not order more than " + product.orderLimit + " items for this product"
			else
				null
		}
	}


#### Action Parameters

The action parameters (if any) are defined with the keyword `parameter`:

	action int someAction {
		@... // Isis and JDO annotations
		parameter int someParameter {
		}
		body {
			someParameter + 1
		}
	}

An action parameter can have additional attributes (supporting methods):

	action int someAction {
		@... // Isis and JDO annotations
		parameter int someParameter {
			default {
				5
			}
		}
		body {
			someParameter + 1
		}
	}

These features are described in the following chapters.


##### Default

The keyword `default` defines an expression which returns the initial argument value for this property:

	parameter int someParameter {
		default {
			5
		}
	}


##### Drop-Downs

The keyword `choices` defines an expression which returns a collection of values for this property. These values are used for populating drop-down list boxes:

	parameter int someParameter {
		choices {
			#[1, 2, 3]
		}
	}


##### Auto-Complete

The keyword `complete` defines an expression which returns a collection of values from a properties drop-down list box for a given search string (parameter name is `search`):

	parameter int someParameter {
		@MinLength(3)
		complete {
			switch search {
				case 'min' : #[1, 2]
				case 'max' : #[2, 3]
				default : #[]
			}
		}
	}

The optional annotation `@MinLength` specifies the minimum number of characters that must be entered before the auto-complete method is called


##### Validate

The keyword `validate` defines an expression which validates a proposed value (parameter named `value`). It returns a string which is the reason the modification is vetoed or `null` if not vetoed:

	parameter int someParameter {
		validate {
			if (value < 0 && value > 10)
				"Proposed value out of bounds"
			else
				null
		}
	}


#### Action Event

With the keyword `event` a custom domain event (subtype of `ActionDomainEvent`) can be defined: 

	@Action(domainEvent = SomeEvent)
	action someAction {
		event SomeEvent
	}


## Services

Domain services, factories or repositories are defined with the keyword `service`. They have a unique name and are preceeded by Isis or selected JDO annotations.

	@... // Isis and JDO annotations 
	service SomeService {
	}


### Inheritance

By using the keyword `extends` a service can inherit from another service:

	service SomeService extends SomeSuperType {
	}


### Injections

With the keyword `inject` an Isis service can be autowired (field injection) into a service:

	service SomeService {
		inject OtherTypeRepository others;
	}


### Actions

Services support the same kind of actions like [entities](#entities), e.g.

	service SomeService {
		@... // Isis and JDO annotations
		action boolean someAction {
			body {
				true
			}
			disable {
				if (isBlacklisted())
					"Cannot executed for blacklisted service")
				else
					null
			}
		}
	}

Service actions have the same features as [entity actions](#actions):

 * [Rules](#action-rules)
 * [Parameters](#action-parameters)
 * [Event](#action-event)


## Behaviours

Behaviours ([Mixins](http://isis.apache.org/guides/rgant.html#_rgant-Mixin)) are defined with the keyword `behaviour`. They have a unique name and are preceeded by Isis or selected JDO annotations.
The parameter of the behaviour's single-argument constructor is defined after the keyword `for`. 

	@... // Isis and JDO annotations 
	behaviour SomeBehaviour for SomeObject obj {
	}


### Inheritance

By using the keyword `extends` a behaviour can inherit from another type:

	behaviour SomeBehaviour for SomeObject obj extends SomeSuperType {
	}


### Injections

With the keyword `inject` an Isis service can be autowired (field injection) into a behaviour:

	behaviour SomeBehaviour for SomeObject obj {
		inject OtherTypeRepository others;
	}


### Actions

Behaviours support the same kind of actions like [service](#services), e.g.

	behaviour SomeBehaviour for SomeObject obj {
		@... // Isis and JDO annotations
		action SomeObject $$ {
			body {
				obj
			}
			disable {
				if (isBlacklisted())
					"Cannot executed for blacklisted behaviour")
				else
					null
			}
		}
	}

Behaviour actions have the same features as [service actions](#actions):

 * [Rules](#action-rules)
 * [Parameters](#action-parameters)
 * [Event](#action-event)
 