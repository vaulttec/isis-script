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
package org.vaulttec.isis.script.ui.outline

import com.google.inject.Inject
import java.util.Comparator
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.resource.ILocationInFileProvider
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode
import org.eclipse.xtext.ui.editor.preferences.IPreferenceStoreAccess
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionFeature
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisActionParameterFeature
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisCollectionFeature
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisTypeDeclaration
import org.vaulttec.isis.script.dsl.IsisUiHint

/**
 * Customization of the default outline structure.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#outline
 */
class IsisOutlineTreeProvider extends DefaultOutlineTreeProvider {

	@Inject ILocationInFileProvider locationInFileProvider;

	@Inject IPreferenceStoreAccess preferenceStoreAccess;

	def _createChildren(DocumentRootNode parentNode, IsisFile file) {
		if (file.package != null) {
			parentNode.createNode(file.package)
		}
		if (file.importSection != null) {
			parentNode.createNode(file.importSection)
		}
		if (file.declaration != null) {
			if (preferenceStoreAccess.preferenceStore.getBoolean(
				GoIntoTopLevelTypeOutlineContribution.PREFERENCE_KEY)) {
				createSortedChildren(parentNode, file.declaration)
			} else {
				parentNode.createNode(file.declaration)
			}
		}
	}

	def _createChildren(IOutlineNode parentNode, IsisTypeDeclaration type) {
		createSortedChildren(parentNode, type)
	}

	def _isLeaf(IsisInjection injection) {
		true
	}

	def _isLeaf(IsisProperty property) {
		property.features.isNullOrEmpty && property.events.isNullOrEmpty
	}

	def _createChildren(IOutlineNode parentNode, IsisProperty property) {
		createSortedChildren(parentNode, property)
	}

	def _isLeaf(IsisPropertyFeature feature) {
		true
	}

	def _isLeaf(IsisCollection collection) {
		collection.features.isNullOrEmpty && collection.events.isNullOrEmpty
	}

	def _createChildren(IOutlineNode parentNode, IsisCollection collection) {
		createSortedChildren(parentNode, collection)
	}

	def _isLeaf(IsisCollectionFeature feature) {
		true
	}

	def _isLeaf(IsisAction action) {
		action.features.isNullOrEmpty && action.parameters.isNullOrEmpty && action.events.isNullOrEmpty
	}

	def _createChildren(IOutlineNode parentNode, IsisAction action) {
		createSortedChildren(parentNode, action)
	}

	def _isLeaf(IsisActionFeature feature) {
		true
	}

	def _createChildren(IOutlineNode parentNode, IsisActionParameter parameter) {
		parameter.features.forEach[parentNode.createNode(it)]
	}

	def _isLeaf(IsisActionParameterFeature feature) {
		true
	}

	def _isLeaf(IsisUiHint uiHint) {
		true
	}

	/**
	 * Adds a model elements children by their location in the source code.
	 */
	private def createSortedChildren(IOutlineNode parentNode, EObject element) {
		element.eContents.filter[!(it instanceof JvmTypeReference) && !(it instanceof XAnnotation)].sortWith(
			new Comparator() {
				override compare(Object o1, Object o2) {
					locationInFileProvider.getSignificantTextRegion(o1 as EObject).offset -
						locationInFileProvider.getSignificantTextRegion(o2 as EObject).offset
				}
			}).forEach[parentNode.createNode(it)]
	}

}
