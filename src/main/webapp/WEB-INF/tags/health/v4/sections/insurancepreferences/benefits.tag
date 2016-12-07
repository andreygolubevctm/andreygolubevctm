<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<simples:dialogue id="49" vertical="health" />

<form_v2:fieldset legend="What would you like covered in your new health insurance policy?" postLegend="Select all the hospital and extras benefits that you would like covered in your new insurance policy.">
	<field_v1:hidden xpath="${pageSettings.getVerticalCode()}/benefits/covertype" defaultValue="medium" />
</form_v2:fieldset>

<simples:dialogue id="46" className="simples-dialogue-hospital-cover" vertical="health" />

<%-- TEMPLATES --%>
<core_v1:js_template id="benefits-explanation">
	<content:get key="coverPopup" />
</core_v1:js_template>

<c:forEach items="${resultTemplateItems}" var="selectedValue">
	<health_v4_insuranceprefs:benefitsItem item="${selectedValue}" />
</c:forEach>

<core_v1:js_template id="customise-cover-template">
	<content:get key="customiseCoverTemplate"/>
</core_v1:js_template>

