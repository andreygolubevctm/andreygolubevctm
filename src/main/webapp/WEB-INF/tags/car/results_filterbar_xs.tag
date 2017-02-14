<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core_v1:js_template id="car-${name}-template">

	<form_v2:fieldset legend="" id="${name}FieldSet">

		<c:set var="coverTypeOptions">
			<c:choose>
				<c:when test="${skipNewCoverTypeCarJourney eq true or pageSettings.getBrandCode() ne 'ctm'}">COMPREHENSIVE=Comprehensive</c:when>
				<c:otherwise>COMPREHENSIVE=Comprehensive,TPFT=Third party property&#44; fire and theft,TPPD=Third party property</c:otherwise>
			</c:choose>
		</c:set>

		<form_v2:row label="Cover Type" id="${name}CoverType" className="initial">
			<c:set var="analAttribute"><field_v1:analytics_attr analVal="Cover Type" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${xpath}/coverType" style="vertical" required="true"
				className="" items="${coverTypeOptions}" title="" additionalLabelAttributes="${analAttribute}" />
		</form_v2:row>

		<form_v2:row label="Excess" id="${name}ExcessRow">
			<div class="select">
				<span class="input-group-addon"><i class="icon-sort"></i></span>
				<c:set var="analAttribute"><field_v1:analytics_attr analVal="Excess" quoteChar="\"" /></c:set>
				<field_v1:additional_excess
						defaultVal="800"
						increment="100"
						minVal="400"
						xpath="${xpath}/excess"
						maxCount="17"
						title=""
						required=""
						omitPleaseChoose="Y"
						className="form-control"
						additionalAttributes="${analAttribute}" />
			</div>
		</form_v2:row>

	</form_v2:fieldset>

</core_v1:js_template>