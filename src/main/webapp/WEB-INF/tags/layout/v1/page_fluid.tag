<%-- TODO: FIX URLS FOR ALL REFERENCES TO ${assetUrl} -- They currently use ../ for scripts. We need to move scripts to the asset folder! --%>
<%@ tag description="The Page - Full width" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request"/>
<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer"/>
<jsp:useBean id="newPage" class="com.ctm.web.core.web.NewPage"/>
${newPage.init(pageContext.request, pageSettings)}

<%@ attribute name="title" required="false" rtexprvalue="true" description="The title of the page" %>
<%@ attribute name="skipJSCSS" required="false" rtexprvalue="true" description="Provide if wanting to exclude loading normal js/css (except jquery)" %>
<%@ attribute required="false" name="body_class_name" description="Allow extra styles to be added to the rendered body tag" %>
<%@ attribute required="false" name="bundleFileName" description="Pass in alternate bundle file name" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="navbar_additional" %>
<%@ attribute fragment="true" required="false" name="progress_bar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>

<%@ attribute fragment="true" required="false" name="vertical_settings" %>
<%@ attribute fragment="true" required="false" name="before_close_body" %>

<core_v2:no_cache_header/>

<%-- Variables --%>
<c:set var="isDev" value="${environmentService.getEnvironmentAsString() eq 'localhost' || environmentService.getEnvironmentAsString() eq 'NXI'}"/>
<c:set var="superTagEnabled" value="${pageSettings.getSetting('superTagEnabled') eq 'Y'}"/>
<c:set var="DTMEnabled" value="${pageSettings.getSetting('DTMEnabled') eq 'Y'}"/>
<c:set var="GTMEnabled" value="${pageSettings.getSetting('GTMEnabled') eq 'Y'}"/>

<c:set var="separateJS" value="${param.separateJS eq 'true'}"/>

<%-- Whether we want to show logging or not (for use on Production) --%>
<c:set var="showLogging" value="${isDev or (not empty param.showLogging && param.showLogging == 'true')}"/>

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/"/>
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}"/>

<%-- for Health V2 A/B testing --%>
<c:set var="fileName" value="${pageSettings.getVerticalCode()}"/>
<c:if test="${not empty bundleFileName}"><c:set var="fileName" value="${bundleFileName}" /></c:if>

<%-- Capture brandCode provided in the URL --%>
<c:set var="urlStyleCodeId">
    <c:if test="${not empty param.brandCode and (fn:toLowerCase(param.brandCode) eq 'wfdd' or fn:toLowerCase(param.brandCode) eq 'bddd')}">${fn:toLowerCase(param.brandCode)}</c:if>
</c:set>

<!DOCTYPE html>
<go:html>
    <head>
            <%-- Google Optimise 360 --%>
        <c:if test="${empty callCentre or not callCentre}">
            <content:get key="googleOptimise360"/>
        </c:if>

        <title>${title} - ${pageSettings.getSetting('brandName')}</title>
        <meta charset='utf-8'>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
            <%-- 'maximum-scale' will disable zooming but also assists with iOS Viewport Scaling Bug on rotation --%><%-- user-scalable=no--%>
        <jsp:invoke fragment="head_meta"/>

        <link rel="shortcut icon" type="image/x-icon" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/favicon.ico?new">

        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">

        <meta name="ROBOTS" content="NOINDEX, NOFOLLOW">

        <c:if test="${pageSettings.getSetting('appleTouchIconsEnabled') eq 'Y'}">
            <link rel="apple-touch-icon" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/phone.png">
            <link rel="apple-touch-icon" sizes="76x76" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/tablet.png">
            <link rel="apple-touch-icon" sizes="120x120" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/phone@2x.png">
            <link rel="apple-touch-icon" sizes="152x152" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/tablet@2x.png">
            <link rel="apple-touch-icon" sizes="180x180" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/phone@3x.png">
        </c:if>

        <c:if test="${empty skipJSCSS}">
            <c:set var="browserName" value="${userAgentSniffer.getBrowserName(pageContext.getRequest().getHeader('user-agent'))}"/>
            <c:set var="browserVersion" value="${userAgentSniffer.getBrowserVersion(pageContext.getRequest().getHeader('user-agent'))}"/>

            <c:if test="${pageSettings.getVerticalCode() ne 'generic'}">
                <c:choose>
                    <%-- We don't include the separate inc files for Simples in IE because its path structure causes failures due to relative path issues --%>
                    <c:when test="${browserName eq 'IE' and browserVersion le 9}">
                        <c:import url="/assets/includes/styles/${pageSettings.getBrandCode()}/${fileName}.html"/>
                    </c:when>
                    <c:otherwise>
                        <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/${fileName}${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
                    </c:otherwise>
                </c:choose>
            </c:if>

            <%--  Modernizr --%>
            <script src='${assetUrl}js/bundles/plugins/modernizr${pageSettings.getSetting('minifiedFileString')}.js'></script>
        </c:if>

        <jsp:invoke fragment="head"/>

        <c:if test="${DTMEnabled eq true and not empty pageSettings and pageSettings.hasSetting('DTMSourceUrl')}">
            <c:if test="${fn:length(pageSettings.getSetting('DTMSourceUrl')) > 0}">
                <script src="${pageSettings.getSetting('DTMSourceUrl')}"></script>
            </c:if>
        </c:if>

            <%-- There's a bug in the JSTL parser which eats up the spaces between dynamic classes like this so using c:out sorts it out --%>
        <c:set var="bodyClass">
            <c:out value="${pageSettings.getVerticalCode()} ${callCentre ? ' callCentre simples' : ''} ${body_class_name}"/>
        </c:set>
    </head>

    <body class="jeinit  ${bodyClass}">

    <c:if test="${GTMEnabled eq true and not empty pageSettings and pageSettings.hasSetting('GTMPropertyId')}">
        <c:if test="${not empty pageSettings.getSetting('GTMPropertyId')}">
            <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
                    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
                    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
                    '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
            })(window,document,'script','CtMDataLayer','${pageSettings.getSetting('GTMPropertyId')}');</script>
        </c:if>
    </c:if>

    <div class="navMenu-row">

        <!-- body content -->
        <header class="header-wrap">

            <div class="header-top dropdown-interactive-base navMenu-row-fixed">

                <div class="dynamicTopHeaderContent">
                    <content:get key="topHeaderContent"/>
                    <c:set var="competitionApplicationEnabledSetting"><content:get key="competitionApplicationEnabled"/></c:set>
                    <c:if test="${competitionApplicationEnabledSetting eq 'Y' and not callCentre}">
                        <content:get key="competitionApplicationTopHeaderContent"/>
                    </c:if>

                    <c:set var="premiumIncreaseEnabledSetting"><content:get key="premiumIncreaseEnabled"/></c:set>
                    <c:if test="${premiumIncreaseEnabledSetting eq 'Y' and not callCentre}">
                        <content:get key="premiumIncreaseContent"/>
                    </c:if>

                    <coupon:banner/>
                </div>

                <div class="container-fluid">

                    <div class="col-sm-12">
                            <%-- Brand and toggle get grouped for better mobile display --%>
                        <jsp:invoke var="header_button_left_class" fragment="header_button_left"/>
                        <nav class="navbar-header header-buttons-logos<c:if test='${not empty header_button_left_class}'> header_button_left</c:if>" role="navigation">

                            <jsp:invoke fragment="header_button_left"/>

                            <button type="button" class="navbar-toggle hamburger collapsed disabled" data-toggle="navMenuOpen" data-target=".navbar-collapse-menu">
                                <span class="sr-only">Toggle Navigation</span>
                                <span class="icon icon-reorder"></span>
                            </button>

                            <c:set var="exitUrl" value=""/>
                            <c:if test="${pageSettings.hasSetting('exitUrl')}">
                                <c:set var="exitUrl" value="${fn:toLowerCase(pageSettings.getSetting('exitUrl'))}"/>
                            </c:if>

                            <c:if test="${not empty exitUrl}"><a id="js-logo-link" href="https://www.comparethemarket.com.au" title="Compare The Market Australia"></c:if>
                            <span id="logo" class="navbar-brand text-hide">${pageSettings.getSetting('windowTitle')}</span>
                            <c:if test="${not empty exitUrl}"></a></c:if>
                        </nav>

                        <jsp:invoke fragment="header"/>

                    </div>

                </div>
                <jsp:invoke fragment="progress_bar"/>
                <nav id="navbar-main" class="navbar navbar-affix navbar-default navbar-collapse navbar-collapse-menu collapse navMenu-contents" role="navigation">

                    <div class="row">
                        <div class="container">
                            <jsp:invoke fragment="navbar"/>
                        </div>
                    </div>
                    <jsp:invoke fragment="navbar_outer"/>
                </nav>

                <jsp:invoke fragment="navbar_additional"/>

            </div>

            <%-- XS Results Pagination --%>
            <jsp:invoke fragment="xs_results_pagination"/>
            </div>

        </header>
            <%--  Supertag --%>
        <c:if test="${superTagEnabled eq true and not empty pageSettings and pageSettings.hasSetting('supertagInitialPageName')}">
            <agg_v2:supertag/>
        </c:if>

        <%--  content --%>
        <jsp:doBody/>
        <c:choose>
            <c:when test="${empty skipJSCSS}">

                <%-- User Tracking --%>
                <c:set var="isUserTrackingEnabled"><core_v2:userTrackingEnabled/></c:set>
                <c:if test="${empty isUserTrackingEnabled}">
                    <c:set var="isUserTrackingEnabled" value="${false}"/>
                </c:if>
                <c:if test="${isUserTrackingEnabled eq true}">
                    <core_v2:sessioncam/>
                </c:if>

                <%-- JS Libraries --%>
                <!--[if lt IE 9]>
                <script src="${assetUrl}js/bundles/plugins/respond${pageSettings.getSetting('minifiedFileString')}.js"></script>
                <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
                <script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-1.11.3${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
                <![endif]-->
                <!--[if gte IE 9]><!-->
                <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
                <script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-2.1.4${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
                <!--<![endif]-->

                <script src="${assetUrl}js/libraries/bootstrap${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>

                <go:insertmarker format="HTML" name="js-href"/>
                <go:script>
                    <go:insertmarker format="SCRIPT" name="js-head"/>
                </go:script>
                <%--  Underscore --%>
                <c:if test="${isDev eq false}">
                    <script src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
                </c:if>
                <script>window._ || document.write('<script src="${assetUrl}libraries/underscore-1.8.3.min.js">\x3C/script>')</script>

                <!-- Meerkat -->
                <c:if test="${pageSettings.getVerticalCode() ne 'generic'}">
                    <c:choose>
                        <%-- Load separateJS files, but don't include separateJS if Simples --%>
                        <c:when test="${separateJS}">
                            <c:import url="/assets/includes/js/${fileName}.html"/>
                        </c:when>
                        <c:otherwise>
                            <script src="${assetUrl}js/bundles/${fileName}${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <%-- Additional Meerkat Scripts --%>
                <jsp:invoke fragment="additional_meerkat_scripts"/>
                <%-- CouponId from either brochure site cookies or direct query string --%>
                <c:choose>
                    <c:when test="${not empty param.couponid}">
                        <c:set var="couponId"><c:out value="${go:decodeUrl(param.couponid)}" escapeXml="true"/></c:set>
                    </c:when>
                    <c:when test="${not empty cookie.CouponID and not empty cookie.CouponID.value}">
                        <c:set var="couponId">
                            <c:out value="${go:decodeUrl(cookie.CouponID.value)}" escapeXml="true"/>
                        </c:set>
                    </c:when>
                </c:choose>

                <%-- Server date for JS to access --%>
                <jsp:useBean id="now" class="java.util.Date"/>
                <c:set var="serverMonth"><fmt:formatDate value="${now}" type="DATE" pattern="M"/></c:set>
                <c:set var="serverMonth" value="${serverMonth-1}"/>

                <script>
                    (function (meerkat) {
                        var siteConfig = {
                            title: '${title} - ${pageSettings.getSetting("windowTitle")}',
                            name: '${pageSettings.getSetting("brandName")}',
                            vertical: '${pageSettings.getVerticalCode()}',
	                        urlStyleCodeId: "${urlStyleCodeId}",
                            isDev: ${isDev}, <%-- boolean determined from conditions above in this tag --%>
                            minifiedFileString: '${pageSettings.getSetting('minifiedFileString')}',
                            isCallCentreUser: <c:out value="${not empty callCentre}"/>,
                            <c:if test="${pageSettings.hasSetting('inInEnabled')}">
                            inInEnabled: ${pageSettings.getSetting('inInEnabled')},
                            </c:if>
                            showLogging: <c:out value="${showLogging}" />,
                            environment: '${fn:toLowerCase(environmentService.getEnvironmentAsString())}',
                            serverDate: new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>, <c:out value="${serverMonth}" />, <fmt:formatDate value="${now}" type="DATE" pattern="d"/>),
                            revision: '<core_v1:buildIdentifier />',
                            tokenEnabled: '${newPage.tokenEnabled}',
                            <c:if test="${param.callStack eq 'true'}">callStack: true, </c:if>
                            verificationToken: '${newPage.createTokenForNewPage(pageContext.request , data.current.transactionId ,pageSettings)}',
                            <c:if test="${not empty data.current.transactionId}">initialTransactionId: ${data.current.transactionId}, </c:if><%-- DO NOT rely on this variable to get the transaction ID, it gets wiped by the transactionId module. Use transactionId.get() instead --%>
                            urls: {
                                base: '${pageSettings.getBaseUrl()}',
                                exit: '${exitUrl}',
                                context: '${pageSettings.getContextFolder()}'
                            },
                            isTaxTime: '<content:get key="taxTime"/>',
                            watchedFields: '<content:get key="watchedFields"/>',
                            content: {
                                brandDisplayName: '<content:get key="brandDisplayName"/>'
                            },
                            tracking: {
                                brandCode: '${pageSettings.getBrandCode()}',
                                superTagEnabled: ${superTagEnabled},
                                DTMEnabled: ${DTMEnabled},
                                GTMEnabled: ${GTMEnabled},
                                userTrackingEnabled: ${isUserTrackingEnabled}
                            },
                            leavePageWarning: {
                                enabled: ${pageSettings.getSetting("leavePageWarningEnabled")}, <c:if test="${pageSettings.hasSetting('leavePageWarningDefaultMessage')}">
                                defaultMessage: "${go:jsEscape(pageSettings.getSetting('leavePageWarningDefaultMessage'))}", </c:if>
                                message: "${go:jsEscape(pageSettings.getSetting('leavePageWarningMessage'))}"

                            },
                            liveChat: {
                                config: {},
                                instance: {},
                                enabled: false
                            },
                            session: {
                                windowTimeout: ${sessionDataService.getClientDefaultExpiryTimeout(pageContext.request)},
                                deferredPokeDuration: 300000,
                                firstPokeEnabled: true,
                                bigIP: "${sessionDataService.getCookieByName(pageContext.request, environmentService.getBIGIPCookieId())}"
                            },
                            navMenu: {
                                type: 'default',
                                direction: 'right'
                            },
                            useNewLogging: ${pageSettings.getSetting("useNewLogging") and not param['automated-test']},
                            couponId: '<c:out value="${couponId}"/>',
                            vdn: '<c:out value="${go:decodeUrl(param.vdn)}" escapeXml="true" />'<c:if test="${pageSettings.getSetting('kampyleFeedback') eq 'Y'}">,
                            kampyleId: 112902
                            </c:if>
                            <core_v1:settings />
                        };

                        <%-- Vertical settings should be passed in as a JSP fragment --%>
                        <c:if test="${not empty vertical_settings}">
                        <c:set var="verticalSettingsJSTemp"><jsp:invoke fragment="vertical_settings" /></c:set>
                        <c:set var="verticalSettingsJSObj">
                        <c:choose>
                        <c:when test="${not empty verticalSettingsJSTemp}"><c:out value="${verticalSettingsJSTemp}" escapeXml="false" /></c:when>
                        <c:otherwise><c:out value="{}" escapeXml="false" /></c:otherwise>
                        </c:choose>
                        </c:set>
                        $.extend(true, siteConfig, ${verticalSettingsJSObj});
                        </c:if>

                        var options = {};
                        meerkat != null && meerkat.init(siteConfig, options);

                    })(window.meerkat);
                </script>

            </c:when>
            <c:otherwise>
                <!--[if lt IE 9]>
                <script src="${assetUrl}js/bundles/plugins/respond${pageSettings.getSetting('minifiedFileString')}.js"></script>
                <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
                <script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-1.11.3${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
                <![endif]-->
                <!--[if gte IE 9]><!-->
                <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
                <script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-2.1.4${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
                <!--<![endif]-->
            </c:otherwise>
        </c:choose>
            <%-- Body End Fragment --%>
        <jsp:invoke fragment="body_end"/>
            <%-- Generally vertical specific settings should be declared in a <vertical>/settings.tag file placed in the body_end fragment space. --%>

        <div id="dynamic_dom"></div>
    </div>

    <jsp:invoke fragment="before_close_body"/>

    <c:if test="${DTMEnabled eq true and not empty pageSettings and pageSettings.hasSetting('DTMSourceUrl')}">
        <c:if test="${fn:length(pageSettings.getSetting('DTMSourceUrl')) > 0}">
            <script type="text/javascript">if (typeof _satellite !== 'undefined') {
                _satellite.pageBottom();
            }</script>
        </c:if>
    </c:if>

    <go:script>
        $(document).ready(function() {
        <go:insertmarker format="SCRIPT" name="onready"/>

        <c:if test="${pageSettings.getVerticalCode() ne 'generic'}">
            yepnope.injectJs({
            src: '${assetUrl}js/bundles/${fileName}.deferred${pageSettings.getSetting('minifiedFileString')}.js?${revision}',
            attrs: {
            async: true
            } <%-- We need to now initialise the deferred modules --%>
            }, function initDeferredModules() {
            meerkat.modules.init();
            });
        </c:if>});
    </go:script>
    </body>
</go:html>
