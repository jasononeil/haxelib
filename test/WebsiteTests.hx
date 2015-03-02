package;

import website.api.ProjectListApi;
import ufront.app.UfrontApplication;
import ufront.mailer.*;
import ufront.auth.EasyAuth;
import ufront.view.TemplatingEngines;
import twl.webapp.*;
import twl.*;
import buddy.*;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

@:build(buddy.GenerateMain.build(["website"]))
class WebsiteTests {
	static var ufApp:UfrontApplication;

	public static function getTestApp():UfrontApplication {
		if ( ufApp==null ) {
			// Create a UfrontApplication suitable for unit testing.
			ufApp = new UfrontApplication({
				indexController: website.controller.HomeController,
				errorHandlers: [],
				disableBrowserTrace: true,
				contentDirectory: "../uf-content/",
				templatingEngines: [TemplatingEngines.erazor],
				viewPath: "www/view/",
				defaultLayout: "layout.html",
			});

			// Different injections for our test suite.
			ufApp.inject( UFMailer, TestMailer, true );
			ufApp.inject( EasyAuth, new EasyAuthAdminMode() );
			ufApp.inject( String, "www/documentation-files/", "documentationPath" );
		}
		return ufApp;
	}
}