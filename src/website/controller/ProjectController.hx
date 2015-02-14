package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;

class ProjectController extends Controller {

	@:route("/$projectName")
	public function project( projectName:String ) {
		return 'View project $projectName';
	}

	@:route("/$projectName/$semver")
	public function version( projectName:String, semver:String ) {
		return 'View project $projectName version $semver';
	}

	@:route("/$projectName/$semver/doc/$typePath")
	public function docs( projectName:String, semver:String, typePath:String ) {
		return 'View project $projectName docs for $typePath';
	}

	@:route("/$projectName/$semver/files/$filePath")
	public function file( projectName:String, semver:String, filePath:String ) {
		return 'View project $projectName files: $filePath';
	}
}