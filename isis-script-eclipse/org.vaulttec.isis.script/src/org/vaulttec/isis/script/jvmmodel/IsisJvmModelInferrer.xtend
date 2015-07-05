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
package org.vaulttec.isis.script.jvmmodel

import java.util.List
import javax.inject.Inject
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.vaulttec.isis.script.IsisModelHelper
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisEvent
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.dsl.IsisUiHint

import static org.vaulttec.isis.script.dsl.IsisPropertyFeatureType.*

/**
 * <p>Infers a JVM model from {@link IsisFile}.</p> 
 */
class IsisJvmModelInferrer extends AbstractModelInferrer {

	@Inject extension IsisModelHelper
	@Inject extension JvmTypesBuilder

	def dispatch void infer(IsisFile file, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		val declaration = file.declaration
		if (declaration != null) {
			acceptor.accept(file.toClass(QualifiedName.create(file.package.name, declaration.name))) [
				initializeDeclaration(declaration)
			]
		}
	}

	def dispatch void initializeDeclaration(JvmGenericType it, IsisEntity entity) {
		superTypes += entity.superType.cloneWithProxies
		addAnnotations(entity.annotations)
		addContainerInjection(entity)
		addInjections(entity.injections)
		addProperties(entity.properties)
		addEvents(entity.events)
		addActions(entity.actions)
		addUiHints(entity.uiHints)
		addComparable(entity)
	}

	def dispatch void initializeDeclaration(JvmGenericType it, IsisService service) {
		addAnnotations(service.annotations)
		superTypes += service.superType.cloneWithProxies
		addInjections(service.injections)
		addActions(service.actions)
	}

	protected def void addComparable(JvmGenericType it, IsisEntity entity) {
		val entityType = typeRef()
		val entityNonDerivedPropertyNames = entity.properties.filter[!hasFeature(DERIVED)].map[name].join(',')
		superTypes += typeRef(Comparable, entityType)
		members += entity.toMethod("compareTo", typeRef("int")) [
//			annotations += annotationRef(Override)
			parameters +=
				entity.toParameter("other", entityType)
			body = '''return org.apache.isis.applib.util.ObjectContracts.compare(this, other, "«entityNonDerivedPropertyNames»");'''
		]
	}

	protected def void addContainerInjection(JvmGenericType it, IsisEntity entity) {
		members += entity.toField("container", typeRef("org.apache.isis.applib.DomainObjectContainer")) [
			annotations += annotationRef(Inject)
			annotations += annotationRef(SuppressWarnings, "unused")
		]
	}

	protected def void addInjections(JvmGenericType it, EList<IsisInjection> injections) {
		for (i : injections) {
			members += i.toField(i.name, i.type) [
				annotations += annotationRef(Inject)
				annotations += annotationRef(SuppressWarnings, "unused")
			]
		}
	}

	protected def void addProperties(JvmGenericType it, EList<IsisProperty> properties) {
		for (p : properties) {
			addPropertyGetter(p)
			p.features.forEach [ f |
				switch (f.type) {
					case DERIVED: {
					}
					case MODIFY:
						addPropertyModify(p)
					case CLEAR:
						addPropertyClear(p)
					case DEFAULT:
						addPropertyDefault(p)
					case CHOICES:
						addPropertyChoices(p)
					case HIDE:
						addPropertyHide(p)
					case DISABLE:
						addPropertyDisable(p)
					case VALIDATE:
						addPropertyValidate(p)
				}
			]
		}
	}

	protected def void addPropertyGetter(JvmGenericType it, IsisProperty p) {
		if (!p.hasFeature(DERIVED)) {
			members += p.toField(p.name, p.type)
		}
		members += p.toGetter(p.name, p.type) => [
			addAnnotations(p.annotations)
			if (!p.hasFeature(DERIVED)) {
				body = p.getFeatureExpression(DERIVED)

			}
		]
		if (!p.hasFeature(DERIVED)) {
			members += p.toSetter(p.name, p.type)
		}
	}

	protected def void addPropertyModify(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("modify" + p.name.toFirstUpper, typeRef("void")) [
			parameters += p.toParameter(p.name, p.type)
			body = p.getFeatureExpression(MODIFY)
		]
	}

	protected def void addPropertyClear(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("clear" + p.name.toFirstUpper, typeRef("void")) [
			body = p.getFeatureExpression(CLEAR)
		]
	}

	protected def void addPropertyDefault(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("default" + p.name.toFirstUpper, p.type) [
			body = p.getFeatureExpression(DEFAULT)
		]
	}

	protected def void addPropertyChoices(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("choices" + p.name.toFirstUpper, typeRef(List, p.type)) [
			body = p.getFeatureExpression(CHOICES)
		]
	}

	protected def void addPropertyHide(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("hide" + p.name.toFirstUpper, typeRef("boolean")) [
			body = p.getFeatureExpression(HIDE)
		]
	}

	protected def void addPropertyDisable(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("disable" + p.name.toFirstUpper, typeRef(String)) [
			body = p.getFeatureExpression(DISABLE)
		]
	}

	protected def void addPropertyValidate(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("validate" + p.name.toFirstUpper, typeRef(String)) [
			body = p.getFeatureExpression(VALIDATE)
		]
	}

	protected def void addActions(JvmGenericType it, EList<IsisAction> actions) {
		for (a : actions) {
			members += a.toMethod(a.name, a.returnType) [
				addAnnotations(a.annotations)
				parameters += a.parameters.map[val param = type.cloneWithProxies
					param.addAnnotations(annotations)
					param
				]
				body = a.expression
			]
		}
	}

	protected def void addEvents(JvmGenericType it, EList<IsisEvent> events) {
		val entityType = typeRef()
		for (e : events) {
			members += e.toClass(e.name) [
				static = true
				superTypes += typeRef("org.apache.isis.applib.services.eventbus.ActionDomainEvent", entityType)
				members += e.toConstructor [
					parameters += e.toParameter("source", entityType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					body = '''super(source, identifier);'''
				]
				members += e.toConstructor [
					parameters += e.toParameter("source", entityType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters += e.toParameter("arguments", typeRef("Object..."))
					body = '''super(source, identifier, arguments);'''
				]
				members += e.toConstructor [
					parameters += e.toParameter("source", entityType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters += e.toParameter("arguments", typeRef(List, typeRef(Object)))
					body = '''super(source, identifier, arguments);'''
				]
			]
		}
	}

	protected def void addUiHints(JvmGenericType it, EList<IsisUiHint> uiHints) {
		for (uiHint : uiHints) {
			members += uiHint.toMethod("get" + uiHint.type.literal.toFirstUpper, uiHint.expression.inferredType) [
				body = uiHint.expression
			]
		}
	}

}
