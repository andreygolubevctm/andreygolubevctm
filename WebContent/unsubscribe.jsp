<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<core:load_settings conflictMode="false" />

<c:choose>
	<c:when test="${not empty param.brand}">
		<c:set var="brand" ><c:out value="${fn:toUpperCase(param.brand)}" escapeXml="true" /></c:set>
	</c:when>
	<c:when test="${not empty data['unsubscribe/brand']}">
		<c:set var="brand" value="${data.unsubscribe.brand}" />
	</c:when>
	<c:otherwise >
		<c:set var="brand" value="CTM" />
	</c:otherwise>
</c:choose>
<c:set var="vertical" ><c:out value="${param.vertical}" escapeXml="true" /></c:set>
<c:if test="${empty vertical && brand == 'MEER'}">
	<c:set var="vertical" value="competition" />
</c:if>
<c:choose>
	<c:when test="${empty param.unsubscribe_email and not empty data.unsubscribe.email}">
		<%-- DISPLAY THE UNSUBSCRIBE PAGE WITH THE INFO SAVED IN THE SESSION --%>
		<c:choose>
			<c:when test="${brand == 'CTM'}">
				<core:unsubscribe brand="${brand}" />
	</c:when>
	<c:otherwise>
				<meerkat:unsubscribe brand="${brand}" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<%-- SAVE THE PARAMETERS, SAVE THEM IN THE SESSION AND REDIRECT TO THE SAME PAGE --%>
		<%-- Check the email exists in the database --%>

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
				<vertical>${vertical}</vertical>
				<DISC>${param.DISC}</DISC>
			</unsubscribe>
		</c:set>
		<go:setData dataVar="data" xpath="unsubscribe" value="*DELETE" />
		<go:setData dataVar="data" xml="${unsubscribe}" />
		
		<%-- Redirect --%>
		<c:redirect url="${data['settings/root-url']}${data.settings.styleCode}/unsubscribe.jsp" />
	</c:otherwise>
</c:choose>
