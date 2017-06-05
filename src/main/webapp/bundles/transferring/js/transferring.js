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

$(window).load(function () {
    var urlVars = getUrlVars();

    var transactionId = loopedDecodeUriComponent(urlVars.transactionId);
    var productId = loopedDecodeUriComponent(urlVars.productId);
    var vertical = loopedDecodeUriComponent(urlVars.vertical);
    var msg = loopedDecodeUriComponent(urlVars.msg);
    var brand = loopedDecodeUriComponent(urlVars.brand);
    var tracking = null;

    var data = {
        transactionId: transactionId,
        productId: productId,
        vertical: vertical,
        msg: msg,
        brand: brand,
        tracking: tracking
    };

    var delay = 1000;

    if (urlVars.hasOwnProperty('tracking')) {
        try {
            var tmp = JSON.parse(loopedDecodeUriComponent(urlVars.tracking));
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

        if (typeof meerkat === 'object' && tracking !== null && typeof tracking === 'object') {
            meerkat.messaging.publish(meerkat.modules.events.tracking.EXTERNAL, {
                method: 'trackQuoteTransfer',
                object: tracking
            }, true);
        }

        // For Quotes from Email campaigns
        if ((vertical === 'car' || vertical === 'home') && urlVars.utm_medium === 'email') {

            if (transactionId !== undefined) {
                transactionId = $('.quoteUrl').attr('transactionId');
                data.transactionId = transactionId;
            }

            data.productId = window.returnedResult.productId;
            data.brand = window.returnedResult.brandCode;

            meerkat.messaging.publish(meerkat.modules.events.tracking.EXTERNAL, {
                method: 'trackQuoteHandoverClick',
                object: {
                    event: "trackQuoteHandoverClick",
                    actionStep: vertical + " transfer online",
                    brandCode: "ctm",
                    currentJourney: 1,
                    productBrandCode: window.returnedResult.brandCode,
                    productID: window.returnedResult.productId,
                    productName: window.returnedResult.productDes,
                    quoteReferenceNumber: transactionId,
                    rootID: transactionId,
                    trackingKey: "",
                    transactionID: transactionId,
                    type: "online",
                    vertical: vertical,
                    simplesUser: false
                }
            });

            delay = 2000;
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

                $mainForm.submit();
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