package website;

import tools.haxelib.SiteDb;
import ufront.app.UfrontApplication;
import ufront.view.TemplatingEngines;
import website.controller.*;
import ufront.mailer.*;
import ufront.middleware.*;
import ufront.cache.UFCache;
import ufront.cache.DBCache;
import ufront.web.session.CacheSession;
import ufront.middleware.RequestCacheMiddleware;
import sys.db.*;

class Server {
	static var ufApp:UfrontApplication;

	static function main() {

		ufApp = new UfrontApplication({
			indexController: HomeController,
			templatingEngines: [TemplatingEngines.erazor],
			defaultLayout: "layout.html",
			logFile: "logs/haxelib.log",
			sessionImplementation: CacheSession,
			contentDirectory: "../uf-content/"
		});
		InlineSessionMiddleware.alwaysStart = true;
		ufApp.injectValue( String, neko.Web.getCwd()+"documentation-files/", "documentationPath" );
		ufApp.injectClass( UFCacheConnectionSync, DBCacheConnection );
		ufApp.injectClass( UFCacheConnection, DBCacheConnection );

		var smtpMailer = null; // new SMTPMailer(Config.server.smtp);
		var dbMailer = new DBMailer( smtpMailer );
		ufApp.injectValue( UFMailer, dbMailer );

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
