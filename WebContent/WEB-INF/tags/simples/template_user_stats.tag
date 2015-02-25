<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-user-stats" type="text/html">

	<table class="table">
		<thead>
			<tr>
				<th colspan="7">Today&#39;s stats</th>
				<th colspan="2" class="left-border">Total</th>
			</tr>
			<tr>
				<th>Completed</th>
				<th>Completed as PM</th>
				<th>Unsuccessful</th>
				<th>Postponed</th>
				<th>Contact</th>
				<th>Sales</th>
				<th>Conversion</th>
				<th class="left-border">Active</th>
				<th>Future</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>{{= obj.completed }}</td>
				<td>{{= obj.completedAsPM }}</td>
				<td>{{= obj.unsuccessful }}</td>
				<td>{{= obj.postponed }}</td>
				<td>{{= obj.contact }}%</td>
				<td>{{= obj.sales }}</td>
				<td>{{= obj.conversion }}%</td>
				<td class="left-border">{{= obj.active }}</td>
				<td>{{= obj.future }}</td>
				<td></td>
			</tr>
		</tbody>
	</table>

</script>