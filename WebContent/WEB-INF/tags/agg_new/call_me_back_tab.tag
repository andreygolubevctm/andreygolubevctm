<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Call Me Back Tab"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="Class name to assign to parent element" %>

<%-- HTML --%>
<c:if test="${empty callCentre}">
	<a id="callMeBackTabButton" href="javascript:;"></a>
	<div id="callMeBackModalContent" class="col-xs-12 displayNone">
		<agg_new:call_me_back_form id="callmeback-tab-form" />
	</div>
</c:if>