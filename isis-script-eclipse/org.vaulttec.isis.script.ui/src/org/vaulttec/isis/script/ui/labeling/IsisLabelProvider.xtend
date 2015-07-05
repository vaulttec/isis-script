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
package org.vaulttec.isis.script.ui.labeling

import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.jface.viewers.StyledString
import org.eclipse.xtext.xbase.ui.labeling.XbaseLabelProvider
import org.vaulttec.isis.script.IsisModelHelper
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisEvent
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisPackageDeclaration
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.dsl.IsisUiHint

import static org.vaulttec.isis.script.dsl.IsisPropertyFeatureType.*

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#label-provider
 */
class IsisLabelProvider extends XbaseLabelProvider {

	@Inject extension IsisModelHelper

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	def text(IsisInjection injection) {
		createDecoratedLabel(injection.name, injection.type.simpleName)
	}

	def text(IsisProperty property) {
		createDecoratedLabel(property.name, property.type.simpleName)
	}

	def text(IsisPropertyFeature feature) {
		feature.type.literal
	}

	def text(IsisAction action) {
		createDecoratedLabel(action.name + '(' + action.parameters.map[type.simpleName].join(',') + ')',
			action.returnType.simpleName)
	}

	def text(IsisUiHint uiHint) {
		uiHint.type.literal
	}

	override protected doGetImage(Object element) {
		// icons are stored in the 'icons' folder of this project.
		switch element {
			IsisPackageDeclaration:
				'obj16/package.gif'
			IsisEntity:
				'obj16/entity.gif'
			IsisService:
				'obj16/service.gif'
			IsisInjection:
				'obj16/injection.gif'
			IsisAction:
				'obj16/action.gif'
			IsisProperty:
				if (element.hasFeature(DERIVED)) {
					'obj16/property_derived.gif'
				} else {
					'obj16/property.gif'
				}
			IsisPropertyFeature:
				'obj16/action.gif'
			IsisEvent:
				'obj16/event.gif'
			IsisUiHint:
				'obj16/ui_hint.gif'
			default:
				super.doGetImage(element)
		}
	}

	private def createDecoratedLabel(String name, String decorator) {
		new StyledString(name).append(new StyledString(' : ' + decorator, StyledString.DECORATIONS_STYLER))
	}

}
