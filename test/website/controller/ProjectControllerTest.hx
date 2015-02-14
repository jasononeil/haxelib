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

class ProjectControllerTest extends BuddySuite {
	public function new() {

		var haxelibSite = WebsiteTests.getTestApp();

		describe("When I view a project", {
			it("Should show the project view for the latest version", function (done) {
				whenIVisit( "/p/detox" )
					.onTheApp( haxelibSite )
					.itShouldLoad( ProjectController, "project", [] )
					.itShouldReturn( ViewResult, function (result) {
						var title:String = result.data['title'];
//						(result.data['title']:String).should.be("Hello World");
						Assert.same( result.templateSource, FromEngine("project/project") );
						Assert.same( result.layoutSource, FromEngine("layout.html") );
						// TODO: Check we got the latest version.
					})
					.andFinishWith( done );
			});
		});

		describe("When I view a project version", {
			it("Should show me the README for the current version", {
				// check `viewResult`...
			});
			it("Should show me the file list for the current version", {
				// check `viewResult`...
			});
			it("Should show me a list of all versions", {
				// check `viewResult`...
			});
			it("Should show me the haxelibs this depends on", {
				// check `viewResult`...
			});
			it("Should show me the haxelibs that depend on this", {
				// check `viewResult`...
			});
			it("Should let me know if there is a more recent version");
			it("Should let me know if this version is not considered stable");
		});

		describe("When I view a project's files", {
			it("Should show me that file's source code in line");
			it("Should render markdown files as HTML");
			it("Should show binary files size and a link to download it");
		});

		describe("When I view a projects docs", {
			it("Should show the correct documentation for this version");
		});
	}
}