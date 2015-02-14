package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;
import website.api.ProjectListApi;
using StringTools;
using tink.CoreApi;

class HomeController extends Controller {

	@inject public var projectListApi:ProjectListApi;

	@:route("/")
	public function homepage() {
		var latestProjects = projectListApi.latest( 20 );
		// "Welcome, old site, Latest Releases, Browse projects";
		return new ViewResult({
			title: "Haxelib",
			latestProjects: latestProjects,
		});
	}

	@:route("/p/*")
	public var projectController:ProjectController;

	@:route("/u/*")
	public var userController:UserController;

	@:route("/rss/")
	public var rssController:RSSController;

	// TODO: get ufront-mvc to support `/t/$tagName` and `/t/$tagName.json` as different routes.
	@:route("/t/$tagName")
	public function tag( tagName:String ):ActionResult {
		if ( tagName.endsWith(".json") ) {
			return tagJson( tagName.substr(0,tagName.length-5) );
		}
		else {
			return new ViewResult({
				title: 'Tag: $tagName',
				description: 'You are currently viewing a list of all project on haxelib with the tag "$tagName"',
				projects: projectListApi.byTag( tagName )
			}, "projectList.html");
		}
	}

	@:route("/all")
	public function all() {
		return new ViewResult({
			title: 'All Haxelibs',
			description: 'You are currently viewing a list of every project on haxelib',
			projects: projectListApi.all()
		}, "projectList.html");
	}

	@:route("/search")
	public function search( ?args:{ v:String } ) {
		if ( args.v==null || args.v.length==0 ) {
			return new ViewResult({
				title: 'Search for "${args.v}"',
				description: 'Searching project names and descriptions for the word "${args.v}',
				projects: projectListApi.search( args.v )
			}, "searchForm.html");
		}
		else {
			return new ViewResult({
				title: "Show a search box.  For now use ?v="
			}, "projectList.html");
		}
	}

	@:route("/search.json")
	public function searchJson( args:{ v:String } )
		return new JsonResult( projectListApi.search(args.v).sure() );

	@:route("/all.json")
	public function allJson()
		return new JsonResult( projectListApi.all().sure() );

	public function tagJson( tagName:String )
		return new JsonResult( projectListApi.byTag(tagName).sure() );
}
