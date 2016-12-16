<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Postcode"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="fieldXpath" value="${xpath}/postcode" />
<form_v4:row label="Postcode" fieldXpath="${fieldXpath}" className="clear required_input">
	<div class="health_contact_details_postcode_wrapper">
		<field_v1:post_code xpath="${fieldXpath}" title="postcode" required="true" className="health_contact_details_postcode" />
	</div>
	<div class="health_contact_details_postcode_results_wrapper">
		<div class="health_contact_details_postcode_results"></div>
		<button type="button" class="btn btn-secondary postcode-items-btn-edit">Edit</button>
	</div>
</form_v4:row>