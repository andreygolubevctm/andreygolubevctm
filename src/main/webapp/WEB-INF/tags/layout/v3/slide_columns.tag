<%@ tag description="Layout to have 2 columns in a slide"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rightColumn" fragment="true" required="true"%>
<%@ attribute name="sideHidden" 	required="false" rtexprvalue="false" description="Hide the side column when collapsing to XS" %>
<%@ attribute name="sideAbove" 	required="false" rtexprvalue="false" description="Enable to render the fieldset-column-side above the main area in XS instead "%>
<%@ attribute name="colSize" 	required="false" rtexprvalue="false" description="Override the column width"%>
<c:if test="${empty colSize}">
	<c:set var="colSize" value="9" />
</c:if>

<div class="row">

	<c:if test="${empty sideAbove}">
		<div class="col-sm-${colSize}">
			<jsp:doBody />
		</div>
	</c:if>

	<div class="fieldset-column-side col-sm-3<c:if test="${not empty sideAbove}"> col-sm-push-9</c:if><c:if test="${not empty sideHidden}"> hidden-xs</c:if>">
		<jsp:invoke fragment="rightColumn" />
	</div>
	
	<c:if test="${not empty sideAbove}">
		<div class="col-sm-9 col-sm-pull-3">
			<jsp:doBody />
		</div>
	</c:if>
</div>
