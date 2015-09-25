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

$(window).load(function () {
    var urlVars = getUrlVars();
    var transactionId = decodeURIComponent(urlVars.transactionId);
    var productId = decodeURIComponent(urlVars.productId);
    var vertical = decodeURIComponent(urlVars.vertical);
    var msg = decodeURIComponent(urlVars.msg);
    var brand = decodeURIComponent(urlVars.brand);
    var tracking = null;

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
            var tmp = JSON.parse(decodeURIComponent(urlVars.tracking));
            tracking = _.omit(tmp, 'brandXCode');
            tracking.brandCode = tmp.brandXCode;
        } catch (e) {/* IGNORE */
        }
    }

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
        .delay(1000)
        .queue(function (next) {
            var urlVars = getUrlVars();
            if (urlVars.hasOwnProperty('handoverType') && urlVars.handoverType == "post") {
                var $mainForm = $('#mainform');
                $mainForm.attr('method', 'POST').attr('action', decodeURIComponent(urlVars.handoverURL));

                var textArea = $('<textarea>').attr('style', 'display:none').attr('name', decodeURIComponent(urlVars.handoverVar)).val(decodeURIComponent(urlVars.handoverData));
                $mainForm.append(textArea);
                $mainForm.submit();
            } else {
                try {
                    var quoteUrl = $('.quoteUrl').attr('quoteUrl');
                    if (quoteUrl !== '') {
                        if (quoteUrl == 'DUPLICATE') {
                            transferError("Duplicate productId " + productId + " encounted on " + vertical, data);
                        } else {
                            if (vertical == 'travel') {
                                quoteUrl = decodeURIComponent(quoteUrl);
                            }
                            window.location.replace(quoteUrl);
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