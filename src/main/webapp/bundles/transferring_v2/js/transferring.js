function loopedDecodeUriComponent(component) {
    if(window.useLoopedTransferringURIDecoding) {
        do {
            component = decodeURIComponent(component);
        } while (component.match(/%[0-9a-f]{2}/i));
    }

    return component;
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
        vars[key] = value;
    });
    return vars;
}

function transferError(description, data) {
    meerkat.modules.errorHandling.error({
        errorLevel: "fatal",
        page: "transferring.js",
        description: description,
        data: data,
        closeWindow: true,
        transactionId: data.transactionId
    });
}

$(window).on("load", function () {
	var redirectionDisabled = false;
	var delay = 1000;

	var urlVars = getUrlVars();
    var transactionId = loopedDecodeUriComponent(urlVars.transactionId);
    var productId = loopedDecodeUriComponent(urlVars.productId);
    var vertical = loopedDecodeUriComponent(urlVars.vertical);
    var msg = loopedDecodeUriComponent(urlVars.msg);
    var brand = loopedDecodeUriComponent(urlVars.brand);
    var tracking = null;
    var gaclientid = null;

    var data = {
        transactionId: transactionId,
        productId: productId,
        vertical: vertical,
        msg: msg,
        brand: brand,
        tracking: tracking
    };

	if (urlVars.hasOwnProperty('tracking')) {
		try {
			var tmp = JSON.parse(loopedDecodeUriComponent(urlVars.tracking));
			tracking = _.omit(tmp, 'brandXCode');
			tracking.brandCode = tmp.brandXCode;
		} catch (e) {/* IGNORE */}
	}

	// Create a public object to provide readonly access to the gaclientid
	var TransferGAClientId = function(gid) {
		var gaClientId = gid;
		this.get = function() {
			return gaClientId;
		};
	};
	if (tracking !== null && _.isObject(tracking) && _.has(tracking,'gaclientid')) {
		gaclientid = tracking.gaclientid;
	} else if(urlVars.hasOwnProperty('gaclientid')) {
		gaclientid = loopedDecodeUriComponent(urlVars.gaclientid);
	}
	window.transferGAClientIdObj = new TransferGAClientId(gaclientid);

    $(window).queue(function (next) {
        window.focus();

        var message = '';
        if (msg !== 'undefined' && msg.length > 0) {
            $('.message').text(msg);
        }

        if (typeof meerkat == 'object' && tracking !== null && typeof tracking == 'object') {
            meerkat.messaging.publish(meerkat.modules.events.tracking.EXTERNAL, {
                method: 'trackQuoteTransfer',
                object: tracking
            }, true);
        }

        next();
    })
        .delay(delay)
        .queue(function (next) {
            var urlVars = getUrlVars();
            if (urlVars.hasOwnProperty('handoverType') && urlVars.handoverType == "post") {
                var $mainForm = $('#mainform');
                $mainForm.attr('method', 'POST').attr('action', loopedDecodeUriComponent(urlVars.handoverURL));

                var handoverVars = urlVars.handoverVar.split(',');
                var handoverDatas =loopedDecodeUriComponent(urlVars.handoverData).split(',');

                for (i = 0; i < handoverVars.length; i++) {
                    var textArea = $('<textarea>').attr('style', 'display:none').attr('name', handoverVars[i]).val(handoverDatas[i]);
                    $mainForm.append(textArea);
                }

                if(!redirectionDisabled) {
                	$mainForm.submit();
                }
            } else {
                try {
                    var quoteUrl = $('.quoteUrl').attr('quoteUrl');
                    if (quoteUrl !== '') {
                        if (quoteUrl == 'DUPLICATE') {
                            transferError("Duplicate productId " + productId + " encounted on " + vertical, data);
                        } else {
                            if (vertical == 'travel') {
                                quoteUrl = loopedDecodeUriComponent(quoteUrl);
                            }
                            if(!redirectionDisabled) {
                            	window.location.replace(quoteUrl);
                            }
                        }
                    } else {
                        transferError("No quoteURL was found for the transfer handover for " + vertical, data);
                    }
                } catch (e) {
                    transferError("Something went wrong during the redirect of the trasferring page for " + vertical, data);
                }

            }
            next();
        });
});