<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's dob xpath" %>

<c:set var="fieldXpath" value="${xpath}/partner/dob" />
<form_v4:row label="Your partner's date of birth" fieldXpath="${fieldXpath}" id="benefits_partner_dob" className="lhcRebateCalcTrigger hidden-toggle">
	<field_v4:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
</form_v4:row>