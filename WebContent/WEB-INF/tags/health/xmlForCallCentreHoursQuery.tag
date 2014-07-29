<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- You should already have this bit --%>
<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Get the tranId from the query string params --%>
<c:set var="myTranId" value="${tranId}" />
<c:set var="mysqlSelect" value="${sqlSelect}" />

<%-- fetch the data --%>
<sql:query var="details">
	SELECT html FROM ctm.scrapes WHERE id = 135
</sql:query>

<%-- read the rows and add them to the data bucket --%>
<c:if test="${details.rowCount > 0}">
	<go:setData dataVar="data" xpath="tempSQL/results/callCentreHours" value="${details.rows[0].html}" />
</c:if>

<%-- output it to the page --%>
${go:getEscapedXml(data['tempSQL'])}