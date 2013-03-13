<%@
page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %><%@
include file="/WEB-INF/tags/taglib.tagf"

%><c:set target="${pageContext.response}" property="contentType" value="text/plain"

/><c:set var="ncresponse" value="X"
/><c:if test="${ not empty(pageContext.request.remoteUser) and not empty(param.nc) and fn:indexOf(param.nc, '.') > 1 }"
	><c:set var="ncresponse" value="${fn:split(param.nc, '.')[1]}"
/></c:if

><c:out value="T${ncresponse}" />