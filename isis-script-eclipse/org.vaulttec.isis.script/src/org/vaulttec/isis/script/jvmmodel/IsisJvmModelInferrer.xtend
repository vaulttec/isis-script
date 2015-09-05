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

import java.util.Collection
import java.util.List
import javax.inject.Inject
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.vaulttec.isis.script.IsisModelHelper
import org.vaulttec.isis.script.dsl.IsisAction
import org.vaulttec.isis.script.dsl.IsisActionFeatureType
import org.vaulttec.isis.script.dsl.IsisActionParameter
import org.vaulttec.isis.script.dsl.IsisActionParameterFeature
import org.vaulttec.isis.script.dsl.IsisActionParameterFeatureType
import org.vaulttec.isis.script.dsl.IsisCollection
import org.vaulttec.isis.script.dsl.IsisCollectionFeatureType
import org.vaulttec.isis.script.dsl.IsisEntity
import org.vaulttec.isis.script.dsl.IsisFile
import org.vaulttec.isis.script.dsl.IsisInjection
import org.vaulttec.isis.script.dsl.IsisProperty
import org.vaulttec.isis.script.dsl.IsisPropertyFeature
import org.vaulttec.isis.script.dsl.IsisPropertyFeatureType
import org.vaulttec.isis.script.dsl.IsisService
import org.vaulttec.isis.script.dsl.IsisUiHint
import org.vaulttec.isis.script.dsl.IsisUiHintType

/**
 * <p>Infers a JVM model from {@link IsisFile}.</p> 
 */
class IsisJvmModelInferrer extends AbstractModelInferrer {

	@Inject extension IsisModelHelper
	@Inject extension JvmTypesBuilder
	@Inject extension TypeReferences

	def dispatch void infer(IsisFile file, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		val declaration = file.declaration
		if (file.package != null && !file.package.name.nullOrEmpty && declaration != null &&
			!declaration.name.nullOrEmpty) {
			val type = file.toClass(QualifiedName.create(file.package.name, declaration.name))

			// Create declaration
			acceptor.accept(type) [
				initializeDeclaration(declaration)
			]
		}
	}

	protected def dispatch void initializeDeclaration(JvmGenericType it, IsisEntity entity) {
		superTypes += entity.superType.cloneWithProxies
		addAnnotations(entity.annotations)
		addContainerInjection(entity)
		addInjections(entity.injections)
		addProperties(entity.properties)
		addCollections(entity.collections)
		addActions(entity.actions)
		addUiHints(entity.uiHints)
		addComparable(entity)
	}

	protected def dispatch void initializeDeclaration(JvmGenericType it, IsisService service) {
		superTypes += service.superType.cloneWithProxies
		addAnnotations(service.annotations)
		addContainerInjection(service)
		addInjections(service.injections)
		addActions(service.actions)
	}

	protected def void addComparable(JvmGenericType it, IsisEntity entity) {
		val entityType = typeRef()
		val entityNonDerivedPropertyNames = entity.properties.filter[!hasFeature(IsisPropertyFeatureType.DERIVED)].map [
			name
		].join(',')
		superTypes += typeRef(Comparable, entityType)
		members += entity.toMethod("compareTo", typeRef("int")) [
			annotations += annotationRef(Override)
			parameters +=
				entity.toParameter("other", entityType)
			body = '''return org.apache.isis.applib.util.ObjectContracts.compare(this, other, "«entityNonDerivedPropertyNames»");'''
		]
	}

	protected def void addContainerInjection(JvmGenericType it, EObject object) {
		members += object.toField("container", typeRef("org.apache.isis.applib.DomainObjectContainer")) [
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
			addPropertyField(p)
			p.features.forEach [ f |
				switch (f.type) {
					case HIDE:
						addPropertyHide(p)
					case DISABLE:
						addPropertyDisable(p)
					case VALIDATE:
						addPropertyValidate(p)
					case DERIVED: {
					}
					case MODIFY:
						addPropertyModify(p)
					case CLEAR:
						addPropertyClear(p)
					case CHOICES:
						addPropertyChoices(p)
					case COMPLETE:
						addPropertyComplete(p, f)
					case DEFAULT:
						addPropertyDefault(p)
				}
			]
			addEvents(p)
		}
	}

	protected def void addPropertyField(JvmGenericType it, IsisProperty p) {
		if (!p.hasFeature(IsisPropertyFeatureType.DERIVED)) {
			members += p.toField(p.name, p.type)
		}
		members += p.toGetter(p.name, p.type) => [
			addAnnotations(p.annotations)
			if (!p.hasFeature(IsisPropertyFeatureType.DERIVED)) {
				body = p.getFeatureExpression(IsisPropertyFeatureType.DERIVED)
			}
		]
		if (!p.hasFeature(IsisPropertyFeatureType.DERIVED)) {
			members += p.toSetter(p.name, p.type)
		}
	}

	protected def void addPropertyHide(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("hide" + p.name.toFirstUpper, typeRef("boolean")) [
			body = p.getFeatureExpression(IsisPropertyFeatureType.HIDE)
		]
	}

	protected def void addPropertyDisable(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("disable" + p.name.toFirstUpper, typeRef(String)) [
			body = p.getFeatureExpression(IsisPropertyFeatureType.DISABLE)
		]
	}

	protected def void addPropertyValidate(JvmGenericType it, IsisProperty p) {
		val bodyExpression = p.getFeatureExpression(IsisPropertyFeatureType.VALIDATE)
		members += p.toMethod("validate" + p.name.toFirstUpper, bodyExpression.inferredType) [
			parameters += p.toParameter("value", p.type)
			body = bodyExpression
		]
	}

	protected def void addPropertyModify(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("modify" + p.name.toFirstUpper, typeRef("void")) [
			parameters += p.toParameter("value", p.type)
			body = p.getFeatureExpression(IsisPropertyFeatureType.MODIFY)
		]
	}

	protected def void addPropertyClear(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("clear" + p.name.toFirstUpper, typeRef("void")) [
			body = p.getFeatureExpression(IsisPropertyFeatureType.CLEAR)
		]
	}

	protected def void addPropertyChoices(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("choices" + p.name.toFirstUpper, typeRef(Collection, p.type)) [
			body = p.getFeatureExpression(IsisPropertyFeatureType.CHOICES)
		]
	}

	protected def void addPropertyComplete(JvmGenericType it, IsisProperty p, IsisPropertyFeature f) {
		members += p.toMethod("autoComplete" + p.name.toFirstUpper, typeRef(Collection, p.type)) [
			addAnnotations(f.annotations)
			parameters += p.toParameter("search", typeRef(String))
			body = p.getFeatureExpression(IsisPropertyFeatureType.CHOICES)
		]
	}

	protected def void addPropertyDefault(JvmGenericType it, IsisProperty p) {
		members += p.toMethod("default" + p.name.toFirstUpper, p.type) [
			body = p.getFeatureExpression(IsisPropertyFeatureType.DEFAULT)
		]
	}

	protected def void addCollections(JvmGenericType it, EList<IsisCollection> collections) {
		for (c : collections) {
			addCollectionField(c)
			c.features.forEach [ f |
				switch (f.type) {
					case HIDE:
						addCollectionHide(c)
					case DISABLE:
						addCollectionDisable(c)
					case VALIDATE:
						addCollectionValidate(c)
					case DERIVED: {
					}
					case ADD:
						addCollectionAdd(c)
					case REMOVE:
						addCollectionRemove(c)
				}
			]
			addEvents(c)
		}
	}

	protected def void addCollectionField(JvmGenericType it, IsisCollection c) {
		if (!c.hasFeature(IsisCollectionFeatureType.DERIVED)) {
			members += c.toField(c.name, c.type) [
				initializer = c.init
			]
		}
		members += c.toGetter(c.name, c.type) => [
			addAnnotations(c.annotations)
			if (!c.hasFeature(IsisCollectionFeatureType.DERIVED)) {
				body = c.getFeatureExpression(IsisCollectionFeatureType.DERIVED)
			}
		]
		if (!c.hasFeature(IsisCollectionFeatureType.DERIVED)) {
			members += c.toSetter(c.name, c.type)
		}
	}

	protected def void addCollectionHide(JvmGenericType it, IsisCollection c) {
		members += c.toMethod("hide" + c.name.toFirstUpper, typeRef("boolean")) [
			body = c.getFeatureExpression(IsisCollectionFeatureType.HIDE)
		]
	}

	protected def void addCollectionDisable(JvmGenericType it, IsisCollection c) {
		members += c.toMethod("disable" + c.name.toFirstUpper, typeRef(String)) [
			body = c.getFeatureExpression(IsisCollectionFeatureType.DISABLE)
		]
	}

	protected def void addCollectionValidate(JvmGenericType it, IsisCollection c) {
		val bodyExpression = c.getFeatureExpression(IsisCollectionFeatureType.VALIDATE)
		members += c.toMethod("validate" + c.name.toFirstUpper, bodyExpression.inferredType) [
			parameters += c.toParameter("value", c.type)
			body = bodyExpression
		]
	}

	protected def void addCollectionAdd(JvmGenericType it, IsisCollection c) {
		val argumentType = c.type.getArgument(0)
		members += c.toMethod("addTo" + c.name.toFirstUpper, typeRef("void")) [
			parameters += c.toParameter(argumentType.simpleName.toFirstLower, argumentType)
			body = c.getFeatureExpression(IsisCollectionFeatureType.ADD)
		]
	}

	protected def void addCollectionRemove(JvmGenericType it, IsisCollection c) {
		val argumentType = c.type.getArgument(0)
		members += c.toMethod("removeFrom" + c.name.toFirstUpper, typeRef("void")) [
			parameters += c.toParameter(argumentType.simpleName.toFirstLower, argumentType)
			body = c.getFeatureExpression(IsisCollectionFeatureType.REMOVE)
		]
	}

	protected def void addActions(JvmGenericType it, EList<IsisAction> actions) {
		for (a : actions) {
			members += a.toMethod(a.name, a.type) [
				addAnnotations(a.annotations)
				parameters += a.parameters.map [
					val param = type.cloneWithProxies
					param.addAnnotations(annotations)
					param
				]
				body = getFeatureExpression(a, IsisActionFeatureType.BODY)
			]
			addActionParameters(a, a.parameters)
			a.features.forEach [ f |
				switch (f.type) {
					case BODY: {
					}
					case HIDE:
						addActionHide(a)
					case DISABLE:
						addActionDisable(a)
					case VALIDATE:
						addActionValidate(a)
				}
			]
			addEvents(a)
		}
	}

	protected def void addActionHide(JvmGenericType it, IsisAction a) {
		members += a.toMethod("hide" + a.name.toFirstUpper, typeRef("boolean")) [
			body = a.getFeatureExpression(IsisActionFeatureType.HIDE)
		]
	}

	protected def void addActionDisable(JvmGenericType it, IsisAction a) {
		members += a.toMethod("disable" + a.name.toFirstUpper, typeRef(String)) [
			body = a.getFeatureExpression(IsisActionFeatureType.DISABLE)
		]
	}

	protected def void addActionValidate(JvmGenericType it, IsisAction a) {
		val bodyExpression = a.getFeatureExpression(IsisActionFeatureType.VALIDATE)
		members += a.toMethod("validate" + a.name.toFirstUpper, bodyExpression.inferredType) [
			for (p : a.parameters) {
				parameters += p.toParameter(p.type.name, p.type.parameterType)
			}
			body = bodyExpression
		]
	}

	protected def void addActionParameters(JvmGenericType it, IsisAction a, EList<IsisActionParameter> parameters) {
		var index = 0;
		for (p : parameters) {
			for (f : p.features) {
				switch (f.type) {
					case DEFAULT:
						addActionParameterDefault(a, p, index)
					case CHOICES:
						addActionParameterChoices(a, p, index)
					case COMPLETE:
						addActionParameterComplete(a, p, f, index)
					case VALIDATE:
						addActionParameterValidate(a, p, index)
				}
			}
			index++;
		}
	}

	protected def void addActionParameterDefault(JvmGenericType it, IsisAction a, IsisActionParameter p, int index) {
		members += p.toMethod("default" + index + a.name.toFirstUpper, p.type.parameterType) [
			body = p.getFeatureExpression(IsisActionParameterFeatureType.DEFAULT)
		]
	}

	protected def void addActionParameterChoices(JvmGenericType it, IsisAction a, IsisActionParameter p, int index) {
		members += p.toMethod("choices" + index + a.name.toFirstUpper, typeRef(Collection, p.type.parameterType)) [
			body = p.getFeatureExpression(IsisActionParameterFeatureType.CHOICES)
		]
	}

	protected def void addActionParameterComplete(JvmGenericType it, IsisAction a, IsisActionParameter p,
		IsisActionParameterFeature f, int index) {
		members += p.toMethod("autoComplete" + index + a.name.toFirstUpper, typeRef(Collection, p.type.parameterType)) [
			addAnnotations(f.annotations)
			parameters += p.toParameter("search", typeRef(String))
			body = p.getFeatureExpression(IsisActionParameterFeatureType.CHOICES)
		]
	}

	protected def void addActionParameterValidate(JvmGenericType it, IsisAction a, IsisActionParameter p, int index) {
		val bodyExpression = p.getFeatureExpression(IsisActionParameterFeatureType.VALIDATE)
		members += p.toMethod("validate" + index + a.name.toFirstUpper, bodyExpression.inferredType) [
			parameters += p.toParameter("value", p.type.parameterType)
			body = bodyExpression
		]
	}

	protected def void addEvents(JvmGenericType it, IsisProperty property) {
		val sourceType = typeRef()
		val targetType = property.type
		for (e : property.events) {
			members += e.toClass(e.name) [
				static = true
				superTypes += typeRef("org.apache.isis.applib.services.eventbus.PropertyDomainEvent", sourceType)
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					body = '''super(source, identifier);'''
				]
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters += e.toParameter("oldValue", targetType)
					parameters += e.toParameter("newValue", targetType)
					body = '''super(source, identifier, oldValue, newValue);'''
				]
			]
		}
	}

	protected def void addEvents(JvmGenericType it, IsisCollection collection) {
		val sourceType = typeRef()
		val targetType = collection.type
		for (e : collection.events) {
			members += e.toClass(e.name) [
				static = true
				superTypes += typeRef("org.apache.isis.applib.services.eventbus.CollectionDomainEvent", sourceType)
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters +=
						e.toParameter("of",
							typeRef("org.apache.isis.applib.services.eventbus.CollectionDomainEvent.Of"))
					body = '''super(source, identifier, of);'''
				]
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters +=
						e.toParameter("of",
							typeRef("org.apache.isis.applib.services.eventbus.CollectionDomainEvent.Of"))
					parameters += e.toParameter("value", targetType)
					body = '''super(source, identifier, of, value);'''
				]
			]
		}
	}

	protected def void addEvents(JvmGenericType it, IsisAction action) {
		val sourceType = typeRef()
		for (e : action.events) {
			members += e.toClass(e.name) [
				static = true
				superTypes += typeRef("org.apache.isis.applib.services.eventbus.ActionDomainEvent", sourceType)
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					body = '''super(source, identifier);'''
				]
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters += e.toParameter("arguments", typeRef("Object..."))
					body = '''super(source, identifier, arguments);'''
				]
				members += e.toConstructor [
					parameters += e.toParameter("source", sourceType)
					parameters += e.toParameter("identifier", typeRef("org.apache.isis.applib.Identifier"))
					parameters += e.toParameter("arguments", typeRef(List, typeRef(Object)))
					body = '''super(source, identifier, arguments);'''
				]
			]
		}
	}

	protected def void addUiHints(JvmGenericType it, EList<IsisUiHint> uiHints) {
		for (uiHint : uiHints) {
			val returnType = if (uiHint.type == IsisUiHintType.TITLE)
					uiHint.expression.inferredType
				else
					typeRef(String)
			members += uiHint.toMethod(uiHint.type.literal, returnType) [
				body = uiHint.expression
			]
		}
	}

}
