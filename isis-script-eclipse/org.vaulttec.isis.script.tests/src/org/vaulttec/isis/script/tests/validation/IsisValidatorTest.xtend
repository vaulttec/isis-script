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
package org.vaulttec.isis.script.tests.validation

import javax.inject.Inject
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.vaulttec.isis.script.dsl.DslPackage
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.tests.IsisInjectorProvider

import static org.junit.Assert.*
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
	def void validateLowerCasePropertyName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				property int MyProperty
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisProperty, INVALID_NAME, 'Name should start with a non-capital')
	}

	@Test
	def void validateLowerCaseCollectionName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				collection java.util.Set<String> MyCollection = new java.util.TreeSet<String> {
				}
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisCollection, INVALID_NAME, 'Name should start with a non-capital')
	}

	@Test
	def void validateLowerCaseActionName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				action String Test {
					body {
						""
					}
				}
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisAction, INVALID_NAME, 'Name should start with a non-capital')
	}

	@Test
	def void validateLowerCaseActionParameterName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				action String test {
					body {
						""
					}
					parameter int P1
				}
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisActionParameter, INVALID_NAME, 'Name should start with a non-capital')
	}

	@Test
	def void validateUpperCaseEventName() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				property int myProperty {
					event myPropertyChanged
				}
			}
		'''.parse.assertWarning(DslPackage.eINSTANCE.isisEvent, INVALID_NAME, 'Name should start with a capital')
	}

	@Test
	def void validateActionBody() {
		'''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				action test {
				}
			}
		'''.parse.assertError(DslPackage.eINSTANCE.isisAction, MISSING_BODY, 'Action must have a body')
	}

	@Test
	def void validateMultipleFeatures() {
		val issues = '''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				property int myProperty {
					hide {
						true
					}
					hide {
						false
					}
				}
			}
		'''.parse.validate
		assertEquals(2, issues.size)
		val issue = issues.get(0)
		assertEquals(Severity.ERROR, issue.severity)
		assertEquals(MULTIPLE_FEATURES, issue.code)
		assertEquals('Only one occurrence of "hide" is allowed', issue.message)
	}

	@Test
	def void validateMultipleUiHints() {
		val issues = '''
			package org.vaulttec.isis.script.test
			entity MyEntity {
				title {
					"foo"
				}
				title {
					"bar"
				}
			}
		'''.parse.validate
		assertEquals(2, issues.size)
		val issue = issues.get(0)
		assertEquals(Severity.ERROR, issue.severity)
		assertEquals(MULTIPLE_UI_HINTS, issue.code)
		assertEquals('Only one occurrence of "title" is allowed', issue.message)
	}

}