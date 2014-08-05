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


	$(window).queue(function(next) {
		window.focus();
		mboxTrack("carApplicationOverlay");
		
		var message = '';
		if(msg !== 'undefined' && msg.length > 0){
			$('.message').text(msg);
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

function mboxTrack(mbox) {
	var d = new Date(); 
	var ub = mboxFactoryDefault.getUrlBuilder().clone(); 
	ub.addParameter("mbox", mbox); 
	ub.addParameter('mboxTime', d.getTime() - (d.getTimezoneOffset() * 60000)); 
	ub.addParameters(Array.prototype.slice.call(arguments).slice(1)); 
	var img = new Image(); 
	img.src = ub.buildUrl().replace("/undefined", "/ajax") + "&rand=" + Math.ceil(Math.random() * 9999999999);;
}	