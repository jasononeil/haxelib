package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;

class UserController extends Controller {

	@:route("/$username")
	public function profile( username:String ) {
		return 'View user $username';
	}

	// Future: edit your own profile.  Especially password resets.
}
