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

import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.actions.SortOutlineContribution.DefaultComparator
import org.eclipse.xtext.ui.editor.outline.impl.EObjectNode
import org.eclipse.xtext.xtype.XImportSection
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionFeature
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisCollectionFeature
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisEvent
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisPackageDeclaration
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.dsl.IsisUiHint

class IsisOutlineNodeComparator extends DefaultComparator {

	override getCategory(IOutlineNode node) {
		if (node instanceof EObjectNode) {
			switch (node.getEClass.instanceClass) {
				case IsisPackageDeclaration:
					return -80
				case XImportSection:
					return -70
				case IsisEntity,
				case IsisService:
					return -60
				case IsisInjection:
					return -50
				case IsisProperty:
					return -40
				case IsisCollection:
					return -30
				case IsisAction:
					return -20
				case IsisActionParameter:
					return -13
				case IsisPropertyFeature,
				case IsisCollectionFeature,
				case IsisActionFeature:
					return -12
				case IsisEvent:
					return -11
				case IsisUiHint:
					return -10
			}
		}
		Integer.MIN_VALUE
	}

}