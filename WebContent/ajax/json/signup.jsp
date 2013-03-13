<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

	<go:setData dataVar="data" xpath="signup" value="*DELETE" />
	<go:setData dataVar="data" value="*PARAMS" />
	
	<go:log>${data}</go:log>
	<go:call pageId="AGGNLS" xmlVar="${data.xml['signup']}"	resultVar="result"/>

	<c:set var="fuelSignup" value="${data['signup/fuel']}"/>
	<c:if test="${fuelSignup == 'Y'}">
		<go:log>../write/fuel_signup.jsp?fuel_signup_name_first=${data['signup/firstname']}&fuel_signup_name_last=${data['signup/surname']}&fuel_signup_email=${data['signup/email']}&fuel_signup_terms=${data['signup/newsoffers']}</go:log>
		<c:import url="../write/fuel_signup.jsp?fuel_signup_name_first=${data['signup/firstname']}&fuel_signup_name_last=${data['signup/surname']}&fuel_signup_email=${data['signup/email']}&fuel_signup_terms=${data['signup/newsoffers']}" var="tmpVar"/>
		<go:log>${tmpVar}</go:log>
	</c:if>

	
	<c:choose>
		<c:when test="${result=='true'}" >
			OK
		</c:when>
		<c:otherwise>
	 		sign up not successful
		</c:otherwise>
	</c:choose>

