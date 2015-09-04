<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<session:get settings="true" authenticated="true" verticalCode="HOME" />

<%-- TODO: remove this once we are off DISC --%>
${logger.debug('Writing Report')}
<security:populateDataFromParams rootPath="home" delete="false" />

<%-- Touch types: A = Apply now,  CB = Call me back,  CD = Call direct --%>
<c:set var="touch" value="${param.touch}"/>
<c:set var="is_valid_touch">
	<core:validate_touch_type valid_touches="A,CD,T,Q" touch="${touch}" />
</c:set>
<c:choose>
	<c:when test="${is_valid_touch==true}">
		<core:transaction touch="${touch}" noResponse="true" />
	</c:when>
	<c:otherwise>
		<error:non_fatal_error origin="home_quote_report.jsp" errorMessage="ERROR: Touch type is invalid or unsupported: '${touch}'" errorCode="" />
		${logger.warn('Touch type is invalid or unsupported. {}', log:kv('touch',touch ))}
	</c:otherwise>
</c:choose>

