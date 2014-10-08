<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Ensures the commencement date is not in the past"%>
<%@ tag import="com.ctm.web.validation.CommencementDateValidation" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="commencementDate"	required="true"	 	rtexprvalue="true"	 description="The commencement date string" %>
<%@ attribute name="dateFormat"			required="true"	 	rtexprvalue="true"	 description="The date format of the commencement date" %>

<c:set var="isValid"><%=CommencementDateValidation.isValid(commencementDate, dateFormat) %></c:set>

<c:if test="${isValid eq false}">
	<c:set var="commencementDate"><%=CommencementDateValidation.getToday(dateFormat) %></c:set>
</c:if>

${commencementDate}