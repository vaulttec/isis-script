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
package org.vaulttec.isis.script.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.outline.actions.IOutlineContribution;
import org.eclipse.xtext.ui.editor.outline.impl.OutlineFilterAndSorter.IComparator;
import org.eclipse.xtext.ui.editor.outline.quickoutline.QuickOutlineFilterAndSorter;
import org.vaulttec.isis.script.ui.outline.CollapseAllOutlineContribution;
import org.vaulttec.isis.script.ui.outline.GoIntoTopLevelTypeOutlineContribution;
import org.vaulttec.isis.script.ui.outline.IsisOutlineNodeComparator;
import org.vaulttec.isis.script.ui.outline.IsisQuickOutlineFilterAndSorter;

import com.google.inject.Binder;
import com.google.inject.name.Names;

/**
 * Use this class to register components to be used within the IDE.
 */
public class IsisUiModule extends AbstractIsisUiModule {

	public IsisUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}

	@Override
	public Class<? extends IComparator> bindOutlineFilterAndSorter$IComparator() {
		return IsisOutlineNodeComparator.class;
	}

	public Class<? extends QuickOutlineFilterAndSorter> bindQuickOutlineFilterAndSorter() {
		return IsisQuickOutlineFilterAndSorter.class;
	}

	public void configureCollapseAllOutlineContribution(Binder binder) {
		binder.bind(IOutlineContribution.class).annotatedWith(Names.named("CollapseAllOutlineContribution"))
				.to(CollapseAllOutlineContribution.class);
	}

	public void configureGoIntoTopLevelTypeOutlineContribution(Binder binder) {
		binder.bind(IOutlineContribution.class).annotatedWith(Names.named("GoIntoTopLevelTypeOutlineContribution"))
				.to(GoIntoTopLevelTypeOutlineContribution.class);
	}

}
