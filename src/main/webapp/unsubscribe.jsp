<%@ page import="org.slf4j.LoggerFactory" %>
<%--
	Unsubscribe Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('jsp:unsubscribe')}" />

<session:new verticalCode="GENERIC"/>
<%-- VARS --%>
<c:set var="hasAlreadyLoaded" value="${not empty unsubscribe && empty param.unsubscribe_email and not empty unsubscribe.getEmailDetails()}"/>
<c:set var="getAuthenticatedUnsubscribeDetails" value="${not empty param.unsubscribe_email || not empty param.email}"/>
<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}"/>
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}"/>

<%-- HTML --%>
<c:choose>
    <c:when test="${hasAlreadyLoaded eq true}">

        <layout:generic_page title="Unsubscribe" outputTitle="${false}">

        <jsp:attribute name="head">
            <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/components/unsubscribe.${pageSettings.getBrandCode()}.css?${revision}" media="all">
        </jsp:attribute>

        <jsp:attribute name="head_meta">
        </jsp:attribute>

        <jsp:attribute name="header">
            <div class="navbar-collapse header-collapse-contact collapse">
                <ul class="nav navbar-nav navbar-right">
                </ul>
            </div>
        </jsp:attribute>

        <jsp:attribute name="navbar">

            <ul class="nav navbar-nav" role="menu">
                <li class="visible-xs">
                    <span class="navbar-text-block navMenu-header">Menu</span>
                </li>
            </ul>

        </jsp:attribute>


        <jsp:attribute name="form_bottom">
        </jsp:attribute>

        <jsp:attribute name="footer">
            <core:whitelabeled_footer />
        </jsp:attribute>

        <jsp:attribute name="vertical_settings">
        </jsp:attribute>

            <jsp:attribute name="body_end"></jsp:attribute>

            <jsp:attribute name="additional_meerkat_scripts">
                <script src="${assetUrl}brand/${pageSettings.getBrandCode()}/js/components/unsubscribe.modules.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
        </jsp:attribute>

            <jsp:body>

                <unsubscribe_layout:slide_unsubscribe/>

                <div class="hiddenFields">
                    <form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
                    <core:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
                </div>

                <input type="hidden" name="transcheck" id="transcheck" value="1"/>

            </jsp:body>

        </layout:generic_page>

    </c:when>
    <c:when test="${getAuthenticatedUnsubscribeDetails eq true}">
        <unsubscribe:redirect_with_details/>
    </c:when>
    <c:otherwise>
        ${logger.warn('Invalid Unsubscribe Parameter unsubscribe_email={} param.email={}',param.unsubscribe_email , param.email)}
    </c:otherwise>
</c:choose>
