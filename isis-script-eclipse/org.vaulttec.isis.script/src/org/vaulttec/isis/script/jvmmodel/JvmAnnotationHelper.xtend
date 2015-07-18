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
import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.TypesFactory

class JvmAnnotationHelper {

	@Inject TypesFactory typesFactory

	def addStringValue(JvmAnnotationReference annoRef, String name, String value) {
		val annoValue = typesFactory.createJvmStringAnnotationValue => [
			operation = annoRef.annotation.declaredOperations.findFirst[it.simpleName == name]
			values += value
		]
		annoRef.explicitValues += annoValue
		annoRef
	}

	def addTypeValue(JvmAnnotationReference annoRef, String name, JvmTypeReference value) {
		val annoValue = typesFactory.createJvmTypeAnnotationValue => [
			operation = annoRef.annotation.declaredOperations.findFirst[it.simpleName == name]
			values += value
		]
		annoRef.explicitValues += annoValue
		annoRef
	}

}