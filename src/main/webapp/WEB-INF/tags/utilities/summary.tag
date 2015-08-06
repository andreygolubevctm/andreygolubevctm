<%@ tag description="The Application Summary" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div class="${name}">
	<h3 class="${name}_sectionHeadings">Account holder details</h3>
	<ui:accordion id="selectedPlanDetails" headingIcon="ui-icon-plus" activeHeadingIcon="ui-icon-minus" autoHeight="false" clearStyle="true" openPanel="false">
		<ui:accordion_panel title="Plan details" className="${name}_planDetails aol-features apply-online-template" />
		<ui:accordion_panel title="Pricing Information" className="${name}_pricingInfo aol-price-info" />
		<ui:accordion_panel title="Terms &amp; Conditions" className="${name}_termsAndConditions" />
	</ui:accordion>

	<hr />

	<h3 class="${name}_sectionHeadings">
		Confirm your details
		<div class="${name}_modifyDetails">
			<a href="javascript:void(0);" data-prevslide="true" class="green-button" title="Modify Details"><span>Modify Details</span></a>
		</div>
	</h3>
	<div class="${name}_confirmDetails">

		<!-- template here -->

	</div>

	<%-- JS TEMPLATES --%>
	<core:js_template id="account-holder-details-template">
		<div class="left-column">
			<div class="${name}_row">
				<div class="left-column rounded-corners">Full Name</div>
				<div class="right-column">[#= fullName #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Main Phone No</div>
				<div class="right-column">[#= phoneNo #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Alternate Phone No</div>
				<div class="right-column">[#= alternatePhoneNo #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Email</div>
				<div class="right-column">[#= email #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Date of Birth</div>
				<div class="right-column">[#= dob #]</div>
			</div>
			<div class="${name}_row identification">
				<div class="left-column rounded-corners">Identification</div>
				<div class="right-column">[#= identificationType #]</div>
			</div>
			<div class="${name}_row identification">
				<div class="left-column rounded-corners">Identification No</div>
				<div class="right-column">[#= identificationNo #]</div>
			</div>
			<div class="${name}_row identification issuedFrom">
				<div class="left-column rounded-corners">Issued From</div>
				<div class="right-column">[#= issuedFrom #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Concession</div>
				<div class="right-column">[#= hasConcession #]</div>
			</div>
			<div class="${name}_row concession">
				<div class="left-column rounded-corners">Concession Type</div>
				<div class="right-column">[#= concessionType #]</div>
			</div>
			<div class="${name}_row concession">
				<div class="left-column rounded-corners">Card Number</div>
				<div class="right-column">[#= cardNo #]</div>
			</div>
			<div class="${name}_row concession">
				<div class="left-column rounded-corners">Card Start Date</div>
				<div class="right-column">[#= cardStartDate #]</div>
			</div>
			<div class="${name}_row concession">
				<div class="left-column rounded-corners">Card End Date</div>
				<div class="right-column">[#= cardEndDate #]</div>
			</div>
		</div>
		<div class="right-column">
			<div class="${name}_row">
				<div class="left-column rounded-corners">Supply Address</div>
				<div class="right-column">[#= address #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Billing Address</div>
				<div class="right-column">[#= billing_address #]</div>
			</div>
			<div class="${name}_row movingDate">
				<div class="left-column rounded-corners">Estimated Move in Date</div>
				<div class="right-column">[#= movingDate #]</div>
			</div>
			<div class="${name}_row">
				<div class="left-column rounded-corners">Medical Requirements</div>
				<div class="right-column">[#= medicalRequirements #]</div>
			</div>
			<div class="${name}_row medicalRequirements">
				<div class="left-column rounded-corners">Medical Req. Type</div>
				<div class="right-column">[#= medicalRequirementsType #]</div>
			</div>
			<div class="${name}_row isPowerOn">
				<div class="left-column rounded-corners">Is the Power On?</div>
				<div class="right-column">[#= isPowerOn #]</div>
			</div>
			<div class="${name}_row directDebit">
				<div class="left-column rounded-corners">Direct Debit?</div>
				<div class="right-column">[#= directDebit #]</div>
			</div>
			<div class="${name}_row electronicBill">
				<div class="left-column rounded-corners">Electronic Bill</div>
				<div class="right-column">[#= electronicBill #]</div>
			</div>
			<div class="${name}_row electronicCommunication">
				<div class="left-column rounded-corners">Electronic Comm.</div>
				<div class="right-column">[#= electronicCommunication #]</div>
			</div>
			<div class="${name}_row billDeliveryMethod">
				<div class="left-column rounded-corners">Bill Delivery Method</div>
				<div class="right-column">[#= billDeliveryMethod #]</div>
			</div>
		</div>
	</core:js_template>


	<core:clear />
	<hr />

	<div id="${name}_summaryText_template_placeholder"></div>

	<core:js_template id="summary-text-template">
		<p class="${name}_transfer">Click the Submit Application button below to submit your application to transfer your energy account(s) to [#= provider #]</p>
		<p class="${name}_movingIn">Click the Submit Application button below to submit your application to connect your energy account(s) to [#= provider #]</p>

		<p>After you have clicked on the Submit Application button the following will occur:</p>
		<ul>
			<li>The next page will confirm that Switchwise has received your application &amp; display your order number.</li>
			<li>A confirmation email including the details of your application will be sent to the email address you provided.</li>
			<li>Once your application is accepted by [#= provider #] your Energy Agreement and 10 business day cooling-off period will begin from the date of this Agreement.</li>
			<li>Should there be any issues with your application [#= provider #] will contact you directly.</li>
		</ul>
	</core:js_template>

	<core:js_template id="summary-text-template-DOD">
		<p class="${name}_transfer">Click the Submit Application button above to submit your application to transfer your energy account(s) to [#= provider #].</p>
		<p class="${name}_movingIn">Click the Submit Application button above to submit your application to connect your energy account(s) to [#= provider #].</p>

		<p>After you have clicked on the Submit Application button the following will occur:</p>
		<ul>
			<li>The next page will confirm that Switchwise has received your application &amp; display your Switchwise order number</li>
			<li>A confirmation email including the details of your application and the products you have selected will be sent to the email address you provided</li>
			<li>A [#= provider #] Customer Service Representative will call you back within one business day to complete your application and collect your direct debit details</li>
			<li>If [#= provider #] is unable to speak to you on the phone or collect your direct debit details they will not be able to complete your application to transfer to [#= provider #].</li>
		</ul>
	</core:js_template>

	<core:js_template id="summary-text-template-ENA">
		<p class="${name}_transfer">Click the Submit Application button above to submit your application to transfer your energy account(s) to [#= provider #].</p>
		<p class="${name}_movingIn">Click the Submit Application button above to submit your application to connect your energy account(s) to [#= provider #].</p>

		<p>After you have clicked on the Submit Application button the following will occur:</p>
		<ul>
			<li>The next page will confirm that Switchwise has received your application &amp; display your Switchwise order number</li>
			<li>A confirmation email including the details of your application and the products you have selected will be sent to the email address you provided</li>
			<li>A Switchwise Customer Service Representative will call you back within one business day to complete your application</li>
			<li>If Switchwise is unable to speak to you on the phone they might not be able to complete your application to transfer to [#= provider #].</li>
		</ul>
	</core:js_template>

	<hr />

</div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

</go:script>

<go:script marker="js-head">
	$(document).on('click','a[data-prevslide=true]',function(){
		QuoteEngine.prevSlide();
	});
</go:script>
<%-- CSS --%>
<go:style marker="css-head">
	#selectedPlanDetails{
		width: 98%;
		margin-left: 1%;
		margin-right: 1%;
	}

	.${name}_planDetails h6:first-child{
		padding-top: 5px;
	}
	.${name}_priceInfo p:first-child{
		margin-top: 5px;
	}

	.${name} ul li{
		list-style-image: url(brand/ctm/images/bullet_edit.png);
		list-style-position: outside;
		margin: 0 0 0.6em 14px;
	}
		.${name} ul li a{
			font-size: 100%;
		}

	#${name}_summaryText_template_placeholder{
		padding: 0 5px;
	}
	#${name}_summaryText_template_placeholder p{
		margin: 5px 0;
	}

	.${name}_sectionHeadings{
		color: #0c4da2;
		margin-top: 25px;
		margin-bottom: 10px;
		position: relative;
	}
		.${name}_modifyDetails{
			position: absolute;
			right: 0;
			top: -13px;
		}

	.${name} hr{
		border-top: 1px dashed rgb(35, 91, 136);
		margin: 25px 0;
	}

	.${name}_confirmDetails{
		margin-top: 30px;
		width: 98%;
		margin-left: 1%;
		margin-right: 1%;
	}
		.${name} .left-column,
		.${name} .right-column{

		}

		.${name}_row{
			border-bottom: 1px dashed rgb(35, 91, 136);
			float: left;
			width: 100%;
			margin-bottom: 6px;
		}
		.${name}_row .left-column,
		.${name}_row .right-column{
			margin-bottom: 6px;
		}
		.${name}_row .left-column{
			padding: 8px;
			font-weight: bold;
			width: 44%;
			background-color: #F2F7FD;
			border: 1px solid #E3E8EC;
			height: 26px;
			line-height: 26px;
		}
		.${name}_row .right-column{
			background-color: white;
			width: 48%;
			padding-top: 12px;
		}
</go:style>