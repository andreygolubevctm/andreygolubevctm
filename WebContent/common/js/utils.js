/** GENERAL UTILITY ROUTINES **/
function twoDigits(row){
	return (row < 10)?"0"+row:row;
}

function getUrlParamByName(key) {
	key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&"); // escape RegEx meta chars
	var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
	return match && decodeURIComponent(match[1].replace(/\+/g, " "));
}