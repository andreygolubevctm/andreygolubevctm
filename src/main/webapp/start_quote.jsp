<%--
	Retrieve Quotes Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Set authenticatedData to scope of request --%>
<session:new verticalCode="GENERIC" authenticated="${true}"/>

<%-- Block Save/Retrieve if it is not enabled for a brand --%>
<c:set var="saveQuoteEnabled" scope="request">${pageSettings.getSetting('saveQuote')}</c:set>
<c:if test="${saveQuoteEnabled == 'N'}">
    <%
        response.sendError(404);
        if (true) {
            return;
        }
    %>
</c:if>


<%-- HTML --%>
<c:set var="responseJson" scope="request" value="{}" />
<c:set var="isLoggedIn" value="false" scope="request" />

<layout:generic_page title="Start New Quote" outputTitle="${false}">

<jsp:attribute name="head">
   <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/components/retrievequotes.${pageSettings.getBrandCode()}.css?${revision}" media="all"/>
</jsp:attribute>

<jsp:attribute name="head_meta">
</jsp:attribute>

<jsp:attribute name="header">
</jsp:attribute>

<jsp:attribute name="form_bottom">
    <h2>Unfortunately for security reasons your link has expired, please start a new quote below.</h2>
    <br>
    <confirmation:other_products />
</jsp:attribute>

<jsp:attribute name="footer">
    <core:whitelabeled_footer />
</jsp:attribute>

<jsp:attribute name="vertical_settings">
    <retrievequotes:settings />
</jsp:attribute>
    <jsp:attribute name="body_end"></jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
        <%--<script src="${assetUrl}brand/${pageSettings.getBrandCode()}/js/components/retrievequotes.modules.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>--%>
    </jsp:attribute>
</layout:generic_page>