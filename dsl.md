# Isis Script DSL

The different aspects of the Isis Script DSL are explained in the following sections.  


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

A property can have additional attributes (supporting methods):

	entity SomeType {
		property int someProperty {
			default {
				1
			}
			validate {
				if (proposed < 0 && proposed > 10)
					"Proposed value out of bounds"
				else
					null
				}
			}
		}
	}

These features are described in the ollowing chapters.


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

The keyword `disable` defines an expression for disabling (making read-only) the property. It returns a string with e reason for disabling or `null` if not disabled:

	property int someProperty {
		disable {
			if (isBlacklisted())
				"Cannot change for blacklisted entities")
			else
				null
		}
	}


##### Validate

The keyword `validate` defines an expression which validates a proposed value. It returns a string which is the reason the modification is vetoed or `null` if not vetoed:

	property int someProperty {
		validate {
			if (proposed < 0 && proposed > 10)
				"Proposed value out of bounds"
			else
				null
		}
	}


#### Derived Property

The keyword `derived` defines an expression which is used for the getter of a non-persistent (derived) property. Derived properties have no instance variable and setter.

	property int someProperty {
		derived {
			someCalculation()
		}
	}

For these properties only the business rule `hide` is allowed.


#### Modify

The keyword `modify` defines an expression to update a property with a given value (parameter name is the same as the property name):

	property int someProperty {
		modify {
			doSomeStuff()
			setSomeProperty(someProperty)	// 'someProperty' is the method parameter
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


#### Default

The keyword `default` defines an expression which returns the initial argument value for this property:

	property int someProperty {
		default {
			2
		}
	}


### Actions

TODO


### Events

With the keyword `event` a domain event (subtype of `ActionDomainEvent`) can be defined: 

	entity SomeType {
		event SomeEvent;

		@Action(domainEvent = SomeEvent)
		action someAction {
		}
	}
