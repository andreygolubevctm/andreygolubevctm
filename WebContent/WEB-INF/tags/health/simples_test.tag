<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- SCRIPT --%>
<go:script marker="onready">

<c:if test="${empty callCentre}">

	/* If no login detected and we're in an iframe then the user must 
	 * have been logged out - redirect to login page
	 */
	if ( window.self !== window.top ) {
		top.location.href = "/ctm/simples.jsp";
	}
	
</c:if>

</go:script>