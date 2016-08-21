<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Render a data-analytics attribute string" %>
<jsp:useBean id="now" class="java.util.Date"/>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="analVal" 		required="true"	 rtexprvalue="true"	 description="Value to be passed to analytics attribute" %>
<%@ attribute name="quoteChar" 	required="false" rtexprvalue="true"	 description="Override the quote character to use when rendering" %>

<c:if test="${empty quoteChar}">
	<c:set var="quoteChar" value="'" />
</c:if>

<c:out value=" data-analytics=${quoteChar}${analVal}${quoteChar} " />