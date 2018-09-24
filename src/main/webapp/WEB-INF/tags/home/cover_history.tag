<%@ tag description="Cover History" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="baseXpath" required="true" rtexprvalue="true" description="base xpath"%>


<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<jsp:useBean id="past" class="java.util.GregorianCalendar" />
<% past.add(java.util.GregorianCalendar.YEAR, -5); %>
<fmt:formatDate var="past_Date" pattern="yyyy-MM-dd" value="${past.time}" />

<jsp:useBean id="future" class="java.util.GregorianCalendar" />
<% future.add(java.util.GregorianCalendar.YEAR, 1); %>
<fmt:formatDate var="future_Date" pattern="yyyy-MM-dd" value="${future.time}" />

<form_v2:fieldset legend="Previous Cover">

	<div class="notLandlord">
		<%-- Claims --%>
		<c:set var="fieldXpath" value="${xpath}/claims" />
		<form_v2:row fieldXpath="${fieldXpath}" label="In the last 5 years, have you or any other household member had any thefts, burglaries or made any insurance claims for home and/or contents?" id="claimsRow">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Insurance Claims" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${fieldXpath}"
				required="true"
				items="Y=Yes,N=No"
				title="if the policy holder, or any other household member has had any thefts, burglaries or has made any home and/or contents insurance claims in the last 5 years."
				additionalLabelAttributes="${analyticsAttr}" />
		</form_v2:row>
	</div>

	<div class="isLandlord">
		<%-- Claims --%>
		<c:set var="fieldXpath" value="${xpath}/claims" />
		<form_v2:row fieldXpath="${fieldXpath}" label="In the last 5 years, have you had any thefts, burglaries or made any landlord insurance claims?" id="claimsRow">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Insurance Claims" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${fieldXpath}"
				required="true"
				items="Y=Yes,N=No"
				title="if the policy holder, or any other household member has had any thefts, burglaries or has made any home and/or contents insurance claims in the last 5 years."
				additionalLabelAttributes="${analyticsAttr}" />
		</form_v2:row>
	</div>

</form_v2:fieldset>

<form_v2:fieldset legend="Your preferred date to start the insurance">
	<%-- Commencement Date --%>
	<c:set var="fieldXpath" value="${baseXpath}/startDate" />
	<home:commencementDate xpath="${fieldXpath}" />
</form_v2:fieldset>
