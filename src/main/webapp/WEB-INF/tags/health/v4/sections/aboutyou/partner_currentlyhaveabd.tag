<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Currently own private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="hideHelpText" required="false" rtexprvalue="true"	 description="Hide the Help tooltip" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/partner/abd" />
<c:set var="abdSubLabel">
	<health_v4:abd_whats_this shortTitle='true' />
</c:set>


<form_v4:row hideRowBorder="true" label="Does your partner's current health cover include an Age-Based Discount?" subLabel="${abdSubLabel}" id="${name}_partnerhasABD" fieldXpath="${fieldXpath}"  className="lhcRebateCalcTrigger partnerHasABD hidden">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Does your current health cover include an Age-Based Discount?"  id="partner_abd_health_cover" className="health-cover_details_partner_abd_current" required="true" />

	<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content"></div>
	</div>
</form_v4:row>

	<div class="abd-support-text hidden" id="couple_both_has_abd">
		<p>Based on what you’ve told us, because both you and your partner currently hold a policy with an Age-Based Discount, you may be eligible to retain that discount provided you choose a policy with the badge <health_v4:abd_badge abd='false' /> when you get to your comparison results.</p>
		<health_v4:abd_whats_this shortTitle='false' />
	</div>

	<div class="abd-support-text hidden" id="couple_one_has_abd">
		<p>Based on what you’ve told us, because one of you currently holds a policy with an Age-Based Discount, you may be eligible to retain that discount provided you choose a policy with the badge <health_v4:abd_badge abd='false' /> when you get to your comparison results.</p>
		<health_v4:abd_whats_this shortTitle='false' />
	</div>

	<div class="abd-support-text hidden" id="couple_both_18_to_30">
		<p>Based on what you’ve told us, because both you and your partner are under 30, you may be eligible to receive an Age-Based discount on applicable health insurance policies. Look out for the <health_v4:abd_badge abd='true' /> badge when you get to your comparison results.</p>
		<health_v4:abd_whats_this shortTitle='false' />
	</div>

	<div class="abd-support-text hidden" id="couple_one_18_to_30">
		<p>Based on what you’ve told us, one of you may be eligible to receive an Age-Based discount on applicable health insurance policies. Look out for the <health_v4:abd_badge abd='true' /> badge when you get to your comparison results.</p>
		<health_v4:abd_whats_this shortTitle='false' />
	</div>