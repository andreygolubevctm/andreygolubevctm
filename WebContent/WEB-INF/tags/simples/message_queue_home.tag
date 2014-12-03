<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Simples Message Details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<%-- Check settings for if the message queue feature is enabled --%>
<c:catch var="settingError">
	<c:set var="messageQueueEnabled" value="${pageSettings.getSetting('messageQueueEnabled')}" />
	<c:set var="messageQueueRole"    value="${pageSettings.getSetting('messageQueueRole')}" />
</c:catch>

<c:if test="${not empty settingError}"><go:log level="INFO" source="simples_message_queue_home">${settingError}</go:log></c:if>



<c:choose>
	<%-- Check if queue is restricted to certain active directory groups --%>
	<c:when test="${messageQueueEnabled == 'Y' and (empty messageQueueRole or (not empty messageQueueRole and pageContext.request.isUserInRole(messageQueueRole)))}">

<simples:template_comments />
<simples:template_messageaudit />
<simples:template_messagedetail />
<simples:template_touches />

<div class="simples-home-buttons hidden">
	<field:button xpath="loadquote" title="Get Next Message" className="btn btn-tertiary btn-lg message-getnext" />
	<a href="/${pageSettings.getContextFolder()}simples/startQuote.jsp" class="btn btn-form btn-lg message-inbound">Start New Quote <span class="icon icon-arrow-right"></span></a>
</div>

<div class="simples-message-details-container">
</div>

	</c:when>

	<%-- No access to queue --%>
	<c:otherwise>
	</c:otherwise>
</c:choose>
