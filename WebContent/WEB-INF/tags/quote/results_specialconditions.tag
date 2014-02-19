<%@ tag description="specialConditions and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>



<%-- HTML --%>
<c:set var="specialConditionsTitle">
	<div class="dialogTitle">Special Conditions Confirmation</div>
</c:set>

<c:set var="specialConditionsTitleEscaped">
	${go:replaceAll( go:replaceAll( specialConditionsTitle, '"', '\\\\"' ), "\\r\\n", "" )}
</c:set>

<c:set var="onClose">
	<%-- reset with default non parsed HTML, ready for next opening/parsing --%>
	$("#ui-dialog-title-specialConditionsDialog").html( "${specialConditionsTitleEscaped}" );
</c:set>

<ui:dialog
	id="specialConditions"
	title="${specialConditionsTitleEscaped}"
	dialogBackgroundColor="#ffffff"
	width="500"
	onClose="${onClose}"
	>

	<p>Please be aware that <span class="SCMessage"></span>.</p>

	<p><strong>Would you like to proceed with your purchase?</strong></p>
	<div class="SCbuttons">
			<a class="button" id="scProceed"><span >Proceed</span></a>
			<a class="button" id="scSelectProduct" ><span >Select Another Product</span></a>
			<div class="cleardiv"></div>
	</div>

	</ui:dialog>

<%-- CSS --%>
<go:style marker="css-head">


	.specialConditionsDialogContainer span.ui-dialog-title .icon{
		float: left;
		margin: 0 24px 0px 0px;
	}
	.specialConditionsDialogContainer .dialogClose{
		position: absolute;
		top: -40px;
		right: -7px;
	}
	.specialConditionsDialogContainer .ui-dialog-titlebar{
		padding: .4em 1em !important;
		height: auto;
		z-index: 10;
		position: relative;
	}
	.specialConditionsDialogContainer span.ui-dialog-title .dialogTitle{
		margin-top:5px;
		background-color: #ffffff;
		display: block;
		text-align:center;
		font-weight:bold;
		font-size:22px;
		color:#0c4da2;
	}
	.specialConditionsDialogContainer span.ui-dialog-title .title {
		margin-top: 11px;
		float: left;
		width: 340px;
	}
	.specialConditionsDialogContainer span.ui-dialog-title .title h2{
		font-size: 26px;
		color: #4B5053;
	}
	.specialConditionsDialogContainer span.ui-dialog-title .title h3{
		font-size: 18px;
		font-family: "SunLt Light", "Open Sans", Helvetica, Arial, sans-serif;
	}

	.specialConditionsDialogContainer.ui-dialog .ui-dialog-content{border:0px;}
	.ui-dialog .ui-dialog-title {
		width:100%;
		font-size:18px;}

	#specialConditionsDialog{
		clear: both;
	}
	#specialConditionsDialog p {
		margin-bottom: 9px;
		font-size: 15px;
		text-align:center;
		margin: 10px 10px;

	}

	#specialConditionsDialog p .yearsOld{

		font-weight:bold;
	}


	.SCbuttons{
		margin:0 auto;
		width:70%;
	}
	.SCbuttons a {
		display:block;
		text-align:center;
		margin:0 auto;
		cursor:pointer;
	}

	.specialConditionsDialogContainer #scProceed span{
			display: block;
			padding: 9px 10px 10px 0;
			color: #fff;
			font-size: 15px;
			text-shadow: 0px 1px 1px rgba(0, 0, 0, 0.5);
			font-weight: 600;
			margin-left: 10px;
			text-align: center;
			background-color:#16AF42;
			background-image: -webkit-gradient(
			linear,
			left top,
			left bottom,
			color-stop(0, #19BE50),
			color-stop(1, #16AF41)
			);
			background-image: -o-linear-gradient(bottom, #19BE50 0%, #16AF41 100%);
			background-image: -moz-linear-gradient(bottom, #19BE50 0%, #16AF41 100%);
			background-image: -webkit-linear-gradient(bottom, #19BE50 0%, #16AF41 100%);
			background-image: -ms-linear-gradient(bottom, #19BE50 0%, #16AF41 100%);
			background-image: linear-gradient(to bottom, #19BE50 0%, #16AF41 100%);
			border-radius:5px;
			}

	.specialConditionsDialogContainer a.button#scProceed{
		margin: 8px 0;
		text-decoration: none;
		}



	.specialConditionsDialogContainer #scSelectProduct span{
			display: block;
			padding: 9px 10px 10px 0;
			color: #FFF;
			font-size: 15px;
			text-shadow: 0px 1px 1px rgba(0, 0, 0, 0.5);
			font-weight: 600;
			margin-left: 10px;
			text-align: center;
			background-color:#8F9090;
			background-image: -webkit-gradient(
			linear,
			left top,
			left bottom,
			color-stop(0, #929493),
			color-stop(1, #8C8C8C));
			background-image: -o-linear-gradient(bottom, #929493 0%, #8C8C8C 100%);
			background-image: -moz-linear-gradient(bottom, #929493 0%, #8C8C8C 100%);
			background-image: -webkit-linear-gradient(bottom, #929493 0%, #8C8C8C 100%);
			background-image: -ms-linear-gradient(bottom, #929493 0%, #8C8C8C 100%);
			background-image: linear-gradient(to bottom, #929493 0%, #8C8C8C 100%);
			border-radius:5px;		}

	.specialConditionsDialogContainer a.button#scSelectProduct{

		margin: 8px 0;
		text-decoration: none;
		}

	#specialConditionsDialog > p{
	margin-top: 2px;
	padding-bottom: 10px;
	}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var specialConditions = new Object();
specialConditions = {

	init: function(){

	specialConditions.addListener();
	},

	addListener: function(){
		//Close and transfer
			$('#scProceed').on('click', function(e){

			e.preventDefault();
			$(this).unbind('click');
				specialConditions.proceed();
			return false;
			});
			//Close all and return to products page
			$('#scSelectProduct').click(function(e){
				e.preventDefault();
				specialConditions.selectAnotherProduct();

			});
	},
	show: function(content){

		$('span.SCMessage').empty().html(content);
		specialConditionsDialog.open();
	},

	proceed: function(){

		specialConditionsDialog.close();
		$('#go-to-insurer').unbind('click');
		specialConditions.updateBucket('true');
		moreDetailsHandler.applyOnline();

	},

	selectAnotherProduct: function(){
		specialConditions.updateBucket('false');
		$.each($('div.ui-dialog-content'), function (i, e) {
			if ($(this).dialog("isOpen")) {
					$(this).dialog("close");
				};
		});


	},
	updateBucket: function(proceed){

			$.ajax({
					url: "ajax/write/car_quote_proceed.jsp",
					data: {proceeded: proceed},
					type: "POST",
					async: true,
					dataType: "json",
					timeout:60000,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(response){
						return false;
					},
					error: function(data){
						return false;
					}
				});

	}


}




</go:script>
