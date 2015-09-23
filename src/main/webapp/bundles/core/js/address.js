;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var moduleEvents = {
			ADDRESS_CHANGE: 'ADDRESS_CHANGE'
		};

	var settings = {
		defaultHash:''
	},
	previousHash;

	function setHash(value){
		window.location.hash = value;
		previousHash = value;
	}

	function setStartHash(value){
		settings.defaultHash = value;
		previousHash = value;
	}

	function appendToHash(value){
		if(_.indexOf(getWindowHashAsArray(), value) == -1){
			window.location.hash = getWindowHash()+'/'+value;
			previousHash = window.location.hash;
		}
	}

	function getPreviousHash() {
		return previousHash;
	}

	function removeFromHash(value){

		var hashArray = meerkat.modules.address.getWindowHashAsArray();

		for(var j=hashArray.length-1;j>=0;j--){
			if(hashArray[j] == value){
				hashArray.splice(j, 1);
			}
		}

		window.location.hash = hashArray.join('/');
	}


	function initAddress() {

		var self = this;
		$(window).on('hashchange', function onHashChange(eventObject){
			// meerkat.logging.info('[hashchange] '+meerkat.modules.address.getWindowHash());
			meerkat.messaging.publish(moduleEvents.ADDRESS_CHANGE, {
				previousHash:meerkat.modules.address.getPreviousHash(),
				hash:meerkat.modules.address.getWindowHash(),
				hashArray:meerkat.modules.address.getWindowHashAsArray()
			});
		});

	}

	function getWindowHashAsArray(){
		return getWindowHash().split('/');
	}

	function getWindowHashAt(position){
		var hashArray = getWindowHashAsArray();
		if(position >= hashArray.length) return "";
		return hashArray[position];
	}


	/* Get the hash from the browser's window */
	function getWindowHash(){
		var hash = window.location.hash;
		if(hash != null) return hash.replace('#', '');
		return '';
	}

	meerkat.modules.register('address', {
		init: initAddress,
		events: moduleEvents,
		getWindowHashAsArray:getWindowHashAsArray,
		getWindowHash:getWindowHash,
		getPreviousHash:getPreviousHash,
		setHash:setHash,
		appendToHash:appendToHash,
		removeFromHash:removeFromHash,
		setStartHash:setStartHash,
		getWindowHashAt:getWindowHashAt
	});

})(jQuery);
