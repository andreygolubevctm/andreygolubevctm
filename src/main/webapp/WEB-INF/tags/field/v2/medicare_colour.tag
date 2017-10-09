<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the colour of the person's Medicare card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="variable's xpath" %>

<div id="health_medicareDetails_yellowCardMessage" class="hidden">
	Yellow card holders (reciprocal) have limited Medicare access and no benefit if you elect to be treated as a private patient in either a private or public hospital. You may choose private hospital cover for tax-purposes as the Medicare levy surcharge may still otherwise apply.
</div>

<div class="select">
	<span class=" input-group-addon">
		<i class="icon-sort"></i>
	</span>
    <field_v1:array_select xpath="${xpath}" items="=Please Choose...,green=Green,blue=Blue,yellow=Green/Yellow (Reciprocal),none=None of the above" className="dontSubmit" required="true" title="your Medicare card colour. To proceed with this policy, you must have a green, blue or yellow medicare card." />
</div>