jQuery.fn.extend({
mask: function() {
},
unmask: function() {
}
});

asyncTest( "should getSearchURL", 3, function() {
	var expectedUrlPrefix = "ajax/html/smart_street.jsp?&postCode=&fieldId=test_streetSearch&showUnable=yes&excludePostBoxes=true";
	var expectedHouseNumber = "1";
	var streetSearch = $("#test_streetSearch");
	init_address("test");
	streetSearch.val(expectedHouseNumber);
	streetSearch.trigger('getSearchURL', function getSearchURLCallBack(url) {
		ok( url == expectedUrlPrefix + "&houseNo=1", "url does not match!" );
		streetSearch.val(expectedHouseNumber + " T");
		streetSearch.trigger('getSearchURL', function getSearchURLCallBack(url) {
			ok( url == expectedUrlPrefix + "&houseNo=" + expectedHouseNumber + "&street=T", "url does not match!" );
			streetSearch.val(expectedHouseNumber + " Test");
			streetSearch.trigger('getSearchURL', function getSearchURLCallBack(url) {
				ok( url == expectedUrlPrefix + "&houseNo=" + expectedHouseNumber + "&street=TEST", "url does not match!" );
				start();
			});
		});
	});
});