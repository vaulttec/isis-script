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

import org.eclipse.emf.ecore.EAttribute
import org.eclipse.xtext.validation.Check
import org.vaulttec.isis.script.dsl.DslPackage
import org.vaulttec.isis.script.dsl.IsisRepository
import org.vaulttec.isis.script.dsl.IsisTypeDeclaration
import org.vaulttec.isis.script.dsl.IsisProperty

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class IsisValidator extends AbstractIsisValidator {

	public static val INVALID_NAME = 'IsisScript.InvalidName'

	@Check
	def checkTypeNameStartsWithCapital(IsisTypeDeclaration typeDeclaration) {
		checkNameStartsWithCapital(typeDeclaration.name, DslPackage.Literals.ISIS_TYPE_DECLARATION__NAME, INVALID_NAME)
	}

	@Check
	def checkRepositoryNameStartsWithCapital(IsisRepository typeDeclaration) {
		checkNameStartsWithCapital(typeDeclaration.name, DslPackage.Literals.ISIS_REPOSITORY__NAME, INVALID_NAME)
	}

	@Check
	def checkPropertyNameStartsWithNonCapital(IsisProperty property) {
		checkNameStartsWithNonCapital(property.name, DslPackage.Literals.ISIS_PROPERTY__NAME, INVALID_NAME)
	}

	private def checkNameStartsWithCapital(String name, EAttribute attribute, String code) {
		if (Character.isLowerCase(name.charAt(0))) {
			warning('Name should start with a capital', attribute, code)
		}
	}

	private def checkNameStartsWithNonCapital(String name, EAttribute attribute, String code) {
		if (Character.isUpperCase(name.charAt(0))) {
			warning('Name should start with a non-capital', attribute, code)
		}
	}

}
