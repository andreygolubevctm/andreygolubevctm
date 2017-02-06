<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Optin row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/healthCvr" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="about you" quoteChar="\"" /></c:set>
<%-- Override set in splittest_helper tag --%>
<c:if test="${showOptInOnSlide3 eq false}">
	<c:set var="termsAndConditions">
		<%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
		I understand <content:optin key="brandDisplayName" useSpan="true"/> compares health insurance policies from a range of
		<a href='<content:get key="participatingSuppliersLink"/>' target='_blank'>participating suppliers</a>.
		By providing my contact details I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may contact me, during the Call Centre <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">opening hours</a>, about the services they provide.
		I confirm that I have read the <form_v1:link_privacy_statement />.
	</c:set>

	<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
	<div class="health-contact-details-optin-group form-group">
		<div class="col-xs-12 fieldrow">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="combined optin" quoteChar="\"" /></c:set>
			<field_v2:checkbox
					xpath="${pageSettings.getVerticalCode()}/contactDetails/optin"
					value="Y"
					className="validate row-content"
					required="true"
					label="${true}"
					title="${termsAndConditions}"
					errorMsg="Please agree to the Terms &amp; Conditions"
					additionalLabelAttributes="${analyticsAttr}"
			/>
		</div>
	</div>
</c:if>
<simples:dialogue id="37" vertical="health" mandatory="true" className="hidden" />