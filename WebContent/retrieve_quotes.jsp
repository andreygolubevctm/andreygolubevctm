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

<%-- VARS --%>
<c:set var="paramHashedEmail"><c:out value="${param.hashedEmail}" escapeXml="true"/></c:set>
<c:set var="paramEmail"><c:out value="${param.email}" escapeXml="true"/></c:set>

<%-- HTML --%>
<c:choose>
    <c:when test="${not empty paramHashedEmail}">
        <%-- Sets userData to session scope --%>
        <security:authentication
                emailAddress="${paramEmail}"
                password="${param.password}"
                hashedEmail="${paramHashedEmail}"/>
        <retrievequotes:redirect_with_details/>
    </c:when>
    <c:otherwise>

        <%-- Are we already logged in? --%>
        <c:set var="responseJson" scope="request" value="{}" />
        <c:set var="isLoggedIn" value="false" scope="request" />
        <c:if test="${not empty authenticatedData.userData && not empty authenticatedData.userData.authentication && authenticatedData.userData.authentication.validCredentials}">
            <c:import var="responseJson" url="ajax/json/retrieve_quotes.jsp" scope="request" />
            <c:set var="isLoggedIn" value="true" scope="request" />
        </c:if>

        <layout:journey_engine_page title="Retrieve Your Quotes">

        <jsp:attribute name="head">
            <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/components/retrievequotes.${pageSettings.getBrandCode()}.css?${revision}" media="all">
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
                <li class="slide-feature-my-quotes">
                    <a href="javascript:;" class="btn-email"><span>My Quotes</span></a>
                </li>
                <li class="slide-feature-start-new-quote">
                    <a href="javascript:;" class="btn-cta" id="new-quote"><span>Start a New Quote</span></a>
                </li>
            </ul>

            <ul class="nav navbar-nav navbar-right">
                <li class="slide-feature-logout ">
                    <a href="javascript:;" class="btn-cta" id="logout-user"><span>Logout</span></a>
                </li>
            </ul>

        </jsp:attribute>


        <jsp:attribute name="form_bottom">
        </jsp:attribute>

        <jsp:attribute name="footer">
            <core:whitelabeled_footer />
        </jsp:attribute>

        <jsp:attribute name="vertical_settings">
            <retrievequotes:settings />
        </jsp:attribute>

            <jsp:attribute name="body_end"></jsp:attribute>

            <jsp:attribute name="additional_meerkat_scripts">
                <script src="${assetUrl}brand/${pageSettings.getBrandCode()}/js/components/retrievequotes.modules.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
        </jsp:attribute>

            <jsp:body>

                <retrievequotes_layout:slide_login />
                <retrievequotes_layout:slide_quotes />

                <div class="hiddenFields">
                    <form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
                    <core:referral_tracking vertical="retrieve_quotes"/>
                </div>

                <input type="hidden" name="transcheck" id="transcheck" value="1"/>

            </jsp:body>

        </layout:journey_engine_page>

    </c:otherwise>
</c:choose>

<core:js_template id="new-quote-template">
    <h2>Start a New Quote</h2>
    <br>
    <confirmation:other_products />
</core:js_template>