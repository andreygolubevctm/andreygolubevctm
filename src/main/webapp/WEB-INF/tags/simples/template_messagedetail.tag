<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-messagedetail" type="text/html">

<div class="messagedetail-container">
	<%-- ERRORS --%>
	{{ if (typeof errors !== 'undefined' && errors.length > 0) { }}

		{{ _.each(errors, function(error) { }}
			<div class="alert alert-danger">{{= error.message }}</div>
		{{ }) }}

	{{ } else if (obj === false) { }}

		<p><!-- No current message. --></p>

	{{ } else if (obj.message.messageId === 0) { }}

		<p>There are either no active messages in the queue, or current time is outside call centre hours.</p>

	{{ } else { }}

		<h2>Current Message</h2>

		<table class="table table-condensed table-hover">
			<tbody>
				<tr>
					<th width="26%">Status</th>
					<td>{{= obj.message.status }} (Message ID: {{= obj.message.messageId }}) Latest Transaction ID: {{= obj.transaction.newestTransactionId}}</td>
				</tr>
				<tr>
					<th>Brand/Vertical</th>
					<td>{{= obj.transaction.styleCodeName }} - {{= obj.transaction.verticalCode }}</td>
				</tr>
				<tr>
					<th>Contact name</th>
					<td>{{= obj.message.contactName }}</td>
				</tr>
				<tr>
					<th>State</th>
					<td>{{= obj.message.state }}</td>
				</tr>
				<tr>
					<th><c:if test="${!pageSettings.getSetting('inInEnabled')}">Numbers to call</c:if></th>
					<td>
                        <c:if test="${!pageSettings.getSetting('inInEnabled')}">
						{{ if (obj.message.phoneNumber1 && obj.message.phoneNumber1 != '') { }}
						<button data-phone="{{= obj.message.phoneNumber1 }}" class="btn btn-form"><span class="icon icon-phone"></span> {{= obj.message.phoneNumber1 }}</button>
						{{ } if (obj.message.phoneNumber2 && obj.message.phoneNumber2 != '') { }}
						<button data-phone="{{= obj.message.phoneNumber2 }}" class="btn btn-form"><span class="icon icon-phone"></span> {{= obj.message.phoneNumber2 }}</button>
						{{ } }}
                        </c:if>
						{{ var isConfirmed = false }}
						{{ _.each(obj.touches, function(touch, key) { }}
							{{ if (touch.type && touch.type.code === 'C') { isConfirmed = true; return; } }}
						{{ }) }}
						{{ if (isConfirmed) { }}
							<span class="label label-success">SOLD</span>
						{{ } else { }}
						<button class="btn btn-tertiary messagedetail-loadbutton">Amend quote <span class="icon icon-arrow-right"></span></button>
						{{ } }}
					</td>
				</tr>
				{{ if (obj.hasOwnProperty('verticalProperties')) { }}
				<tr>
					<th>Primary DOB</th><td>{{= obj.verticalProperties['Primary DOB'] }}</td>
				</tr>
				<tr>
					<th>Email</th><td>{{= obj.verticalProperties['Email'] }}</td>
				</tr>
				{{ } }}

				{{ if (!meerkat.modules.benefitsNameConverter.checkIfClinicalCategories(obj.verticalProperties['Benefits source'])) { }}
				{{ var nonClinicalInfo = ['Address', 'Benefits', 'Situation']; nonClinicalInfo.forEach(function(item) { }}
				{{ if (!obj.verticalProperties[item]) { return; } }}
				<tr>
					<th>{{= item }}</th><td>{{= obj.verticalProperties[item] }}</td>
				</tr>
				{{ });} }}
				{{ if (obj.verticalProperties['Income level'] !== null && obj.verticalProperties['Income level'] !== undefined && obj.verticalProperties['Income level'] !== '') { }}
				<tr>
					<th>Income level</th><td>{{= meerkat.modules.benefitsNameConverter.getRebateTiers(obj.verticalProperties['Family Type'], obj.verticalProperties['Income level']) }}</td>
				</tr>
				{{ } }}
			</tbody>
		</table>
		{{ if (meerkat.modules.benefitsNameConverter.checkIfClinicalCategories(obj.verticalProperties['Benefits source'])) { }}
		<div class="line-separator"></div>
		<table class="table table-condensed table-hover">
			<tbody>
				{{ if (obj.hasOwnProperty('verticalProperties')) { }}
				<tr>
					<th width="26%">Product type</th><td>{{= meerkat.modules.benefitsNameConverter.covertProductType(obj.verticalProperties['Product type']) }}</td>
				</tr>
				<tr>
					<th>Reason</th><td>{{= meerkat.modules.benefitsNameConverter.convertReason(obj.verticalProperties['Reason']) }}</td>
				</tr>
				<tr>
					<th>Hospital quick selects</th><td>{{= meerkat.modules.benefitsNameConverter.convertHospital(obj.verticalProperties['Hospital quick selects']) }}</td>
				</tr>
				<tr>
					<th>Extras quick selects</th><td>{{= meerkat.modules.benefitsNameConverter.convertExtras(obj.verticalProperties['Extras quick selects']) }}</td>
				</tr>
				<tr>
					<th>Selected benefits</th><td>{{= obj.verticalProperties['Benefits'] }}</td>
				</tr>
				<tr>
					<th>Situation</th><td>{{= obj.verticalProperties['Situation'] }}</td>
				</tr>
				{{ } }}
			</tbody>
		</table>
		{{ } }}

		{{ var commentTemplate = _.template($("#simples-template-comments").html()); }}
		{{= commentTemplate(obj) }}

		{{ var touchTemplate = _.template($("#simples-template-touches").html()); }}
		{{= touchTemplate(obj) }}

		{{ var auditTemplate = _.template($("#simples-template-audits").html()); }}
		{{= auditTemplate(obj) }}

	{{ } }}
</div>

</script>