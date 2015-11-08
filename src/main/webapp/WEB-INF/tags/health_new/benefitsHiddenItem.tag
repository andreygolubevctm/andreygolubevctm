<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.model.results.ResultsTemplateItem" %>


<c:if test="${item.isShortlistable()}">
	<c:set var="xpath" value="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}"/>
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />
	<c:if test="${data[xpath] != '' && not empty data[xpath]}">
		<c:set var="fieldValue"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
	</c:if>
	<input type="hidden" name="${name}" class="benefit-item" data-skey="${item.getShortlistKey()}" data-shortlist-parent-key="" value="${fieldValue}" />
</c:if>