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
package org.vaulttec.isis.script.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.jdt.core.search.IJavaSearchConstants
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.common.types.xtext.ui.ITypesProposalProvider
import org.eclipse.xtext.ui.editor.contentassist.ConfigurableCompletionProposal
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotationsPackage
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeatureType

/**
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
 * on how to customize the content assistant.
 */
class IsisProposalProvider extends AbstractIsisProposalProvider {

	static val ISIS_ANNOTATION_FILTER = new ITypesProposalProvider.Filter() {
		override boolean accept(int modifiers, char[] packageName, char[] simpleTypeName, char[][] enclosingTypeNames,
			String path) {
			val package = String.valueOf(packageName)
			if (package.equals("org.apache.isis.applib.annotation") || package.equals("javax.jdo.annotations"))
				true
			else
				false
		}

		override int getSearchFor() {
			IJavaSearchConstants.ANNOTATION_TYPE
		}
	}

	override completeXAnnotation_AnnotationType(EObject model, Assignment assignment, ContentAssistContext context,
		ICompletionProposalAcceptor acceptor) {
		completeJavaTypes(context, XAnnotationsPackage.Literals.XANNOTATION__ANNOTATION_TYPE, ISIS_ANNOTATION_FILTER,
			acceptor)
	}

	override void completeKeyword(Keyword keyword, ContentAssistContext contentAssistContext,
		ICompletionProposalAcceptor acceptor) {
		if (!(contentAssistContext.currentModel instanceof IsisProperty)) {
			super.completeKeyword(keyword, contentAssistContext, acceptor)
		}
	}

	override void complete_IsisPropertyFeature(EObject model, RuleCall ruleCall, ContentAssistContext context,
		ICompletionProposalAcceptor acceptor) {
		if (model instanceof IsisProperty) {
			IsisPropertyFeatureType.VALUES.filter[v|model.features.forall[type != v]].forEach [
				val proposalText = literal + " {}"
				val proposal = createCompletionProposal(proposalText, literal, null, context);
				if (proposal instanceof ConfigurableCompletionProposal) {
					proposal.selectionStart = proposal.replacementOffset
					proposal.cursorPosition = proposalText.length - 1
				}
				acceptor.accept(proposal)
			]
		}
	}

}
