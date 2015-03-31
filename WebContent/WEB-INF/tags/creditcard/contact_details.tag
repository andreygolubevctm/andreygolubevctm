<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Handover Contact Details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_new:row label="Full Name" hideHelpIconCol="true" labelAbove="${true}">
    <field:person_name xpath="${xpath}/name" title="your full name" required="true" placeholder="Your full name" className="sessioncamexclude" />
</form_new:row>

<form_new:row label="Email Address" hideHelpIconCol="true" labelAbove="${true}">
    <field_new:email xpath="${xpath}/email" title="your email" placeHolder="Your email address" required="true" className="sessioncamexclude" />
</form_new:row>

<form_new:row label="Postcode / Suburb" className="postcodeDetails" hideHelpIconCol="true" labelAbove="${true}">
    <field_new:lookup_suburb_postcode xpath="${xpath}/location" required="true" placeholder="Postcode / Suburb" />
    <field:hidden xpath="${xpath}/suburb" />
    <field:hidden xpath="${xpath}/postcode" />
    <field:hidden xpath="${xpath}/state" />
</form_new:row>