<%--
Redemption Page for Toy Promo 2018
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.unsubscribe')}"/>

<session:new verticalCode="GENERIC"/>

<session:getAuthenticated />

<%-- VARS --%>
<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}"/>
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}"/>

<%-- HTML --%>
<layout_v1:generic_page title="Toy Redemption">

    <jsp:attribute name="head">
        <link rel="stylesheet"
              href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/redemption${pageSettings.getSetting('minifiedFileString')}.css?${revision}"
              media="all">
    </jsp:attribute>

    <jsp:attribute name="head_meta" />

    <jsp:attribute name="header"></jsp:attribute>

    <jsp:attribute name="navbar"></jsp:attribute>

    <jsp:attribute name="form_bottom"></jsp:attribute>

    <jsp:attribute name="footer"><core_v1:generic_footer/></jsp:attribute>

    <jsp:attribute name="vertical_settings"></jsp:attribute>

    <jsp:attribute name="body_end"></jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
		<script src="${assetUrl}assets/js/bundles/redemption${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
	</jsp:attribute>

    <jsp:body>
        <redemption:redemption_setup/>

        <script class="crud-modal-template" type="text/html">
            <redemption:redemption_form />
        </script>
    </jsp:body>

</layout_v1:generic_page>
