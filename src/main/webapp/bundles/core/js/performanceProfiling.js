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

	function isOpera(){
		return USER_AGENT.indexOf('opera mini') > -1;
	}

	function isBlackBerry(){
		return USER_AGENT.indexOf('blackBerry') > -1;
	}

	function isWindows(){
		return USER_AGENT.indexOf('iemobile') > -1;
	}

	function isMobile() {
		return isIos() || isAndroid() || isBlackBerry() || isOpera() || isWindows();
	}

	function isFFAffectedByDropdownMenuBug() {
		return USER_AGENT.match(/firefox\/(30|31|32|33|34).*/i);
	}

	function isSafariAffectedByColumnCountBug() {

		return USER_AGENT.match(/(8\.\d+\.?\d?|7\.1|6\.2) safari/i);
	}

	function isSafari() {
		if (USER_AGENT.indexOf('safari')!=-1){
			if(USER_AGENT.indexOf('chrome')  > -1){
				return false;
			}else{
				return true;
			}
		} else {
			return false;
		}
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

	function isIE11(){
		if(getIEVersion() === 11){
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
		var isIE = ((ua.indexOf ( "msie " ) > 0) || (ua.indexOf ( "trident" ) > 0));

		if (isIE){      // If Internet Explorer, return version number
			var msieIndex = ua.indexOf ( "msie" );
			// MS 11 onwards. It doesn't use msie anymore
			// http://msdn.microsoft.com/en-us/library/ie/bg182625(v=vs.110).aspx
			if (msieIndex == -1) {
				var version = ua.match(/trident.*rv[ :]*(11|12)\./i);
				return parseInt(version[1]);

			}
			return parseInt (ua.substring (msieIndex+5, ua.indexOf (".", msieIndex )));
		}else{
			return null;
		}
	}

	/** amILocal confirms whether the users IP address is within local network
	 *  IP rules are as follows:
	 *      a] 192.168.*.*
	 *      b] 172.16.*.* to 172.31.*.*
	 *      c] 10.*.*.*
	 *      d] 127.0.0.1
	 *  meerkat.site.ipAddress is available to ALL verticals
	 * @returns {boolean}
	 */
	function amILocal() {
		var ipTests = [
				/^192\.168\.(\d){1,3}\.(\d){1,3}$/,
				/^172\.(1[6-9]|2[0-9]|3[01])\.(\d){1,3}\.(\d){1,3}$/,
				/^10\.(\d){1,3}\.(\d){1,3}\.(\d){1,3}$/,
				/^127\.0\.0\.1$/
		];
		for(var i=0; i<ipTests.length; i++) {
			if(ipTests[i].test(meerkat.site.ipaddress)) {
				return true;
			}
		}
		return false;
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
		isBlackBerry:isBlackBerry,
		isOpera:isOpera,
		isWindows:isWindows,
		isMobile:isMobile,
		isFFAffectedByDropdownMenuBug: isFFAffectedByDropdownMenuBug,
		isSafariAffectedByColumnCountBug: isSafariAffectedByColumnCountBug,
		isSafari: isSafari,
		isIE8:isIE8,
		isIE9:isIE9,
		isIE10:isIE10,
		isIE11:isIE11,
		getIEVersion: getIEVersion,
		amILocal: amILocal
	});

})(jQuery);