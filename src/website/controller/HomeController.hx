package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;
import website.api.ProjectListApi;
import website.model.SiteDb;
using thx.core.Arrays;
using thx.core.Floats;
using StringTools;
using tink.CoreApi;
using CleverSort;

class HomeController extends Controller {

	@inject public var projectListApi:ProjectListApi;
	@inject("scriptDirectory") public var scriptDir:String;

	// Perform init() after dependency injection has occured.
	@post public function init() {
		// All MVC actions come through HomeController (our index controller) first, so this is a good place to set global template variables.
		var r = context.request;
		var url = 'http://'+r.hostName+r.uri;
		if ( r.queryString!="" ) {
			url += '?'+r.queryString;
		}
		ViewResult.globalValues.set( "pageUrl", url );
		ViewResult.globalValues.set( "todaysDate", Date.now() );
		ViewResult.globalValues.set( "description", "Haxe is an open source toolkit based on a modern, high level, strictly typed programming language." );
	}

	@:route("/")
	public function homepage() {
		var latestProjects = projectListApi.latest( 10 ).sure();
		var tags = projectListApi.getTagList( 10 ).sure();
		// "Welcome, old site, Latest Releases, Browse projects";
		return new ViewResult({
			title: "Haxelib - the Haxe package manager",
			description: "Haxelib is a tool that enables sharing libraries and code in the Haxe ecosystem.",
			pageUrl: context.request.uri,
			latestProjects: latestProjects,
			tags: tags,
			exampleCode: CompileTime.readFile( "/website/homepage-example.txt" )
		});
	}

	@:route("/p/*")
	public var projectController:ProjectController;

	@:route("/u/*")
	public var userController:UserController;

	@:route("/rss/")
	public var rssController:RSSController;

	@:route("/documentation/*")
	public var documentationController:DocumentationController;

	@:route("/t/")
	public function tagList():ViewResult {
		var tagList = projectListApi.getTagList( 50 ).sure();

		// Build a tag cloud.
		var sizes = [for (t in tagList) t.count];
		var least = sizes.min();
		var most = sizes.max();
		var minSize = 10;
		var maxSize = 140;
		function fontSizeForCount( count:Int ) {
			var range = most - least;
			var pos = (count - least) / range;
			return pos.interpolate(minSize,maxSize);
		}
		var tagCloud = [for (t in tagList) { tag:t.tag, size:fontSizeForCount(t.count) }];
		tagCloud.cleverSort( _.tag );

		return new ViewResult({
			title: 'Haxelib Tags',
			description: 'The 50 most popular tags for projects on Haxelib, sorted by the number of projects',
			tags: tagList,
			tagCloud: tagCloud,
		});
	}

	// TODO: get ufront-mvc to support `/t/$tagName` and `/t/$tagName.json` as different routes.
	@:route("/t/$tagName")
	public function tag( tagName:String ):ActionResult {
		if ( tagName.endsWith(".json") ) {
			return tagJson( tagName.substr(0,tagName.length-5) );
		}
		else {
			return new ViewResult({
				title: 'Tag: $tagName',
				icon: 'fa-tag',
				description: 'A list of all projects on Haxelib with the tag "$tagName"',
				projects: projectListApi.byTag( tagName ).sure(),
			}, "projectList.html");
		}
	}

	@:route("/all")
	public function all() {
		var list = projectListApi.all().sure();
		return new ViewResult({
			title: 'All Haxelibs',
			icon: 'fa-star',
			description: 'A list of every project uploaded on haxelib, sorted by popularity',
			projects: list,
		}, "projectList.html");
	}

	@:route("/search")
	public function search( ?args:{ v:String } ) {
		if ( args.v==null || args.v.length==0 ) {
			return new ViewResult({
				title: "Show a search box.  For now use ?v="
			}, "searchForm.html");
		}
		else {
			return new ViewResult({
				title: 'Search for "${args.v}"',
				icon: 'fa-search',
				description: 'Haxelib projects that match the search word "${args.v}"',
				projects: projectListApi.search( args.v ).sure()
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
