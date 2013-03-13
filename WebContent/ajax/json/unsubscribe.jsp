<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<c:choose>
	<c:when test="${not empty param.email}">
		<c:set var="pgmData" value="<data><email>${param.email}</email></data>" />
		<go:call pageId="AGGTUE"   wait="TRUE" xmlVar="pgmData"  resultVar="result"/>
		
		<c:choose>
			<c:when test="${result=='true'}" >
				OK
			</c:when>
			<c:otherwise>
				That email address was not found on file
			</c:otherwise>
		</c:choose>
		
	</c:when>
	<c:otherwise>
		Email address is empty 
	</c:otherwise>
</c:choose>
