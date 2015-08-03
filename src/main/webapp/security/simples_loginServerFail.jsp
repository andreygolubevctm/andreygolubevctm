<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<layout:simples_page>

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>
		<p>Sorry, an error has occurred:</p>
		<ul>
			<li>could not communicate with authentication system; or</li>
			<li>you are not in an LDAP group authorised to access Simples</li>
		</ul>
		<p><a id="next-step" href="/${pageSettings.getContextFolder()}security/simples_logout.jsp" class="btn btn-cta">Continue</a></p>
	</jsp:body>

</layout:simples_page>
