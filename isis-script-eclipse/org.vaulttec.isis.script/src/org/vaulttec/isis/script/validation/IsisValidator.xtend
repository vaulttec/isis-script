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
package org.vaulttec.isis.script.validation

import javax.inject.Inject
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.validation.Check
import org.vaulttec.isis.script.IsisModelHelper
import org.vaulttec.isis.script.dsl.DslPackage
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisEvent
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisTypeDeclaration
import org.vaulttec.isis.script.dsl.IsisActionFeatureType

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class IsisValidator extends AbstractIsisValidator {

	public static val INVALID_NAME = 'IsisScript.InvalidName'
	public static val MISSING_BODY = 'IsisScript.MissingBody'

	@Inject extension IsisModelHelper

	@Check
	def checkTypeNameStartsWithCapital(IsisTypeDeclaration typeDeclaration) {
		checkNameStartsWithCapital(typeDeclaration.name, DslPackage.Literals.ISIS_TYPE_DECLARATION__NAME, INVALID_NAME)
	}

	@Check
	def checkPropertyNameStartsWithNonCapital(IsisProperty property) {
		checkNameStartsWithNonCapital(property.name, DslPackage.Literals.ISIS_PROPERTY__NAME, INVALID_NAME)
	}

	@Check
	def checkCollectionNameStartsWithNonCapital(IsisCollection collection) {
		checkNameStartsWithNonCapital(collection.name, DslPackage.Literals.ISIS_COLLECTION__NAME, INVALID_NAME)
	}

	@Check
	def checkActionNameStartsWithNonCapital(IsisAction it) {
		checkNameStartsWithNonCapital(name, DslPackage.Literals.ISIS_ACTION__NAME, INVALID_NAME)
	}

	@Check
	def checkActionParameterNameStartsWithNonCapital(IsisActionParameter it) {
		checkNameStartsWithNonCapital(type.name, DslPackage.Literals.ISIS_ACTION_PARAMETER__TYPE,
			INVALID_NAME)
	}

	@Check
	def checkEventNameStartsWithCapital(IsisEvent it) {
		checkNameStartsWithCapital(name, DslPackage.Literals.ISIS_EVENT__NAME, INVALID_NAME)
	}

	@Check
	def checkActionHasBodyExpression(IsisAction it) {
		if (!hasFeature(IsisActionFeatureType.BODY)) {
			error('Action must have a body', DslPackage.Literals.ISIS_ACTION__FEATURES, MISSING_BODY)
		}
	}

	private def checkNameStartsWithCapital(String name, EAttribute attribute, String code) {
		if (Character.isLowerCase(name.charAt(0))) {
			warning('Name should start with a capital', attribute, code)
		}
	}

	private def checkNameStartsWithNonCapital(String name, EStructuralFeature feature, String code) {
		if (Character.isUpperCase(name.charAt(0))) {
			warning('Name should start with a non-capital', feature, code)
		}
	}

}
