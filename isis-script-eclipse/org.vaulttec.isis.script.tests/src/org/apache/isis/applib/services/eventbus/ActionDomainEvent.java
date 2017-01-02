package org.apache.isis.applib.services.eventbus;

public abstract class ActionDomainEvent<T> {

	public static class Default extends ActionDomainEvent<Object> {
		public Default() {
		}
	}

}
