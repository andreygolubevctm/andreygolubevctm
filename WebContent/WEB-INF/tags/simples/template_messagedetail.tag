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

	{{ } else if (obj.messageId === 0) { }}

		<p>There are either no active messages in the queue, or current time is outside call centre hours.</p>

	{{ } else if (obj === false) { }}

		<p><!-- No current message. --></p>

	{{ } else { }}

		<h2>Current Message</h2>

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
					<td>
						{{ if (obj.phoneNumber1 && obj.phoneNumber1 != '') { }}
						<button data-phone="{{= obj.phoneNumber1 }}" class="btn-form btn icon-phone"><span>&nbsp;{{= obj.phoneNumber1 }}</span></button>
						{{ } if (obj.phoneNumber2 && obj.phoneNumber2 != '') { }}
						<button data-phone="{{= obj.phoneNumber2 }}" class="btn-form btn icon-phone"><span>&nbsp;{{= obj.phoneNumber2 }}</span></button>
						{{ } }}
						<button class="btn btn-tertiary messagedetail-loadbutton">Amend quote <span class="icon icon-arrow-right"></span></button>
					</td>
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