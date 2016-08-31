<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Render a data-analytics attribute string" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="analVal" 	required="true"	 rtexprvalue="true"	 description="Value to be passed to analytics attribute" %>
<%@ attribute name="quoteChar" 	required="false" rtexprvalue="true"	 description="Override the quote character to use when rendering" %>

<%-- Default quoting for data value is single quotes --%>
<c:if test="${empty quoteChar}">
	<c:set var="quoteChar" value="'" />
</c:if>

<%-- Output the attribute string --%>
<c:out escapeXml="false" value=" data-analytics=${quoteChar}${analVal}${quoteChar}" />