package website.controller;

import website.controller.*;
import ufront.web.result.ViewResult;
import website.Server;
using tink.CoreApi;

// These imports are common for our various test-suite tools.
import buddy.*;
import mockatoo.Mockatoo.*;
import ufront.test.TestUtils.NaturalLanguageTests.*;
import utest.Assert;
using buddy.Should;
using ufront.test.TestUtils;
using mockatoo.Mockatoo;

class DocumentationControllerTest extends BuddySuite {
	public function new() {

		var haxelibSite = WebsiteTests.getTestApp();

		describe("When viewing documentation", {
			it("Should load all pages without errors", function (done) {
				var pages = DocumentationController.documentationPages;
				var allResults = [];
				for ( url in pages.keys() ) {
					var title = pages[url];
					var page =
						if ( url=="/documentation" ) null
						else url.substr( "/documentation/".length );
					var result = whenIVisit( url )
						.onTheApp( haxelibSite )
						.itShouldLoad( DocumentationController, "documentationPage", [page] )
						.itShouldReturn( ViewResult, function (result) {
							Assert.same( FromEngine("documentation/documentationPage"), result.templateSource );
							Assert.same( FromEngine("layout.html"), result.layoutSource );
							(result.data['title']:String).should.be('$title - Haxelib Documentation');
						});
					allResults.push( result );
				}

				Future.ofMany( allResults ).handle( function() done() );
			});
		});

	}
}