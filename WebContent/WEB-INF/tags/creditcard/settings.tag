<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="productHandoverUrlWithParams"><c:out value="${productHandoverUrl}" escapeXml="false" /></c:set>
<c:set var="escapeCharacter" value="?" />
<c:if test="${fn:contains(productHandoverUrl, '?')}">
	<c:set var="escapeCharacter" value="&" />
</c:if>
<c:set var="vertical" value="${fn:toLowerCase(vertical)}" />
<c:set var="xpath" value="${vertical}/tracking/cid" />
<c:set var="productHandoverUrlWithParams" value="${productHandoverUrlWithParams}${escapeCharacter}brand=${productBrandCode}&productID=${productID}&campaignID=${data[xpath]}&transactionID=${data.current.transactionId}" />
{
	product: {
		code: '<c:out value="${productID}" />',
		shortDescription: '<c:out value="${productID}" escapeXml="false" />',
		handoverUrl: '<c:out value="${productHandoverUrlWithParams}" escapeXml="false" />',
		"provider": {
			"code": '<c:out value="${productBrandCode}" />',
			"name": '<c:out value="${productBrand}" />'
		}
	}
}