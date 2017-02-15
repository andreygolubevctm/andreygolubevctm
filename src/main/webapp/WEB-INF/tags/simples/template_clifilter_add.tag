<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-clifilter-add" type="text/html">

<div class="simples-clifilter-modal">
	<div class="simples-clifilter-modal-header">
		<h2>Add to CLI Filter</h2>
	</div>
	<div class="simples-clifilter-modal-body">
		{{ if (typeof successMessage !== 'undefined' && successMessage.length > 0) { }}
			<div class="alert alert-success">{{= successMessage }}</div>
		{{ } }}
		{{ if (typeof errorMessage !== 'undefined' && errorMessage.length > 0) { }}
			<div class="alert alert-danger">{{= errorMessage }}</div>
		{{ } }}
		<form id="simples-add-clifilter" class="form-horizontal">
			<div class="form-group row">
				<label for="phone" class="col-xs-3 control-label">Phone Number</label>
				<div class="row-content col-xs-6">
					<input type="text" name="phone" class="form-control phone" placeholder="0x xxxx xxxx" size="10">
				</div>
			</div>
			<div class="row text-right">
				<div class="col-xs-9  text-right">
					<span class="form-error text-danger"></span>
					<a data-provide="simples-clifilter-submit" class="btn btn-warning">Add to CLI Filter</a>
				</div>
			</div>
		</form>
	</div>
</div>

</script>