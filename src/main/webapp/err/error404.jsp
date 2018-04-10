<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--IMPORTANT keep this catch as we don't want to disclose a stacktrace to the user --%>
<c:catch var="error">
    <c:set var="logger" value="${log:getLogger('jsp.err.error404')}" />
    <settings:setVertical verticalCode="GENERIC"/>
    <c:set var="brandCode" value="${applicationService.getBrandCodeFromRequest(pageContext.getRequest())}"/>
    <c:set var="pageTitle" value="404"/>
</c:catch>

<c:set var="referer"><%=request.getHeader("Referer")%></c:set>

<c:choose>
    <c:when test="${not empty error or empty brandCode}">
        <h1>Whoops, sorry... looks like you're looking for something that isn't there!</h1>

        <p>Sorry about that, but the page you're looking for can't be found. Either you've typed the web address incorrectly, or the page you were looking for has been moved or deleted.</p>

        <p>Try checking the URL you used for errors.</p>
    </c:when>
    <c:otherwise>
        <%--IMPORTANT keep this catch as we don't want to disclose a stacktrace to the user --%>
        <c:catch var="error">
            ${logger.info('Page not found. {},{}', log:kv('request_uri', requestScope["javax.servlet.forward.request_uri"]), log:kv('servletPath',pageContext.request.servletPath ))}

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

				<jsp:attribute name="vertical_settings">
		{session: {firstPokeEnabled: false}}
	</jsp:attribute>

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
                                    ${fn:replace(errorPageHTML,'[[error_code]]','404')}
                                </c:when>
                                <c:otherwise>
                                    <h1 class="error_title">Whoops, sorry... looks like you're looking for something that isn't there!!!</h1>

                                    <div class="error_message">

                                        <p>Sorry about that, but the page you're looking for can't be found. Either you've typed the web address incorrectly, or the page you were looking for has been moved or
                                            deleted.</p>
                                        <c:choose>
                                            <c:when test="${pageSettings.getBrandCode() != 'ctm'}">
                                                <p>Try checking the URL you used for errors, or continue browsing our comparison services below.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p>Try checking the URL you used for errors, or continue browsing our range of comparison services below.</p>
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