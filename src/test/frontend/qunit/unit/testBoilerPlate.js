window.jQuery
&& window.jQuery.each
|| document
    .write('<script src="../../../main/webapp/framework/jquery/lib/jquery-2.0.3.min.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/meerkat/meerkat.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/meerkat/meerkat.logging.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/meerkat/meerkat.modules.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/comms.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/numberUtils.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/utils.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/transactionId.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/tracking.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/deviceMediaState.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/dialogs.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/modules/js/core/loadingAnimation.js">\x3C/script>');
document.write('<script src="../../../main/webapp/framework/bootstrap/js/modal.js">\x3C/script>');
;
(function (meerkat) {

    var siteConfig = {
        title: 'Kitchen sink: Current &amp; new - Compare The Market',
        name: 'Compare The Market Australia',
        brand: 'ctm',
        vertical: 'default',
        isDev: true, //boolean determined from conditions above in this tag
        isCallCentreUser: false,
        environment: 'localhost',
        //could be: localhost, integration, qa, staging, prelive, prod
        logpath: '/ctm/ajax/write/register_fatal_error.jsp?uncache=',
        urls: {
            root: 'http://localhost:8080/',
            exit: 'http://int.comparethemarket.com.au/',
            quote: '',
            privacyPolicy: '/ctm/legal/privacy_policy.pdf',
            websiteTerms: '/ctm/legal/website_terms_of_use.pdf',
            fsg: ''
        },
        liveChat: {
            config: {
                lpServer: "server.lon.liveperson.net",
                lpTagSrv: "sr1.liveperson.net",
                lpNumber: "1563103",
                deploymentID: "1",
                pluginsConsoleDebug: false
            },
            instance: {
                brand: 'ctm',
                vertical: 'Health',
                unit: 'health-insurance-sales',
                button: 'chat-health-insurance-sales'
            }
        }
    };
    //pluginsConsoleDebug above will suppress debug console logs being output for our liveperson plugins.
    var options = {};
    meerkat != null && meerkat.init(siteConfig, options);

})(window.meerkat);

window._
|| document
    .write('<script src="../../../main/webapp/framework/lib/js/underscore-1.5.2.min.js">\x3C/script>')

$(document).ready(function () {
    var vertical = "health";
    var frequency = "Monthly";

    meerkat.site = {
        title: 'Health Quote - Compare The Market Australia',
        name: 'Compare the Market',
        vertical: vertical,
        quoteType: vertical,
        isDev: true, //boolean determined from conditions above in this tag
        isCallCentreUser: false,
        showLogging: true,
        environment: 'localhost',
        //could be: localhost, integration, qa, staging, prelive, prod
        initialTransactionId: 2204245,
        // DO NOT rely on this variable to get the transaction ID, it gets wiped by the transactionId module. Use transactionId.get() instead
        urls: {
            base: 'http://localhost:8080/ctm/',
            exit: 'http://int.comparethemarket.com.au/health-insurance/'
        },
        content: {
            brandDisplayName: 'comparethemarket.com.au'
        },
        //This is just for supertag tracking module, don't use it anywhere else
        tracking: {
            brandCode: 'ctm'
        },
        leavePageWarning: {
            enabled: true,
            message: "You're leaving?! Before you go, why don't you save your quote so you can easily review your health insurance options at a later date"
        },
        liveChat: {
            config: {},
            instance: {},
            enabled: false
        },
        navMenu: {
            type: 'default',
            direction: 'right'
        },
        useNewLogging: true
    };

    meerkat.modules.transactionId.set = function (transactionId) {

    };

    // mock out server call
    meerkat.modules.optIn = {
        fetch: function (settings) {
            var result = {
                optInMarketing: true
            };
            settings.onSuccess(result);
        }
    };

    Results = {
        settings: {
            frequency: frequency
        }
    };

});

function getProduct() {
    return {
        transactionId: 2204639,
        ambulance: {},
        promo: {},
        premium: {
            annually: {
                base: "$2,351.44",
                baseAndLHC: "$2,669.24",
                discounted: "N",
                hospitalValue: 2187.2,
                lhc: 317.8,
                lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
                lhcfreetext: "$2,351.44",
                lhcfreevalue: 2351.44,
                pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
                rebate: "",
                rebateValue: "$0.00",
                text: "$2,669.24",
                value: 2669.24
            },
            fortnightly: {
                base: "$2,351.44",
                baseAndLHC: "$2,669.24",
                discounted: "N",
                hospitalValue: 2187.2,
                lhc: 317.8,
                lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
                lhcfreetext: "$2,351.44",
                lhcfreevalue: 2351.44,
                pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
                rebate: "",
                rebateValue: "$0.00",
                text: "$2,669.24",
                value: 2669.24
            },
            halfyearly: {
                base: "$2,351.44",
                baseAndLHC: "$2,669.24",
                discounted: "N",
                hospitalValue: 2187.2,
                lhc: 317.8,
                lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
                lhcfreetext: "$2,351.44",
                lhcfreevalue: 2351.44,
                pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
                rebate: "",
                rebateValue: "$0.00",
                text: "$2,669.24",
                value: 2669.24
            },
            monthly: {
                base: "$2,351.44",
                baseAndLHC: "$2,669.24",
                discounted: "N",
                hospitalValue: 2187.2,
                lhc: 317.8,
                lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
                lhcfreetext: "$2,351.44",
                lhcfreevalue: 2351.44,
                pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
                rebate: "",
                rebateValue: "$0.00",
                text: "$2,669.24",
                value: 2669.24
            },
            quarterly: {
                base: "$2,351.44",
                baseAndLHC: "$2,669.24",
                discounted: "N",
                hospitalValue: 2187.2,
                lhc: 317.8,
                lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
                lhcfreetext: "$2,351.44",
                lhcfreevalue: 2351.44,
                pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
                rebate: "",
                rebateValue: "$0.00",
                text: "$2,669.24",
                value: 2669.24
            },
            weekly: {
                base: "$2,351.44",
                baseAndLHC: "$2,669.24",
                discounted: "N",
                hospitalValue: 2187.2,
                lhc: 317.8,
                lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
                lhcfreetext: "$2,351.44",
                lhcfreevalue: 2351.44,
                pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
                rebate: "",
                rebateValue: "$0.00",
                text: "$2,669.24",
                value: 2669.24
            }
        },
        service: "PHIO",
        showAltPremium: true,
        showApply: true,
        whatHappensNext: ""
    };
}
