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
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisRepository
import org.vaulttec.isis.script.dsl.IsisTypeDeclaration
import org.vaulttec.isis.script.dsl.IsisUiHint

/**
 * Customization of the default outline structure.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#outline
 */
class IsisOutlineTreeProvider extends DefaultOutlineTreeProvider {

	@Inject
	private ILocationInFileProvider locationInFileProvider;

	def _createChildren(DocumentRootNode parentNode, IsisFile file) {
		if (file.package != null) {
			parentNode.createNode(file.package)
		}
		if (file.importSection != null) {
			parentNode.createNode(file.importSection)
		}
		if (file.declaration != null) {
			parentNode.createNode(file.declaration)
		}
	}

	def _isLeaf(IsisInjection injection) {
		true
	}

	def _createChildren(IOutlineNode parentNode, IsisProperty property) {
		property.features.forEach[parentNode.createNode(it)]
	}

	def _createChildren(IOutlineNode parentNode, IsisRepository repository) {
		repository.actions.forEach[parentNode.createNode(it)]
	}

	/**
	 * Adds a type declarations model elements by their location in the source code.
	 */
	def _createChildren(IOutlineNode parentNode, IsisTypeDeclaration type) {
		type.eContents.filter[!(it instanceof JvmTypeReference) && !(it instanceof XAnnotation)].sortWith(
			new Comparator() {
				override compare(Object o1, Object o2) {
					locationInFileProvider.getSignificantTextRegion(o1 as EObject).offset -
						locationInFileProvider.getSignificantTextRegion(o2 as EObject).offset
				}
			}).forEach[parentNode.createNode(it)]
	}

	def _isLeaf(IsisProperty property) {
		property.features.isNullOrEmpty
	}

	def _isLeaf(IsisPropertyFeature feature) {
		true
	}

	def _isLeaf(IsisRepository repository) {
		repository.actions.isNullOrEmpty
	}

	def _isLeaf(IsisUiHint uiHint) {
		true
	}

	def _isLeaf(IsisAction action) {
		true
	}

}
