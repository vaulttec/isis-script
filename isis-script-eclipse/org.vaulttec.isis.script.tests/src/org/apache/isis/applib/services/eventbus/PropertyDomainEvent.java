package org.apache.isis.applib.services.eventbus;

public class PropertyDomainEvent<S, T> {

	public static class Default extends PropertyDomainEvent<Object, Object> {
		public Default() {
		}
	}

}
