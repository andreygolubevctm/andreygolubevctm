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
	<c:set var="fieldXpath" value="${xpath}/address" />
	<c:set var="unitTypes">=Select unit type if applicable, UN=Unit, L=Level, TO=Townhouse, SH=Shop, OT=Other</c:set>
	<field_v4:address_search_smartsearch xpath="${fieldXpath}" prefix="Residential" unitTypes="${unitTypes}" />

	<c:if test="${empty callCentre && empty data[xpath].postalMatch}">
			<go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
	</c:if>

	<form_v4:row>
			<div id="simples-postcode-toggle">
				<field_v2:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
			</div>
	</form_v4:row>
	<div id="${name}_postalGroup">
				<c:set var="fieldXpath" value="${xpath}/postal" />
				<c:set var="unitTypes">=Select unit type if applicable, UN=Unit, PO=PO Box, L=Level, TO=Townhouse, SH=Shop, OT=Other</c:set>
				<field_v4:address_search_smartsearch xpath="${fieldXpath}" prefix="Postal" unitTypes="${unitTypes}" />
	</div>

		<group_v2:contact_numbers xpath="${xpath}" required="true" />

		<c:set var="fieldXpath" value="${xpath}/email" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Email Address" id="${name}_emailGroup">
			<field_v2:email xpath="${fieldXpath}" title="your email address" required="true" size="40" />
			<span class="fieldrow_legend" id="${name}_emailMessage">(we'll send your confirmation here)</span>
			<field_v1:hidden xpath="${xpath}/emailsecondary" />
			<field_v1:hidden xpath="${xpath}/emailhistory" />
		</form_v2:row>

		<c:set var="fieldXpath" value="${xpath}_no_email" />
		<form_v2:row fieldXpath="${fieldXpath}" id="${name}_noEmailGroup">
			<field_v2:checkbox xpath="${fieldXpath}" value="N"
				title="No email address"
				required="false"
				label="true" />
		</form_v2:row>
		
		<form_v2:row id="${name}_optInEmail-group" hideHelpIconCol="true">
			<field_v2:checkbox xpath="${xpath}/optInEmail" value="Y"
				title="Stay up to date with news and offers direct to your inbox"
				required="false"
				label="true" />
		</form_v2:row>

		<%-- Default contact Point to off --%>
		<c:set var="fieldXpath" value="${xpath}/contactPoint" />
		<form_v2:row fieldXpath="${fieldXpath}" label="How would you like <span>the Fund</span> to send you information?" id="${name}_contactPoint-group"
					className="health_application-details_contact-group hidden">
			<field_v2:array_radio items="E=Email,P=Post,S=SMS" xpath="${fieldXpath}" title="like the fund to contact you" required="false" id="${name}_contactPoint" />
		</form_v2:row>
		
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