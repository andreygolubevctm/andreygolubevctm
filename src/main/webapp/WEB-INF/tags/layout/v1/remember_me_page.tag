<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />
<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>
<%@ attribute required="false" name="body_class_name" description="Allow extra styles to be added to the rendered body tag" %>
<%@ attribute name="ignore_journey_tracking" required="false" rtexprvalue="true" description="Ignore Journey Tracking" %>
<%@ attribute name="bundleFileName" required="false" rtexprvalue="true" description="Pass in an alternate file name" %>
<%@ attribute name="displayNavigationBar" required="false" rtexprvalue="true" description="Pass false to remove the navigation bar" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_additional" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="progress_bar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>
<%@ attribute fragment="true" required="true" name="vertical_settings" %>

<%@ attribute fragment="true" required="false" name="results_loading_message" %>
<%@ attribute fragment="true" required="false" name="before_close_body" %>




</layout_v3:slide>



<%--<layout_v1:page title="${title}" body_class_name="${body_class_name}" bundleFileName="${bundleFileName}" displayNavigationBar="${displayNavigationBar}">--%>

	<%--<jsp:attribute name="head">--%>
		<%--<jsp:invoke fragment="head" />--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="head_meta">--%>
		<%--<jsp:invoke fragment="head_meta" />--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="header">--%>
		<%--<jsp:invoke fragment="header" />--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="header_button_left">--%>
        <%--<jsp:invoke fragment="header_button_left" />--%>
    <%--</jsp:attribute>--%>

    <%--<jsp:attribute name="navbar">--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="navbar_additional">--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="navbar_outer">--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="vertical_settings">--%>
		<%--<jsp:invoke fragment="vertical_settings" />--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:attribute name="body_end">--%>
		<%--<jsp:invoke fragment="body_end" />--%>
	<%--</jsp:attribute>--%>

    <%--<jsp:body>--%>
        <%--<c:choose>--%>
            <%--<c:when test="${pageSettings.getSetting('rememberMeEnabled') eq 'Y' and--%>
                    <%--rememberMeService.hasRememberMe(pageContext.request, 'health') and--%>
                    <%--(empty pageContext.request.queryString or fn:length(param.action) == 0) and--%>
                    <%--empty param.preload and--%>
                    <%--empty param.skipRemember and--%>
                    <%--pageSettings.getBrandCode() eq 'ctm' and--%>
                    <%--empty authenticatedData.login.user.uid and--%>
                    <%--rememberMeService.hasPersonalInfoAndLoadData(pageContext.request, pageContext.response, 'health')}">--%>
                <%--<div id="pageContent">--%>
                    <%--<article class="container">--%>
                        <%--<div class="remember-me text-center">--%>
                            <%--<h1>Hi looks like you've compared health insurance with us before.</h1>--%>
                            <%--<h2><a class="remember-me-remove" href="javascript:;">Not you?</a></h2>--%>
                            <%--<h2>Enter your date of birth to review the products you found last time.</h2>--%>

                            <%--<form id="rememberMeForm" class="remember-me-form">--%>

                                <%--<form_v4:row label="Date of Birth" className="row primary_dob col-sm-offset-2">--%>
                                    <%--<c:set var="fieldXpath" value="health/rememberme/dob" />--%>
                                    <%--<field_v4:person_dob xpath="${fieldXpath}" title="your" required="true" ageMin="16" ageMax="120" disableErrorContainer="${false}" />--%>
                                <%--</form_v4:row>--%>

                                <%--<button type="submit" class="btn btn-lg btn-cta" id="submitButton"  name="submitButton" value="Submit">View Products and Prices <span class="icon icon-arrow-right"></span></button>--%>
                            <%--</form>--%>
                            <%--<a class="remember-me-remove" href="javascript:;">< Start a new quote</a>--%>
                        <%--</div>--%>
                    <%--</article>--%>
                <%--</div>--%>
            <%--</c:when>--%>
            <%--<c:otherwise>--%>
                <%--<c:redirect url="${pageSettings.getBaseUrl()}health_quote_v4.jsp" />--%>
            <%--</c:otherwise>--%>
        <%--</c:choose>--%>

        <%--<agg_v1:footer_outer>--%>
            <%--<jsp:invoke fragment="footer" />--%>
        <%--</agg_v1:footer_outer>--%>

    <%--</jsp:body>--%>

<%--</layout_v1:page>--%>