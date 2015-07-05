# Isis Script

Isis Script is an [Xtext](http://xtext.org)-based [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for generating Java code for the [Apache Isis framework](http://isis.apache.org) from a textual representation.


## The DSL

The Isis Script DSL is inspired by concepts from [Domain-Driven Design](http://domaindrivendesign.org/books/). It provides keywords for creating entities, service, repositories or events.

```java
entity SimpleObject {
    property String name

	event UpdateNameDomainEvent

	title {
		name
	}
}
```

Isis Script uses [Xtexts support for accessing JVM types](https://www.eclipse.org/Xtext/documentation/305_xbase.html#jvmtypes), e.g. for Java annotations, super types, return types or parameters.

```java
@Action(domainEvent = SimpleObject.UpdateNameDomainEvent)
action SimpleObject updateName(
        @Parameter(maxLength = 40)
        @ParameterLayout(named = "New name")
        String newName) {
```

To map the Isis Script DSL to the corresponding Java code the notion of packages and imports are supported as well.

```java
package domainapp.dom.modules.simple

import org.apache.isis.applib.annotation.DomainObject
import org.apache.isis.applib.annotation.DomainObjectLayout

@DomainObject(objectType = "SIMPLE")
@DomainObjectLayout(bookmarking = BookmarkPolicy.AS_ROOT)
entity SimpleObject {
}
```

[Xbase expressions](https://www.eclipse.org/Xtext/documentation/305_xbase.html#xbase-expressions) are used to implement the dynamic parts of the DSL, e.g. property features, action or UI hints.

```java
action TranslatableString validateUpdateName(String name) {
    if (name.contains("!"))
        TranslatableString.tr("Exclamation mark is not allowed")
    else
        null
}

title {
    TranslatableString.tr("Object: {name}", "name", name)
}
```

Isis Script files (which are using the file name extension `.isis`) are representing a single Java type. Depending declaration type keyword (`entity` or `service`) used in the DSL the corresponding source code is generated in the package defined via the `package` keyword within the folder `target/generated-sources/isis/`. This source code is plain Java which is compiled by the Java compiler.


## The Tools

Isis Script comes with an [Xtext](http://xtext.org)-generated [Eclipse](http://www.eclipse.org) editor which supports the [IDE features](https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html) known from the Java editor, e.g

* Syntax Coloring
* Outline View
* Content Assist
* Quick Fixes
* Hyper Linking

![DSL Editor](/../images/screenshots/simpleobject-dsl-editor.png?raw=true "DSL Editor")
	
The source code in the editor is evaluated while typing. So the outline and the problems markers are updated automatically. When a modified Isis Script is saved in the editor then the corresponding Java source file is generated in within the folder `target/generated-sources/isis/`.

![Generated Java Source Code](/../images/screenshots/simpleobject-java-editor.png?raw=true "Generated Java Source Code")

To switch between the generated Java source code and the Isis Script file the option "Open Generated File" / "Open Source File" from the editors context menu can be used.


## System Requirements

To use Isis Script you need local installations of the following tools:

* [Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/) (1.7 or newer)
* [Eclipse](http://eclipse.org/downloads/) (4.2 or newer) with [Xtext](http://www.eclipse.org/Xtext/download.html) (2.7.0 or newer)


## Installation

The Isis Script Editor can be installed with the Eclipse Update Manager `Help > Install New Software...` from the
update site [https://raw.githubusercontent.com/vaulttec/isis-script/updatesite/](https://raw.githubusercontent.com/vaulttec/isis-script/updatesite/).


## License

Isis Script is released under the [Ecilpse Public License, Version 1.0](http://www.eclipse.org/org/documents/epl-v10.php).
