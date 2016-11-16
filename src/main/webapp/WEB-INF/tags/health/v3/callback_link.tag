<%--
	Health callback link
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Hide the link if it's disabled --%>
<c:if test="${pageSettings.getSetting('callbackPopupEnabled') eq 'Y'}" >
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
	<a href="javascript:;" class="callback-link" data-toggle="dialog"
			${analyticsAttr} data-content="#view_all_hours_cb"
			data-title="Request a Call" data-cache="true"><i class="icon-callback" ${analyticsAttr}></i>Request a Call</a>
</c:if>