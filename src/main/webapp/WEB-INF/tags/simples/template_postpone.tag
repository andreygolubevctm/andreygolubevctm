<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-postpone" type="text/html">

<div class="postpone-container" data-id="{{= obj.transactionId }}">

	<h2>{{= obj.heading}}</h2>

	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}
		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}
	{{ } }}

	<div class="row">
	{{ if(obj.parentStatusId == 31 || obj.parentStatusId == 32){ }}
		<div class="col-sm-3">
	{{ } else { }}
		<div class="col-sm-5">
	{{ } }}
			<field_v2:calendar mode="inline" xpath="postponedate" required="true" title="postpone date" minDate="" maxDate="" validateMinMax="false" />
		</div>
	{{ if(obj.parentStatusId == 31 || obj.parentStatusId == 32){ }}
		<div class="col-sm-5">
	{{ } else { }}
		<div class="col-sm-6">
	{{ } }}
			<div class="row">
				<div class="col-sm-12">
					<h5>Select a time</h5>

					<div class="row">
						<div class="col-xs-4">
							<field_v2:array_select items="01=01|02=02|03=03|04=04|05=05|06=06|07=07|08=08|09=09|10=10|11=11|12=12" required="true" title="Hour" xpath="postponehour" className="" delims="|" />
						</div>
						<div class="col-xs-4">
							<field_v2:array_select items="00=00|05=05|10=10|15=15|20=20|25=25|30=30|35=35|40=40|45=45|50=50|55=55" required="true" title="Minute" xpath="postponeminute" className="" delims="|" />
						</div>
						<div class="col-xs-4">
							<field_v2:array_radio items="AM=AM,PM=PM" required="true" title="AM/PM" xpath="postponeampm" className="postponeampmgroup" />
						</div>
					</div>
					<div class="timeWarning">Enter time above in Qld local time and allow for customer's local time difference (e.g. daylight saving time)</div>
				</div>
			</div>

			<c:if test="${!pageSettings.getSetting('inInEnabled')}">
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
			</c:if>

			<div class="row">
				<div class="col-sm-12">
					<h5>Comments</h5>
					<textarea class="form-control" placeholder="Write your comments here"></textarea>
				</div>
			</div>

		</div>

	{{ if(obj.parentStatusId == 31 || obj.parentStatusId == 32){ }}
		<div class="col-sm-4">
			<h5>Personal Messages</h5>
			<div class="personal-messages-container"><!-- empty --></div>
		</div>
	{{ } }}
	</div>

</div>

</script>