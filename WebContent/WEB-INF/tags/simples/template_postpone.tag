<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-postpone" type="text/html">

<div class="postpone-container"
	data-id="{{= obj.transactionId }}">

	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}
		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}
	{{ } }}

	<c:set var="fieldXpath" value="postponedate" />
	<form_new:row fieldXpath="${fieldXpath}" label="Postpone to" hideHelpIconCol="true">
		<div class="row">
			<div class="col-xs-6">
				<field_new:calendar mode="component" xpath="${fieldXpath}" required="true" title="postpone date" minDate="today" maxDate="+7d" validateMinMax="false" />
			</div>
			<div class="col-xs-3">
				<field_new:input xpath="postponetime" required="true" placeHolder="HH:mm" />
			</div>
		</div>
	</form_new:row>

	<form_new:row fieldXpath="reason" label="Reason" hideHelpIconCol="true">
		<select name="reason" class="form-control">
			{{ _.each(obj.statuses, function(status) { }}
				<option value="{{= status.id }}">{{= status.status }}</option>
			{{ }) }}
		</select>
	</form_new:row>

	<form_new:row label="Comment" className="comment-inputfields" hideHelpIconCol="true">
		<textarea class="form-control" placeholder="Write optional comment here..."></textarea>
	</form_new:row>

	<form_new:row label="" hideHelpIconCol="true">
		<div class="checkbox">
			<input type="checkbox" name="assigntome" id="assigntome" class="checkbox-custom" value="Y" checked>
			<label for="assigntome">Assign to me</label>
		</div>
	</form_new:row>
</div>

</script>