/*
 * generated by Xtext
 */
package org.vaulttec.isis.script


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class IsisStandaloneSetup extends IsisStandaloneSetupGenerated {

	def static void doSetup() {
		new IsisStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
