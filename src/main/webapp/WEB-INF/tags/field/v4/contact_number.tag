<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<c:set var="fieldXPath" value="${xpath}/mobile" />
<form_v4:row label="Mobile Number" subLabel="<a class='contact-number-switch' href='javascript:;'>Other number?</a>" fieldXpath="${fieldXPath}" className="contact-number">
    <field_v1:flexi_contact_number xpath="${fieldXPath}"
                                   maxLength="20"
                                   required="true"
                                   className="contact-number-field sessioncamexclude"
                                   labelName="mobile number"
                                   phoneType="Mobile"
                                   requireOnePlusNumber="true"/>
</form_v4:row>

<c:set var="fieldXPath" value="${xpath}/other" />
<form_v4:row label="Other number" subLabel="<a class='contact-number-switch' href='javascript:;'>Mobile number?</a>" fieldXpath="${fieldXPath}" className="contact-number hidden">
    <field_v1:flexi_contact_number xpath="${fieldXPath}"
                                   maxLength="20"
                                   required="true"
                                   className="contact-number-field sessioncamexclude"
                                   labelName="other number"
                                   phoneType="LandLine"
                                   requireOnePlusNumber="true"/>
</form_v4:row>