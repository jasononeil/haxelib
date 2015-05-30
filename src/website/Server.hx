package website;

import tools.haxelib.SiteDb;
import website.controller.*;
import ufront.mailer.*;
import ufront.MVC;
import sys.db.*;

class Server {
	static var ufApp:UfrontApplication;

	static function main() {

		ufApp = new UfrontApplication({
			indexController: HomeController,
			templatingEngines: [TemplatingEngines.erazor],
			defaultLayout: "layout.html",
			logFile: "logs/haxelib.log",
			sessionImplementation: VoidSession,
			authImplementation: NobodyAuthHandler,
			contentDirectory: "../uf-content/"
		});
		ufApp.injectValue( String, neko.Web.getCwd()+"documentation-files/", "documentationPath" );
		ufApp.injectClass( UFCacheConnectionSync, DBCacheConnection );
		ufApp.injectClass( UFCacheConnection, DBCacheConnection );

		var cacheMiddleware = new RequestCacheMiddleware();
		ufApp.addRequestMiddleware( cacheMiddleware, true ).addResponseMiddleware( cacheMiddleware, true );

		// If we're on neko, and using the module cache, next time jump straight to the main request.
		#if (neko && !debug)
			neko.Web.cacheModule(run);
		#end

		// Execute the main request.
		run();
	}

	static function run() {
		SiteDb.init();
		ufApp.executeRequest();
		SiteDb.cleanup();
	}
}
