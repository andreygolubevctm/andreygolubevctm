<%@ tag description="Simples search result more info template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-moreinfo" type="text/html">

	<%-- ERRORS --%>
	{{ if (typeof errorMessage !== 'undefined' && errorMessage.length > 0) { }}
		<div class="alert alert-danger">{{= errorMessage }}</div>
	{{ } }}

	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}
		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}
	{{ } }}

	<%-- ADDITIONAL INFO FROM ORIGINAL SEARCH RESULT --%>
	{{ if (typeof resultData !== 'undefined') { }}
		<table class="table table-condensed table-hover">
			<tbody>
				<tr>
					<th width="30%">Status</th>
					<td>
						{{ if (editable === 'C') { }}
							<strong class="text-success">SOLD</strong>
							{{ if (typeof confirmationKey !== 'undefined' && confirmationKey.length > 0) { }}
								<a href="viewConfirmation?key={{= confirmationKey }}" class="btn btn-sm btn-success" target="_blank" title="Open quote's confirmation page">View confirmation</a>
							{{ } else { }}
								(confirmation ID unknown)
							{{ } }}
							<br>
							<span class="text-success">{{= obj.selectedProductProvider }} {{= obj.selectedProductTitle }}</span>

						{{ } else if (editable === 'F') { }}<strong class="text-primary">PENDING/FAILED</strong>
						{{ } else { }}<strong class="text-info">AVAILABLE</strong>{{ } }}
					</td>
				</tr>
				<tr>
					<th>State</th>
					<td>{{= resultData.state }}</td>
				</tr>
				<tr>
					<th>Primary applicant</th>
					<td>{{= contacts.primary.name }}{{ if (contacts.primary.dob !== '') { }}<br>{{= contacts.primary.dob }}{{ } }}</td>
				</tr>
				{{ if (contacts.partner.name !== '' || contacts.partner.dob !== '') { }}
					<tr>
						<th>Partner applicant</th>
						<td>{{= contacts.partner.name }}{{ if (contacts.partner.dob !== '') { }}<br>{{= contacts.partner.dob }}{{ } }}</td>
					</tr>
				{{ } }}
				{{ if (resultData.phone !== '') { }}
					<tr>
						<th>Phone</th>
						<td>{{= resultData.phone }}</td>
					</tr>
				{{ } }}
				{{ if (resultData.address !== '') { }}
					<tr>
						<th>Address</th>
						<td>{{= resultData.address }}</td>
					</tr>
				{{ } }}
			</tbody>
		</table>
	{{ } }}

	<hr>

	{{ var commentTemplate = _.template($("#simples-template-comments").html()); }}
	{{= commentTemplate(obj) }}

	<hr>

	{{ var touchTemplate = _.template($("#simples-template-touches").html()); }}
	{{= touchTemplate(obj) }}

</script>