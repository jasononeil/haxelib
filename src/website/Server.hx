package website;

import ufront.app.UfrontApplication;
import ufront.view.TemplatingEngines;
import website.controller.*;
import ufront.mailer.*;
import sys.db.*;

class Server {
	static var ufApp:UfrontApplication;

	static function main() {

		ufApp = new UfrontApplication({
			indexController: HomeController,
			templatingEngines: [TemplatingEngines.erazor],
			defaultLayout: "layout.html",
			logFile: "logs/haxelib.log",
			contentDirectory: "../uf-content/"
		});

		var smtpMailer = null; // new SMTPMailer(Config.server.smtp);
		var dbMailer = new DBMailer( smtpMailer );
		ufApp.inject( UFMailer, dbMailer );

		// Execute the main request.
		run();

		// If we're on neko, and using the module cache, next time jump straight to the main request.
		#if (neko && !debug)
			neko.Web.cacheModule(run);
		#end
	}

	static function run() {
//		sys.db.Manager.cnx = Mysql.connect( Config.mysql );
		ufApp.executeRequest();
	}
}