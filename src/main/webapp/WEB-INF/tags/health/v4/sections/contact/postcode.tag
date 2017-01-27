<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Postcode"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="fieldXpath" value="${xpath}/postcode" />
<c:set var="location" value="${data['health/situation/location']}" />

<form_v4:row label="Postcode" fieldXpath="${fieldXpath}" className="clear required_input">
	<div class="health_contact_details_postcode_wrapper">
		<field_v1:post_code xpath="${fieldXpath}" title="postcode" required="true" className="health_contact_details_postcode" />
	</div>
	<div class="health_contact_details_postcode_results_wrapper">
		<div class="health_contact_details_postcode_results"></div>
		<a href="javascript:;" class="suburb-items-btn-edit">Edit</a>
		<field_v2:validatedHiddenField xpath="${pageSettings.getVerticalCode()}/situation/location"
									   additionalAttributes="data-rule-locationSelection='true'"/>
	</div>
</form_v4:row>