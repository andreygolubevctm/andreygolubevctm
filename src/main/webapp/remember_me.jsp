<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="HEALTH" authenticated="true" />

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />

<%-- Call centre numbers --%>
<jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber" /></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber" /></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber" /></c:set>

<c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>
<c:set var="callCentreCBModal" scope="request"><health_v4:callback_modal /></c:set>

<layout_v1:remember_me_page title="Remember Me" bundleFileName="health_v4" displayNavigationBar="${false}">

	<jsp:attribute name="head">
        <c:set var="isDev" value="${environmentService.getEnvironmentAsString() eq 'localhost' || environmentService.getEnvironmentAsString() eq 'NXI' || environmentService.getEnvironmentAsString() eq 'NXQ'}" />

        <c:if test="${isDev eq true && !param['automated-test']}">
            <script src="https://cdn.logrocket.com/LogRocket.min.js"></script>
            <script>window.LogRocket && window.LogRocket.init('compare-the-market/web-ctm');</script>
        </c:if>
	</jsp:attribute>

    <jsp:attribute name="head_meta">
	</jsp:attribute>

    <jsp:attribute name="header">
        <c:if test="${not empty callCentreNumber}">
             <div class="navbar-collapse header-collapse-contact collapse">
                 <ul class="nav navbar-nav navbar-right callCentreNumberSection">
                     <li class="navbar-text">Confused? Talk to our experts now.</li>
                     <li>
                         <div class="navbar-text hidden-xs" data-livechat="target">
                             Call <a href="javascript:;" data-toggle="dialog"
                                     data-content="#view_all_hours"
                                     data-dialog-hash-id="view_all_hours"
                                     data-title="Call Centre Hours" data-cache="true">
                             <span class="noWrap callCentreNumber">${callCentreNumber}</span>
                         </a> or <health_v4:callback_link /> ${callCentreCBModal}
                         </div>

                         <div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
                     </li>
                 </ul>
             </div>
        </c:if>
	</jsp:attribute>

    <jsp:attribute name="form_bottom">
	</jsp:attribute>

    <jsp:attribute name="footer">
		<core_v1:whitelabeled_footer />
	</jsp:attribute>

    <jsp:attribute name="vertical_settings">
	</jsp:attribute>

    <jsp:attribute name="body_end" />

</layout_v1:remember_me_page>