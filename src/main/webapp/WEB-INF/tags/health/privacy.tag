<%@ tag description="This controls areas and makes them private (hides on and off). This can be grouped with other Ajax type functions, e.g. to Pause phone recording and hide/show area"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"						required="true"		rtexprvalue="true"	 description="The xpath to the content" %>
<%@ attribute name="make_private"				required="true"		rtexprvalue="true"	 description="Whether the area should be controlled, true for control, false for letting the content through." %>
<%@ attribute name="control_label_makeVisible"	required="false"	rtexprvalue="false"	 description="The button label for enabling/showing the private area, default: Pause Recording" %>
<%@ attribute name="control_label_makeHidden"	required="false"	rtexprvalue="false"	 description="The button label for disabling/hiding the private area, default: Resume Recording" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:choose>
	<%-- Pass through --%>
	<c:when test="${make_private != true or make_private != 'true'}">
		<jsp:doBody />
	</c:when>
	<c:otherwise>

		<%-- Labels --%>
		<c:if test="${empty control_label_makeVisible}">
			<c:set var="control_label_makeVisible" value="Pause Recording" />
		</c:if>
		<c:if test="${empty control_label_makeHidden}">
			<c:set var="control_label_makeHidden" value="Resume Recording" />
		</c:if>

		<div class="agg_privacy" id="${name}">
			<button class="agg_privacy_button btn btn-save"><span>${control_label_makeVisible}</span></button>

			<div class="agg_privacy_container invisible">
				<jsp:doBody />
			</div>

			<button class="agg_privacy_button btn btn-save"><span>${control_label_makeVisible}</span></button>
		</div>

	</c:otherwise>
</c:choose>