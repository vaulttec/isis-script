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
package org.vaulttec.isis.script.formatting2;

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.annotations.formatting2.XbaseWithAnnotationsFormatter
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionFeature
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisActionParameterFeature
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisCollectionFeature
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisPackageDeclaration
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.dsl.IsisTypeDeclaration
import org.vaulttec.isis.script.dsl.IsisUiHint

import static org.vaulttec.isis.script.dsl.DslPackage.Literals.*

class IsisFormatter extends XbaseWithAnnotationsFormatter {
	
	def dispatch void format(IsisFile isisFile, extension IFormattableDocument document) {
		isisFile.prepend[noSpace].append[newLine]
		isisFile.package.format
		isisFile.importSection.format
		isisFile.declaration.format
	}

	def dispatch void format(IsisPackageDeclaration isisPackage, extension IFormattableDocument document) {
		isisPackage.regionFor.feature(ISIS_PACKAGE_DECLARATION__NAME).prepend[oneSpace]
		isisPackage.append[newLines = 2]
	}

	def dispatch void format(IsisEntity isisEntity, extension IFormattableDocument document) {
		isisEntity.formatType(document)
		isisEntity.properties.forEach[format.append[newLines = 2]]
		isisEntity.collections.forEach[format.append[newLines = 2]]
		isisEntity.uiHints.forEach[format.append[newLines = 2]]
	}

	def dispatch void format(IsisService isisService, extension IFormattableDocument document) {
		isisService.formatType(document)
	}

	def void formatType(IsisTypeDeclaration isisType, extension IFormattableDocument document) {
		isisType.annotations.forEach[format.append[newLine]]
		isisType.regionFor.feature(ISIS_TYPE_DECLARATION__NAME).surround[oneSpace]
		isisType.superType.format.surround[oneSpace]
		isisType.formatBlock(document)
		isisType.injections.forEach [ injection |
			injection.type.format.surround[oneSpace];
			injection.append[newLines = if(injection == isisType.injections.last) 2 else 1]
		]
		isisType.actions.forEach[format.append[newLines = 2]]
	}

	def void formatBlock(EObject block, extension IFormattableDocument document) {
		interior(
			block.regionFor.keyword("{").prepend[oneSpace].append[newLines = 2],
			block.regionFor.keyword("}").append[newLines = if (block instanceof IsisTypeDeclaration) 1 else 2],
			[indent]
		)
	}

	def dispatch void format(IsisProperty isisProperty, extension IFormattableDocument document) {
		isisProperty.annotations.forEach[format.append[newLine]]
		isisProperty.type.format.surround[oneSpace]
		isisProperty.formatBlock(document)
		isisProperty.features.forEach[format.append[newLines = 2]]
		isisProperty.events.forEach[format.append[newLines = 2]]
	}

	def dispatch void format(IsisPropertyFeature isisPropertyFeature, extension IFormattableDocument document) {
		isisPropertyFeature.annotations.forEach[format.append[newLine]]
		isisPropertyFeature.expression.format.prepend[oneSpace]
	}

	def dispatch void format(IsisCollection isisCollection, extension IFormattableDocument document) {
		isisCollection.annotations.forEach[format.append[newLine]]
		isisCollection.type.format.surround[oneSpace]
		isisCollection.regionFor.feature(ISIS_COLLECTION__NAME).surround[oneSpace]
		isisCollection.init.format.surround[oneSpace]
		isisCollection.formatBlock(document)
		isisCollection.features.forEach[format.append[newLines = 2]]
		isisCollection.events.forEach[format.append[newLines = 2]]
	}

	def dispatch void format(IsisCollectionFeature isisCollectionFeature, extension IFormattableDocument document) {
		isisCollectionFeature.annotations.forEach[format.append[newLine]]
		isisCollectionFeature.expression.format.prepend[oneSpace]
	}

	def dispatch void format(IsisAction isisAction, extension IFormattableDocument document) {
		isisAction.annotations.forEach[format.append[newLine]]
		isisAction.type.format.surround[oneSpace]
		isisAction.formatBlock(document)
		isisAction.parameters.forEach[format.append[newLines = 2]]
		isisAction.features.forEach[format.append[newLines = 2]]
		isisAction.events.forEach[format.append[newLines = 2]]
	}

	def dispatch void format(IsisActionParameter isisActionParameter, extension IFormattableDocument document) {
		isisActionParameter.annotations.forEach[format.append[newLine]]
		isisActionParameter.type.format.surround[oneSpace]
		isisActionParameter.formatBlock(document)
		isisActionParameter.features.forEach[format.append[newLines = 2]]
	}

	def dispatch void format(IsisActionParameterFeature isisActionParameterFeature, extension IFormattableDocument document) {
		isisActionParameterFeature.annotations.forEach[format.append[newLine]]
		isisActionParameterFeature.expression.format.prepend[oneSpace]
	}

	def dispatch void format(IsisActionFeature isisActionFeature, extension IFormattableDocument document) {
		isisActionFeature.expression.format.prepend[oneSpace]
	}

	def dispatch void format(IsisUiHint isisUiHint, extension IFormattableDocument document) {
		isisUiHint.expression.format.prepend[oneSpace]
	}

}
