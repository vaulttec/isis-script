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
package org.vaulttec.isis.script.ide

import com.google.inject.Guice
import org.eclipse.xtext.util.Modules2
import org.vaulttec.isis.script.IsisRuntimeModule
import org.vaulttec.isis.script.IsisStandaloneSetup

/**
 * Initialization support for running Xtext languages as language servers.
 */
class IsisIdeSetup extends IsisStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new IsisRuntimeModule, new IsisIdeModule))
	}

}
