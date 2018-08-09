<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="field_email" 	value="${name}_email" />
<c:set var="is_callcentre">
    <c:choose>
        <c:when test="${empty callCentre}"><c:out value="false" /></c:when>
        <c:otherwise><c:out value="true" /></c:otherwise>
    </c:choose>
</c:set>

<c:set var="location" value="${data['health/situation/location']}" />
<c:if test="${not empty location and location.matches('[0-9]+')}">
	<go:setData dataVar="data" xpath="${xpath}/address/postCode" value="${location}" />
</c:if>

<%-- HTML --%>
<div id="${name}-selection" class="health_application-details">

    <c:choose>
        <c:when test="${useElasticSearch eq true}">
            <group_v3:elastic_address
                    xpath="${xpath}/address"
                    type="R"
                    suburbAdditionalAttributes=" data-rule-validateSelectedResidentialSuburb='true' data-msg-validateSelectedResidentialSuburb='Your address does not match the original suburb provided.' autocomplete='no'"
                    suburbNameAdditionalAttributes=" data-rule-validateSelectedResidentialSuburb='true' data-msg-validateSelectedResidentialSuburb='The selected suburb does not match the original suburb selected.' autocomplete='no'"
                    postCodeAdditionalAttributes=" data-rule-validateSelectedResidentialPostCode='true' data-msg-validateSelectedResidentialPostCode='Your address does not match the original postcode provided.' autocomplete='no'"
                    postCodeNameAdditionalAttributes=" data-rule-validateSelectedResidentialPostCode='true' data-msg-validateSelectedResidentialPostCode='The entered postcode does not match the original postcode provided.' autocomplete='no'"
                    disableErrorContainer="${true}"
            />
        </c:when>
        <c:otherwise>
            <group_v4:address xpath="${xpath}/address" type="R" stateValidationField="#health_application-selection .content"  disableErrorContainer="${false}" />
        </c:otherwise>
    </c:choose>

    <c:if test="${empty callCentre && empty data[xpath].postalMatch}">
        <go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
    </c:if>

    <form_v4:row>
        <field_v2:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
    </form_v4:row>

    <div id="${name}_postalGroup">
        <c:choose>
            <c:when test="${useElasticSearch eq true}">
                <group_v3:elastic_address
                        xpath="${xpath}/postal"
                        type="P"
                        suburbNameAdditionalAttributes=" autocomplete='no'"
                        suburbAdditionalAttributes=" autocomplete='no'"
                        postCodeNameAdditionalAttributes=" autocomplete='no'"
                        postCodeAdditionalAttributes=" autocomplete='no'"
                        disableErrorContainer="${true}"
                />
            </c:when>
            <c:otherwise>
                <group_v4:address xpath="${xpath}/postal" type="P" stateValidationField="#health_application-selection .content" disableErrorContainer="${false}" nonStdStreetAdditionalAttributes=" maxlength='29'"/>
            </c:otherwise>
        </c:choose>
    </div>

    <group_v4:contact_numbers xpath="${xpath}" required="true" />

    <c:set var="fieldXpath" value="${xpath}/email" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Email Address" id="${name}_emailGroup">
        <field_v2:email xpath="${fieldXpath}" title="your email address" required="true" size="40" />
        <span class="fieldrow_legend" id="${name}_emailMessage">(we'll send your confirmation here)</span>
        <field_v1:hidden xpath="${xpath}/emailsecondary" />
        <field_v1:hidden xpath="${xpath}/emailhistory" />
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}_no_email" />
    <form_v4:row fieldXpath="${fieldXpath}" id="${name}_noEmailGroup">
        <field_v2:checkbox xpath="${fieldXpath}" value="N"
                           title="No email address"
                           required="false"
                           label="true" />
    </form_v4:row>

    <form_v4:row id="${name}_optInEmail-group">
        <field_v2:checkbox xpath="${xpath}/optInEmail" value="Y"
                           title="Stay up to date with news and offers direct to your inbox"
                           required="false"
                           label="true" />
    </form_v4:row>

    <%-- Default contact Point to off --%>
    <c:set var="fieldXpath" value="${xpath}/contactPoint" />
    <form_v4:row fieldXpath="${fieldXpath}" label="How would you like <span>the Fund</span> to send you information?" id="${name}_contactPoint-group"
                 className="health_application-details_contact-group hidden">
        <field_v2:array_radio items="E=Email,P=Post,S=SMS" xpath="${fieldXpath}" title="like the fund to contact you" required="false" id="${name}_contactPoint" />
    </form_v4:row>

    <%-- Product Information --%>
    <field_v1:hidden xpath="${xpath}/provider" className="health_application_details_provider" />
    <field_v1:hidden xpath="${xpath}/productId" className="health_application_details_productId" />
    <field_v1:hidden xpath="${xpath}/productName" className="health_application_details_productNumber" />
    <field_v1:hidden xpath="${xpath}/productTitle" className="health_application_details_productTitle" />
    <field_v1:hidden xpath="${xpath}/providerName" className="health_application_details_providerName" />


</div>




<%-- JAVASCRIPT --%>
<c:set var="contactPointPath" value="${xpath}/contactPoint" />
<c:set var="contactPointValue" value="${data[contactPointPath]}" />

<input type="hidden" id="contactPointValue" value="${contactPointValue}"/>