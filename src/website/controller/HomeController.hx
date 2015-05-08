package website.controller;

import ufront.web.Controller;
import ufront.web.result.*;
import ufront.ufadmin.controller.*;
import website.api.ProjectListApi;
import website.model.SiteDb;
using thx.Arrays;
using thx.Floats;
using StringTools;
using tink.CoreApi;
using CleverSort;

class HomeController extends Controller {

	@inject public var projectListApi:ProjectListApi;

	// Perform init() after dependency injection has occured.
	@post public function init() {
		// All MVC actions come through HomeController (our index controller) first, so this is a good place to set global template variables.
		var r = context.request;
		var url = 'http://'+r.hostName+r.uri;
		if ( r.queryString!="" ) {
			url += '?'+r.queryString;
		}
		ViewResult.globalValues.set( "pageUrl", url );
		ViewResult.globalValues.set( "currentPage", r.uri );
		ViewResult.globalValues.set( "todaysDate", Date.now() );
		ViewResult.globalValues.set( "documentationPages", DocumentationController.getDocumentationPages() );
		ViewResult.globalValues.set( "description", "Haxe is an open source toolkit based on a modern, high level, strictly typed programming language." );
	}

	@:route("/")
	public function homepage() {
		var latestProjects = projectListApi.latest( 10 ).sure();
		var tags = projectListApi.getTagList( 10 ).sure();
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

	@cacheRequest
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
	@cacheRequest
	@:route("/t/$tagName")
	public function tag( tagName:String ):ActionResult {
		if ( tagName.endsWith(".json") ) {
			return tagJson( tagName.substr(0,tagName.length-5) );
		}
		else {
			var list = projectListApi.byTag( tagName ).sure();
			var versions = [for (p in list) p.name => p.versionObj.toSemver()];
			var authors = [for (p in list) p.name => p.ownerObj.name];
			return new ViewResult({
				title: 'Tag: $tagName',
				icon: 'fa-tag',
				description: 'A list of all projects on Haxelib with the tag "$tagName"',
				projects: list,
				versions: versions,
				authors: authors,
			}, "projectList.html");
		}
	}

	@cacheRequest
	@:route("/all")
	public function all() {
		var list = projectListApi.all().sure();
		var versions = [for (p in list) p.name => p.versionObj.toSemver()];
		var authors = [for (p in list) p.name => p.ownerObj.name];
		return new ViewResult({
			title: 'All Haxelibs',
			icon: 'fa-star',
			description: 'A list of every project uploaded on haxelib, sorted by popularity',
			projects: list,
			versions: versions,
			authors: authors,
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
			var list = projectListApi.search( args.v ).sure();
			var versions = [for (p in list) p.name => p.versionObj.toSemver()];
			var authors = [for (p in list) p.name => p.ownerObj.name];
			return new ViewResult({
				title: 'Search for "${args.v}"',
				icon: 'fa-search',
				description: 'Haxelib projects that match the search word "${args.v}"',
				projects: list,
				versions: versions,
				authors: authors,
			}, "projectList.html");
		}
	}

	@:route("/search.json")
	public function searchJson( args:{ v:String } )
		return new JsonResult( projectListApi.search(args.v).sure() );

	@cacheRequest
	@:route("/all.json")
	public function allJson()
		return new JsonResult( projectListApi.all().sure() );

	@:route("/ufadmin/*")
	public function ufadmin() {
		return executeSubController( UFAdminHomeController );
	}

	public function tagJson( tagName:String )
		return new JsonResult( projectListApi.byTag(tagName).sure() );
}
