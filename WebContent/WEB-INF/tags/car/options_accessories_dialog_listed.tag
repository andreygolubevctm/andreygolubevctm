<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core:js_template id="quote-nonstandard-accessories-template">
<div id="${name}Dialog">
	<div class="tab-content">
		<div class="tab-pane quote-optional-accessories-listed">
			<form_new:fieldset legend="">
				<p class="no-items-found">No non-standard accessories have been found for your selected vehicle.</p>
				<div class="items-found">
					<div id="injectIntoHeader">
						<div class="row">
							<div class="col-xs-12">
								<p>By listing all the non-standard accessories the insurer will be able to get a more accurate idea of the car's true value.</p>
							</div>
						</div>
						<div class="row accessoriesHeader">
							<div class="col-xs-5">
								<p>
									Accessory
								</p>
							</div>
							<div class="col-xs-7">
								<p>
									Included or approximate Purchase Price
								</p>
							</div>
						</div>
					</div>
					{{ $.each(vehicleNonStandardAccessories, function(index, vehicleNonStandardAccessory) { }}
						<div class="row accessoryRow">
							<div class="col-xs-5">
								{{ if (vehicleNonStandardAccessory.checked) { }}
									<field_new:checkbox xpath="quote/nonstandard/acc" id="{{= index }}_checkbox" className="nonStandardAccessoryCheckbox" value="{{= vehicleNonStandardAccessory.code }}" required="false" label="{{= vehicleNonStandardAccessory.label }}" title="{{= vehicleNonStandardAccessory.label }}" customAttribute="itemIndex='{{= index }}' checked='checked'" />
								{{ } else { }}
									<field_new:checkbox xpath="quote/nonstandard/acc" id="{{= index }}_checkbox" className="nonStandardAccessoryCheckbox" value="{{= vehicleNonStandardAccessory.code }}" required="false" label="{{= vehicleNonStandardAccessory.label }}" title="{{= vehicleNonStandardAccessory.label }}" customAttribute="itemIndex='{{= index }}'" />
								{{ } }}
							</div>
							<div class="col-xs-7">
								{{ if (vehicleNonStandardAccessory.checked) { }}
									<select class="form-control nonStandardAccessorySelect" required itemIndex="{{= index }}">
								{{ } else { }}
									<select class="form-control nonStandardAccessorySelect" required itemIndex="{{= index }}" disabled="true">
								{{ } }}
									{{= vehicleNonStandardAccessory.priceDropdown }}
								</select>
							</div>
						</div>
					{{ }); }}
				</div>
			</form_new:fieldset>
		</div>
		<div class="tab-pane quote-standard-accessories">
			<form_new:fieldset legend="These are fitted standard to your vehicle and do not need to be declared">
				<p class="no-items-found">No included standard accessories have been found for your selected vehicle.</p>
				<div class="row items-found">
					<ul>{{= standardAccessories }}</ul>
				</div>
			</form_new:fieldset>
		</div>
	</div>
</div>
</core:js_template>