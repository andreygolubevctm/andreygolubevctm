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
	<%-- Policy Holder First Name --%>
	<c:set var="fieldXpath" value="${xpath}/firstName" />
	<form_v2:row fieldXpath="${fieldXpath}" label="First Name">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="First Name" quoteChar="\"" /></c:set>
		<field_v1:person_name xpath="${fieldXpath}"
			title="policy holder's first name"
			required="true"
			maxlength="50"
			additionalAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Policy Holder Last Name --%>
	<c:set var="fieldXpath" value="${xpath}/lastName" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Last Name">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Last Name" quoteChar="\"" /></c:set>
		<field_v1:person_name xpath="${fieldXpath}"
			title="policy holder's last name"
			required="true"
			maxlength="50"
			additionalAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Policy Holder DOB --%>
	<c:set var="fieldXpath" value="${xpath}/dob" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Policy Holder's Date of Birth">
		<field_v2:person_dob xpath="${fieldXpath}"
			title="policy holder's"
			required="true"
			ageMin="16"
			ageMax="99"
			trackingPrefix="Policy Holder"/>
	</form_v2:row>

	<c:if test="${journeySplitTestActive eq true}">
		<home:contact_details_v2 xpath="${xpath}" />
	</c:if>

</form_v2:fieldset>

<%-- Class name to force join policy holder fields to be hidden --%>
<c:set var="joinPolicyHolderClassname">
	<c:choose>
		<c:when test="${journeySplitTestActive eq true}">hidden</c:when>
		<c:otherwise><%-- empty --%></c:otherwise>
	</c:choose>
</c:set>

<%-- Joint Policy Holder Button removed due to ticket HNC-463 - Associated Fields left in due to validation requirements for oldest policy holder over 55 AND for displaying old quotes --%>
<form_v2:fieldset className="${joinPolicyHolderClassname}" legend="Joint Policy Holder <a class='btn btn-hollow-red btn-sm btn-right btn-wide toggleJointPolicyHolder' href='javascript:;'>Remove</a>" id="jointPolicyHolder">
	<%-- 	JOINT POLICY HOLDER --%>
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
			ageMax="99"
			trackingPrefix="Joint Policy Holder"/>
	</form_v2:row>

</form_v2:fieldset>