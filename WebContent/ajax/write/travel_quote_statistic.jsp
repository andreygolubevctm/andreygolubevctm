<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="tranid" value="${param.id}" />
<c:set var="sequenceid" value="${param.seq}" />
<c:set var="srvid" value="${param.srvid}" />
<c:set var="prdid" value="${param.prodid}" />
<c:set var="resptime" value="${param.time}" />
<c:set var="respmsg" value="${param.msg}" />

<sql:update>
 	insert into aggregator.statistic_master (TransactionId,CalcSequence,TransactionDate,TransactionTime) 
 	values 
 	('${tranid}','${sequenceid}',CURRENT_DATE,CURRENT_TIME); 
 </sql:update>

 <sql:update>
 	insert into aggregator.statistic_details (TransactionId,CalcSequence,ServiceId,ProductId,ResponseTime,ResponseMessage) 
 	values 
 	('${tranid}','${sequenceid}','${srvid}','${prdid}','${resptime}','${respmsg}'); 
 </sql:update>
 