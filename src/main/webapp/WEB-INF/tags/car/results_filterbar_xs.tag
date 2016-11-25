<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core_v1:js_template id="car-${name}-template">

	<form_v2:fieldset legend="" id="${name}FieldSet">

		<form_v2:row label="Cover Type" id="${name}CoverType" className="initial">
			<field_v2:array_radio xpath="${xpath}/coverType" style="vertical" required="true"
				className="" items="COMPREHENSIVE=Comprehensive,TPFT=3rd party property&#44; fire and theft,TPPD=3rd party property," title="" />
		</form_v2:row>

		<form_v2:row label="Excess" id="${name}ExcessRow">
			<div class="select">
				<span class="input-group-addon"><i class="icon-sort"></i></span>
				<field_v1:additional_excess
						defaultVal="800"
						increment="100"
						minVal="400"
						xpath="${xpath}/excess"
						maxCount="17"
						title=""
						required=""
						omitPleaseChoose="Y"
						className="form-control" />
			</div>
		</form_v2:row>

	</form_v2:fieldset>

</core_v1:js_template>