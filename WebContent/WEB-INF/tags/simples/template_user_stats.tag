<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-user-stats" type="text/html">

	<table class="table">
		<thead>
			<tr>
				<th colspan="6">Today&#39;s stats</th>
				<th colspan="2">Total</th>
			</tr>
			<tr>
				<th width="12%">Completed</th>
				<th width="12%">Unsuccessful</th>
				<th width="12%">Postponed</th>
				<th width="12%">Contact</th>
				<th width="12%">Sales</th>
				<th>Conversion</th>
				<th width="12%">Active</th>
				<th width="12%">Future</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>{{= obj.completed }}</td>
				<td>{{= obj.unsuccessful }}</td>
				<td>{{= obj.postponed }}</td>
				<td>{{= obj.contact }}%</td>
				<td>{{= obj.sales }}</td>
				<td>{{= obj.conversion }}%</td>
				<td>{{= obj.active }}</td>
				<td>{{= obj.future }}</td>
				<td></td>
			</tr>
		</tbody>
	</table>

</script>