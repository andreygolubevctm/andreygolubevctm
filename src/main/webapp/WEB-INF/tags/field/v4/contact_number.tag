<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="additional css class attribute" %>
<%@ attribute name="mobileXpath" required="true" rtexprvalue="true" description="mobile field's xpath" %>
<%@ attribute name="otherXpath" required="true" rtexprvalue="true" description="other field's xpath" %>
<c:set var="otherLabel">Don't have mobile number?</c:set>


<div class="contact-number ${className}" data-contact-by="mobile">
    <c:set var="fieldXPath" value="${mobileXpath}" />
    <form_v4:row label="Mobile number" subLabel="<a class='contact-number-switch' href='javascript:;' tabindex='999'>${otherLabel}</a>" fieldXpath="${fieldXPath}" className="contact-number-mobile required_input">
        <field_v1:flexi_contact_number xpath="${fieldXPath}"
                                       maxLength="20"
                                       required="true"
                                       className="contact-number-field sessioncamexclude"
                                       labelName="mobile number"
                                       phoneType="Mobile"
                                       requireOnePlusNumber="true"/>
    </form_v4:row>

    <c:set var="fieldXPath" value="${otherXpath}" />
    <form_v4:row label="${otherLabel}" subLabel="<a class='contact-number-switch' href='javascript:;' tabindex='998'>Mobile number?</a>" fieldXpath="${fieldXPath}" className="contact-number-other required_input">
        <field_v1:flexi_contact_number xpath="${fieldXPath}"
                                       maxLength="20"
                                       required="true"
                                       className="contact-number-field sessioncamexclude"
                                       labelName="other number"
                                       phoneType="LandLine"
                                       requireOnePlusNumber="true"/>
    </form_v4:row>
</div>