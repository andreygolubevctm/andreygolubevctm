<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Currently own private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="hideHelpText" required="false" rtexprvalue="true"	 description="Hide the Help tooltip" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/abd" />
<c:set var="abdSubLabel">
	<health_v4:abd_whats_this shortTitle='true' />
</c:set>

<form_v4:row hideRowBorder="true" label="Does your current health cover include an Age-Based Discount?" subLabel="${abdSubLabel}" id="${name}_primaryhasABD" fieldXpath="${fieldXpath}"  className="lhcRebateCalcTrigger primaryHasABD hidden">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Does your current health cover include an Age-Based Discount?" required="true" />

	<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content">Blah</div>
	</div>

	<div class="abd-support-text hidden" id="single_18_to_30">
		<p>Text A</p>
		<p>Because you’re under 30, you may be eligible to receive an Age-Based discount on applicable health insurance policies. Look out for the <health_v4:abd_badge abd='true' /> badge when you get to your comparison results.</p>
		<health_v4:abd_whats_this shortTitle='false' />
	</div>

	<div class="abd-support-text hidden" id="single_has_abd_policy">
		<p>Text B</p>
		<p>Based on what you’ve told us, because you currently hold a policy with an Age-Based Discount, you may be eligible to retain that discount provided you choose a policy with the badge <health_v4:abd_badge abd='false' /> when you get to your comparison results.</p>
		<health_v4:abd_whats_this shortTitle='false' />
	</div>

</form_v4:row>