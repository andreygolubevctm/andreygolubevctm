<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />
<session:get settings="true"/>
<security:populateDataFromParams rootPath="fuel" />
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.signup')}" />

${logger.info('data is {}', log:kv('data', data.fuel))}

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<c:set var="sessionid" value="${pageContext.session.id}" />
<c:set var="brand" value="CTM" />
<c:set var="vertical" value="FUEL" />
<c:set var="source" value="SIGNUP" />
<c:set var="firstName" value="" />
<c:set var="lastName" value="" />
<c:set var="emailAddress" value="${data['fuel/signup/email']}" />
<c:set var="marketing" value="Y" />
<c:set var="privacy" value="Y" />
<c:set var="errorPool" value="" />

<%--
Requires two calls, one to add to the email master and one to sign-up for the fuel alerts
--%>

<%-- Initial variable check --%>
<c:if test="${empty emailAddress or emailAddress =='' }">
	<c:set var="errorPool">${errorPool}
	<error type="init">Missing email address</error></c:set>
</c:if>

<c:if test="${empty errorPool}">

	<agg_v1:write_email
		items="marketing=${marketing},fuel=${marketing}"
		vertical="${vertical}"
		lastName="${lastName}"
		firstName="${firstName}"
		emailAddress="${emailAddress}"
		source="${source}"
		brand="${brand}" />

</c:if>
<c:choose>
	<c:when test="${empty errorPool}">
		{"success":true}
	</c:when>
	<c:otherwise>
		{"success":false, errors: ${go:XMLtoJSON(errorPool)}}
	</c:otherwise>
</c:choose>