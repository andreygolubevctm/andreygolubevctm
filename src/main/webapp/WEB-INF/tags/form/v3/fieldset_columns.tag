<%@ tag description="Layout to have 2 columns in a fieldset"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rightColumn" 		required="true" 	fragment="true"%>
<%@ attribute name="sideHidden" 		required="false" 	rtexprvalue="false" 	description="Hide the side column when collapsing to XS" %>
<%@ attribute name="sideAbove" 			required="false" 	rtexprvalue="false" 	description="Enable to render the fieldset-column-side above the main area in XS instead of below by default, and use pull classes to make it look normal in all larger breakpoints" %>
<%@ attribute name="displayFullWidth" 	required="false"	rtexprvalue="true"	 	description="Determine's whether or not to have these columns display full width" %>

<div class="row">

<c:if test="${empty sideAbove}">
	<div <c:if test="${ empty displayFullWidth or displayFullWidth eq false}">class="col-sm-9"</c:if>>
		<jsp:doBody />
	</div>
</c:if>
<c:if test="${ empty displayFullWidth or displayFullWidth eq false}">
	<%--The below isnt formatted nicely for readability (on separate lines) because we want the --%>
	<%--fragment to be empty (no whitespace) if its actually empty so we can hide it--%>
	<div class="fieldset-column-side col-sm-3<c:if test="${not empty sideAbove}"> col-sm-push-9</c:if><c:if test="${not empty sideHidden}"> hidden-xs</c:if>"><jsp:invoke fragment="rightColumn" /><banners:banner-tile /></div>
</c:if>
<c:if test="${not empty sideAbove and empty displayFullWidth or displayFullWidth eq false}">
	<div class="col-sm-9 col-sm-pull-3">
		<jsp:doBody />
	</div>
</c:if>

</div>