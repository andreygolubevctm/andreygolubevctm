<%--
	Health callback link
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Hide the link if it's disabled --%>
<c:if test="${pageSettings.getSetting('callbackPopupEnabled') eq 'Y'}" >
<a href="javascript:;" class="callback-link" data-toggle="dialog"
			data-content="#view_all_hours_cb"
			data-title="Request a Call" data-cache="true"><i class="icon-callback"></i>Request a Call</a>
</c:if>