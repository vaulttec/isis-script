package org.vaulttec.isis.script.formatting2

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.formatter.FormatterTester
import org.junit.Test
import org.junit.runner.RunWith
import org.vaulttec.isis.script.tests.IsisInjectorProvider

@RunWith(XtextRunner)
@InjectWith(IsisInjectorProvider)
class IsisFormatterTest {

	@Inject extension FormatterTester

	@Test
	def void formatEmptyType() {
		assertFormatted[
			toBeFormatted = '''
					
				package     acme     entity   Foo   {}  
						
			'''
			expectation = '''
				package acme
				
				entity Foo {
				
				}
			'''
		]
	}

	@Test
	def void formatImports() {
		assertFormatted[
			toBeFormatted = '''
					
				package     acme    import ArrayList    import List    entity   Foo   {}  
						
			'''
			expectation = '''
				package acme
				
				import ArrayList
				import List
				
				entity Foo {
				
				}
			'''
		]
	}

	@Test
	def void formatAnnotationsAndInjections() {
		assertFormatted[
			toBeFormatted = '''
					
				package    acme  @Anno1    @Anno2   entity   Foo     extends    Bar   {   
					
						
					inject     Inject1    inject1    inject     Inject2    inject2   }   
						
			'''
			expectation = '''
				package acme
				
				@Anno1
				@Anno2
				entity Foo extends Bar {
				
					inject Inject1 inject1
					inject Inject2 inject2
				
				}
			'''
		]
	}

	@Test
	def void formatEntity() {
		assertFormatted[
			toBeFormatted = '''
					
				package    acme    entity   Foo     extends    Bar   {   
					
						
				
					@Anno3    @Anno4   property   Integer     prop1   {    default {-5}    }  
				
					@Anno5    @Anno6   property   Double     prop2   {    default {-2.5}    }  
					
						collection     List<String>     names   =    new    ArrayList    {    addTo {    getNames.add(element)    }
					
							validateAddTo   {    if (getNames.contains(element))    "Element already added"      else      null   }     }
					
						@Anno7       action   SimpleObject   updateName    {    @Parameter  (  maxLength  =   40)    @ParameterLayout (   named   =   "New name")   parameter   String   newName {
								default   {   getName   }   }      body {      setName(  newName )    this    }   validate  {   if (newName.contains("!"))    TranslatableString.tr("Exclamation mark is not allowed")   
								else null    }   event UpdateNameDomainEvent  }
					
						
						title    {     TranslatableString.tr("Object: {name}", "name", name)   }   
						
				}   
						
			'''
			expectation = '''
				package acme
				
				entity Foo extends Bar {
				
					@Anno3
					@Anno4
					property Integer prop1 {
				
						default {
							-5
						}
				
					}
				
					@Anno5
					@Anno6
					property Double prop2 {
				
						default {
							-2.5
						}
				
					}
				
					collection List<String> names = new ArrayList {
				
						addTo {
							getNames.add(element)
						}
				
						validateAddTo {
							if(getNames.contains(element)) "Element already added" else null
						}
				
					}
				
					@Anno7
					action SimpleObject updateName {
				
						@Parameter(maxLength=40)
						@ParameterLayout(named="New name")
						parameter String newName {
				
							default {
								getName
							}
				
						}
				
						body {
							setName(newName)
							this
						}
				
						validate {
							if(newName.contains("!")) TranslatableString.tr("Exclamation mark is not allowed") else null
						}
				
						event UpdateNameDomainEvent
				
					}
				
					title {
						TranslatableString.tr("Object: {name}", "name", name)
					}
				
				}
			'''
		]
	}

	@Test
	def void formatService() {
		assertFormatted[
			toBeFormatted = '''
					
				package    acme    service   Foo     extends    Bar   {   
					
						
				
					@Action(semantics = SAFE)    @ActionLayout(   bookmarking   = AS_ROOT)    @MemberOrder(sequence = "1")     action List<SimpleObject> listAll {
						body  {   repositoryService.allInstances(SimpleObject)    }    }
					@Action(semantics = SAFE)    @ActionLayout(  bookmarking    =   AS_ROOT)   @MemberOrder(sequence = "2")    action List<SimpleObject> findByName {
						@ParameterLayout(named="Name")    parameter   String    name   body    {   
							repositoryService.allMatches(new QueryDefault(SimpleObject, "findByName", "name", name))    }   }
							
							
				
							
					@MemberOrder(sequence = "3")    action    SimpleObject   create   {      @ParameterLayout(named="Name")      parameter    String   name    
						body   {    val obj = factoryService.instantiate(SimpleObject)      obj.name = name   repositoryService.persist(obj)      obj   }    }
						
				    }   
						
			'''
			expectation = '''
				package acme
				
				service Foo extends Bar {
				
					@Action(semantics=SAFE)
					@ActionLayout(bookmarking=AS_ROOT)
					@MemberOrder(sequence="1")
					action List<SimpleObject> listAll {
				
						body {
							repositoryService.allInstances(SimpleObject)
						}
				
					}
				
					@Action(semantics=SAFE)
					@ActionLayout(bookmarking=AS_ROOT)
					@MemberOrder(sequence="2")
					action List<SimpleObject> findByName {
				
						@ParameterLayout(named="Name")
						parameter String name
				
						body {
							repositoryService.allMatches(new QueryDefault(SimpleObject, "findByName", "name", name))
						}
				
					}
				
					@MemberOrder(sequence="3")
					action SimpleObject create {
				
						@ParameterLayout(named="Name")
						parameter String name
				
						body {
							val obj = factoryService.instantiate(SimpleObject)
							obj.name = name
							repositoryService.persist(obj)
							obj
						}
				
					}

				}
			'''
		]
	}

}
