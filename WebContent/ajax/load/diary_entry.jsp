<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- TODO SESSION CHECK--%>
<session:get authenticated="true" />


<%--
	LOAD THE VARIABLES INTO DATA ARRAY
	<use a form tag to create the html>
	return the HTML for the document
--%>


<%--
TODO:
Place the abstracted endDate and startDate into parse functions and replace them into the data (maybe straight through to the variables used)
--%>


<sql:setDataSource dataSource="jdbc/ctm"/>

<go:log>
	ID = ${param.commsId}
	OWNER: ${authenticatedData.login.user.uid}
</go:log>

<%-- Call the Diary Entry (with a security check) --%>
<sql:query var="result">
	SELECT *
	FROM ctm.diary_entries
	WHERE `commsId` = ?
	AND `owner` = ?
	LIMIT 1
	<sql:param value="${param.commsId}" />
	<sql:param value="${authenticatedData.login.user.uid}" />
</sql:query>

<%-- SET: the temporary bean data --%>
<c:set var="tempXpath" value="diary/form${result.rows[0]['commsId']}" />

<go:log>COMMA: ${result.rows[0]['commsId']}</go:log>

<go:log>
	The GOTTEN ID: ${result.rows[0]['commsId']}
</go:log>

<go:log>
	<form${result.rows[0]['commsId']}>
		<commsId>${result.rows[0]['commsId']}</commsId>
		<status>${result.rows[0]['status']}</status>
		<title>${result.rows[0]['title']}</title>
		<author>${result.rows[0]['author']}</author>		
		<owner>${result.rows[0]['owner']}</owner>
		<message>${result.rows[0]['message']}</message>
		<allDay>${result.rows[0]['allDay']}</allDay>
		<url>${result.rows[0]['url']}</url>
		<dateStart>${result.rows[0]['dateStart']}</dateStart>
		<timeStart>${result.rows[0]['timeStart']}</timeStart>
		<dateEnd>${result.rows[0]['dateEnd']}</dateEnd>
		<timeEnd>${result.rows[0]['timeEnd']}</timeEnd>	
	</form${result.rows[0]['commsId']}>		
</go:log>

<go:log>Date format
<%--
DATE: <fmt:formatDate value="${param.startDate}" var="dateStart" pattern="yyyy-MM-dd" />
TIME: <fmt:formatDate value="${param.startDate}" var="timeStart" pattern="kk:mm" />
 --%>
 <%--
DATE: <fmt:parseDate value="${param.startDate}" var="dateStart" dateStyle="FULL" type="both" />
TIME: <fmt:parseDate value="${param.startDate}" var="timeStart" dateStyle="FULL" type="both" />
--%>
</go:log> 

<c:set var="tempXML">
	<form${result.rows[0]['commsId']}>
		<commsId>${result.rows[0]['commsId']}</commsId>
		<status>${result.rows[0]['status']}</status>
		<title>${result.rows[0]['title']}</title>
		<author>${result.rows[0]['author']}</author>		
		<owner>${result.rows[0]['owner']}</owner>
		<message>${result.rows[0]['message']}</message>
		<allDay>${result.rows[0]['allDay']}</allDay>
		<url>${result.rows[0]['url']}</url>
		<%-- Configure the times --%>
		<c:choose>
			<c:when test="${not empty param.startDate && empty result.rows[0]['dateStart']}">
				<dateStart>${result.rows[0]['dateStart']}</dateStart>
				<timeStart>${result.rows[0]['timeStart']}</timeStart>
			</c:when>
			<c:otherwise>
				<dateStart>${result.rows[0]['dateStart']}</dateStart>
				<timeStart>${result.rows[0]['timeStart']}</timeStart>
			</c:otherwise>
		</c:choose>
		<dateEnd>${result.rows[0]['dateEnd']}</dateEnd>
		<timeEnd>${result.rows[0]['timeEnd']}</timeEnd>	
	</form${result.rows[0]['commsId']}>
</c:set>

<c:set var="tempXpath" value="diary/form${result.rows[0]['commsId']}" />

<go:setData dataVar="data" xpath="${tempXpath}" value="*DELETE" />	
<go:setData dataVar="data" xpath="diary" xml="${tempXML}" />

<%-- THE FORM as HTML (use this as an ajax or in a looop to seed html pages) --%>
<simples:diary_form xpath="${tempXpath}" commsId="${result.rows[0]['commsId']}" title="${result.rows[0]['title']}" />