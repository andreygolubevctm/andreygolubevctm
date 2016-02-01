<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Handover Contact Details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_v2:row label="Full Name" hideHelpIconCol="true" labelAbove="${true}">
    <field_v1:person_name xpath="${xpath}/name" title="your full name" required="true" placeholder="Your full name" />
</form_v2:row>

<form_v2:row label="Email Address" hideHelpIconCol="true" labelAbove="${true}">
    <field_v2:email xpath="${xpath}/email" title="your email" placeHolder="Your email address" required="true" />
</form_v2:row>

<form_v2:row label="Postcode / Suburb" className="postcodeDetails" hideHelpIconCol="true" labelAbove="${true}">
    <field_v2:lookup_suburb_postcode xpath="${xpath}/location" required="true" placeholder="Postcode / Suburb" />
    <field_v1:hidden xpath="${xpath}/suburb" />
    <field_v1:hidden xpath="${xpath}/postcode" />
    <field_v1:hidden xpath="${xpath}/state" />
</form_v2:row>