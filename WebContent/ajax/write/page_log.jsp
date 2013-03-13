<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- 
	page_log.jsp
	
	Used to write page log records on the iSeries 
 --%>
<go:log>Writing Page Log</go:log>

<go:setData dataVar="data" xpath="log" value="*DELETE" />
<go:setData dataVar="data" xpath="log/sessionId" value="${pageContext.session.id}" />
<go:setData dataVar="data" xpath="log" value="*PARAMS" />


<c:choose>
<c:when test="${data['settings/vertical']=='HEALTH' or data['settings/vertical']=='IP' or data['settings/vertical']=='LIFE'}">
<%-- Also store the log data in mysql --%>	
<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Get the next sequenceNo to be stored --%>
<c:set var="sequenceNo">
	<sql:query var="existing">
		SELECT sequenceNo + 1 AS sequenceNo FROM aggregator.transaction_page_log WHERE transactionId = ?;
		<sql:param value="${data.current.transactionId}" />
	</sql:query>
	<c:choose>
		<c:when test="${not empty existing and existing.rowCount > 0}">${existing.rows[0].sequenceNo}</c:when>
		<c:otherwise>${1}</c:otherwise>
	</c:choose>
</c:set>

<%-- Store the new log record --%>
<c:catch var="error">	
	<sql:update var="result">
		INSERT INTO aggregator.transaction_page_log (transactionId, sequenceNo, pageId, tranDate, tranTime, tranType, status)
		VALUES
		(?, ?, ?, Now(), Now(), null, null);
		<sql:param value="${data.current.transactionId}" />
		<sql:param value="${sequenceNo}" />
		<sql:param value="${data.log.pageId}" />
	</sql:update>
</c:catch>
</c:when>
<c:otherwise>
<go:log>${data.xml['log']}</go:log>
<go:call pageId="AGGPAG" transactionId="${data.text['current/transactionId']}" wait="FALSE" xmlVar="${data.xml['log']}"/>
</c:otherwise>
</c:choose>