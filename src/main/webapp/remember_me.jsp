<%@ taglib prefix="logic" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="HEALTH" authenticated="true" />

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />
<agg_v1:remember_me_settings vertical="health" />

<%-- Call centre numbers --%>
<jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber" /></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber" /></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber" /></c:set>
<c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>

<layout_v1:journey_engine_page title="Remember Me" ignore_journey_tracking="${true}" bundleFileName="health_remember_me" displayNavigationBar="${false}" body_class_name="remember-me-page">

    <jsp:attribute name="head">
    </jsp:attribute>

    <jsp:attribute name="head_meta">
    </jsp:attribute>

    <jsp:attribute name="header">
        <c:if test="${not empty callCentreNumber}">
            <div class="navbar-collapse header-collapse-contact collapse">
                <ul class="nav navbar-nav navbar-right callCentreNumberSection">
                    <li class="navbar-text confused-text">Confused? Talk to our experts now.</li>
                    <li>
                        <div class="navbar-text hidden-xs" data-livechat="target">
                            <div class="callCentreNumber-container">
                                <span class="icon icon-phone"></span>
                                <a href="javascript:;" data-toggle="dialog"
                                    data-content="#view_all_hours"
                                    data-title="Call Centre Hours" data-cache="true">
                                    <span class="noWrap callCentreNumber">${callCentreNumber}</span>
                                    <span class="noWrap callCentreAppNumber">${callCentreAppNumber}</span>
                                </a>
                            </div>
                        </div>
                        <div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
                    </li>
                </ul>
            </div>
        </c:if>
    </jsp:attribute>

    <jsp:attribute name="progress_bar">
    </jsp:attribute>

    <jsp:attribute name="body_end">
    </jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
    </jsp:attribute>

    <jsp:attribute name="vertical_settings">
        <health_v4:settings />
    </jsp:attribute>

    <jsp:attribute name="footer">
        <health_v1:footer />
    </jsp:attribute>

    <jsp:attribute name="form_bottom">
    </jsp:attribute>

    <jsp:body>
        <c:choose>
            <c:when test="${isRememberMe}">
                <c:set var="firstname" value="${rememberMeService.getNameOfUser(pageContext.request, pageContext.response, 'health')}" />
                <div id="pageContent">
                    <article class="container">
                        <div class="remember-me text-center">
                            <h1>Hi ${firstname}, <a class="remember-me-remove" href="javascript:;"
                                                    data-track-action="token expired">  Not you? Start new quote</a></h1>
                            <h1> looks like you've compared health insurance with us before.</h1>
                            <h2>Enter your date of birth to review the products you found last time.</h2>

                            <form id="rememberMeForm" class="remember-me-form">

                                <c:set var="fieldXpath" value="rememberme/primary/dob" />
                                <div class="col-sm-offset-2">
                                    <form_v4:row label="Your Date of Birth" fieldXpath="${fieldXpath}" className="remember-me-dob-group">
                                        <field_v4:person_dob xpath="${fieldXpath}" title="your" required="true" ageMin="16" ageMax="120" />
                                    </form_v4:row>
                                </div>
	                            <c:set var="fieldXpath" value="rememberme/reviewedit" />
	                            <field_v1:hidden xpath="${fieldXpath}" defaultValue="N" />
                                <button type="submit" class="btn btn-lg btn-secondary hidden-xs rememberme-review-btn"
                                        name="reviewButton" value="Submit">Review my chosen benefits</button>
                                <button type="submit" class="btn btn-lg btn-cta rememberme-submit-btn"
                                        name="submitButton" value="Submit">View latest results <span
                                        class="icon icon-arrow-right"></span></button>
                                <button type="submit" class="btn btn-lg btn-secondary visible-xs rememberme-review-btn"
                                        name="reviewButton" value="Submit">Review my chosen benefits</button>
                            </form>
                        </div>
                    </article>
                </div>
            </c:when>
            <c:otherwise>
                <c:redirect url="${pageSettings.getBaseUrl()}health_quote_v4.jsp" />
            </c:otherwise>
        </c:choose>
    </jsp:body>
</layout_v1:journey_engine_page>