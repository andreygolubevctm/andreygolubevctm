<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Don't override settings --%>
<c:if test="${empty data.settings.styleCode}">
	<c:import url="brand/ctm/settings.xml" var="settingsXml" />
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" xml="${settingsXml}" />
</c:if>

<c:choose>
	<c:when test="${empty param.unsubscribe_email and not empty data.unsubscribe.email}">
		<%-- DISPLAY THE UNSUBSCRIBE PAGE WITH THE INFO SAVED IN THE SESSION --%>
	<core:unsubscribe/>
	</c:when>
	<c:otherwise>
		<%-- SAVE THE PARAMETERS, SAVE THEM IN THE SESSION AND REDIRECT TO THE SAME PAGE --%>
		<%-- Check the email exists in the database --%>
		<c:set var="brand" value="CTM" />

		<c:choose>
			<c:when test="${param.DISC eq 'true'}">
				<c:set var="email"><security:hashed_email action="decrypt" email="${param.unsubscribe_email}" brand="${brand}" DISC="true" /></c:set>
				<c:set var="emailJson"><security:hashed_email action="decrypt" email="${param.unsubscribe_email}" brand="${brand}" DISC="true" output="json" /></c:set>
			</c:when>
			<c:otherwise>
				<c:set var="email"><security:hashed_email action="decrypt" email="${param.unsubscribe_email}" brand="${brand}" /></c:set>
				<c:set var="emailJson"><security:hashed_email action="decrypt" email="${param.unsubscribe_email}" brand="${brand}" output="json" /></c:set>
			</c:otherwise>
		</c:choose>
		
		<%-- Save in session --%>
		<c:set var="unsubscribe">
			<unsubscribe>
				<hashedEmail>${param.unsubscribe_email}</hashedEmail>
				<email>${email}</email>
				<emailJson>${emailJson}</emailJson>
				<brand>${brand}</brand>
				<vertical>${param.vertical}</vertical>
				<DISC>${param.DISC}</DISC>
			</unsubscribe>
		</c:set>
		<go:setData dataVar="data" xpath="unsubscribe" value="*DELETE" />
		<go:setData dataVar="data" xml="${unsubscribe}" />
		
		<%-- Redirect --%>
		<c:redirect url="https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp" />
	</c:otherwise>
</c:choose>
