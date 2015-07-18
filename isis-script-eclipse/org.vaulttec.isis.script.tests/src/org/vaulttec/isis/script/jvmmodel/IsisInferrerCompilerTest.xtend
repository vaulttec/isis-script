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
import org.eclipse.xtext.util.IAcceptor
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import static org.junit.Assert.*
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
			  private DomainObjectContainer container;
			  
			  @Override
			  public int compareTo(final Entity1 other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other, "");
			  }
			}
		''')
	}

	@Test
	def void testEntityRepository() {
		'''
			package org.vaulttec.isis.script.test
			entity Child {
				repository {
					inject Object injectedObj
					action listAll() {
						container.allInstances(Child)
					}
				}
			}
		'''.compile(new IAcceptor<CompilationTestHelper.Result>() {
			override accept(Result r) {
				assertEquals(2, r.generatedCode.size)
				assertEquals('''
					package org.vaulttec.isis.script.test;
					
					import java.util.List;
					import javax.inject.Inject;
					import org.apache.isis.applib.DomainObjectContainer;
					import org.apache.isis.applib.annotation.DomainService;
					import org.vaulttec.isis.script.test.Child;
					
					@DomainService(repositoryFor = Child.class)
					@SuppressWarnings("all")
					public class Children {
					  @Inject
					  @SuppressWarnings("unused")
					  private DomainObjectContainer container;
					  
					  @Inject
					  @SuppressWarnings("unused")
					  private Object injectedObj;
					  
					  public List<Child> listAll() {
					    return this.container.<Child>allInstances(Child.class);
					  }
					}
				'''.toString, r.getGeneratedCode("org.vaulttec.isis.script.test.Children"))
			}
		})
	}

	@Test
	def void testEntityEvent() {
		'''
			package org.vaulttec.isis.script.test
			entity Child {
				event NameChangedEvent
			}
		'''.assertCompilesTo(
		'''
			package org.vaulttec.isis.script.test;
			
			import java.util.List;
			import javax.inject.Inject;
			import org.apache.isis.applib.DomainObjectContainer;
			
			@SuppressWarnings("all")
			public class Child implements Comparable<Child> {
			  @Inject
			  @SuppressWarnings("unused")
			  private DomainObjectContainer container;
			  
			  public static class NameChangedEvent implements org.apache.isis.applib.services.eventbus.ActionDomainEvent {
			    public NameChangedEvent(final Child source, final org.apache.isis.applib.Identifier identifier) {
			      super(source, identifier);
			    }
			    
			    public NameChangedEvent(final Child source, final org.apache.isis.applib.Identifier identifier, final Object... arguments) {
			      super(source, identifier, arguments);
			    }
			    
			    public NameChangedEvent(final Child source, final org.apache.isis.applib.Identifier identifier, final List<Object> arguments) {
			      super(source, identifier, arguments);
			    }
			  }
			  
			  @Override
			  public int compareTo(final Child other) {
			    return org.apache.isis.applib.util.ObjectContracts.compare(this, other, "");
			  }
			}
		''')
	}

}