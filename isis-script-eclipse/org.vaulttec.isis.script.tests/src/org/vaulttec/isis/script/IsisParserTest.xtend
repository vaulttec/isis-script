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
package org.vaulttec.isis.script

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

import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(IsisInjectorProvider))
class IsisParserTest {

	@Inject extension ParseHelper<IsisFile>
	@Inject extension ValidationTestHelper

	@Test
	def void parseEntity() {
		'''
			package org.vaulttec.isis.script.test
			entity Entity1 {
				inject Object injection1
				event Event1
				property int prop1
				action action1() {
				}
			}
		'''.parse => [
			assertNoErrors
			assertEquals("org.vaulttec.isis.script.test", package.name)
			val entity = declaration as IsisEntity
			assertEquals("Entity1", entity.name)
			assertEquals("injection1", entity.injections.get(0).name)
			assertEquals("Event1", entity.events.get(0).name)
			assertEquals("prop1", entity.properties.get(0).name)
			assertEquals("action1", entity.actions.get(0).name)
		]
	}

	@Test
	def void parseRepository() {
		'''
			package org.vaulttec.isis.script.test
			entity Entity1 {
				repository {
					inject Object injectedObj
					action listAll() {
						container.allInstances(Entity1)
					}
				}
			}
		'''.parse => [
			assertNoErrors
			val repo = (declaration as IsisEntity).repositories.get(0)
			assertNotNull(repo)
			assertEquals("injectedObj", repo.injections.get(0).name)
			val action = repo.actions.get(0)
			assertEquals("listAll", action.name)
		]
	}

	@Test
	def void parseService() {
		'''
			package org.vaulttec.isis.script.test
			service Service1 {
				inject Object injection1
				action action1() {
				}
			}
		'''.parse => [
			assertNoErrors
			assertEquals("org.vaulttec.isis.script.test", package.name)
			val entity = declaration as IsisService
			assertEquals("Service1", entity.name)
			assertEquals("injection1", entity.injections.get(0).name)
			assertEquals("action1", entity.actions.get(0).name)
		]
	}

}
