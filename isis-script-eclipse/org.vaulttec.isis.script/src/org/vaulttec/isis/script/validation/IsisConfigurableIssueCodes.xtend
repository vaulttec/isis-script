/*******************************************************************************
 * Copyright (c) 2016 Torsten Juergeleit.
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
package org.vaulttec.isis.script.validation

import org.eclipse.xtext.preferences.PreferenceKey
import org.eclipse.xtext.util.IAcceptor
import org.eclipse.xtext.validation.SeverityConverter
import org.eclipse.xtext.xbase.validation.IssueCodes
import org.eclipse.xtext.xbase.validation.XbaseConfigurableIssueCodes

class IsisConfigurableIssueCodes extends XbaseConfigurableIssueCodes {

	override protected initialize(IAcceptor<PreferenceKey> iAcceptor) {
		super.initialize(iAcceptor)
		iAcceptor.accept(create(IssueCodes.COPY_JAVA_PROBLEMS, SeverityConverter.SEVERITY_ERROR))
	}

}
