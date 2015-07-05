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
package org.vaulttec.isis.script.configuration

import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.OutputConfigurationProvider

class IsisOutputConfigurationProvider extends OutputConfigurationProvider {

	override getOutputConfigurations() {
		val configs = super.outputConfigurations
		configs.findFirst[name == IFileSystemAccess.DEFAULT_OUTPUT].outputDirectory = "target/generated-sources/isis"
		configs
	}

}