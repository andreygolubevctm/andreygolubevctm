<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<form_v2:fieldset legend="Policy Holder Details">

	<%-- MAIN POLICY HOLDER --%>
	<%-- Policy Holder Title --%>
	<c:set var="fieldXpath" value="${xpath}/title" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Title">
		<field_v2:import_select xpath="${fieldXpath}"
			title="the policy holder's title"
			required="false"
			url="/WEB-INF/option_data/titles_simple.html"
			className="person-title" />
	</form_v2:row>

	<%-- Policy Holder First Name --%>
	<c:set var="fieldXpath" value="${xpath}/firstName" />
	<form_v2:row fieldXpath="${fieldXpath}" label="First Name">
		<field_v1:person_name xpath="${fieldXpath}"
			title="policy holder's first name"
			required="true"
			maxlength="50" />
	</form_v2:row>

	<%-- Policy Holder Last Name --%>
	<c:set var="fieldXpath" value="${xpath}/lastName" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Last Name">
		<field_v1:person_name xpath="${fieldXpath}"
			title="policy holder's last name"
			required="true"
			maxlength="50" />
	</form_v2:row>

	<%-- Policy Holder DOB --%>
	<c:set var="fieldXpath" value="${xpath}/dob" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Policy Holder's Date of Birth">
		<field_v2:person_dob xpath="${fieldXpath}"
			title="policy holder's"
			required="true"
			ageMin="16"
			ageMax="99"/>
	</form_v2:row>

</form_v2:fieldset>
<form_v2:fieldset legend="Joint Policy Holder <a class='btn btn-hollow-red btn-sm btn-right btn-wide toggleJointPolicyHolder' href='javascript:;'>Remove</a>" id="jointPolicyHolder">
	<%-- 	JOINT POLICY HOLDER --%>
	<%-- Joint Policy Holder Title --%>
	<c:set var="fieldXpath" value="${xpath}/jointTitle" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Title">
		<field_v2:import_select xpath="${fieldXpath}"
			title="the joint policy holder's title"
			required="false"
			url="/WEB-INF/option_data/titles_simple.html"
			className="person-title jointPolicyHolder" />
	</form_v2:row>

	<%-- Joint Policy Holder First Name --%>
	<c:set var="fieldXpath" value="${xpath}/jointFirstName" />
	<form_v2:row fieldXpath="${fieldXpath}" label="First Name">
		<field_v1:person_name xpath="${fieldXpath}"
			title="joint policy holder's first name"
			required="false"
			maxlength="50"
			className="jointPolicyHolder" />
	</form_v2:row>

	<%-- Joint Policy Holder Last Name --%>
	<c:set var="fieldXpath" value="${xpath}/jointLastName" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Last Name">
		<field_v1:person_name xpath="${fieldXpath}"
			title="joint policy holder's last name"
			required="false"
			maxlength="50"
			className="jointPolicyHolder" />
	</form_v2:row>

	<%-- Joint Policy Holder DOB --%>
	<c:set var="fieldXpath" value="${xpath}/jointDob" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Date of Birth">
		<field_v2:person_dob xpath="${fieldXpath}"
			title="joint policy holder's"
			required="true"
			className="jointPolicyHolder"
			ageMin="16"
			ageMax="99"/>
	</form_v2:row>

</form_v2:fieldset>

<form_v2:fieldset legend="">
<%-- Joint Policy Holder Button --%>
	<c:set var="fieldXpath" value="${xpath}/addJointPolicyHolder" />
	<form_v2:row fieldXpath="${fieldXpath}" label="">
		<a class="btn btn-next nav-next-btn toggleJointPolicyHolder addPolicyHolderBtn" href="javascript:;">Add Joint Policy Holder</a>
	</form_v2:row>
</form_v2:fieldset>