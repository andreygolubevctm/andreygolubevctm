<script id="confirmation-fund-details-template" type="text/html">
	<div class="fundDetails">
		<div class="col-xs-12">
			<p>For any questions, contact {{= fundName }} via any of the methods below</p>
		</div>
		<!-- leveraging existing styles -->
		<div class="col-xs-4 companyLogo {{= provider }}-mi" ></div>
		<div class="col-xs-8">
			{{ if(!_.isEmpty(phoneNumber)) { }}<p class="phoneNumber">{{= phoneNumber }}</p>{{ } }}
			{{ if(!_.isEmpty(email)) { }}<p>{{= email }}</p>{{ } }}
			{{ if(!_.isEmpty(website)) { }}<p>{{= website }}</p>{{ } }}
		</div>
	</div>
</script>