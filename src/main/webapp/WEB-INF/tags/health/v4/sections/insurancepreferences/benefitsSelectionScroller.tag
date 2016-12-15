<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Scrolls the user down to the benefits selection section"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="isSidebar" 		required="false"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="benefitsContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "healthbenefits_v4")}' />

<c:set var="dbKey">benefitsScroller</c:set>

<c:if test="${isSidebar eq true}">
	<c:set var="sideBarClass">sidebar</c:set>
	<c:set var="dbKey">benefitsScrollerSidebar</c:set>
</c:if>


<div class="benefitsScroller ${sideBarClass}">
	<a href="javascript:;">${benefitsContent.getSupplementaryValueByKey(dbKey)}</a>
</div>