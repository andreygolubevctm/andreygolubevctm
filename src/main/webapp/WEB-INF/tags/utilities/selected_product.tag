<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>

<%-- VARIABLES --%>

<%-- HTML --%>
<table class="selectedProductTable">
	<tr>
		<th class="onepixel"></th>
		<th class="selectedProductSupplierColumn">Retailer &amp; Plan</th>
		<th class="onepixel"></th>
		
		<th class="selectedProductContractPeriodColumn">Contract Period</th>
		<th class="onepixel"></th>
		<th class="selectedProductCancellationFeeColumn">Maximum Cancellation Fee</th>
		<th class="onepixel"></th>
		<th class="selectedProductEstimatedCostsColumn">Estimated Costs (1st Year)</th>
		<th class="onepixel estSavings"></th>
		<th class="selectedProductEstimatedSavingsColumn estSavings">Savings upto</th>
		<th class="onepixel"></th>
		<th class="selectedProductModifyPlanColumn">&nbsp;</th>
		<th class="onepixel"></th>
	</tr>
	<tr class="selectedProduct">

	</tr>
</table>

<core_v1:js_template id="selected-product-template">
	<td class="delimiter onepixel"></td>
	<td>
		<div class="supplier_and_plan">
			<div class="thumb"><img src="common/images/logos/utilities/[#= retailerId #]_logo.jpg" alt="[#= retailerName #] Logo" title="[#= retailerName #] Logo" /></div>
			<div class="label">
				<p class="title">[#= retailerName #]</p>
				<p>[#= planName #] <a href="javascript:void(0);" data-selectproduct="true">View Details</a></p>
			</div>
		</div>
	</td>
	<td class="delimiter onepixel"></td>
	<td>[#= contractPeriod #]</td>
	<td class="delimiter onepixel"></td>
	<td>[#= formatted.cancellationFees #]</td>
	<td class="delimiter onepixel"></td>
	<td>[#= formatted.price #]</td>
	<td class="delimiter onepixel estSavings"></td>
	<td class="estSavings estSavingsCell">[#= formatted.yearlySavings #]</td>
	<td class="delimiter onepixel"></td>
	<td><a href="javascript:void(0);" data-modifyplan="true" class="green-button" title="Modify Plan"><span>Modify Plan</span></a></td>
	<td class="delimiter onepixel"></td>
</core_v1:js_template>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var SelectedProduct = new Object();
	SelectedProduct = {
		view : function(){
			Results.viewProduct(utilitiesChoices._product.planId, true);
		}
	}
	$(document).on('click','a[data-modifyplan=true]',function(){
		QuoteEngine.gotoSlide({index:1});
	});

	$(document).on('click','a[data-selectproduct=true]',function(){
		SelectedProduct.view();
	});
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	/* COLUMNS */
	.selectedProductSupplierColumn{
		width: 190px;
	}
	.selectedProductGreenRatingColumn{
		width: 10%;
	}
	.selectedProductContractPeriodColumn{
		width: 10%;
	}
	.selectedProductCancellationFeeColumn{
		width: 17%;
	}
	.selectedProductEstimatedCostsColumn{
		width: 15%;
	}
	.selectedProductEstimatedSavingsColumn{
		width: 15%;
	}
	.selectedProductModifyPlanColumn{
		width: 100px;
	}
	.selectedProductTable .onepixel{
		width: 1px;
	}


	/* TABLE */
	.selectedProductTable{
		margin-bottom: 30px;
		margin-top: 48px;
		text-align: center;
	}
	.selectedProductTable th{
		vertical-align: middle;
	}
	.selectedProductTable td{
		background: white url(common/images/results_summary_header/utilities_summary_header_bkg.png) bottom left repeat-x;
		height: 40px;
		vertical-align: middle;
		padding: 0 5px;
	}
	.selectedProductTable .delimiter{
		padding: 15px 0;
		background-image: url(common/images/results_summary_header/utilities_summary_header_delimeter.png);
	}

	/* BUTTON */
	.selectedProductTable .green-button{
		width: 92px;
		height: 33px;
	}
	.selectedProductTable .green-button span{
		margin-left: 3px;
		font-size: 13px;
		padding: 10px 3px 11px 0px
	}

	/* CELLS */
	.selectedProductTable .supplier_and_plan{
		width: 190px;
	}
	.selectedProductTable .supplier_and_plan div{
		float: left;
	}
	.selectedProductTable .supplier_and_plan .thumb {
		vertical-align:top;
	}
	.selectedProductTable .supplier_and_plan .thumb img {
		max-width: 50px;
		max-height: 50px;
	}
	.selectedProductTable .supplier_and_plan .label {
		width: 135px;
		padding-left: 3px;
		padding-top: 5px;
		text-align: left;
	}
	.ie8 .selectedProductTable .supplier_and_plan .label {
		width: 130px;
	}
	.selectedProductTable .supplier_and_plan .label p {
		padding-bottom: 3px;
	}
	.selectedProductTable .supplier_and_plan .label p.title {
		font-weight: bold;
	}
</go:style>