<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
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
