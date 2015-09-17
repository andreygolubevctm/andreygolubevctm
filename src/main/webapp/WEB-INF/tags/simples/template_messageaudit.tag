<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-audits" type="text/html">

<c:if test="${isRoleSupervisor or isRoleIT}">
	<div class="audit-container">

		<%-- AUDITS --%>
		<h2>Message Audit</h2>

		{{ if (typeof messageaudits !== 'undefined' && messageaudits.length > 0) { }}
			<table class="table table-condensed table-hover">
				<thead>
					<tr>
						<th width="26%"><strong>Date</strong></th>
						<th width="15%"><strong>Operator</strong></th>
						<th width="30%"><strong>Status</strong></th>
						<th><strong>Reason</strong></th>
					</tr>
				</thead>

				<%-- Filter the comments to only the types that matter for an operator --%>
				<tbody>
				{{ _.each(messageaudits, function(audit) { }}
					<tr>
						<td>{{= audit.created }}</td>
						<td>{{= audit.operator }}</td>
						<td>{{= audit.status }}</td>
						<td>{{= audit.reasonStatus }}</td>
					</tr>
				{{ }) }}
				</tbody>
			</table>
		{{ } else { }}

			<p>No audit found.</p>

		{{ }/*audits*/ }}

	</div>

</c:if>

</script>