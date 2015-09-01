<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('jsp:err.error500')}" />

<%--IMPORTANT keep this catch as we don't want to disclose a stacktrace to the user --%>
<c:catch var="error">
    <settings:setVertical verticalCode="GENERIC"/>
    <c:set var="brandCode" value="${applicationService.getBrandCodeFromRequest(pageContext.getRequest())}"/>
    <c:set var="pageTitle" value="500"/>
</c:catch>

<c:choose>
    <c:when test="${not empty error}">
        <h1>Whoops, sorry... 500 Internal server error. Looks like something went wrong.</h1>

        <p>You have experienced a technical error. We apologise.</p>

        <p>We are working to correct this issue. Please wait a few moments and try again.</p>
    </c:when>
    <c:when test="${empty brandCode}">
        <h2>500 Internal server error</h2>

        <p>Unable to find valid brand code.</p>
    </c:when>
    <c:otherwise>
        <%--IMPORTANT keep this catch as we don't want to disclose a stacktrace to the user --%>
        <c:catch var="error">
            ${logger.error('Request URI: {}, servletPath: {}', requestScope["javax.servlet.forward.request_uri"], pageContext.request.servletPath)}
            <layout:generic_page title="${pageTitle} - Error Page" outputTitle="${false}">

                <jsp:attribute name="head">
                    <c:set var="assetUrl" value="/${pageSettings.getContextFolder()}" />
                    <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/components/unsubscribe.${pageSettings.getBrandCode()}.css?${revision}" media="all">
                </jsp:attribute>

                <jsp:attribute name="head_meta"></jsp:attribute>


                <jsp:attribute name="header"></jsp:attribute>

                <jsp:attribute name="form_bottom"></jsp:attribute>

                <jsp:attribute name="footer">
                    <core:whitelabeled_footer/>
                </jsp:attribute>

				<jsp:attribute name="vertical_settings">{session: {firstPokeEnabled: false}}</jsp:attribute>

                <jsp:attribute name="body_end">
                </jsp:attribute>

                <jsp:body>

                    <div role="form" class="journeyEngineSlide active unsubscribeForm">
                        <layout:slide_center xsWidth="12" mdWidth="10">
                            <h1 class="error_title">Whoops, sorry... 500 Internal server error </h1>

                            <div class="error_message">
                                <h2>looks like something went wrong.</h2>

                                <p>You have experienced a technical error. We apologise. </p>

                                <c:choose>
                                    <c:when test="${pageSettings.getBrandCode() != 'ctm'}">
                                        <p>We are working to correct this issue. Please wait a few moments and try again, or continue browsing our comparison services below.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p>We are working to correct this issue. Please wait a few moments and try again, or continue browsing our range of comparison services below.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <confirmation:other_products/>
                        </layout:slide_center>
                    </div>


                </jsp:body>

            </layout:generic_page>
            ${logger.error("500 Error Hit" , error )}
        </c:catch>
    </c:otherwise>
</c:choose>