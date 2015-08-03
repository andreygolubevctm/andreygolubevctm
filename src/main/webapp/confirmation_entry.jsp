<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Set GENERIC as vertical to start with
	Vertical is updated once it is retrieved via validate: <settings:setVertical verticalCode="${vertical}" /> --%>
<%-- <session:new verticalCode="GENERIC" /> --%>
<settings:setVertical verticalCode="GENERIC" />

<%-- Comes in from AFG as ConfirmationID --%>
<c:set var="confirmationId"><c:out value="${param.ConfirmationID}" escapeXml="true" /></c:set>
<c:set var="isValid" value="false" />

<c:if test="${not empty confirmationId}">

	<%-- Determine if the ConfirmationID is valid for this StyleCodeId. --%>
	<%-- Determine and Set VerticalCode from transaction header --%>
	<c:set var="isValid">
		<confirmation:validate confirmationId="${confirmationId}" />
	</c:set>

	<%-- If confirmation is valid, do touches etc based on vertical --%>
	<%-- If touches etc succeeded, set isValid to true, otherwise fail. --%>
	<c:if test="${isValid eq true}">
		<c:choose>
			<c:when test="${pageSettings.getVerticalCode() eq 'homeloan'}">
			</c:when>
			<c:otherwise><%-- Do Nothing --%></c:otherwise>
		</c:choose>
	</c:if>

</c:if>

<c:choose>
	<c:when test="${isValid eq true}">
		<%-- Must have current transactionId --%>
		<c:set var="transactionId" value="${data.current.transactionId}" />
		<c:redirect url="${pageSettings.getBaseUrl()}confirmation.jsp">
			<c:param name="action" value="confirmation" />
			<c:param name="transactionId" value="${transactionId}" />
			<c:param name="ConfirmationID" value="${confirmationId}" />
		</c:redirect>
	</c:when>
	<c:otherwise>
		<c:redirect url="${pageSettings.getBaseUrl()}confirmation.jsp">
			<c:param name="action" value="error" />
			<c:param name="transactionId" value="0" />
		</c:redirect>
	</c:otherwise>
</c:choose>