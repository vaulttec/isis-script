package org.vaulttec.isis.script.ui.outline

import com.google.inject.Inject
import org.eclipse.jface.action.Action
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.xtext.ui.PluginImageHelper
import org.eclipse.xtext.ui.editor.outline.actions.IOutlineContribution
import org.eclipse.xtext.ui.editor.outline.impl.OutlinePage
import org.eclipse.xtext.ui.editor.preferences.IPreferenceStoreAccess

class CollapseAllOutlineContribution extends Action implements IOutlineContribution {

	@Inject PluginImageHelper imageHelper

	private Action action
	private TreeViewer treeViewer

	override register(OutlinePage outlinePage) {
		val toolBarManager = outlinePage.site.actionBars.toolBarManager
		toolBarManager.add(getAction())
		treeViewer = outlinePage.treeViewer
	}

	protected def getAction() {
		if (action == null) {
			action = this;
			configureAction(action);
		}
		action;
	}

	protected def configureAction(Action action) {
		action.text = "Collapse All"
		action.toolTipText = "Collapse All"
		action.description = "Collapse All"
		action.imageDescriptor = imageHelper.getImageDescriptor("obj16/collapse_all.gif")
	}

	override run() {
		if (treeViewer != null && !treeViewer.getTree().isDisposed()) {
			treeViewer.collapseAll()
		}
	}

	override deregister(OutlinePage outlinePage) {
		treeViewer = null
	}

	override initialize(IPreferenceStoreAccess access) {
	}

}