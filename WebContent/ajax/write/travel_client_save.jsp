<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="sessionid" value="${pageContext.session.id}" />
<c:set var="ipaddress" value="${pageContext.request.remoteAddr}" />
<c:set var="stylecode" value="CTM" />
<c:set var="status" value="" />
<c:set var="prodtyp" value="TRAVEL" />
 
<c:choose>
	<c:when test="${not empty param.email}">
		<c:set var="emailadr" value="${param.email}" />
	</c:when>
	<c:otherwise>
		<c:set var="emailadr" value="" />
	</c:otherwise>
</c:choose>

<sql:query var="results">
 	select max(TransactionId) as previd from aggregator.transaction_header
 	where sessionid = '${sessionid}'; 
</sql:query>

<c:choose>
	<c:when test="${results.rows[0].previd!=null}">
		<c:set var="previousid" value="${results.rows[0].previd}" />
	</c:when>
	<c:otherwise>
		<c:set var="previousid" value="0" />
	</c:otherwise>
</c:choose>

<sql:update>
 	insert into aggregator.transaction_header 
 	(PreviousId,ProductType,emailaddress,ipaddress,startdate,starttime,stylecode,advertKey,sessionid,status) 
 	values 
 	('${previousid}','${prodtyp}','${emailadr}','${ipaddress}',CURRENT_DATE,CURRENT_TIME,'${stylecode}',0,'${sessionid}','${status}'); 
 </sql:update>

<sql:query var="results">
 	select LAST_INSERT_ID() as tranid from aggregator.transaction_header; 
</sql:query>

<c:forEach var="item" items="${param}" varStatus="status">
	<sql:update>
 		insert into aggregator.transaction_details (transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
 		values 
 		('${results.rows[0].tranid}','${status.count}','${item.key}','${item.value}',default,default); 
	 </sql:update>
	
	<c:out value="${item.key}"/>=<c:out value="${item.value}"/>
</c:forEach>