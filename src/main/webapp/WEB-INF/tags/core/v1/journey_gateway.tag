<%@ tag description="Triggers a page redirection if split test is active and not already set" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="verticalLabel" required="true" rtexprvalue="false" description="The label used to identify the vertical settings eg HEALTH" %>
<%@ attribute name="splitTestLabel" required="true" rtexprvalue="true" description="The label used to define split test values in vertical configuration" %>

<%-- The vertical needs to be set so that it's value exists in the pageContext --%>
<settings:setVertical verticalCode="${verticalLabel}" />

<c:catch>
	<jsp:useBean id="journeyGatewayService" class="com.ctm.web.core.services.tracking.JourneyGateway" />
	<c:set var="journey" value="${journeyGatewayService.getJourney(pageContext.getRequest(), splitTestLabel, pageContext.getResponse())}" />
	<c:if test="${not empty journey}">
		<c:redirect url="${journey}" />
	</c:if>
</c:catch>