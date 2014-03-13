

/**
 * FATAL ERROR TAG
 */
var FatalErrorDialog = {
	display:function(sentParams){
		FatalErrorDialog.exec(sentParams);
	},
	init:function(){},
	exec:function(sentParams){
		
		var params = $.extend({
			silent:			false,
			fatal:  		false,
			message:		"A fatal error has occurred.",
			page:			"undefined.jsp",
			description:	null,
			data:			null
		}, sentParams);

		meerkat.modules.errorHandling.error(params);

	}
}


// Used in split_test.tag
var Track = {
	splitTest:function splitTesting(result, supertagName){
		meerkat.modules.tracking.recordSupertag('splitTesting',{
			version:result,
			splitTestName: supertagName
		});
	}
}
