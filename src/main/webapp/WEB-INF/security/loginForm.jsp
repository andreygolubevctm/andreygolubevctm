<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<%-- Force any page that uses this to produce an unauthorised header --%>
<% response.setStatus(401); /* Unauthorised */ %>

<c:set var="userName" value="" />
<c:if test="${ not empty(param.j_username) }">
	<c:set var="userName" value="${param.j_username}" />
</c:if>

<c:if test="${empty pageTitle}">
	<c:set var="pageTitle" value="Log in" />
</c:if>

<c:set var="baseUrl" value="/${pageSettings.getContextFolder()}" />

<script>
window.onload = function() {
	var loginUrl = window.location.toString();

	if ( window.top != window ) {
		window.top.location = '${baseUrl}simples.jsp';
	} else {
		document.getElementById('j_username').focus();
	}
};
</script>

<layout_v1:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>

		<form action="${baseUrl}j_security_check" method="POST">

			<layout_v1:slide_columns sideHidden="true">

				<jsp:attribute name="rightColumn">
				</jsp:attribute>

				<jsp:body>

					<form_v2:fieldset legend="${pageTitle}">
						<c:if test="${not empty welcomeText}">
							<ui:bubble variant="chatty">
								${welcomeText}
							</ui:bubble>
						</c:if>

						<form_v2:row fieldXpath="j_username" label="Username">
							<input type="text" id="j_username" name="j_username" maxlength="100" value="<c:out value="${userName}" />" class="form-control">
						</form_v2:row>
						<form_v2:row fieldXpath="j_password" label="Password">
							<input type="password" id="j_password" name="j_password" maxlength="100" value="" class="form-control">
						</form_v2:row>

						<form_v2:row>
							<button id="next-step" type="submit" class="btn btn-cta">Log in</button>
						</form_v2:row>
					</form_v2:fieldset>

				</jsp:body>

			</layout_v1:slide_columns>
		</form>

	</jsp:body>
</layout_v1:simples_page>
