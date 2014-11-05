;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		tests = [],
		PERFORMANCE ={
			LOW :'low',
			MEDIUM : 'medium',
			HIGH : 'high'
		};

	var USER_AGENT = navigator.userAgent.toLowerCase();

	// Timer method to perform time checks between events.

	function startTest(name){

		var start = new Date().getTime();
		var obj = {
			name:name,
			startTime:start
		};

		tests.push(obj);
	}

	function endTest(name){

		var end = new Date().getTime();

		var testObj = _.findWhere(tests, {name:name});
		if(typeof testObj === 'undefined') return null;

		var index = tests.indexOf(testObj);
		tests.splice(index, 1);

		var time = end - testObj.startTime;
		return time;
	}

	// Browser detection methods

	function isIos(){
		return !!navigator.platform.match(/iPhone|iPod|iPad/i);
	}

	function isAndroid(){
		return USER_AGENT.indexOf('android') > -1;
	}

	function isChrome(){
		return USER_AGENT.indexOf('chrome') > -1;
	}

	function isFFAffectedByDropdownMenuBug() {
		return USER_AGENT.match(/firefox\/(30|31|32|33|34).*/i);
	}

	function isSafariAffectedByColumnCountBug() {

		return USER_AGENT.match(/(8\.\d+\.?\d?|7\.1|6\.2) safari/i);
	}

	function isIE8(){
		if(getIEVersion() === 8){
			return true;
		}
		return false;
	}

	function isIE9(){
		if(getIEVersion() === 9){
			return true;
		}
		return false;
	}

	function isIE10(){
		if(getIEVersion() === 10){
			return true;
		}
		return false;
	}

	function isIos5(){
		if(isIos()  && USER_AGENT.match(/os 5/)){
			return true;
		}
		return  false;
	}

	function isIos6(){
		if(isIos()  && USER_AGENT.match(/os 6/)){
			return true;
		}
		return  false;
	}

	function isIos7(){
		if(isIos()  && USER_AGENT.match(/os 7/)){
			return true;
		}
		return  false;
	}

	function getIEVersion(){
		var ua = USER_AGENT;
		var msie = ua.indexOf ( "msie " );

		if ( msie > 0 ){      // If Internet Explorer, return version number
			return parseInt (ua.substring (msie+5, ua.indexOf (".", msie )));
		}else{
			return null;
		}
	}

	meerkat.modules.register("performanceProfiling", {
		PERFORMANCE:PERFORMANCE,
		startTest: startTest,
		endTest:endTest,
		isIos5:isIos5,
		isIos6:isIos6,
		isIos7:isIos7,
		isIos:isIos,
		isAndroid:isAndroid,
		isChrome:isChrome,
		isFFAffectedByDropdownMenuBug: isFFAffectedByDropdownMenuBug,
		isSafariAffectedByColumnCountBug: isSafariAffectedByColumnCountBug,
		isIE8:isIE8,
		isIE9:isIE9,
		isIE10:isIE10,
		getIEVersion: getIEVersion
	});

})(jQuery);