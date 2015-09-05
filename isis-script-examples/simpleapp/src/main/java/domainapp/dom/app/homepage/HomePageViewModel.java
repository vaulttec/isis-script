package domainapp.dom.app.homepage;

import java.util.List;

import org.apache.isis.applib.annotation.ViewModel;

import domainapp.dom.modules.simple.SimpleObject;
import domainapp.dom.modules.simple.SimpleObjects;

@ViewModel
public class HomePageViewModel {

	@javax.inject.Inject
	SimpleObjects simpleObjects;

	public String title() {
		return getObjects().size() + " objects";
	}

	@org.apache.isis.applib.annotation.HomePage
	public List<SimpleObject> getObjects() {
		return simpleObjects.listAll();
	}

}
