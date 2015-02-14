package website.controller;

import website.controller.*;
import ufront.web.result.*;
import ufront.web.result.ViewResult;
import website.Server;

// These imports are common for our various test-suite tools.
import buddy.*;
import mockatoo.Mockatoo.*;
import ufront.test.TestUtils.NaturalLanguageTests.*;
import utest.Assert;
using buddy.Should;
using ufront.test.TestUtils;
using mockatoo.Mockatoo;

class HomeControllerTest extends BuddySuite {
	public function new() {

		var haxelibSite = WebsiteTests.getTestApp();

		describe("When I go to the homepage", {
			it("Should show our homepage view", function (done) {
				whenIVisit( "/" )
					.onTheApp( haxelibSite )
					.itShouldLoad( HomeController, "homepage", [] )
					.itShouldReturn( ViewResult, function (result) {
						var title:String = result.data['title'];
						(result.data['title']:String).should.be("Haxelib");
						Assert.same( result.templateSource, FromEngine("home/homepage") );
						Assert.same( result.layoutSource, FromEngine("layout.html") );
					})
					.andFinishWith( done );
			});
			it("Should show a list of popular projects");
			it("Should show a list of recently updated projects");
			it("Show me my projects if I am logged in");
		});

		describe("When I load a tag page", {
			it("Should show the list of projects with that tag");
		});

		describe("When I load the 'all projects' page", {
			it("Should show them all");
		});

		describe("When I search", {
			it("Should show me the search form if there is no search term entered");
			it("Should show projects matching the name");
			it("Should show projects matching the description");
			it("Redirect straight to the project page if there's only 1 search result");
			// TODO: ask Nicolas, should we just use Google?
		});

		describe("When I want to access the data through a JSON API", {
			it("Should give me search via JSON");
			it("Should give me tags via JSON");
			it("Should give me all via JSON");
		});
	}
}