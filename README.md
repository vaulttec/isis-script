# Isis Script

Isis Script is an [Xtext](http://xtext.org)-based [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for generating Java code for the [Apache Isis framework](http://isis.apache.org) from a textual representation.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [The DSL](#the-dsl)
- [The Implementation](#the-implementation)
- [The Tools](#the-tools)
  - [The Eclipse DSL Editor](#the-eclipse-dsl-editor)
  - [The Maven Support](#the-maven-support)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## The DSL

The [Isis Script DSL](https://github.com/vaulttec/isis-script/blob/develop/dsl.md) is inspired by concepts from [Domain-Driven Design](http://domaindrivendesign.org/books/). It provides keywords for creating entities (with their annotations, injections, properties, events, actions and UI hints) and services (with their annotations, injections and actions).
To map the Isis Script DSL to the corresponding Java code the notion of packages and imports are supported as well.

The following example shows an entity with a property, an action publishing an event and a title UI hint:

```java
package domainapp.dom.modules.simple

import org.apache.isis.applib.annotation.Action
import org.apache.isis.applib.annotation.DomainObject

@DomainObject(objectType = "SIMPLE")
@Queries(#[
	@Query(name = "findByName", language = "JDOQL",
		value = "SELECT FROM domainapp.dom.modules.simple.SimpleObject WHERE name.indexOf(:name) >= 0")
])
entity SimpleObject {
	property String name

	@Action(domainEvent = UpdateNameDomainEvent)
	action void updateName {
		parameter String newName
		body {
			setName(newName)
		}
		event UpdateNameDomainEvent
	}

	title {
		TranslatableString.tr("Object: {name}", "name", name)
	}
}
```

The following example (package and imports are omitted for brevity) shows a repository service for the aforementioned entity:

```java
@DomainService(repositoryFor = SimpleObject)
service SimpleObjects {
	action List<SimpleObject> listAll {
		body {
			container.allInstances(SimpleObject)
		}
	}

	action List<SimpleObject> findByName {
		@ParameterLayout(named="Name") 
		parameter String name
		body {
			container.allMatches(new QueryDefault(SimpleObject, "findByName", "name", name))
		}
	}
}
```

The following example (package and imports are omitted for brevity) shows a service with an action using an injected repository:

```java
service SimpleObjectProvider {
	inject SimpleObjects repo

	action List<SimpleObject> allObjects {
		body {
			repo.listAll
		}
	}
}
```

The following examples shows the complete Isis Script for the entity and repository service of the domain object `SimpleObject` from the [Isis Script `simpleapp` example project](https://github.com/vaulttec/isis-script/tree/develop/isis-script-examples/simpleapp) created from the [Apache Isis Maven archetype SimpleApp](http://isis.apache.org/guides/ug.html#_ug_getting-started_simpleapp-archetype):

```java
package domainapp.dom.modules.simple

import javax.jdo.annotations.Column
import javax.jdo.annotations.DatastoreIdentity
import javax.jdo.annotations.IdGeneratorStrategy
import javax.jdo.annotations.IdentityType
import javax.jdo.annotations.PersistenceCapable
import javax.jdo.annotations.Queries
import javax.jdo.annotations.Query
import javax.jdo.annotations.Unique
import javax.jdo.annotations.Version
import javax.jdo.annotations.VersionStrategy
import org.apache.isis.applib.annotation.Action
import org.apache.isis.applib.annotation.BookmarkPolicy
import org.apache.isis.applib.annotation.DomainObject
import org.apache.isis.applib.annotation.DomainObjectLayout
import org.apache.isis.applib.annotation.Editing
import org.apache.isis.applib.annotation.Parameter
import org.apache.isis.applib.annotation.ParameterLayout
import org.apache.isis.applib.annotation.Property
import org.apache.isis.applib.annotation.Title
import org.apache.isis.applib.services.i18n.TranslatableString

@PersistenceCapable(identityType=IdentityType.DATASTORE)
@DatastoreIdentity(strategy=IdGeneratorStrategy.IDENTITY, column="id")
@Version(strategy=VersionStrategy.VERSION_NUMBER, column="version")
@Queries(#[
	@Query(name = "find", language = "JDOQL",
		value = "SELECT FROM domainapp.dom.modules.simple.SimpleObject"),
	@Query(name = "findByName", language = "JDOQL",
		value = "SELECT FROM domainapp.dom.modules.simple.SimpleObject WHERE name.indexOf(:name) >= 0")
])
@Unique(name="SimpleObject_name_UNQ", members = #["name"])
@DomainObject(objectType = "SIMPLE")
@DomainObjectLayout(bookmarking = BookmarkPolicy.AS_ROOT)
entity SimpleObject {

	@Column(allowsNull="false", length = 40)
	@Title(sequence="1")
	@Property(editing = Editing.DISABLED)
	property String name

	@Action(domainEvent = UpdateNameDomainEvent)
	action SimpleObject updateName {
		@Parameter(maxLength = 40)
		@ParameterLayout(named = "New name")
		parameter String newName {
			default {
				getName
			}
		}
		body {
			setName(newName)
			this
		}
		validate {
	        if (newName.contains("!"))
	        	TranslatableString.tr("Exclamation mark is not allowed")
	        else null
		}
		event UpdateNameDomainEvent
	}

	title {
		TranslatableString.tr("Object: {name}", "name", name)
	}
}
```

```java
package domainapp.dom.modules.simple

import org.apache.isis.applib.annotation.DomainServiceLayout
import org.apache.isis.applib.annotation.DomainService
import org.apache.isis.applib.annotation.Action
import org.apache.isis.applib.annotation.SemanticsOf
import org.apache.isis.applib.annotation.BookmarkPolicy
import org.apache.isis.applib.annotation.ActionLayout
import org.apache.isis.applib.annotation.MemberOrder
import org.apache.isis.applib.annotation.ParameterLayout
import org.apache.isis.applib.query.QueryDefault
import java.util.List

@DomainService(repositoryFor = SimpleObject)
@DomainServiceLayout(menuOrder = "10")
service SimpleObjects {

	@Action(semantics = SemanticsOf.SAFE)
	@ActionLayout(bookmarking = BookmarkPolicy.AS_ROOT)
	@MemberOrder(sequence = "1")
	action List<SimpleObject> listAll {
		body {
			container.allInstances(SimpleObject)
		}
	}

	@Action(semantics = SemanticsOf.SAFE)
	@ActionLayout(bookmarking = BookmarkPolicy.AS_ROOT)
	@MemberOrder(sequence = "2")
	action List<SimpleObject> findByName {
		@ParameterLayout(named="Name") 
		parameter String name
		body {
			container.allMatches(new QueryDefault(SimpleObject, "findByName", "name", name))
		}
	}

	@MemberOrder(sequence = "3")
	action SimpleObject create {
		@ParameterLayout(named="Name")
		parameter String name
		body {
			val obj = container.newTransientInstance(SimpleObject)
			obj.name = name
			container.persistIfNotAlready(obj)
			obj
		}
	}
}
```

A formal description of the Isis Script DSL can be found [here](https://github.com/vaulttec/isis-script/blob/develop/dsl.md).


## The Implementation

Isis Script uses [Xtexts support for accessing JVM types](https://www.eclipse.org/Xtext/documentation/305_xbase.html#jvmtypes), e.g. for Java annotations, super types, return types or parameters.

```java
@Action(domainEvent = UpdateNameDomainEvent)
action SimpleObject updateName {
	@Parameter(maxLength = 40)
	@ParameterLayout(named = "New name")
	parameter String newName {
```

[Xbase expressions](https://www.eclipse.org/Xtext/documentation/305_xbase.html#xbase-expressions) are used to implement the dynamic parts of the DSL, e.g. property features, actions or UI hints.

```java
validate {
    if (newName.contains("!"))
    	TranslatableString.tr("Exclamation mark is not allowed")
    else null
}
```

Isis Script files (which are using the file name extension `.isis`) are representing a single Java type. Depending on the declaration type keyword (`entity` or `service`) the corresponding source code is generated in the package defined via the `package` keyword within the folder `target/generated-sources/isis/`. This source code is plain Java which is compiled by the Java compiler.


## The Tools

### The Eclipse DSL Editor

Isis Script comes with an [Xtext](http://xtext.org)-generated [Eclipse](http://www.eclipse.org) editor which supports the [IDE features](https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html) known from the Java editor, e.g

* Syntax Coloring
* Outline View
* Content Assist
* Organize Imports
* Validator
* Quick Fixes
* Hyper Linking

![DSL Editor](/../images/screenshots/simpleobject-dsl-editor.png?raw=true "DSL Editor")
	
The source code in the editor is evaluated while typing. So the outline and the problems markers are updated automatically. 
If enabled then selecting a node in the outline then the corresponding code block is selected in the editor view.

![DSL Editor with selection in outline](/../images/screenshots/simpleobject-dsl-editor-outline.png?raw=true "DSL Editor with selection in outline")

When a modified Isis Script is saved in the editor then the corresponding Java source file is generated within the folder `target/generated-sources/isis/`.

![Generated Java Source Code](/../images/screenshots/simpleobject-java-editor.png?raw=true "Generated Java Source Code")

To switch between the generated Java source file and the Isis Script file the option "Open Generated File" / "Open Source File" from the editors context menu can be used.


### The Maven Support

Isis Script files are compiled to Java source code via the [Xtext Maven Plugin](https://eclipse.org/Xtext/documentation/350_continuous_integration.html). To add the Isis Script output folder to Mavens list of Java source folder the [Build Helper Maven Plugin](http://www.mojohaus.org/build-helper-maven-plugin/) is used. Finally the generated Java source code is compiled by the Maven Compiler Plugin.

A corresponding Maven POM is available in the [`simpleapp` example project](https://github.com/vaulttec/isis-script/tree/develop/isis-script-examples/simpleapp).    


## System Requirements

To use Isis Script you need local installations of the following tools:

* [Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/) (1.7 or newer)
* [Eclipse](http://eclipse.org/downloads/) (4.2 or newer) with [Xtext](http://www.eclipse.org/Xtext/download.html) (2.7.0 or newer)


## Installation

The Isis Script Editor can be installed with the Eclipse Update Manager `Help > Install New Software...` from the
update site [https://raw.githubusercontent.com/vaulttec/isis-script/updatesite/](https://raw.githubusercontent.com/vaulttec/isis-script/updatesite/).


## License

Isis Script is released under the [Eclipse Public License, Version 1.0](http://www.eclipse.org/org/documents/epl-v10.php).
