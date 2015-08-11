<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="vertical"			required="true"  rtexprvalue="true"	 description="The vertical" %>
<%@ attribute name="formAction"			required="true"  rtexprvalue="true"	 description="Action URL of the form" %>

<%@ attribute name="header" 		fragment="true" %>
<%@ attribute name="body_start" 	fragment="true" %>
<%@ attribute name="form_top" 	fragment="true" %>
<%@ attribute name="form_bottom" 	fragment="true" %>
<%@ attribute name="footer" 		fragment="true" %>

<core:doctype />
<go:html>

	<%-- HEADER --%>
	<jsp:invoke fragment="header" />

	<body class="engine stage-0 ${vertical}">

		<jsp:invoke fragment="body_start" />

		<form:form action="${formAction}" method="POST" id="mainform" name="frmMain">

			<jsp:invoke fragment="form_top" />

			<div id="wrapper">
				<div id="page">

					<div id="content">

						<jsp:doBody/>

					</div>

				</div>

			</div>
			<jsp:invoke fragment="form_bottom" />
			
	
		</form:form>
		<form:help />

		<jsp:invoke fragment="footer" />

		<core:closing_body />

	</body>

</go:html>