<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
<session:get settings="true"/>
<security:populateDataFromParams rootPath="fuel" />

<sql:setDataSource dataSource="jdbc/aggregator"/>
<c:set var="sessionid" value="${pageContext.session.id}" />
<c:set var="brand" value="CTM" />
<c:set var="vertical" value="FUEL" />
<c:set var="source" value="SIGNUP" />
<c:set var="firstName" value="${data['fuel/signup/contact/first']}" />
<c:set var="lastName" value="${data['fuel/signup/contact/last']}" />
<c:set var="emailAddress" value="${data['fuel/signup/email']}" />
<c:set var="marketing" value="${data['fuel/signup/terms']}" />
<c:set var="errorPool" value="" /> 

<%--
Requires two calls, one to add to the email master and one to sign-up for the fuel alerts
--%>

<%-- Initial variable check --%>
<c:choose>
	<c:when test="${empty emailAddress or emailAddress =='' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Missing email address</error></c:set>
	</c:when>
	<c:when test="${empty firstName or firstName =='' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Missing first name</error></c:set>	
	</c:when>
	<c:when test="${empty lastName or lastName =='' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Missing last name</error></c:set>
	</c:when>	
	<c:when test="${empty marketing or marketing !='Y' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Acceptance of the terms is required</error></c:set>
	</c:when>		
</c:choose>

<c:if test="${empty errorPool}">
	
	<agg:write_email
		items="marketing=${marketing},fuel=${marketing}"
		vertical="${vertical}"
		lastName="${lastName}"
		firstName="${firstName}"
		emailAddress="${emailAddress}"
		source="${source}"
		brand="${brand}" />

</c:if>


<%-- XML REPONSE --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
<des>Fuel signup form</des>
<c:choose>
	<c:when test="${empty errorPool}">
		<resultcode>0</resultcode>
	</c:when>
	<c:otherwise>
		<resultcode>3</resultcode>
		<errors>${errorPool}</errors>
	</c:otherwise>
</c:choose>
</data>