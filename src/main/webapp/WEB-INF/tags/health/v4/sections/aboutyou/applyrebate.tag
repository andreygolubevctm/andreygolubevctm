<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checkbox to apply the rebate to lower the premium"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/rebate" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate application" quoteChar="\"" /></c:set>
<div class="col-xs-12">
	<field_v2:checkbox
			xpath="${fieldXpath}"
			value="Y"
			className="validate"
			required="false"
			label="${true}"
			title="Apply the Australian Government Rebate to lower my upfront premium"
			additionalLabelAttributes="${analyticsAttr}"
	/>
</div>