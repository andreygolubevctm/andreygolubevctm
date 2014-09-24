<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="CAR" />

<c:set var="stylecode" value="${fn:toUpperCase(pageSettings.getBrandCode())}" />

<%-- TODO: remove this once we are off DISC --%>
<go:log>Writing Report</go:log>
<security:populateDataFromParams rootPath="quote" delete="false" />
<go:log >Calling AGGTRP, transid: ${data.text['current/transactionId']}, xmlval: ${go:getEscapedXml(data['quote'])}</go:log>
<go:call pageId="AGGTRP"transactionId="${data.text['current/transactionId']}" xmlVar="${go:getEscapedXml(data['quote'])}" style="${stylecode}" />

<%-- Touch types: A = Apply now,  CB = Call me back,  CD = Call direct --%>
<c:set var="touch" value="${param.touch}"/>
<c:set var="is_valid_touch">
	<core:validate_touch_type valid_touches="A,CD,CB" touch="${touch}" />
</c:set>
<c:choose>
	<c:when test="${is_valid_touch==true}">
		<core:transaction touch="${touch}" noResponse="true" />
	</c:when>
	<c:otherwise>
		<error:non_fatal_error origin="car_quote_report.jsp" errorMessage="ERROR: Touch type is invalid or unsupported: '${touch}'" errorCode="" />
		<go:log level="WARN" >car_quote_report ERROR: Touch type is invalid or unsupported: "${touch}"</go:log>
	</c:otherwise>
</c:choose>

