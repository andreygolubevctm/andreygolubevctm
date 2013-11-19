<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Stamp an action in the database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="action"		 	required="true"	 rtexprvalue="true"	 description="Which action to stamp" %>
<%@ attribute name="brand"		 	required="true"	 rtexprvalue="true"	 description="The brand (ie. ctm, cc, etc.)" %>
<%@ attribute name="vertical"	 	required="false" rtexprvalue="true"	 description="The vertical (ie. health, car, etc.)" %>
<%@ attribute name="target"			required="true"	 rtexprvalue="true"	 description="The target of the action (could be an email address, a provided Id, etc.)" %>
<%@ attribute name="value"			required="true"	 rtexprvalue="true"	 description="The new value of the target" %>
<%@ attribute name="comment"	 	required="true"	 rtexprvalue="true"	 description="Any comment" %>
<%@ attribute name="operator"	 	required="false" rtexprvalue="true"	 description="Manually define the operator, otherwise is logged-in user" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- VARIABLES --%>
<c:set var="operator">
	<c:choose>
		<c:when test="${not empty operator}">${operator}</c:when>
		<c:when test="${not empty data.login.user.uid}">${data.login.user.uid}</c:when>
		<c:otherwise>ONLINE</c:otherwise>
	</c:choose>
</c:set>
<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />

<%-- for toggle actions replace Y/N by more meaningful on/off values --%>
<c:choose>
	<c:when test="${value eq 'Y'}"><c:set var="value" value="on" /></c:when>
	<c:when test="${value eq 'N'}"><c:set var="value" value="off" /></c:when>
</c:choose>

<sql:update var="results">
	INSERT INTO ctm.stamping (action,brand,vertical,target,value,operatorId,comment,datetime,IpAddress)
	VALUES (?,?,?,?,?,?,?,NOW(),?);
	<sql:param value="${action}" />
	<sql:param value="${fn:toLowerCase(brand)}" />
	<sql:param value="${fn:toLowerCase(vertical)}" />
	<sql:param value="${target}" />
	<sql:param value="${value}" />
	<sql:param value="${operator}" />
	<sql:param value="${comment}" />
	<sql:param value="${ipAddress}" />
</sql:update>