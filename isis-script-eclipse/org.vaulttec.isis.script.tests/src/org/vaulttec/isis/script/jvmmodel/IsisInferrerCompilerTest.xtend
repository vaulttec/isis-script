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
package org.vaulttec.isis.script.jvmmodel

import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.TemporaryFolder
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.vaulttec.isis.script.IsisInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(IsisInjectorProvider))
class IsisInferrerCompilerTest {

	@Rule @Inject public TemporaryFolder temporaryFolder
	@Inject extension CompilationTestHelper

	@Test
	def void testEmptyEntity() {
		'''
			package org.vaulttec.isis.script.test
			entity Entity1 {
			}
		'''.assertCompilesTo(
        '''
			package org.vaulttec.isis.script.test;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			
			@SuppressWarnings("all")
			public class Entity1 implements Comparable<Entity1> {
			  @Inject
			  @SuppressWarnings("unused")
			  DomainObjectContainer container;
			  
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
			package org.vaulttec.isis.script.test
			entity Child {
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
			package org.vaulttec.isis.script.test;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.Identifier;
			import org.apache.isis.applib.services.eventbus.PropertyDomainEvent;
			
			@SuppressWarnings("all")
			public class Child implements Comparable<Child> {
			  @Inject
			  @SuppressWarnings("unused")
			  DomainObjectContainer container;
			  
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
			  
			  public static class Event1 extends PropertyDomainEvent<Child, Integer> {
			    public Event1(final Child source, final Identifier identifier) {
			      super(source, identifier);
			    }
			    
			    public Event1(final Child source, final Identifier identifier, final int oldValue, final int newValue) {
			      super(source, identifier, oldValue, newValue);
			    }
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
			    public Event2(final Child source, final Identifier identifier) {
			      super(source, identifier);
			    }
			    
			    public Event2(final Child source, final Identifier identifier, final String oldValue, final String newValue) {
			      super(source, identifier, oldValue, newValue);
			    }
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
			package org.vaulttec.isis.script.test
			entity Child {
				@org.apache.isis.applib.annotation.Collection(editing = org.apache.isis.applib.annotation.Editing.ENABLED)
				collection java.util.Set<Integer> collec1 = new java.util.TreeSet<Integer> {
					addTo {
						getCollec1().add(element)
					}
					removeFrom {
						getCollec1().remove(element)
					}
				}

				@org.apache.isis.applib.annotation.Collection(editing = org.apache.isis.applib.annotation.Editing.DISABLED)
				collection java.util.List<String> collec2 = new java.util.ArrayList<String> {
					addTo {
						getCollec2().add(element)
					}
					removeFrom {
						getCollec2().remove(element)
					}
				}
			}
		'''.assertCompilesTo(
		'''
			package org.vaulttec.isis.script.test;
			
			import java.util.ArrayList;
			import java.util.List;
			import java.util.Set;
			import java.util.TreeSet;
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			import org.apache.isis.applib.annotation.Collection;
			import org.apache.isis.applib.annotation.Editing;
			
			@SuppressWarnings("all")
			public class Child implements Comparable<Child> {
			  @Inject
			  @SuppressWarnings("unused")
			  DomainObjectContainer container;
			  
			  private Set<Integer> collec1 = new TreeSet<Integer>();
			  
			  @Collection(editing = Editing.ENABLED)
			  public Set<Integer> getCollec1() {
			    return this.collec1;
			  }
			  
			  public void setCollec1(final Set<Integer> collec1) {
			    this.collec1 = collec1;
			  }
			  
			  public void addToCollec1(final Integer element) {
			    Set<Integer> _collec1 = this.getCollec1();
			    _collec1.add(element);
			  }
			  
			  public void removeFromCollec1(final Integer element) {
			    Set<Integer> _collec1 = this.getCollec1();
			    _collec1.remove(element);
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
			    List<String> _collec2 = this.getCollec2();
			    _collec2.add(element);
			  }
			  
			  public void removeFromCollec2(final String element) {
			    List<String> _collec2 = this.getCollec2();
			    _collec2.remove(element);
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
			package org.vaulttec.isis.script.test
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
			package org.vaulttec.isis.script.test;
			
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			
			@SuppressWarnings("all")
			public class Service1 {
			  @Inject
			  @SuppressWarnings("unused")
			  DomainObjectContainer container;
			  
			  public String action1() {
			    return "";
			  }
			  
			  public int action2() {
			    return 42;
			  }
			}
		''')
	}

}