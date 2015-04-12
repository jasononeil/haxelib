package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;
import website.api.DocumentationApi;
using tink.CoreApi;

@cacheRequest
class DocumentationController extends Controller {

	@inject public var api:DocumentationApi;

	@:route("/$page")
	public function documentationPage( ?page:String ) {
		var html = api.getDocumentationHTML( page ).sure();
		var docTitle =
			if ( page==null ) documentationPages['/documentation'];
			else documentationPages['/documentation/$page'];
		return new ViewResult({
			title: '$docTitle - Haxelib Documentation',
			content: html,
			pages: documentationPages,
			currentPage: (page!=null) ? baseUri+page : baseUri,
		});
	}

	public static var documentationPages:Map<String,String> = [
		"/documentation" => "About Haxelib",
		"/documentation/installation" => "Installation",
		"/documentation/using-haxelib" => "Using Haxelib",
		"/documentation/creating-a-haxelib-package" => "Creating a haxelib",
		"/documentation/faq" => "FAQ",
		"/documentation/tips-and-tricks" => "Tips and Tricks",
		"/documentation/api" => "Remoting API and JSON API",
		"/documentation/contributing" => "Contributing to Haxelib",
	];
}
