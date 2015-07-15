$(function () {
	jQuery.fn.extend({
	mask: function() {
	},
	unmask: function() {
	}
	});

	module( "AddressUtils" );

	QUnit.test( "should get is post box", function() {
		ok(AddressUtils.isPostalBox('po box'), "should be a post box" );
		ok(!AddressUtils.isPostalBox('foobar St'), "should not be a post box" );
	});


/*	module( "getSearchURL" );

	QUnit.test( "should get url for single digit", 1, function() {
		var expectedUrlPrefix = "ajax/html/smart_street.jsp?&postCode=&fieldId=QUnit.test_streetSearch&showUnable=yes";
		var expectedHouseNumber = "1";
		var streetSearch = $("#test_streetSearch");
		init_address("test");
		streetSearch.val(expectedHouseNumber);
		var result = "";
		streetSearch.trigger('getSearchURL', function getSearchURLCallBack(url) {
			result = url;
		});
		console.log("result" , result);
		console.log("expectedUrlPrefix" , expectedUrlPrefix);
		ok( result == expectedUrlPrefix + "&houseNo=1", "url does not match!" );
	});

	QUnit.test( "should get url for single digit and start of street", 1, function() {
		var expectedUrlPrefix = "ajax/html/smart_street.jsp?&postCode=&fieldId=QUnit.test_streetSearch&showUnable=yes";
		var expectedHouseNumber = "1";
		var streetSearch = $("#QUnit.test_streetSearch");
		init_address("test");
		streetSearch.val(expectedHouseNumber + " T");
		var result = "";
		streetSearch.trigger('getSearchURL', function getSearchURLCallBack(url) {
			result = url;
		});
		ok( result == expectedUrlPrefix + "&houseNo=" + expectedHouseNumber + "&street=T", "url does not match!" );
	});

	QUnit.test( "should get url for number and street", 1, function() {
		var expectedUrlPrefix = "ajax/html/smart_street.jsp?&postCode=&fieldId=QUnit.test_streetSearch&showUnable=yes";
		var expectedHouseNumber = "1";
		var streetSearch = $("#QUnit.test_streetSearch");
		init_address("QUnit.test");
		streetSearch.val(expectedHouseNumber + " Test");
		var result = "";
		streetSearch.trigger('getSearchURL', function getSearchURLCallBack(url) {
			result = url;
		});
		ok( result == expectedUrlPrefix + "&houseNo=" + expectedHouseNumber + "&street=TEST", "url does not match!" );
	});*/
});