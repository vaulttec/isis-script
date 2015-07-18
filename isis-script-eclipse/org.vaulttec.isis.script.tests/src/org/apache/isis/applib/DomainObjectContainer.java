package org.apache.isis.applib;

import java.util.List;

public interface DomainObjectContainer {

	<T> List<T> allInstances(Class<T> ofType, long... range);

}
