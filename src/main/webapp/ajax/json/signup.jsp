<%@ page import="org.slf4j.LoggerFactory" %>
<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp:ajax.json.signup')}" />

<session:get />

	<security:populateDataFromParams rootPath="signup" />

	${logger.debug("Data populated from request params. {}", log:kv('data',data))}

	<c:set var="fuelSignup" value="${data['signup/fuel']}"/>
	<c:if test="${fuelSignup == 'Y'}">
		<c:set var="url">../write/fuel_signup.jsp?fuel_signup_name_first=${data['signup/firstname']}&fuel_signup_name_last=${data['signup/surname']}&fuel_signup_email=${data['signup/email']}&fuel_signup_terms=${data['signup/newsoffers']}</c:set>
		${logger.debug('calling signup url. {}', log:kv('url', url))}
		<c:import url="${url}" var="tmpVar"/>
		${logger.debug("Signup url called. {}", log:kv('outcome', tmpVar))}
	</c:if>


	<c:choose>
		<c:when test="${result=='true'}" >
			OK
		</c:when>
		<c:otherwise>
			sign up not successful
		</c:otherwise>
	</c:choose>

