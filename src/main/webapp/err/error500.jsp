<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--IMPORTANT keep this catch as we don't want to disclose a stacktrace to the user --%>
<c:catch var="error">
    <c:set var="requestUri" value="${requestScope['javax.servlet.forward.request_uri']}" />
    <settings:setVertical verticalCode="GENERIC"/>
    <c:set var="brandCode" value="${applicationService.getBrandCodeFromRequest(pageContext.getRequest())}"/>
    <c:set var="pageTitle" value="500"/>
</c:catch>
<c:catch var="error">
    ${logger.error('Error Page Hit. {},{}' ,  log:kv('requestUri', requestUri) , log:kv('brandCode',brandCode ), pageContext.exception)}
</c:catch>

<c:set var="referer"><%=request.getHeader("Referer")%></c:set>

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
            <layout_v1:generic_page title="${pageTitle} - Error Page" outputTitle="${false}">

                <jsp:attribute name="head">
                    <c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/"/>
                    <link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/error.css?${revision}" media="all">
                </jsp:attribute>

                <jsp:attribute name="head_meta"></jsp:attribute>


                <jsp:attribute name="header"></jsp:attribute>

                <jsp:attribute name="form_bottom"></jsp:attribute>

                <jsp:attribute name="footer">
                    <core_v1:whitelabeled_footer/>
                </jsp:attribute>

				<jsp:attribute name="vertical_settings">{session: {firstPokeEnabled: false}}</jsp:attribute>

                <jsp:attribute name="body_end">
                </jsp:attribute>

                <jsp:body>

                    <div role="form" class="journeyEngineSlide active unsubscribeForm">
                        <layout_v1:slide_center xsWidth="12" mdWidth="10">

                            <c:choose>
                                <c:when test="${fn:contains('health_quote', $referer)}">
                                    <c:set var="errorPageHTML">
                                        <content:get key="ErrorPageHTML" />
                                    </c:set>
                                    ${fn:replace(errorPageHTML,'[[error_code]]','500')}
                                </c:when>
                                <c:otherwise>
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
                                </c:otherwise>
                            </c:choose>

                        </layout_v1:slide_center>
                    </div>


                </jsp:body>

            </layout_v1:generic_page>
        </c:catch>
    </c:otherwise>
</c:choose>