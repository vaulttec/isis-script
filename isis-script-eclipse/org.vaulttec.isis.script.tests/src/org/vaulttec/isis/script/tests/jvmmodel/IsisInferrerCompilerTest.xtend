/*******************************************************************************
 * Copyright (c) 2015 Torsten Juergeleit.
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 * 
 * The Eclipse Public License is available at
 *    http://www.eclipse.org/legal/epl-v10.html
 * and the Eclipse Distribution License is available at
 *    http://www.eclipse.org/org/documents/edl-v10.html.
 * 
 * Contributors:
 *     Torsten Juergeleit - initial API and implementation
 *******************************************************************************/
package org.vaulttec.isis.script.tests.jvmmodel

import javax.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.xbase.testing.CompilationTestHelper
import org.eclipse.xtext.xbase.testing.TemporaryFolder
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.vaulttec.isis.script.tests.IsisInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(IsisInjectorProvider))
class IsisInferrerCompilerTest {

	@Rule @Inject public TemporaryFolder temporaryFolder
	@Inject extension CompilationTestHelper

	@Test
	def void testEmptyEntity() {
		'''
			package org.vaulttec.isis.script.tests
			entity Entity1 {
			}
		'''.assertCompilesTo(
        '''
			package org.vaulttec.isis.script.tests;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			
			@SuppressWarnings("all")
			public class Entity1 implements Comparable<Entity1> {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  @Override
			  public String toString() {
			    return org.apache.isis.applib.util.ObjectContracts.toString(this);
			  }
			  
			  @Override
			  public int compareTo(final Entity1 other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other);
			  }
			}
		''')
	}
	
	@Test
	def void testDerivedProperty() {
		'''
			package org.vaulttec.isis.script.tests
			entity Entity1 {
			  property String prop1 {
			    derived {
			      "result"
			    }
			  }
			}
		'''.assertCompilesTo(
        '''
			package org.vaulttec.isis.script.tests;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			
			@SuppressWarnings("all")
			public class Entity1 implements Comparable<Entity1> {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  public String getProp1() {
			    return "result";
			  }
			  
			  @Override
			  public String toString() {
			    return org.apache.isis.applib.util.ObjectContracts.toString(this);
			  }
			  
			  @Override
			  public int compareTo(final Entity1 other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other);
			  }
			}
		''')
	}

	@Test
	def void testEntityWithProperties() {
		'''
			package org.vaulttec.isis.script.tests
			entity Child {
				@org.apache.isis.applib.annotation.Property(
					domainEvent = org.apache.isis.applib.services.eventbus.PropertyDomainEvent.Default,
					editing = org.apache.isis.applib.annotation.Editing.DISABLED)
				property int prop1 {
					default {
						42
					}
					event Event1
				}
				property String prop2 {
					default {
						""
					}
					event Event2
				}
			}
		'''.assertCompilesTo(
		'''
			package org.vaulttec.isis.script.tests;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.annotation.Editing;
			import org.apache.isis.applib.annotation.Property;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.eventbus.PropertyDomainEvent;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			
			@SuppressWarnings("all")
			public class Child implements Comparable<Child> {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  private int prop1;
			  
			  @Property(domainEvent = PropertyDomainEvent.Default.class, editing = Editing.DISABLED)
			  public int getProp1() {
			    return this.prop1;
			  }
			  
			  public void setProp1(final int prop1) {
			    this.prop1 = prop1;
			  }
			  
			  public int defaultProp1() {
			    return 42;
			  }
			  
			  public static class Event1 extends PropertyDomainEvent<Child, Integer> {
			  }
			  
			  private String prop2;
			  
			  public String getProp2() {
			    return this.prop2;
			  }
			  
			  public void setProp2(final String prop2) {
			    this.prop2 = prop2;
			  }
			  
			  public String defaultProp2() {
			    return "";
			  }
			  
			  public static class Event2 extends PropertyDomainEvent<Child, String> {
			  }
			  
			  @Override
			  public String toString() {
			    return org.apache.isis.applib.util.ObjectContracts.toString(this, "prop1","prop2");
			  }
			  
			  @Override
			  public int compareTo(final Child other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other, "prop1","prop2");
			  }
			}
		''')
	}

	@Test
	def void testEntityWithCollections() {
		'''
			package org.vaulttec.isis.script.tests
			entity Child {
				@org.apache.isis.applib.annotation.Collection(editing = org.apache.isis.applib.annotation.Editing.ENABLED)
				collection java.util.Set<Integer> collec1 = new java.util.TreeSet<Integer> {
					addTo {
					}
					validateAddTo {
					}
					removeFrom {
					}
					validateRemoveFrom {
					}
				}

				@org.apache.isis.applib.annotation.Collection(editing = org.apache.isis.applib.annotation.Editing.DISABLED)
				collection java.util.List<String> collec2 = new java.util.ArrayList<String> {
					addTo {
					}
					validateAddTo {
					}
					removeFrom {
					}
					validateRemoveFrom {
					}
				}
			}
		'''.assertCompilesTo(
		'''
			package org.vaulttec.isis.script.tests;
			
			import java.util.ArrayList;
			import java.util.List;
			import java.util.Set;
			import java.util.TreeSet;
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.annotation.Collection;
			import org.apache.isis.applib.annotation.Editing;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			
			@SuppressWarnings("all")
			public class Child implements Comparable<Child> {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  private Set<Integer> collec1 = new TreeSet<Integer>();
			  
			  @Collection(editing = Editing.ENABLED)
			  public Set<Integer> getCollec1() {
			    return this.collec1;
			  }
			  
			  public void setCollec1(final Set<Integer> collec1) {
			    this.collec1 = collec1;
			  }
			  
			  public void addToCollec1(final Integer element) {
			  }
			  
			  public Object validateAddToCollec1(final Set<Integer> element) {
			    return null;
			  }
			  
			  public void removeFromCollec1(final Integer element) {
			  }
			  
			  public Object validateRemoveFromCollec1(final Set<Integer> element) {
			    return null;
			  }
			  
			  private List<String> collec2 = new ArrayList<String>();
			  
			  @Collection(editing = Editing.DISABLED)
			  public List<String> getCollec2() {
			    return this.collec2;
			  }
			  
			  public void setCollec2(final List<String> collec2) {
			    this.collec2 = collec2;
			  }
			  
			  public void addToCollec2(final String element) {
			  }
			  
			  public Object validateAddToCollec2(final List<String> element) {
			    return null;
			  }
			  
			  public void removeFromCollec2(final String element) {
			  }
			  
			  public Object validateRemoveFromCollec2(final List<String> element) {
			    return null;
			  }
			  
			  @Override
			  public String toString() {
			    return org.apache.isis.applib.util.ObjectContracts.toString(this);
			  }
			  
			  @Override
			  public int compareTo(final Child other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other);
			  }
			}
		''')
	}

	@Test
	def void testService() {
		'''
			package org.vaulttec.isis.script.tests
			service Service1 {
				action String action1 {
					body {
						""
					}
				}
				action int action2 {
					body {
						42
					}
				}
			}
		'''.assertCompilesTo(
        '''
			package org.vaulttec.isis.script.tests;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			
			@SuppressWarnings("all")
			public class Service1 {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  public String action1() {
			    return "";
			  }
			  
			  public int action2() {
			    return 42;
			  }
			}
		''')
	}

	@Test
	def void testBehaviour() {
		'''
			package org.vaulttec.isis.script.tests
			behaviour Behaviour1 for String text {
			}
		'''.assertCompilesTo(
        '''
			package org.vaulttec.isis.script.tests;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			
			@SuppressWarnings("all")
			public class Behaviour1 {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  private String text;
			  
			  public Behaviour1(final String text) {
			    this.text = text;
			  }
			}
		''')
	}

	@Test
	def void testEntityWithModule() {
		'''
			package org.vaulttec.isis.script.tests
			module TestAppModule
			entity Child {
				property int prop1 {
					default {
						42
					}
					event Event1
				}
				collection java.util.List<String> coll1 = new java.util.ArrayList<String>() {
					event Event2
				}
				action String action1 {
					body {
						""
					}
					event Event3
				}
			}
		'''.assertCompilesTo(
		'''
			package org.vaulttec.isis.script.tests;
			
			import java.util.ArrayList;
			import java.util.List;
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.services.config.ConfigurationService;
			import org.apache.isis.applib.services.factory.FactoryService;
			import org.apache.isis.applib.services.message.MessageService;
			import org.apache.isis.applib.services.registry.ServiceRegistry2;
			import org.apache.isis.applib.services.repository.RepositoryService;
			import org.apache.isis.applib.services.title.TitleService;
			import org.apache.isis.applib.services.user.UserService;
			import org.vaulttec.isis.script.tests.TestAppModule;
			
			@SuppressWarnings("all")
			public class Child implements Comparable<Child> {
			  @Inject
			  DomainObjectContainer container;
			  
			  @Inject
			  FactoryService factoryService;
			  
			  @Inject
			  ServiceRegistry2 serviceRegistry;
			  
			  @Inject
			  RepositoryService repositoryService;
			  
			  @Inject
			  TitleService titleService;
			  
			  @Inject
			  MessageService messageService;
			  
			  @Inject
			  ConfigurationService configService;
			  
			  @Inject
			  UserService userService;
			  
			  public static abstract class PropertyDomainEvent<T> extends TestAppModule.PropertyDomainEvent<Child, T> {
			  }
			  
			  public static abstract class CollectionDomainEvent<T> extends TestAppModule.CollectionDomainEvent<Child, T> {
			  }
			  
			  public static abstract class ActionDomainEvent extends TestAppModule.ActionDomainEvent<Child> {
			  }
			  
			  private int prop1;
			  
			  public int getProp1() {
			    return this.prop1;
			  }
			  
			  public void setProp1(final int prop1) {
			    this.prop1 = prop1;
			  }
			  
			  public int defaultProp1() {
			    return 42;
			  }
			  
			  public static class Event1 extends Child.PropertyDomainEvent<Integer> {
			  }
			  
			  private List<String> coll1 = new ArrayList<String>();
			  
			  public List<String> getColl1() {
			    return this.coll1;
			  }
			  
			  public void setColl1(final List<String> coll1) {
			    this.coll1 = coll1;
			  }
			  
			  public static class Event2 extends Child.CollectionDomainEvent<List<String>> {
			  }
			  
			  public String action1() {
			    return "";
			  }
			  
			  public static class Event3 extends Child.ActionDomainEvent {
			  }
			  
			  @Override
			  public String toString() {
			    return org.apache.isis.applib.util.ObjectContracts.toString(this, "prop1");
			  }
			  
			  @Override
			  public int compareTo(final Child other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other, "prop1");
			  }
			}
		''')
	}

}