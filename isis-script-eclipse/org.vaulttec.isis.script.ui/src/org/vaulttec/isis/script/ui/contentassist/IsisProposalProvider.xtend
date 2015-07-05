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

import javax.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.common.types.access.IJvmTypeProvider
import org.eclipse.xtext.common.types.xtext.ui.ITypesProposalProvider
import org.eclipse.xtext.ui.editor.contentassist.ConfigurableCompletionProposal
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeatureType
import org.vaulttec.isis.script.services.IsisGrammarAccess

/**
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
 * on how to customize the content assistant.
 */
class IsisProposalProvider extends AbstractIsisProposalProvider {

	@Inject IJvmTypeProvider.Factory jvmTypeProviderFactory
	@Inject ITypesProposalProvider typeProposalProvider
	@Inject IsisGrammarAccess grammarAccess

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

//	override completeXAnnotation_AnnotationType(EObject model, Assignment assignment,
//		ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
//		if (EcoreUtil2.getContainerOfType(model, IsisProperty) != null) {
//			val jvmTypeProvider = jvmTypeProviderFactory.createTypeProvider(model.eResource().getResourceSet())
//			val interfaceToImplement = jvmTypeProvider.findTypeByName(IsisEntity.name)
//			typeProposalProvider.createSubTypeProposals(interfaceToImplement, this, context,
//				IsisPackage.Literals.ISIS_PROPERTY__TYPE, TypeMatchFilters.canInstantiate(), acceptor)
//		} else {
//			super.completeXAnnotation_AnnotationType(model, assignment, context, acceptor)
//		}
//	}
//
//	static class AnnotationFilter implements ITypesProposalProvider.Filter {
//		
//	}
}
