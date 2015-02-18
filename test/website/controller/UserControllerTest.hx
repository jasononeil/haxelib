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

class UserControllerTest extends BuddySuite {
	public function new() {

		var haxelibSite = WebsiteTests.getTestApp();

		describe("When I look at the profile of a user", {
			it("Should show me that users profile and their projects", function (done) {
				whenIVisit( "/u/jason" )
					.onTheApp( haxelibSite )
					.itShouldLoad( UserController, "profile", ["jason"] )
					.itShouldReturn( ViewResult, function (result) {
						var title:String = result.data['title'];
						(result.data['title']:String).should.be("View user jason");
						Assert.same( result.templateSource, FromEngine("user/profile") );
						Assert.same( result.layoutSource, FromEngine("layout.html") );
					})
					.andFinishWith( done );
			});
		});
	}
}