package org.apache.isis.applib.annotation;

public @interface DomainService {

	Class<?> repositoryFor() default Object.class;

}
