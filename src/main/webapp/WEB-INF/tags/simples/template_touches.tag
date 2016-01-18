<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-touches" type="text/html">


<c:choose>
	<c:when test="${isRoleSupervisor or isRoleIT}">{{ var isAdmin = true; }}</c:when>
	<c:otherwise>{{ var isAdmin = false; }}</c:otherwise>
</c:choose>

<div class="touch-container">

	<%-- TOUCHES --%>
	<h2>Latest Touches</h2>

	{{ if (typeof touches !== 'undefined' && touches.length > 0) { }}
		<table class="table table-condensed table-hover">
			<thead>
				<tr>
					<th width="26%"><strong>Date</strong></th>
					<th width="15%"><strong>Operator</strong></th>
					<th><strong>Action</strong></th>
					<th width="15%"><strong>Transaction</strong></th>
				</tr>
			</thead>

			<%-- Filter the comments to only the types that matter for an operator --%>
			<tbody>
			{{ var displayTouches = ['N','R','A','P','F','C','L','S', 'B']; }}
			{{ var count = 0; }}
			{{ _.each(touches, function(touch) { }}
				{{ if ((touch.type === null || _.indexOf(displayTouches, touch.type.code) == -1 ) || (isAdmin !== true && count >= 1)) return; }}
				{{ var _des = touch.type.description; }}
				<tr>
					<td>{{= touch.datetime }}</td>
					<td>{{= touch.operator }}</td>
					<td>
						{{ if( touch.touchProductProperty !== null) { }}
							{{= _des }}: {{= touch.touchProductProperty.providerName }} {{= touch.touchProductProperty.productName }}
						{{ } else { }}
							{{= _des }}
						{{ } }}
					</td>
					<td>{{= touch.transactionId }}</td>
				</tr>
				{{ count++; }}
			{{ }) }}
			</tbody>
		</table>
	{{ } else { }}

		<p>No activity found.</p>

	{{ }/*touches*/ }}
</div>

</script>