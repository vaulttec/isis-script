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
package org.vaulttec.isis.script.ui

import com.google.inject.Binder
import com.google.inject.name.Names
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.ui.editor.contentassist.ITemplateProposalProvider
import org.eclipse.xtext.ui.editor.outline.actions.IOutlineContribution
import org.eclipse.xtext.ui.editor.outline.impl.OutlineFilterAndSorter.IComparator
import org.eclipse.xtext.ui.editor.outline.quickoutline.QuickOutlineFilterAndSorter
import org.vaulttec.isis.script.ui.contentassist.IsisTemplateProposalProvider
import org.vaulttec.isis.script.ui.outline.CollapseAllOutlineContribution
import org.vaulttec.isis.script.ui.outline.GoIntoTopLevelTypeOutlineContribution
import org.vaulttec.isis.script.ui.outline.IsisOutlineNodeComparator
import org.vaulttec.isis.script.ui.outline.IsisQuickOutlineFilterAndSorter

/**
 * Use this class to register components to be used within the Eclipse IDE.
 */
@FinalFieldsConstructor
class IsisUiModule extends AbstractIsisUiModule {

	override Class<? extends ITemplateProposalProvider> bindITemplateProposalProvider() {
		IsisTemplateProposalProvider
	}

	override Class<? extends IComparator> bindOutlineFilterAndSorter$IComparator() {
		IsisOutlineNodeComparator
	}

	def Class<? extends QuickOutlineFilterAndSorter> bindQuickOutlineFilterAndSorter() {
		typeof(IsisQuickOutlineFilterAndSorter)
	}

	def configureCollapseAllOutlineContribution(Binder binder) {
		binder.bind(IOutlineContribution).annotatedWith(Names.named("CollapseAllOutlineContribution")).to(
			CollapseAllOutlineContribution);
	}

	def configureGoIntoTopLevelTypeOutlineContribution(Binder binder) {
		binder.bind(IOutlineContribution).annotatedWith(Names.named("GoIntoTopLevelTypeOutlineContribution")).to(
			GoIntoTopLevelTypeOutlineContribution);
	}

}
