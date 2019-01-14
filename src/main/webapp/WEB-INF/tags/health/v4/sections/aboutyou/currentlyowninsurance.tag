<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Currently own private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="hideHelpText" required="false" rtexprvalue="true"	 description="Hide the Help tooltip" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="health insurance status" quoteChar="\"" /></c:set>
<c:set var="alreadyHaveHealthInsurance"><content:get key="alreadyHaveHealthInsurance" /></c:set>

<c:set var="theHelpid" value="" />
<c:set var="hideHelpText">
	<c:choose>
		<c:when test="${not empty hideHelpText and hideHelpText eq true}"><c:set var="theHelpid" value="" /></c:when>
		<c:otherwise><c:set var="theHelpid" value="587" /></c:otherwise>
	</c:choose>
</c:set>

<form_v4:row hideRowBorder="true" label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover" className="lhcRebateCalcTrigger" helpId="${theHelpid}">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Do you currently hold private health insurance?" required="true" className="health-cover_details" id="${name}_health_cover" additionalLabelAttributes="${analyticsAttr}"/>

	<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content">${alreadyHaveHealthInsurance}</div>
	</div>

</form_v4:row>