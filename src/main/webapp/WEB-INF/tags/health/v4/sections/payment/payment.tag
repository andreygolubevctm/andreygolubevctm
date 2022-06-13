<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="className" 	required="false"  	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<health_v1:dual_pricing_settings />
<%-- Product summary header for mobile --%>
<div class="row productSummary-parent visible-xs">
    <div class="productSummary visible-xs">
        <health_v4_payment:policySummary />
    </div>
</div>
<div class="health-payment ${className}" id="${id}">

    <health_v4_payment:payment_details xpath="${xpath}/details" base_xpath="${xpath}" />

    <div class="update-content">
        <fieldset class="qe-window fieldset ">
            <div class="content">
                <health_v4_payment:application_compliance xpath="${xpath}" />
            </div>
        </fieldset>
    </div>
</div>