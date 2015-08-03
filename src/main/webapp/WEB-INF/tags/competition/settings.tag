<%@ tag description="Loading of the Competition Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="fromBrochure" scope="request" value="${true}"/>
<c:set var="pageAction">
            <c:out value="${param.action}"/>
</c:set>
{
isFromBrochureSite: <c:out value="${fromBrochure}"/>,
brochureValues:{
},
pageAction: '<c:out value="${pageAction}"/>'
}
