<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-clifilter-delete" type="text/html">

<div class="simples-clifilter-modal">
	<div class="simples-clifilter-modal-header">
		<h2>Remove from CLI Filter</h2>
	</div>
	<div class="simples-clifilter-modal-body">
		{{ if (typeof successMessage !== 'undefined' && successMessage.length > 0) { }}
			<div class="alert alert-success">{{= successMessage }}</div>
		{{ } }}
		{{ if (typeof errorMessage !== 'undefined' && errorMessage.length > 0) { }}
			<div class="alert alert-danger">{{= errorMessage }}</div>
		{{ } }}
		<form id="simples-delete-clifilter" class="form-horizontal">
			<div class="form-group row">
				<label for="phone" class="col-xs-3 control-label">Phone Number</label>
				<div class="row-content col-xs-6">
					<input type="text" name="phone" class="form-control phone" placeholder="0x xxxx xxxx" size="10">
				</div>
			</div>
			<div class="form-group row">
				<label for="comment" class="col-xs-3 control-label">Comment</label>
				<div class="row-content col-xs-6">
					<textarea name="comment" class="form-control" rows="7" placeholder="Enter the reason for the action..."></textarea>
				</div>
			</div>
			<div class="row text-right">
				<div class="col-xs-9  text-right">
					<span class="form-error text-danger"></span>
					<a data-provide="simples-clifilter-submit" class="btn btn-primary">Remove from CLI Filter</a>
				</div>
			</div>
		</form>
	</div>
</div>

</script>