<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<simples:dialogue id="49" vertical="health" />

<form_v2:fieldset legend="What would you like covered in your new health insurance policy?" postLegend="Select all the hospital and extras benefits that you would like covered in your new insurance policy." className="mainBenefitHeading">
	<field_v1:hidden xpath="${pageSettings.getVerticalCode()}/benefits/covertype" defaultValue="medium" />
</form_v2:fieldset>

<simples:dialogue id="46" className="simples-dialogue-hospital-cover" vertical="health" />

<field_v1:hidden xpath="${pageSettings.getVerticalCode()}/situation/coverType" defaultValue="C" />
<%-- Toggle for benefits --%>
<div class="hidden-sm hidden-md hidden-lg toggleBar" data-targetContainer=".ExtrasBenefitsContainer .content">
	<div class="selectionStatus extras">Your extras benefits selection <span>0</span></div>
	<div class="selectionStatus hospital">Your hospital benefits selection <span>0</span></div>
</div>
<div class="benefitsOverflow">
<c:forEach items="${resultTemplateItems}" var="selectedValue">
	<health_v4_insuranceprefs:benefitsItem item="${selectedValue}"  />
</c:forEach>
</div>