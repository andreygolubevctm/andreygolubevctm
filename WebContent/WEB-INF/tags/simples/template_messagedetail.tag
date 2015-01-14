<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-messagedetail" type="text/html">

<div class="messagedetail-container">
	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}

		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}

	{{ } else if (obj === false) { }}

		<p><!-- No current message. --></p>

	{{ } else if (obj.message.messageId === 0) { }}

		<p>There are either no active messages in the queue, or current time is outside call centre hours.</p>

	{{ } else { }}

		<h2>Current Message</h2>

		<table class="table table-condensed table-hover">
			<tbody>
				<tr>
					<th width="26%">Status</th>
					<td>{{= obj.message.status }} (Message ID: {{= obj.message.messageId }})</td>
				</tr>
				<tr>
					<th>Brand/Vertical</th>
					<td>{{= obj.transaction.styleCodeName }} - {{= obj.transaction.verticalCode }}</td>
				</tr>
				<tr>
					<th>Contact name</th>
					<td>{{= obj.message.contactName }}</td>
				</tr>
				<tr>
					<th>State</th>
					<td>{{= obj.message.state }}</td>
				</tr>
				<tr>
					<th>Numbers to call</th>
					<td>
						{{ if (obj.message.phoneNumber1 && obj.message.phoneNumber1 != '') { }}
						<button data-phone="{{= obj.message.phoneNumber1 }}" class="btn btn-form"><span class="icon icon-phone"></span> {{= obj.message.phoneNumber1 }}</button>
						{{ } if (obj.message.phoneNumber2 && obj.message.phoneNumber2 != '') { }}
						<button data-phone="{{= obj.message.phoneNumber2 }}" class="btn btn-form"><span class="icon icon-phone"></span> {{= obj.message.phoneNumber2 }}</span></button>
						{{ } }}
						<button class="btn btn-tertiary messagedetail-loadbutton">Amend quote <span class="icon icon-arrow-right"></span></button>
					</td>
				</tr>
				{{ if (obj.hasOwnProperty('verticalProperties')) { }}
				{{ _.each(obj.verticalProperties, function(value, key) { }}
					<tr>
						<th>{{= key }}</th><td>{{= value }}</td>
					</tr>
				{{ }) }}
				{{ } }}
			</tbody>
		</table>

		{{ var commentTemplate = _.template($("#simples-template-comments").html()); }}
		{{= commentTemplate(obj) }}

		{{ var touchTemplate = _.template($("#simples-template-touches").html()); }}
		{{= touchTemplate(obj) }}

		{{ var auditTemplate = _.template($("#simples-template-audits").html()); }}
		{{= auditTemplate(obj) }}

	{{ } }}
</div>

</script>