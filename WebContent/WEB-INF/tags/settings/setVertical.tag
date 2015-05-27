<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--

	Sets the vertical code for the page request scope and loads the settings object.
	This method also checks to see if the vertical is enabled for the brand. (and by extension that the brand code is set)

	Call this on vertical start pages like health_quote.jsp

--%>

<%@ attribute name="verticalCode" required="true" rtexprvalue="true" description="VerticalCode is not case sensitive."  %>

<session:core />

<c:set var="pageSettings" value="${settingsService.setVerticalAndGetSettingsForPage(pageContext.getRequest(), verticalCode)}" scope="request"  />
