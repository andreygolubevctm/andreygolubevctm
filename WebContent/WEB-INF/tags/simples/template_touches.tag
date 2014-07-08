<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-touches" type="text/html">

<div class="touch-container">

	<%-- TOUCHES --%>
	<h5>Latest touches:</h5>

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
			{{ _.each(touches, function(touch) { }}
				{{ var _type = ''; }}
				{{ if ('N' === touch.type) _type = 'New quote'; }}
				{{ if ('R' === touch.type) _type = 'Price presentation'; }}
				{{ if ('A' === touch.type) _type = 'Apply'; }}
				{{ if ('P' === touch.type) _type = 'Submit'; }}
				{{ if ('F' === touch.type) _type = 'Join failed'; }}
				{{ if ('C' === touch.type) _type = 'Policy sold'; }}
				{{ if ('L' === touch.type) _type = 'Load quote'; }}
				{{ if ('S' === touch.type) _type = 'Saved quote'; }}
				{{ if (_type !== '') { }}
				<tr>
					<td>{{= touch.datetime }}</td>
					<td>{{= touch.operator }}</td>
					<td>
						{{ if ('C' === touch.type) { }}
							{{= _type}}: {{= obj.selectedProductProvider }} {{= obj.selectedProductTitle }}</span>
						{{ } else { }}
							{{= _type }}
						{{ } }}
					</td>
					<td>{{= touch.transactionId }}</td>
				</tr>
				{{ } }}
			{{ }) }}
			</tbody>
		</table>
	{{ } else { }}

		<p>No activity found.</p>

	{{ }/*touches*/ }}
</div>

</script>