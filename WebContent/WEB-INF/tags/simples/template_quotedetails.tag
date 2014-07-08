<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-quotedetails" type="text/html">

<div class="simples-search-modal">
	<div id="simples-search-modal-header" class="row">
		<div class="col-xs-4">
			<h4>Quote details</h4>
		</div>
		<div class="col-xs-8 text-right">
			<form class="simples-search-quotedetails form-inline" role="search">
				<div class="form-group">
					<input type="text" name="keywords" class="form-control input-sm" value="{{= obj.keywords }}" placeholder="Email or transaction ID">
				</div>
				<button type="submit" class="btn btn-default btn-sm">Find</button>
			</form>
		</div>
	</div>

	{{ if (typeof errorMessage !== 'undefined' && errorMessage.length > 0) { }}
		<div class="alert alert-danger">{{= errorMessage }}</div>
	{{ } }}

	<div id="quote-details-container">
	</div>
</div>

</script>