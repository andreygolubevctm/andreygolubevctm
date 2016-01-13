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
/*
*
 if (typeof meerkat.site.PHGPostImpressionsEnabled !== 'undefined' && meerkat.site.PHGPostImpressionsEnabled === true && typeof meerkat.site.PHGHandoverIds.url !== 'undefined' && typeof meerkat.site.PHGHandoverIds !== 'undefined' && typeof meerkat.site.PHGHandoverIds.partnerValues !== 'undefined' && typeof meerkat.site.PHGHandoverIds.partnerValues.CLBS !== 'undefined') {
 url += "&handoverURL="+encodeURIComponent(meerkat.site.PHGHandoverIds.url+""+meerkat.site.PHGHandoverIds.partnerValues.CLBS+"pubref:/Adref:"+meerkat.modules.transactionId.get()+"/destination:"+product.handoverUrls);
 } else {
 url += "&handoverURL="+encodeURIComponent(product.handoverUrl);
 }
 alert(url);
* */
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
                $mainForm.attr('method', 'POST').attr('action', loopedDecodeUriComponent(urlVars.handoverURL));

                var textArea = $('<textarea>').attr('style', 'display:none').attr('name', loopedDecodeUriComponent(urlVars.handoverVar)).val(loopedDecodeUriComponent(urlVars.handoverData));
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
                                quoteUrl = loopedDecodeUriComponent(quoteUrl);
                            }

                            if (typeof meerkat.site.PHGPostImpressionsEnabled !== 'undefined' && meerkat.site.PHGPostImpressionsEnabled === true && typeof meerkat.site.PHGHandoverIds.url !== 'undefined' && typeof meerkat.site.PHGHandoverIds !== 'undefined' && typeof meerkat.site.PHGHandoverIds.partnerValues !== 'undefined' && typeof meerkat.site.PHGHandoverIds.partnerValues.CLBS !== 'undefined') {
                                quoteUrl = meerkat.site.PHGHandoverIds.url+""+meerkat.site.PHGHandoverIds.partnerValues.CLBS+"pubref:/Adref:"+meerkat.modules.transactionId.get()+"/destination:"+quoteUrl;
                            }
                            alert(quoteUrl);
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