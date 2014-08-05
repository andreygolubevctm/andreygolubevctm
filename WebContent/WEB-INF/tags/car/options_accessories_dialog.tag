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
		<div class="tab-pane quote-optional-accessories">
			<form_new:fieldset legend="Add non-standard accessories to your car">
				<p class="no-items-found">No non-standard accessories have been found for your selected vehicle.</p>
				<div class="items-found">
					<p>By listing all the non-standard accessories the insurer will be able to get a more accurate idea of the car's true value.</p>
					<div class="row added-items">
						<ul>{{= selectedAccessories }}</ul>
					</div>
					<div class="row inner-form">
						<div class="ac-type">
							<label for="quote_nonstandard_accessoriesList">Option / Accessory Type</label>
							<div class="select">
								<span class="input-group-addon"><i class="icon icon-sort"></i></span>
								<select name="quote_nonstandard_accessoriesList" id="quote_nonstandard_accessoriesList" class="form-control" data-visible="true">{{= optionalAccessories }}</select>
							</div>
							<div class="error-field"><!-- empty --></div>
						</div>
						<div class="ac-included">
							<label for="quote_nonstandard_included">Included in purchase price of car</label>
							<field_new:array_radio xpath="quote/nonstandard/included" required="true"
								className="" items="Y=Yes,N=No"
								id="${name}" title="Option included in purchase price of car" />
						</div>
						<div class="ac-price">
							<label for="quote_nonstandard_price">Accessory purchase price</label>
							<field_new:input type="text" xpath="quote/nonstandard/price" required="${required}"
									className="${classname} numeric" maxlength="${7}"
									title="${title}" pattern="[0-9]" integerKeyPressLimit="true" />
							<div class="error-field"><!-- empty --></div>
						</div>
						<div class="ac-add">
							<button type="button" class="btn btn-info">Add Selection</button>
						</div>
						<div class="ac-clear">
							<button type="button" class="btn btn-cancel">Clear</button>
						</div>
					</div>
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