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
import org.eclipse.xtext.ui.editor.outline.impl.EObjectNode
import org.eclipse.xtext.ui.editor.outline.impl.OutlineFilterAndSorter
import org.eclipse.xtext.ui.editor.outline.quickoutline.QuickOutlineFilterAndSorter
import org.eclipse.xtext.xtype.XtypePackage

class IsisQuickOutlineFilterAndSorter extends QuickOutlineFilterAndSorter {

	new() {
		addFilter(new OutlineFilterAndSorter.IFilter() {

			override isEnabled() {
				true
			}

			/**
			 * Filter import section
			 */
			override apply(IOutlineNode node) {
				if (node instanceof EObjectNode) {
					return !node.EClass.equals(XtypePackage.Literals.XIMPORT_SECTION)
				}
				true
			}

		})
	}

}
