<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Currently own private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="health insurance status" quoteChar="\"" /></c:set>
<form_v4:row label="Already have private health insurance cover?" fieldXpath="${fieldXpath}" id="${name}_primaryCover" className="lhcRebateCalcTrigger">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover" additionalLabelAttributes="${analyticsAttr}"/>

	<c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${name}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content">Waiting periods you have already served will automatically be transferred to your new fund, and you won&apos;t need to serve them again. You’ll only need to serve waiting periods for any new or higher benefits that were not part of your old policy.</div>
	</div>

</form_v4:row>