<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--
	reset_password.jsp
	
	Calls iSeries program NTAGGPCF with the reset_id code (that was previously created by NTAGGPRS)
	and a new password.
	NTAGGPCF will return either a confirmation of an error which is supplied back to the page in JSON

	@param reset_id	- The temporary reset_id sent to the client in an email 
	@param reset_password - The client's desired new password. 

--%>

<c:set var="myData" value="<data><emailId>${param.reset_id}</emailId><password>${param.reset_password}</password></data>" />
<go:call pageId="AGGPCF" wait="TRUE" xmlVar="${myData}" resultVar="myResult" mode="P" style="CTM"/>
<go:log source="reset_password_jsp" level="INFO" >myResult: ${myResult}</go:log>

<c:if test="${!fn:startsWith(myResult,'<error>')}">

	<x:parse var="res" xml="${myResult}" />
	<c:set var="emailAddress"><x:out select="$res//email" /></c:set> 
	
	<go:log source="reset_password_jsp" level="INFO" >${emailAddress}</go:log>

	<sql:setDataSource dataSource="jdbc/aggregator"/>
	<sql:update var="result">
		UPDATE aggregator.email_master 
		SET emailPword = ? 
		WHERE emailAddress = ?
		<sql:param value="${param.reset_password}" />
		<sql:param value="${emailAddress}" />
	</sql:update>	
</c:if>

<%-- Return the results as json --%>
${go:XMLtoJSON(myResult)}