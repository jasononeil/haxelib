package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;

class ProjectController extends Controller {

	@:route("/$projectName")
	public function project( projectName:String ) {
		var latestVersion = "1.0.0";
		return version( projectName, latestVersion );
	}

	@:route("/$projectName/$semver")
	public function version( projectName:String, semver:String ) {
		return new ViewResult({
			title: 'View project $projectName version $semver',
		}, "version.html");
	}

	@:route("/$projectName/$semver/doc/$typePath")
	public function docs( projectName:String, semver:String, typePath:String ) {
		return new ViewResult({
			title: 'View project $projectName docs for $typePath',
		});
	}

	@:route("/$projectName/$semver/files/*")
	public function file( projectName:String, semver:String, rest:Array<String> ) {
		var filePath = rest.join("/");
		return new ViewResult({
			title: 'View project $projectName files: $filePath',
		});
	}
}