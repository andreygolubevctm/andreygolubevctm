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

	<form_new:fieldset legend="Contact Details">

		<group_new:address xpath="${xpath}/address" type="R" />
		
		<%-- POSTAL defaults to Y if not pre-loaded --%>
		<c:if test="${ (empty data[xpath].postalMatch) && (empty data['health/contactDetails/email']) }">
			<go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
		</c:if>	
		
		<form_new:row>
			<field_new:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
		</form_new:row>
		
		<div id="${name}_postalGroup">			
			<group_new:address xpath="${xpath}/postal" type="P" />
		</div>

		<group_new:contact_numbers xpath="${xpath}" required="true" />
		
		<c:set var="fieldXpath" value="${xpath}/email" />
		<form_new:row fieldXpath="${fieldXpath}" label="Email Address" id="${name}_emailGroup">
			<field_new:email xpath="${fieldXpath}" title="your email address" required="true" size="40" />
			<span class="fieldrow_legend" id="${name}_emailMessage">(we'll send your confirmation here)</span>
			<field:hidden xpath="${xpath}/emailsecondary" />
			<field:hidden xpath="${xpath}/emailhistory" />
		</form_new:row>
		
		<simples:dialogue id="14" vertical="health" mandatory="true" />
		
		<form_new:row id="${name}_optInEmail-group" hideHelpIconCol="true">
			<field_new:checkbox xpath="${xpath}/optInEmail" value="Y"
				title="Stay up to date with news and offers from comparethemarket.com.au direct to your inbox!"
				required="false"
				label="true" />
		</form_new:row>
		
		<form_new:row id="${name}_okToCall-group" hideHelpIconCol="true">
			<field_new:checkbox xpath="${xpath}_call" value="Y"
				title="Our dedicated Health Insurance consultants will give you a call to chat about your Health Insurance needs and questions."
				required="false"
				label="true" />
		</form_new:row>

		<%-- Default contact Point to off --%>
		<c:set var="fieldXpath" value="${xpath}/contactPoint" />
		<form_new:row fieldXpath="${fieldXpath}" label="How would you like <span>the Fund</span> to send you information?" id="${name}_contactPoint-group"
					className="health_application-details_contact-group hidden">
			<field_new:array_radio items="E=Email,P=Post" xpath="${fieldXpath}" title="like the fund to contact you" required="false" id="${name}_contactPoint" />
		</form_new:row>
		
		<%-- Product Information --%>
		<field:hidden xpath="${xpath}/provider" className="health_application_details_provider" />
		<field:hidden xpath="${xpath}/productId" className="health_application_details_productId" />
		<field:hidden xpath="${xpath}/productName" className="health_application_details_productNumber" />
		<field:hidden xpath="${xpath}/productTitle" className="health_application_details_productTitle" />
		<field:hidden xpath="${xpath}/paymentAmt" className="health_application_details_paymentAmt" />
		<field:hidden xpath="${xpath}/paymentFreq" className="health_application_details_paymentFreq" />
		<field:hidden xpath="${xpath}/paymentHospital" className="health_application_details_paymentLHCfree" />
	
	</form_new:fieldset>

</div>




<%-- JAVASCRIPT --%>
<c:set var="contactPointPath" value="${xpath}/contactPoint" />
<c:set var="contactPointValue" value="${data[contactPointPath]}" />

<input type="hidden" id="contactPointValue" value="${contactPointValue}"/>

<go:script marker="js-head">

$.validator.addMethod("matchStates",
	function(value, element) {
		return healthApplicationDetails.testStatesParity();
	},
	"Your address does not match the original state provided"
);	

</go:script>


<go:validate selector="${name}_address_state" rule="matchStates" parm="true" message="Health product details, prices and availability are based on the state in which you reside. The postcode entered here does not match the original state provided at the start of the search. If you have made a mistake with the postcode on this page please rectify it before continuing. Otherwise please <a href='#results' class='changeStateAndQuote'>carry out the quote again</a> using this state." />