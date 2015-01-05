<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%--
This tag renders a button on the page which can trigger a form for
the user to request a callback from the Call Centre.
--%>

<%-- ATTRIBUTES --%>

<c:set var="id" value="popup-update-providerplans" />

<%-- VARIABLES --%>
<c:set var="formHeight" value="245" />

<%-- HTML --%>
<div id="${id}">
	<div class="qe-window fieldset">
		<h4>Provider and Plan Details <a href="javascript:void(0);" id="${id}_close">close</a></h4>
		<div class="content">
			<div class="usage" style="display: block;">
				<div class="utilities-titles">
					<h5 class="left current-provider E">Electricity</h5>
					<h5 class="left current-provider G">Gas</h5>
				</div>
				<div class="cleardiv"></div>
			</div>

			<div class="currentProviderContainer">
				<div class="fieldrow">
					<div class="fieldrow_label">
						Current Provider(s)</div>
					<div class="fieldrow_value">
						<h5 class="left current-provider E"></h5>
						<h5 class="left current-provider G"></h5>
					</div>
					<div class="fieldrow_legend"></div>
					<div class="cleardiv"></div>

				</div>
				
				<div class="fieldrow currentProviderContainerUpdateRow">
					<div class="fieldrow_label"><!-- empty --></div>
					<div class="fieldrow_value">
						<h5 class="left current-provider">
							<a href="javascript:void(0);" id="${id}_submit" class="button-common">Update</a>
						</h5>
					</div>
					<div class="fieldrow_legend"></div>
					<div class="cleardiv"></div>

				</div>
			</div>

		</div>
	</div>
</div>
<div id='${id}_mask'><!-- empty --></div>

<%-- SCRIPT --%>
<go:script marker="js-head">

<%--JS class which handles the functionality of the CallMeBack form--%>
var UpdateProviderPlans = function() {

	// Private members area
	var that			= this,
		elements		= {},
		type			= false,
		visible			= false;

	var hide = function( callback ) {
		elements.form.fadeOut('slow', function(){
			elements.mask.hide();
			if( typeof callback == "function" ) {
				callback();
			}
		});
	};

	var show = function() {
		var width = 640;
		var height = 220;
		var viewportWidth = jQuery(window).width(),
			viewportHeight = jQuery(window).height(),
			scrolltop = $(window).scrollTop();
		elements.form.css({
			top :	scrolltop + (viewportHeight/2) - (height/2),
			left :	(viewportWidth/2) - (width/2)
		});
		elements.mask.css({height:$(document).height()});
		elements.mask.show();
		elements.form.fadeIn('slow');
		return false;
	};

	var submit = function() {
		var valid_plan_chosen = false;
		if( typeof elements.e_plans == "object" ) {
			var plan = elements.e_plans.val();
			if( plan != "ignore" ) {
				valid_plan_chosen = true;
			}
			$('#utilities_estimateDetails_usage_electricity_currentPlan').val( plan );
		}
		if( typeof elements.g_plans == "object" ) {
			var plan = elements.g_plans.val();
			if( plan != "ignore" ) {
				valid_plan_chosen = true;
			}
			$('#utilities_estimateDetails_usage_gas_currentPlan').val( plan );
		}

		<%-- Must show the selectors so that  --%>
		$('#utilities_estimateDetails .currentProviderContainerCurrentPlanRow:first').show();

		hide( UtilitiesQuote.fetchPrices );

		<%-- Hide selectors again if no plan chosen --%>
		if( !valid_plan_chosen ) {
			$('#utilities_estimateDetails .currentProviderContainerCurrentPlanRow:first').hide();
		}

		utilitiesChoices.showHidePlanHelpText();
	};

	this.init = function() {
		elements = {
			open		: $('#open_update_provider_plans'),
			submit		: $('#${id}_submit'),
			close		: $('#${id}_close'),
			form		: $('#${id}'),
			mask		: $('#${id}_mask'),
			electricity : $('#${id} .current-provider.E'),
			gas 		: $('#${id} .current-provider.G'),
			e_plans		: false,
			g_plans		: false
		};

		type = $('input[name=utilities_householdDetails_whatToCompare]:checked').val();

		elements.form.removeClass("E").removeClass("G").removeClass("EG").addClass( type );

		if( type == 'EG' || type == 'E' ) {
			elements.electricity.eq(1).empty().append( $('#utilities_estimateDetails_usage_electricity_currentSupplier option:selected').text() );
			elements.e_plans = $('<select/>');
			$('#utilities_estimateDetails_usage_electricity_currentPlan option').each(function(index){
				if(index > 0) {
					var option = $('<option/>').val($(this).val()).append($(this).text());
					if( $(this).is(':selected') ) {
						option.attr('selected', true);
					}
					elements.e_plans.append( option );
				}
			});
			elements.electricity.eq(2).empty().append( elements.e_plans );
		}
		if( type == 'EG' || type == 'G' ) {
			elements.gas.eq(1).empty().append( $('#utilities_estimateDetails_usage_gas_currentSupplier option:selected').text() );
			elements.g_plans = $('<select/>');
			$('#utilities_estimateDetails_usage_gas_currentPlan option').each(function(index){
				if(index > 0) {
					var option = $('<option/>').val($(this).val()).append($(this).text());
					if( $(this).is(':selected') ) {
						option.attr('selected', true);
					}
					elements.g_plans.append( option );
				}
			});
			elements.gas.eq(2).empty().append( elements.g_plans );
		}

		switch(type) {
			case 'E':
				elements.electricity.show();
				elements.gas.hide();
				break;
			case 'G':
				elements.electricity.hide();
				elements.gas.show();
				break;
			case 'EG':
			default:
				elements.electricity.show();
				elements.gas.show();
				break;
		};

		elements.submit.on('click', submit);

		elements.mask.on('click', function(){
			hide();
		});

		elements.close.on('click', function(){
			hide();
		});

		elements.open.on('click', function(){
			show();
		});
	};
};

var update_provider_plans = new UpdateProviderPlans();
</go:script>

<%-- STYLE --%>
<go:style marker="css-head">
#${id}{
	position:				absolute !important;
	z-index:				26000 !important;
	-webkit-border-radius:	5px;
	-moz-border-radius: 	5px;
	border-radius: 			5px;
	display:				none;
	-webkit-box-shadow: 	0px 0px 30px rgba(0, 0, 0, 0.75);
	-moz-box-shadow:		0px 0px 30px rgba(0, 0, 0, 0.75);
	box-shadow:				0px 0px 30px rgba(0, 0, 0, 0.75);
}

#${id} .qe-window {
	margin:					0;
	padding:				0;
}

#${id} .current-provider {
	clear:					none;
}

#${id} .current-provider {
	padding:				10px 0;
	width:					185px;
}

#${id} .usage .current-provider {
	padding:				5px 0;
}

#${id} .currentProviderContainer .current-provider {
	color:					#4a4f51;
}

#${id} .currentProviderContainer .current-provider select {
	width:					175px;
}

#${id} .currentProviderContainerCurrentPlanRow .current-provider {
	padding:				0 0 10px 0;
}

#${id}_mask {
	position: 				absolute;
	left: 					0;
	right: 					0;
	bottom: 				0;
	top: 					0;
	z-index: 				1000;
	background:				#000000;
	zoom: 					1;
	filter: 				alpha(opacity=20);
	opacity: 				0.2;
	visibility: 			visible;
	display:				none;
}

#${id}_panel input,
#${id}_panel select {
	border:					1px solid #cccccc !important;
	background:				#FFF;
	padding:				3px 5px;
}

#${id}_panel input {
	padding:				3px 5px;
}

#${id}_panel option {
	padding:				3px 5px;
	background:				#FFF;
}

#${id}_panel input.error,
#${id}_panel select.error {
	border-color:			#ff0000 !important;
}

#${id}_panel input,
#${id}_panel select,
#${id}_panel option {
	color:					#666666;
}

#${id}_panel .row,
#${id}_panel p{
	padding:				5px 10px;
}

#${id}_panel p{
	padding:				10px 20px 5px 15px;
}

#${id}_panel p.sub {
	font-size:				90%;
	text-align:				center;
	padding:				10px 20px;
}

#${id}_panel .row span{
	display:				inline-block;
	width:					100px;
	text-align:				right;
	padding-right:			5px;
}

#${id}_error {
	color:					#FF0000;
}

#${id}_close{
	display:				block;
	position:				absolute;
	width:					36px;
	height:					36px;
	top:					0px;
	right:					0px;
	background:				url(common/images/dialog/close.png) 50% 50% no-repeat;
	text-indent:			-10000px;
}

#${id}_close:hover{
	text-decoration:		underline;
}

#${id} a.button-common {
	font-size:				9pt;
	font-weight:			bold;
	text-decoration:		none;
	padding: 				11px 10px 10px 35px;
	margin: 				4px 0 0 10px;
	-moz-border-radius: 	6px;
	-webkit-border-radius:	6px;
	-o-border-radius: 		6px;
	-ms-border-radius: 		6px;
	-khtml-border-radius:	6px;
	border-radius: 			6px;
	position: 				relative;
}

#${id} .button-common:hover {
	cursor: 				pointer;
}

#${id} .button-common span {
	position: 				absolute;
	left: 					10px;
	top: 					6px;
	width: 					20px;
	height: 				20px;
}

#${id} .currentProviderContainerUpdateRow {
	padding-bottom:			10px;
}

#${id} .currentProviderContainerUpdateRow a {
	color: 					#FFF;
	font-size:				11pt;
	padding:				6px 50px 5px 50px;
	margin: 				4px 0 0 0;
	background:				#009934;
	background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #00B14B), color-stop(100%, #009934));
	background-image: 		-webkit-linear-gradient(#00B14B, #009934);
	background-image: 		-moz-linear-gradient(#00B14B, #009934);
	background-image: 		-o-linear-gradient(#00B14B, #009934);
	background-image: 		linear-gradient(#00B14B, #009934);
	-pie-background: 		linear-gradient(#00B14B, #009934);
	border: 				1px solid #008a25;
	-moz-box-shadow: 		inset 0 1px 0 0 #00C960;
	-webkit-box-shadow: 	inset 0 1px 0 0 #00C960;
	-o-box-shadow: 			inset 0 1px 0 0 #00C960;
	box-shadow: 			inset 0 1px 0 0 #00C960;
}

#${id} .currentProviderContainerUpdateRow a:hover {
	background:				#00B14B;
	background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #009934), color-stop(100%, #00B14B));
	background-image: 		-webkit-linear-gradient(#009934, #00B14B);
	background-image: 		-moz-linear-gradient(#009934, #00B14B);
	background-image: 		-o-linear-gradient(#009934, #00B14B);
	-pie-background: 		linear-gradient(#009934, #00B14B);
	-moz-box-shadow: 		inset 0 1px 0 0 #ffffff;
	-webkit-box-shadow: 	inset 0 1px 0 0 #ffffff;
	-o-box-shadow: 			inset 0 1px 0 0 #ffffff;
	box-shadow: 			inset 0 1px 0 0 #ffffff;
}
</go:style>