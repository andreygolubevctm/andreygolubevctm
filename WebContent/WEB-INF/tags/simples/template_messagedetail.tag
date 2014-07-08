<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-messagedetail" type="text/html">

<div class="messagedetail-container">
	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}

		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>

			{{ if (error.message === 'No message available.') { }}
				<p>There are either no active messages in the queue, or current time is outside call centre hours.</p>
			{{ } }}
		{{ }) }}

	{{ } else { }}

		<table class="table table-condensed table-hover">
			<tbody>
				<tr>
					<th width="30%">Status</th>
					<td>{{= obj.status }} (Message ID: {{= obj.messageId }})</td>
				</tr>
				<tr>
					<th>Brand/Vertical</th>
					<td>{{= obj.styleCodeName }} - {{= obj.vertical }}</td>
				</tr>
				<tr>
					<th>Contact name</th>
					<td>{{= obj.contactName }}</td>
				</tr>
				<tr>
					<th>State</th>
					<td>{{= obj.state }}</td>
				</tr>
				<tr>
					<th>Numbers to call</th>
					<td>{{= obj.phoneNumber1 }}
						{{ if (obj.phoneNumber1 && obj.phoneNumber1 != '') { }}<br>{{ } }}
						{{= obj.phoneNumber2 }}</td>
				</tr>
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