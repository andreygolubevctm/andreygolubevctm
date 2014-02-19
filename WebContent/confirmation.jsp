<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<core:load_settings conflictMode="false" vertical="confirmation" />

<c:set var="xpath" value="confirmation" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />


<%-- First validate the confirmation before loading the rest, but only if a certain vertical --%>
<confirmation:validate xpath="${xpath}">

<%-- check if the vertical is passed, and if not set from param--%>
<c:if test="${empty vertical}">
	<c:set var="vertical" value="${param.vertical }"/>
</c:if>


	<core:doctype />
	<go:html>
		<core:head quoteType="${xpath}" title="Confirmation Page" mainCss="common/${name}.css" mainJs="common/js/${name}.js" />

		<body class="${name} stage-0">

			<%-- SuperTag Top Code --%>
			<agg:supertag_top type="Confirmation"/>

			<form:form action="confirmation.jsp" method="POST" id="mainform" name="frmMain">

				<form:operator_id xpath="${xpath}/operatorid" />

				<form:header quoteType="${xpath}" hasReferenceNo="false" showReferenceNo="false"/>

				<div id="wrapper">
					<div id="page" class='page'>

						<div id="content">
							<div id="confirmation-page">
								<confirmation:vertical_actions vertical="${vertical}" transaction_id="${transaction_id}" confirmation_ref="${confirmation_ref}" />
								<confirmation:summary vertical="${vertical}" transaction_id="${transaction_id}" first_name="${first_name}" />
								<confirmation:other_products vertical="${vertical}" />
								<confirmation:optin vertical="${vertical}" email="${email_address}" />
								<%--<confirmation:related_products vertical="${vertical}"/>--%>
							</div>
						</div>
					</div>
				</div>

			</form:form>

			<confirmation:footer vertical="${vertical}" />

			<core:closing_body>
				<agg:includes supertag="true" />
				<confirmation:includes />
			</core:closing_body>

		</body>

	</go:html>

</confirmation:validate>

