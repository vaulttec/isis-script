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
package org.vaulttec.isis.script.formatting2;

import com.google.inject.Inject
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.annotations.formatting2.XbaseWithAnnotationsFormatter
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionFeature
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisActionParameterFeature
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisCollectionFeature
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisEvent
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.dsl.IsisUiHint
import org.vaulttec.isis.script.services.IsisGrammarAccess

class IsisFormatter extends XbaseWithAnnotationsFormatter {

	@Inject extension IsisGrammarAccess

	def dispatch void format(IsisFile isisFile, extension IFormattableDocument document) {
		isisFile.package.format
		isisFile.importSection.format
		isisFile.declaration.format
	}

	def dispatch void format(IsisEntity isisEntity, extension IFormattableDocument document) {
		for (XAnnotation annotations : isisEntity.annotations) {
			annotations.format
		}
		isisEntity.superType.format
		for (IsisInjection injections : isisEntity.injections) {
			injections.format
		}
		for (IsisProperty properties : isisEntity.properties) {
			properties.format
		}
		for (IsisCollection collections : isisEntity.collections) {
			collections.format
		}
		for (IsisAction actions : isisEntity.actions) {
			actions.format
		}
		for (IsisUiHint uiHints : isisEntity.uiHints) {
			uiHints.format
		}
	}

	def dispatch void format(IsisService isisservice, extension IFormattableDocument document) {
		for (XAnnotation annotations : isisservice.annotations) {
			annotations.format
		}
		isisservice.superType.format
		for (IsisInjection injections : isisservice.injections) {
			injections.format
		}
		for (IsisAction actions : isisservice.actions) {
			actions.format
		}
	}

	def dispatch void format(IsisInjection isisinjection, extension IFormattableDocument document) {
		isisinjection.type.format
	}

	def dispatch void format(IsisProperty isisproperty, extension IFormattableDocument document) {
		for (XAnnotation annotations : isisproperty.annotations) {
			annotations.format
		}
		isisproperty.type.format
		for (IsisPropertyFeature features : isisproperty.features) {
			features.format
		}
		for (IsisEvent events : isisproperty.events) {
			events.format
		}
	}

	def dispatch void format(IsisPropertyFeature isispropertyfeature, extension IFormattableDocument document) {
		for (XAnnotation annotations : isispropertyfeature.annotations) {
			annotations.format
		}
		isispropertyfeature.expression.format
	}

	def dispatch void format(IsisCollection isiscollection, extension IFormattableDocument document) {
		for (XAnnotation annotations : isiscollection.annotations) {
			annotations.format
		}
		isiscollection.type.format
		for (IsisCollectionFeature features : isiscollection.features) {
			features.format
		}
		for (IsisEvent events : isiscollection.events) {
			events.format
		}
	}

	def dispatch void format(IsisCollectionFeature isiscollectionfeature, extension IFormattableDocument document) {
		for (XAnnotation annotations : isiscollectionfeature.annotations) {
			annotations.format
		}
		isiscollectionfeature.expression.format
	}

	def dispatch void format(IsisAction isisaction, extension IFormattableDocument document) {
		for (XAnnotation annotations : isisaction.annotations) {
			annotations.format
		}
		isisaction.type.format
		for (IsisActionFeature features : isisaction.features) {
			features.format
		}
		for (IsisActionParameter parameters : isisaction.parameters) {
			parameters.format
		}
		for (IsisEvent events : isisaction.events) {
			events.format
		}
	}

	def dispatch void format(IsisActionFeature isisactionfeature, extension IFormattableDocument document) {
		isisactionfeature.expression.format
	}

	def dispatch void format(IsisActionParameter isisactionparameter, extension IFormattableDocument document) {
		for (XAnnotation annotations : isisactionparameter.annotations) {
			annotations.format
		}
		isisactionparameter.type.format
		for (IsisActionParameterFeature features : isisactionparameter.features) {
			features.format
		}
	}

	def dispatch void format(IsisActionParameterFeature isisactionparameterfeature, extension IFormattableDocument document) {
		for (XAnnotation annotations : isisactionparameterfeature.annotations) {
			annotations.format
		}
		isisactionparameterfeature.expression.format
	}

	def dispatch void format(IsisUiHint isisuihint, extension IFormattableDocument document) {
		isisuihint.expression.format
	}

}
