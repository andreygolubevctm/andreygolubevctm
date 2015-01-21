function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}


$(window).load(function() {
	var url = decodeURIComponent(getUrlVars()['url']);
	var msg = decodeURIComponent(getUrlVars()['msg']);
	var brand = decodeURIComponent(getUrlVars()['brand']);
	var tracking = null;

	if(getUrlVars().hasOwnProperty('tracking')) {
		try {
			var tmp = JSON.parse(decodeURIComponent(getUrlVars()['tracking']));
			tracking = _.omit(tmp, 'brandXCode');
			tracking.brandCode = tmp.brandXCode;
		} catch(e) {/* IGNORE */}
	}

	$(window).queue(function(next) {
		window.focus();
		
		var message = '';
		if(msg !== 'undefined' && msg.length > 0){
			$('.message').text(msg);
		}
		
		if(typeof meerkat == 'object' && tracking != null && typeof tracking == 'object') {
		meerkat.messaging.publish(meerkat.modules.events.tracking.EXTERNAL, {
			method: 'trackQuoteTransfer',
			object: tracking
		}, true);
		}

		next();
	})
	.delay(1000)
	.queue(function(next) {
		if (getUrlVars()['handoverType'] === "post") {
			var $mainForm = $('#mainform');
			$mainForm.attr('method', 'POST').attr('action', decodeURIComponent(getUrlVars()['handoverURL']));

				var textArea = $('<textarea>').attr('style', 'display:none').attr('name', decodeURIComponent(getUrlVars()['handoverVar'])).val(decodeURIComponent(getUrlVars()['handoverData']));
			$mainForm.append(textArea);
			$mainForm.submit();
		} else {
			window.location.replace(url);
		}
		next();
	});
});