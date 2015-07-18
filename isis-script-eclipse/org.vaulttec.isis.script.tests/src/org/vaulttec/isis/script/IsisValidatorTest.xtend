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
import org.vaulttec.isis.script.dsl.DslPackage
import org.vaulttec.isis.script.dsl.IsisFile
import static org.vaulttec.isis.script.validation.IsisValidator.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(IsisInjectorProvider))
class IsisValidatorTest {

	@Inject extension ParseHelper<IsisFile>
	@Inject extension ValidationTestHelper

	@Test
	def void validateUpperCaseEntityName() {
		'''
			package org.vaulttec.isis.script.test
			entity myEntity {
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisEntity, INVALID_NAME, 'Name should start with a capital')
	}

	@Test
	def void validateUpperCaseServiceName() {
		'''
			package org.vaulttec.isis.script.test
			service myService {
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisService, INVALID_NAME, 'Name should start with a capital')
	}

	@Test
	def void validateUpperCaseRepositoryName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				repository myRepository {
				}
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisRepository, INVALID_NAME, 'Name should start with a capital')
	}

	@Test
	def void validateLowerCasePropertyName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				property int MyProperty
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisProperty, INVALID_NAME, 'Name should start with a non-capital')
	}

}