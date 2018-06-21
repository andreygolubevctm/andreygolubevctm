<%@ tag description="Does your partner have private health insurance row"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's health insurance status xpath" %>
<%@ attribute name="hideHelpText" required="false" rtexprvalue="true"	 description="Hide the Help tooltip" %>

<c:set var="fieldXpath" value="${xpath}/partner/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner health insurance status" quoteChar="\"" /></c:set>
<c:set var="alreadyHaveHealthInsurance"><content:get key="alreadyHaveHealthInsurance" /></c:set>

<c:set var="theHelpid" value="" />
<c:set var="hideHelpText">
	<c:choose>
		<c:when test="${not empty hideHelpText and hideHelpText eq true}"><c:set var="theHelpid" value="" /></c:when>
		<c:otherwise><c:set var="theHelpid" value="572" /></c:otherwise>
	</c:choose>
</c:set>

<%--
Please note the purpose of this question is to capture if the user's partner currently has any form of private health cover ('Y' == (Private Hospital || Extras Only), 'N'= (None))
this is done for marketing purposes and so that the information can be passed on to the new provider.
The way it is currently worded it does not capture that information well and more importantly is not useful for LHC calculation as it does not explicitly ask
"Does your partner currently have Private hospital Cover" - this question will actually be asked on the application page, the biggest problem with this is it means that the
LHC amount cannot be displayed on the results page to help a user with LHC find a policy that is cheaper than their current policy. It also means that some people may say no
even though they might have extras cover.

A better way to capture this information would be to ask the same question and let the user select one of three options (Private Hospital/Extras Only/None) or (Yes/No/Extras Only)
--%>

<form_v4:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover" className="lhcRebateCalcTrigger" helpId="${theHelpid}">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Does your partner currently hold private health insurance?" required="true" className="health-cover_details" id="${name}_partner_health_cover" additionalLabelAttributes="${analyticsAttr}" />

	<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content">${alreadyHaveHealthInsurance}</div>
	</div>

</form_v4:row>