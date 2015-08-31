<%@ page import="org.slf4j.LoggerFactory" %>
<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('signup_jsp')}" />

<session:get />

	<security:populateDataFromParams rootPath="signup" />

	${logger.debug("Data: {}", data)}

	<c:set var="fuelSignup" value="${data['signup/fuel']}"/>
	<c:if test="${fuelSignup == 'Y'}">
		${logger.debug('../write/fuel_signup.jsp?fuel_signup_name_first={}&fuel_signup_name_last={}&fuel_signup_email={}&fuel_signup_terms={}',data['signup/firstname'] , data['signup/surname'] ,  data['signup/email'] , data['signup/newsoffers'])}
		<c:import url="../write/fuel_signup.jsp?fuel_signup_name_first=${data['signup/firstname']}&fuel_signup_name_last=${data['signup/surname']}&fuel_signup_email=${data['signup/email']}&fuel_signup_terms=${data['signup/newsoffers']}" var="tmpVar"/>
		${logger.debug("tmpVar: {}", tmpVar)}
	</c:if>


	<c:choose>
		<c:when test="${result=='true'}" >
			OK
		</c:when>
		<c:otherwise>
			sign up not successful
		</c:otherwise>
	</c:choose>

