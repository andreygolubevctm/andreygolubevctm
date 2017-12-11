<%--
	Retrieve Quotes Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Set authenticatedData to scope of request --%>
<session:new verticalCode="GENERIC" authenticated="${true}"/>

<c:set var="logger" value="${log:getLogger('jsp.call_me_back')}" />
<layout_v1:journey_engine_page title="Call Me Back">

    <jsp:attribute name="head">
        <link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/call_me_back${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
    </jsp:attribute>

    <jsp:attribute name="head_meta">
    </jsp:attribute>

    <jsp:attribute name="header">
    </jsp:attribute>

    <jsp:attribute name="navbar">
    </jsp:attribute>


    <jsp:attribute name="form_bottom">
    </jsp:attribute>

    <jsp:attribute name="footer">
        <%-- I believe we still will want the footer for the terms links and McCafe protection --%>
        <core_v1:whitelabeled_footer />
    </jsp:attribute>

    <jsp:attribute name="vertical_settings">
        <retrievequotes:settings />
    </jsp:attribute>

    <jsp:attribute name="body_end"></jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
        <script src="${assetUrl}assets/js/bundles/call_me_back${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
    </jsp:attribute>

    <jsp:body>

        <%-- Fill body with callMeBack goodness --%>

    </jsp:body>

</layout_v1:journey_engine_page>