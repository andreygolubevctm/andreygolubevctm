<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core_v1:js_template id="home-${name}-template">

	<form_v2:fieldset legend="" id="${name}FieldSet">

		<form_v2:row label="Home Excess" id="${name}HomeExcessRow">
			<div class="select">
				<span class="input-group-addon"><i class="icon-sort"></i></span>
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Home Excess" quoteChar="\"" /></c:set>
				<field_v1:additional_excess
					defaultVal="500"
					increment="100"
					minVal="100"
					xpath="${xpath}/homeExcess"
					maxCount="5"
					title=""
					required=""
					omitPleaseChoose="Y"
					className="form-control"
					additionalValues="750,1000,1500,2000,3000,4000,5000,6000"
					additionalAttributes="${analyticsAttr}" />
			</div>
		</form_v2:row>

		<form_v2:row label="Contents Excess" id="${name}ContentsExcessRow">
			<div class="select">
				<span class="input-group-addon"><i class="icon-sort"></i></span>
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Contents Excess" quoteChar="\"" /></c:set>
				<field_v1:additional_excess
						defaultVal="500"
						increment="100"
						minVal="100"
						xpath="${xpath}/contentsexcess"
						maxCount="5"
						title=""
						required=""
						omitPleaseChoose="Y"
						className="form-control"
						additionalValues="750,1000,1500,2000,3000,4000,5000"
						additionalAttributes="${analyticsAttr}" />
			</div>
		</form_v2:row>
		<div class="dropdown landlordShowAll isLandlord mobile-drop">
			<span>Only show products that include:</span>
			<div class="landlord-filter-items">
				<div class="checkbox">
					<input type="checkbox" checked name="showall" id="showall_m" />
					<label for="showall_m" class=""></label>
					Show All
				</div>
				<div class="checkbox">
					<input type="checkbox" name="lossrent" id="lossrent_m" />
					<label for="lossrent_m"></label>
					Loss of rent
				</div>
				<div class="checkbox">
					<input type="checkbox" name="malt" id="malt_m" />
					<label for="malt_m"></label>
					Malicious damage
				</div>
				<div class="checkbox">
					<input type="checkbox" name="rdef" id="rdef_m" />
					<label for="rdef_m"></label>
					Tenant default
				</div>
			</div>
		</div>

	</form_v2:fieldset>

</core_v1:js_template>