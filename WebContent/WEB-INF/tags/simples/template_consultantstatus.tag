<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-consultantstatus" type="text/html">

	<table class="table table-striped">
		<thead>
			<tr>
				<th>Consultant</th>
				<th>Extension</th>
				<th>Available</th>
			</tr>
		</thead>
		<tbody>
			{{ if (typeof users !== 'undefined' && users.length > 0) { }}
				{{ _.each(users, function(user) { }}
					<tr>
						<td>{{= user.displayName }} ({{= user.username }})</td>
						<td>{{= user.extension }}</td>
						<td>
							{{ if (user.available === true) { }}
								<span class="icon-tick text-success"></span>
							{{ } else { }}
								<span class="icon-cross text-warning"></span>
							{{ } }}
						</td>
					</tr>
				{{ }) }}
			{{ } }}
		</tbody>
	</table>

</script>