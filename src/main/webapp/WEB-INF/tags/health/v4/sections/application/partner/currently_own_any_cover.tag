<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Does your partner have private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/partner/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner health insurance status" quoteChar="\"" /></c:set>
<c:set var="alreadyHaveHealthInsurance"><content:get key="alreadyHaveHealthInsurance" /></c:set>

<form_v4:fieldset legend="Partner's current private health cover">

	<form_v4:row label="Does your partner currently hold Private Health Insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover" className="lhcRebateCalcTrigger" helpId="587">
		<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Does your partner currently hold Private Health Insurance?" required="true" className="health-cover_details health-cover_details-partner" id="${name}_partner_health_cover" additionalLabelAttributes="${analyticsAttr}" />

		<health_v4_application:abd_details className="abd-details-application-couple-no-phi hidden" />
		<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
		<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
			<div class="icon-area">
				<div class="tick"></div>
			</div>
			<div class="content">${alreadyHaveHealthInsurance}</div>
		</div>

	</form_v4:row>

	<form_v4:row label="What type of cover does your partner currently have?" id="${name}_partnerCoverType" className="lhcRebateCalcTrigger">
		<field_v2:array_radio items="C=Hospital & Extras Cover,H=Hospital Cover,E=Extra Cover" style="group" xpath="${fieldXpath}/type" title="- What type of cover does your partner currently have?" required="true" className="health-cover_type_details" id="${name}_partner_health_cover_type" additionalLabelAttributes="${analyticsAttr}"/>
	</form_v4:row>

	<form_v4:row id="${name}_partnerCoverSameProviders" label="Is your partner's hospital and extras cover with the same fund?">
		<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}/sameProviders" title="Is your partner's hospital and extras cover with the same fund?" required="true" />
	</form_v4:row>

</form_v4:fieldset>
