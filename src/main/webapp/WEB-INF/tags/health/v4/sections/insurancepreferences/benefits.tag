<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<simples:dialogue id="49" vertical="health" />

<form_v2:fieldset legend="What would you like covered in your new health insurance policy?" postLegend="Select all the hospital and extras benefits that yo uwould like covered in your new insurance policy.">
	<field_v1:hidden xpath="${pageSettings.getVerticalCode()}/benefits/covertype" defaultValue="medium" />
	<div class="scrollable row">

		<div class="benefits-list col-sm-12">
			<c:set var="fieldXPath" value="${xpath}/coverType" />
				<%-- Taken this from the general_select. I don't like it. Please explain. :D--%>
				<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
				<sql:query var="result">
					SELECT code, description FROM aggregator.general WHERE type = 'healthCvrType' AND (status IS NULL OR status != 0) ORDER BY orderSeq
				</sql:query>

				<c:set var="sep"></c:set>
				<c:set var="items">
					<c:forEach var="row" items="${result.rows}">
						${sep}${row.code}=${row.description}
						<c:set var="sep">,</c:set>
					</c:forEach>
				</c:set>

				<c:set var="label" value="" />
				<c:if test="${not callCentre}">
					<c:set var="label" value="What type of cover are you looking for?" />
				</c:if>
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="cover type" quoteChar="\"" /></c:set>
				<form_v4:row label="${label}" fieldXpath="${fieldXpath}">
					<field_v2:array_radio xpath="${fieldXPath}"
										  required="true"
										  className="health-situation-healthCvrType roundedCheckboxIcons"
										  items="${items}"
										  defaultValue="C"
										  id="${go:nameFromXpath(fieldXPath)}"
										  title="your cover type"
										  additionalLabelAttributes="${analyticsAttr}" />
				</form_v4:row>
		</div>
	</div>
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

