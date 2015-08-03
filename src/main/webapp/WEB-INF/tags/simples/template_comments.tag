<%@ tag description="Simples comments template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-comments" type="text/html">

<div class="comment-container"
	data-id="{{= obj.transactionId }}">

	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}
		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}
	{{ } }}

	<%-- COMMENTS --%>
	<button class="comment-hideshow btn btn-default btn-sm" style="float:right">Add comment</button>

	<h2>Comments<span class="comment-title-tranid"> for ID '{{= obj.transactionId }}'</span></h2>

	<div class="comment-inputfields text-right" style="display:none">
		<textarea class="form-control" placeholder="Write comment here..."></textarea>
		<span class="comment-error text-danger"></span>
		<button class="comment-addcomment btn btn-default btn-sm">Add comment</button>
	</div>

	{{ if (typeof comments !== 'undefined' && comments.length > 0) { }}
		<table class="table table-condensed table-hover">
			<thead>
				<tr>
					<%-- <th width="15%"><strong>Transaction</strong></th> --%>
					<th width="26%"><strong>Date</strong></th>
					<th width="15%"><strong>Operator</strong></th>
					<th><strong>Comment</strong></th>
				</tr>
			</thead>

			<tbody>
			{{ _.each(comments, function(comment) { }}
				<tr>
					<%-- <td>{{= comment.transactionId }}</td> --%>
					<td>{{= comment.datetime }}</td>
					<td>{{= comment.operator }}</td>
					<td>{{= comment.comment }}</td>
				</tr>
			{{ }) }}
			</tbody>
		</table>
	{{ } else { }}

		<p>No comments.</p>

	{{ }/*comments*/ }}

</div>

</script>