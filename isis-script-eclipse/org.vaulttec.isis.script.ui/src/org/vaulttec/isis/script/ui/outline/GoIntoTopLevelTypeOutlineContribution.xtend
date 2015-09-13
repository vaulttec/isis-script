package org.vaulttec.isis.script.ui.outline

import com.google.inject.Inject
import org.eclipse.jface.action.Action
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.xtext.ui.PluginImageHelper
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.actions.AbstractFilterOutlineContribution
import org.eclipse.xtext.ui.editor.outline.impl.EObjectNode
import org.eclipse.xtext.ui.editor.outline.impl.OutlinePage
import org.eclipse.xtext.xtype.XtypePackage
import org.vaulttec.isis.script.dsl.DslPackage

class GoIntoTopLevelTypeOutlineContribution extends AbstractFilterOutlineContribution {

	public static val PREFERENCE_KEY = "ui.outline.goIntoTopLevelType";

	@Inject PluginImageHelper imageHelper

	private TreeViewer treeViewer

	override register(OutlinePage outlinePage) {
		super.register(outlinePage);
		treeViewer = outlinePage.treeViewer
	}

	override protected apply(IOutlineNode node) {
		if (node instanceof EObjectNode) {
			switch (node.EClass) {
				case DslPackage.Literals.ISIS_PACKAGE_DECLARATION,
				case XtypePackage.Literals.XIMPORT_SECTION:
					return false
				default:
					return true
			}
		}
		true
	}

	override protected configureAction(Action action) {
		action.text = "Go Into Top Level Type"
		action.toolTipText = "Go Into Top Level Type"
		action.description = "Go Into Top Level Type"
		action.imageDescriptor = imageHelper.getImageDescriptor("obj16/gointo_toplevel_type.gif")
	}

	override getPreferenceKey() {
		PREFERENCE_KEY
	}

	override stateChanged(boolean newState) {
		if (treeViewer != null && !treeViewer.getTree().isDisposed()) {
			treeViewer.refresh(true)
		}
	}

}