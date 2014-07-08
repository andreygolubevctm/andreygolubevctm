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
		if(msg!='undefined'){
			message = msg;
		}else{
			message = 'Transferring you to...';
		}
		
		Transferring.show(brand, message);
		next();
	})
	.delay(1000)
	.queue(function(next) {
		if (getUrlVars()['handoverType'] === "post")
		{
				var $genericForm = $('#genericForm');
				$genericForm.attr('method', 'POST');
				$genericForm.attr('action', decodeURIComponent(getUrlVars()['handoverURL']));

				var textArea = $('<textarea>').attr('style', 'display:none').attr('name', decodeURIComponent(getUrlVars()['handoverVar'])).val(decodeURIComponent(getUrlVars()['handoverData']));
				$genericForm.append(textArea);

				$genericForm.submit();
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