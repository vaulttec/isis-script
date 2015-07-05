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
package org.vaulttec.isis.script;

import org.eclipse.xtext.generator.IOutputConfigurationProvider;
import org.vaulttec.isis.script.configuration.IsisOutputConfigurationProvider;

import com.google.inject.Binder;
import com.google.inject.Singleton;

/**
 * Use this class to register components to be used at runtime / without the
 * Equinox extension registry.
 */
public class IsisRuntimeModule extends AbstractIsisRuntimeModule {

	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		binder.bind(IOutputConfigurationProvider.class)
				.to(IsisOutputConfigurationProvider.class).in(Singleton.class);
	}

}
