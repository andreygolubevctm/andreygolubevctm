<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select element for what type of cover you're after eg Combined, Hospital or Extras"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="CSS class to be applied to the parent container" %>

<%-- VARIABLES --%>
<c:set var="fieldXpath" value="${xpath}/quickSelectHospital" />
<c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="benefits quickSelectHospital" quoteChar="\"" /></c:set>

<div id="${name}-container" class="${className}">
	<h3>Quick select from common conditions</h3>
	<p>Add any conditions below that relate to you and we'll pre-select all the related hospital cover services typically needed for treatment of that condition.</p>
	<div class="options-container"></div>
	<field_v1:hidden xpath="${xpath}/quickSelectHospital" />
</div>