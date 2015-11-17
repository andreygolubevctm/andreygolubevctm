<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<settings:setVertical verticalCode="HEALTH" />

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />
<c:set var="provider">
    <c:out value="${param.provider}" escapeXml="true" />
</c:set>

<html>
<head>
    <title>Salesforce Health Payment Gateway</title>

    <link rel="shortcut icon" type="image/x-icon" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/favicon.ico">

    <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/salesforce_health${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">

    <!--[if lt IE 9]>
    <script src="${assetUrl}js/bundles/plugins/respond.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-1.11.3${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
    <![endif]-->
    <!--[if gte IE 9]><!-->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-2.1.4${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
    <!--<![endif]-->
    <script>window._ || document.write('<script src="${assetUrl}/libraries/underscore-1.8.3.min.js">\x3C/script>')</script>
    <script src='${assetUrl}js/bundles/plugins/modernizr.min.js'></script>
    <script src="${assetUrl}js/libraries/bootstrap${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
</head>
<body>
    <div id="dynamic_dom"></div>

    <c:set var="gatewayXPath" value="health/payment/gateway" />

    <form id="mainForm" action="#">
        <div class="provider-${provider}">
            <health:credit_card_details xpath="health/payment" />
        </div>
        <%--<health:bank_details xpath="health/payment/bank" />--%>
        <health:gateway_westpac xpath="${gatewayXPath}" />
        <health:gateway_nab xpath="${gatewayXPath}" />
    </form>
    
    <script src="${assetUrl}js/bundles/salesforce_health${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
    
    <script>
        dob_health_application_primary_dob = {};
        dob_health_application_partner_dob = {};
    
        (function (meerkat) {
            meerkat != null && meerkat.init({
                name: '${pageSettings.getSetting("brandName")}',
                vertical: '${pageSettings.getVerticalCode()}',
                urls:{
                    base: '${pageSettings.getBaseUrl()}',
                    exit: '${exitUrl}',
                    context: '${pageSettings.getContextFolder()}'
                },
                session: {
                    firstPokeEnabled: false
                },
                navMenu: {
                    type: "offcanvas"
                },
                content:{
                    callCentreNumber: "<content:get key="callCentreNumber"/>"
                },
                liveChat: {
                    config: {},
                    instance: {},
                    enabled: false
                },
                leavePageWarning: {
                    enabled: false
                },
                journeyStage: [],
                skipResultsPopulation: true,
                loadSource: 'salesForce',
                initialTransactionId: <c:out value="${param.transactionId}" escapeXml="true" />,
                provider: '${provider}'
            }, {});
        })(window.meerkat);
    
        $(document).ready(function() {
            yepnope.injectJs({
                src: '${assetUrl}js/bundles/salesforce_health.deferred${pageSettings.getSetting('minifiedFileString')}.js?${revision}',
                attrs: {
                    async: true
                } <%-- We need to now initialise the deferred modules --%>
            }, function initDeferredModules() {
                meerkat.modules.init();
            });
        });
    </script>
</body>
</html>