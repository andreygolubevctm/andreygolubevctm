<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%@ attribute name="showReducedHoursMessage" 	required="false" rtexprvalue="true"	description="Whether show holiday message" %>

<%-- This file doesn't seem like it's used. Cool? --%>

<c:set var="vertical" value="health" />

<%-- <c:if test="${empty callCentre}">
	<core:live_chat />
</c:if> --%>

<%-- Save Quote Popup --%>
<quote:save_quote quoteType="${vertical}"
	mainJS="Health"
	includeCallMeback="true" />

<c:if test="${showReducedHoursMessage}">
<health:popup_holiday_open_hours />
</c:if>

<%--Dialog panel readmore content on the results page --%>
<div id="results-read-more">
	<div class="content"></div>
	<div class="dialog_footer"></div>
</div>

<%-- Dialog for when selected product not available --%>
<core:popup id="update-premium-error" title="Policy not available">
	<p>Unfortunately, no pricing is available for this fund.</p>
	<p>Click the button below to return to your application and try again or alternatively <i>save your quote</i> and call us on <b>1800 77 77 12</b>.</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<%-- ALT PREMIUM MORE-INFO POPUP --%>
<health:alt_premium_dialog />

<health:prices_have_changed_notification />

<health:popup_hintsdetail />
<health:hints />

<health:simples_test />