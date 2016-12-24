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
package org.vaulttec.isis.script.tests

import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.tests.IsisInjectorProvider

import static org.junit.Assert.*
import org.vaulttec.isis.script.dsl.IsisPropertyFeatureType
import org.eclipse.xtext.xbase.XStringLiteral

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(IsisInjectorProvider))
class IsisParsingTest {

	@Inject extension ParseHelper<IsisFile>
	@Inject extension ValidationTestHelper

	@Test
	def void parseEntity() {
		'''
			package org.vaulttec.isis.script.test
			entity Entity1 {
				inject Object injection1
				property int prop1 {
					default {
						-1
					}
					event Event1
				}
				property String prop2 {
					derived {
						"result"
					}
				}
				collection java.util.Set<String> collection1 = new java.util.TreeSet<String> {
					event Event2
				}
				action String action1 {
					body {
						""
					}
					event Event3
				}
			}
		'''.parse => [
			assertNoErrors
			assertEquals("org.vaulttec.isis.script.test", package.name)
			val entity = declaration as IsisEntity
			assertEquals("Entity1", entity.name)
			assertEquals("injection1", entity.injections.get(0).name)
			
			assertEquals("prop1", entity.properties.get(0).name)
			assertEquals("Event1", entity.properties.get(0).events.get(0).name)

			assertEquals("prop2", entity.properties.get(1).name)
			assertEquals(1, entity.properties.get(1).features.size)
			assertEquals(IsisPropertyFeatureType.DERIVED, entity.properties.get(1).features.get(0).type)
			
			assertEquals("collection1", entity.collections.get(0).name)
			assertEquals("Event2", entity.collections.get(0).events.get(0).name)
			
			assertEquals("action1", entity.actions.get(0).name)
			assertEquals("Event3", entity.actions.get(0).events.get(0).name)
		]
	}

	@Test
	def void parseService() {
		'''
			package org.vaulttec.isis.script.test
			service Service1 {
				inject Object injection1
				action int action1 {
					body {
						42
					}
					event Event1
				}
			}
		'''.parse => [
			assertNoErrors
			assertEquals("org.vaulttec.isis.script.test", package.name)
			val entity = declaration as IsisService
			assertEquals("Service1", entity.name)
			assertEquals("injection1", entity.injections.get(0).name)
			assertEquals("action1", entity.actions.get(0).name)
			assertEquals("Event1", entity.actions.get(0).events.get(0).name)
		]
	}

}
