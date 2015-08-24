<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_new:fieldset_columns sideHidden="false">
	<jsp:attribute name="rightColumn">
	</jsp:attribute>
	<jsp:body>

		<form_new:fieldset legend="Occupancy Details" id="${name}_other_occupants">

			<%-- Anyone Older? --%>
			<c:set var="fieldXpath" value="${xpath}/anyoneOlder" />
			<form_new:row fieldXpath="${fieldXpath}" label="Will anyone older than the policy holder(s) live in the home?" id="anyoneOlder">
				<field_new:array_radio xpath="${fieldXpath}"
					items="Y=Yes,N=No"
					className="pretty_buttons"
					title="if anyone is older than the policy holder at the home"
					required="true" />
			</form_new:row>

			<%-- DOB of the oldest person --%>
			<c:set var="fieldXpath" value="${xpath}/oldestPersonDob" />
			<form_new:row fieldXpath="${fieldXpath}" label="Date of birth of oldest person living in the home" id="oldest_person_DOB">
				<field_new:person_dob xpath="${fieldXpath}"
					title="oldest person dob"
					required="true"
					ageMin="16"
					ageMax="99" />
			</form_new:row>

			<%-- Is anyone over 55? --%>
			<c:set var="fieldXpath" value="${xpath}/over55" />
			<form_new:row fieldXpath="${fieldXpath}" label="Is any person living in the home over 55 and retired?" className="over55">
				<field_new:array_radio xpath="${fieldXpath}"
					items="Y=Yes,N=No"
					className="pretty_buttons"
					title="whether there is anyone over 55 and retired living at the home"
					required="true" />
			</form_new:row>
		</form_new:fieldset>

		<go:validate selector="${name}_oldestPersonDob" rule="oldestPersonOlderThanPolicyHolders" parm="true" message="Please confirm that the oldest person living at the home is older than the policy holder." />

	</jsp:body>

</form_new:fieldset_columns>


