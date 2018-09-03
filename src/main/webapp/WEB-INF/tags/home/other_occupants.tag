<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<div class="notLandlord">
	<form_v2:fieldset_columns sideHidden="false">
		<jsp:attribute name="rightColumn">
		</jsp:attribute>
		<jsp:body>

			<%-- Is anyone over 55? --%>
			<c:set var="fieldXpath" value="${xpath}/retired" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Is any person living in the home over 55 and retired?" className="retired">
				<field_v2:array_radio xpath="${fieldXpath}"
					items="Y=Yes,N=No"
					className="pretty_buttons"
					title="whether there is anyone over 55 and retired living at the home"
					required="true" />
			</form_v2:row>

		</jsp:body>

	</form_v2:fieldset_columns>
</div>
