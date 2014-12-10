<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-postpone" type="text/html">

<div class="postpone-container" data-id="{{= obj.transactionId }}">

	<h2>Postpone this message</h2>

	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}
		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}
	{{ } }}

	<div class="row">
		<div class="col-sm-5">
			<field_new:calendar mode="inline" xpath="postponedate" required="true" title="postpone date" minDate="" maxDate="" validateMinMax="false" />
		</div>

		<div class="col-sm-6">
			<div class="row">
				<div class="col-sm-12">
					<h5>Select a time</h5>

					<div class="row">
						<div class="col-xs-4">
							<field_new:array_select items="01=01|02=02|03=03|04=04|05=05|06=06|07=07|08=08|09=09|10=10|11=11|12=12" required="true" title="Hour" xpath="postponehour" className="" delims="|" />
						</div>
						<div class="col-xs-4">
							<field_new:array_select items="00=00|05=05|10=10|15=15|20=20|25=25|30=30|35=35|40=40|45=45|50=50|55=55" required="true" title="Minute" xpath="postponeminute" className="" delims="|" />
						</div>
						<div class="col-xs-4">
							<field_new:array_radio items="AM=AM,PM=PM" required="true" title="AM/PM" xpath="postponeampm" className="" />
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">
					<h5>Select a postpone reason</h5>

					<select name="reason" class="form-control">
						{{ _.each(obj.statuses, function(status) { }}
							<option value="{{= status.id }}">{{= status.status }}</option>
						{{ }) }}
					</select>
				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">
					<h5>Comments</h5>
					<textarea class="form-control" placeholder="Write your comments here"></textarea>
				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">
					<div class="checkbox">
						<input type="checkbox" name="assigntome" id="assigntome" class="checkbox-custom" value="Y">
						<label for="assigntome">Assign to me as a Personal Message</label>
					</div>
				</div>
			</div>

		</div>
	</div>

</div>

</script>