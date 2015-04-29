<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="coverType">
	<c:choose>
		<c:when test="${fn:contains(data.home.coverType, 'Home Cover')}">home</c:when>
		<c:when test="${fn:contains(data.home.coverType, 'Home & Contents')}">home &amp; contents</c:when>
		<c:otherwise>contents</c:otherwise>
	</c:choose>
</c:set>

<%-- Smaller Templates to reduce duplicate code --%>
<core:js_template id="expired-commencement-date-template">
	<h6>Please note:</h6>
	<div>
		The commencement date you entered for your ${coverType} insurance comparison has now expired. In order to receive quotes, we have automatically updated this commencement date to reflect today's date: <strong>{{= obj.updatedDate}}</strong> (AEST)
	</div>
</core:js_template>