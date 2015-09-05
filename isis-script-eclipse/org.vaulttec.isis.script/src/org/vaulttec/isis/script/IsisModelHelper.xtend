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
package org.vaulttec.isis.script

import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionFeatureType
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisActionParameterFeatureType
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisCollectionFeatureType
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeatureType
import org.vaulttec.isis.script.dsl.IsisUiHintType

class IsisModelHelper {

	def hasFeature(IsisProperty it, IsisPropertyFeatureType featureType) {
		features != null && features.exists[type == featureType]
	}

	def getFeatureExpression(IsisProperty it, IsisPropertyFeatureType featureType) {
		val feature = features.findFirst[type == featureType]
		if (feature != null) {
			feature.expression
		} else {
			null
		}
	}

	def hasFeature(IsisCollection it, IsisCollectionFeatureType featureType) {
		features != null && features.exists[type == featureType]
	}

	def getFeatureExpression(IsisCollection it, IsisCollectionFeatureType featureType) {
		val feature = features.findFirst[type == featureType]
		if (feature != null) {
			feature.expression
		} else {
			null
		}
	}

	def hasFeature(IsisAction it, IsisActionFeatureType featureType) {
		features != null && features.exists[type == featureType]
	}

	def getFeatureExpression(IsisAction it, IsisActionFeatureType featureType) {
		val feature = features.findFirst[type == featureType]
		if (feature != null) {
			feature.expression
		} else {
			null
		}
	}

	def hasFeature(IsisActionParameter it, IsisActionParameterFeatureType featureType) {
		features != null && features.exists[type == featureType]
	}

	def getFeatureExpression(IsisActionParameter it, IsisActionParameterFeatureType featureType) {
		val feature = features.findFirst[type == featureType]
		if (feature != null) {
			feature.expression
		} else {
			null
		}
	}

	def hasUiHint(IsisEntity it, IsisUiHintType hintType) {
		uiHints != null && uiHints.exists[type == hintType]
	}

	def getUiHintExpression(IsisEntity it, IsisUiHintType hintType) {
		val uiHint = uiHints.findFirst[type == hintType]
		if (uiHint != null) {
			uiHint.expression
		} else {
			null
		}
	}

}
