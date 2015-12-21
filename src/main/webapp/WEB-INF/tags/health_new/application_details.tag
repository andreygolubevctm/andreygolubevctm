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


<%-- HTML --%>
<div id="${name}-selection" class="health_application-details">

	<form_v2:fieldset legend="Contact Details">

		<group_v3:address xpath="${xpath}/address" type="R" stateValidationField="#health_application-selection .content"/>

		<%-- POSTAL defaults to Y if not pre-loaded --%>
		<c:if test="${ (empty data[xpath].postalMatch) && (empty data['health/contactDetails/email']) }">
			<go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
		</c:if>

		<form_v3:row>
			<field_new:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
		</form_v3:row>

		<div id="${name}_postalGroup">
			<group_v3:address xpath="${xpath}/postal" type="P" stateValidationField="#health_application-selection .content"/>
		</div>

		<group_v3:contact_numbers xpath="${xpath}" required="true" />

		<c:set var="fieldXpath" value="${xpath}/email" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Email Address" id="${name}_emailGroup">
			<field_new:email xpath="${fieldXpath}" title="your email address" required="true" size="40" />
			<span class="fieldrow_legend" id="${name}_emailMessage">(we'll send your confirmation here)</span>
			<field:hidden xpath="${xpath}/emailsecondary" />
			<field:hidden xpath="${xpath}/emailhistory" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}_no_email" />
		<form_v3:row fieldXpath="${fieldXpath}" id="${name}_noEmailGroup">
			<field_new:checkbox xpath="${fieldXpath}" value="N"
								title="No email address"
								required="false"
								label="true" />
		</form_v3:row>

		<form_v3:row id="${name}_optInEmail-group" hideHelpIconCol="true">
			<field_new:checkbox xpath="${xpath}/optInEmail" value="Y"
								title="Stay up to date with news and offers direct to your inbox"
								required="false"
								label="true" />
		</form_v3:row>

		<form_v3:row id="${name}_okToCall-group" hideHelpIconCol="true">
			<field_new:checkbox xpath="${xpath}_call" value="Y"
								title="Our dedicated Health Insurance consultants will give you a call to chat about your Health Insurance needs and questions."
								required="false"
								label="true" />
		</form_v3:row>

		<%-- Default contact Point to off --%>
		<c:set var="fieldXpath" value="${xpath}/contactPoint" />
		<form_v3:row fieldXpath="${fieldXpath}" label="How would you like <span>the Fund</span> to send you information?" id="${name}_contactPoint-group"
							 className="health_application-details_contact-group hidden">
			<field_new:array_radio items="E=Email,P=Post" xpath="${fieldXpath}" title="like the fund to contact you" required="false" id="${name}_contactPoint" />
		</form_v3:row>

		<%-- Product Information --%>
		<field:hidden xpath="${xpath}/provider" className="health_application_details_provider" />
		<field:hidden xpath="${xpath}/productId" className="health_application_details_productId" />
		<field:hidden xpath="${xpath}/productName" className="health_application_details_productNumber" />
		<field:hidden xpath="${xpath}/productTitle" className="health_application_details_productTitle" />
		<field:hidden xpath="${xpath}/providerName" className="health_application_details_providerName" />

	</form_v2:fieldset>

</div>




<%-- JAVASCRIPT --%>
<c:set var="contactPointPath" value="${xpath}/contactPoint" />
<c:set var="contactPointValue" value="${data[contactPointPath]}" />

<input type="hidden" id="contactPointValue" value="${contactPointValue}"/>