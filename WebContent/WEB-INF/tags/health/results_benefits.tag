<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="xpathBenefitsExtras" value="${xpath}/benefitsExtras"  />



<%-- HTML --%>
<div id="${name}Header" class="${name}">
	<div class="${name}Header">
		<div class="${name}HeaderText">
			<h4>What matters to you?</h4>
			<p>When considering health policies, it's important you review the included hospital and extras benefits. Personalise these quotes by choosing benefits to suit your needs.</p>
			<core:clear />
		</div>
		<div class="${name}HeaderActions">
			<%-- #ChooseBenefits is for SuperTag --%>
			<a href="javascript:void(0);" id="ChooseBenefits" title="Choose Benefits"><!-- empty --></a>
		</div>
		<core:clear />
			<a href="javascript:void(0);" id="${name}CloseBtn" title="Close Choose Benefits Panel"></a>
		</div>
	</div>

<div id="${name}ContentContainer" class="${name}ContentContainer">
	<div class="${name}Situation">
		<div class="hr"></div>
		<form:row label="Your Situation:" className="health-benefits-healthSitu-group">
			<field:general_select xpath="${xpath}/healthSitu" type="healthSitu" className="health-benefits-healthSitu" required="true" title="situation type" />
		</form:row>
		<p><%-- Situation explanation paragraph (HealthBenefits.updateIntro) --%></p>
</div>

	<c:if test="${not empty callCentre}">
		<div class="${name}Filters">
			<div class="fieldrow">
				<div class="fieldrow_label">Level of cover</div>
				<div class="fieldrow_value">
					<field:array_select items="=Hospital level...,0=None,1=Public,2=Budget,3=Medium,4=Top" xpath="health_filter_tierHospital" title="" required="false" />
					<field:array_select items="=Extras level...,0=None,1=Budget,2=Medium,3=Comprehensive" xpath="health_filter_tierExtras" title="" required="false" />
				</div>
			</div>
		</div>
	</c:if>

	<div class="hr"></div>
	
	<div class="${name}Content">
		<div class="two-columns hospital">
			<h5>Personalise your <strong>hospital benefits</strong><div class="help_icon" id="help_286"></div></h5>
		</div>
		<div class="two-columns extras">
			<h5>Personalise your <strong>extras benefits</strong><div class="help_icon" id="help_285"></div></h5>
		</div>
		
		<div id="container4">
			<div id="container3">
				<div id="container2">
					<div id="container1">
						<div id="col1" class="hospital four-columns">
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/PrHospital" 				title="Private Hospital"	value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_253"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/PuHospital" 				title="Private Patient in Public Hospital"	value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_254"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Cardiac" 					title="Heart Surgery"						value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_255"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Obstetric" 				title="Birth Related Services" 				value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_256"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/AssistedReproductive" 	title="Assisted Reproduction eg. IVF"		value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_257"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/CataractEyeLens" 			title="Major Eye Surgery"					value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_258"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/JointReplacement" 		title="Joint Replacement"					value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_259"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/PlasticNonCosmetic" 		title="Non Cosmetic Plastic Surgery"		value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_260"></div>
								<core:clear />
						</div>
						<div id="col2" class="hospital four-columns">
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Sterilisation" 			title="Sterilisation"						value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_262"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/GastricBanding" 			title="Gastric Banding"						value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_263"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/RenalDialysis" 			title="Dialysis"							value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_264"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Palliative" 				title="Palliative Care" 					value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_265"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Psychiatric" 				title="In-Hospital Psychiatry"				value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_266"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Rehabilitation" 			title="In-Hospital Rehabilitation" 			value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_267"></div>
								<core:clear />
							<%-- Removed for HLT-542 but keep commented out as likely to return in future
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Ambulance" 				title="Ambulance" 							value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_284"></div>
								<core:clear />
							<core:clear />
							<div class="ambulanceText"></div>--%>
						</div>
						<div id="col3" class="extras four-columns">
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/DentalGeneral" 		title="General Dental"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_269"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/DentalMajor" 			title="Major Dental"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_270"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Endodontic" 			title="Endodontic"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_271"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Orthodontic" 			title="Orthodontic"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_272"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Optical" 				title="Optical"					value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_273"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Physiotherapy" 		title="Physiotherapy"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_274"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Chiropractic" 		title="Chiropractic"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_275"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Podiatry" 			title="Podiatry"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_276"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Acupuncture" 			title="Acupuncture"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_277"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Naturopath" 			title="Naturopathy"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_278"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Massage" 				title="Remedial Massage"		value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_279"></div>
								<core:clear />
						</div>
						<div id="col4" class="extras four-columns">
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Psychology" 			title="Psychology"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_280"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/GlucoseMonitor" 		title="Glucose Monitor"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_281"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/HearingAid" 			title="Hearing Aids"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_282"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/NonPBS" 				title="Non PBS Pharmaceuticals"	value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_283"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Orthotics" 			title="Orthotics"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_298"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/SpeechTherapy" 		title="Speech Therapy"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_297"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/OccupationalTherapy" 	title="Occupational Therapy"	value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_296"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/Dietetics" 			title="Dietetics"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_295"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/EyeTherapy" 			title="Eye Therapy"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_294"></div>
								<core:clear />
							<field:customisable-checkbox theme="grey" xpath="${xpathBenefitsExtras}/LifestyleProducts"	title="Lifestyle Products"		value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_293"></div>
								<core:clear />
						</div>
					</div>
				</div>
			</div>
			<div class="${name}-ambulance-summary">
				<div class="hr"></div>
				<h5>Ambulance</h5>
				<p>Health policies can include varying levels of ambulance cover. We will present a range of options available in our product results.</p>
		</div>
		</div>
		
		<core:clear />
	</div>
	
	<div class="hr"></div>
		
	<a href="javascript:void(0);" class="green-button" id="${name}UpdateBtn" title="Update Benefits Button"><span>Update Benefits</span></a>
	<core:clear />
</div>

<%-- CSS --%>
<go:style marker="css-head">
	.${name}{
		background-color: #999;
		z-index: 20;
		position: relative;
		padding: 15px 10px 20px 10px;
		<css:rounded_corners value="5" />
		<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="1" blurRadius="10" color="0,0,0,0.3" inset="true" />
		height: 33px;
		bottom: -5px;
	}

/* HEADER */
	.${name}Header{
		margin-top: 7px;
	}
	.${name}HeaderText{
		width: 68%;
		float: right;
		padding-right: 15px;
	}
		.${name}HeaderText h4,
		.${name} p{
			display: inline;
			color: white;
		}
		.${name} p{
			*margin-left: 5px; /* IE7 hack */
		}
		.${name}HeaderText h4{
			font-size: 130%;
		}
		.${name}HeaderText p{
			font-size: 110%;
		}
	.${name}HeaderActions{
		float: left;
		text-align: left;
		position: relative;
		top: -3px;
	}
		#ChooseBenefits{
			display: block;
			height: 32px;
			width: 272px;
			background: transparent url('brand/ctm/images/results/choose_hospital_extras_btn.png') 0 0 no-repeat;
			cursor: pointer;
			text-decoration: none;
			text-align: center;
		}
		#ChooseBenefits:hover{
			background-position: 0 -32px;
		}
		#${name}CloseBtn{
			position: absolute;
			right: 10px;
			top: 22px;
			width: 20px;
			height: 20px;
			display: none;
			background-image: url("brand/ctm/images/icons/grey_close_btn.png");
		}
/* SITUATION */
	.${name}Situation {
		background: #ccc;
		height: 50px;
	}
	.${name}Situation .fieldrow {
		width: 380px;
		float: left;
		min-height: auto;
		margin-top: 8px;
	}
	.${name}Situation .fieldrow_label {
		width: 92px;
		margin-right: 0;
	}
	.${name}Situation p {
		margin: 8px;
		line-height: 1.3;
	}
	.${name}Situation p a {
		font-size: inherit;
	}
	.${name}Situation select {
		border-color: #666;
	}
/* CONTENT */
	.${name}ContentContainer{
		background-color: #999;
		z-index: 21;
		position: relative;
		<css:rounded_corners value="5" corners="bottom-right, bottom-left" />
		display: none;
		zoom: 1;
	}
		.${name}ContentContainer div.hr{
			border-top: 1px solid #6b6b6b;
			border-bottom: 1px solid #adadad;
		}
		.${name}ContentContainer h5 {
			color: white;
			margin: 10px 0;
			font-family: "SunLt Light", "Open Sans", Helvetica, Arial, sans-serif;
		}
		#${name}UpdateBtn{
			margin: 15px;
			background-image: url("brand/ctm/images/buttons/green_btn_60px_left.png");
			height: 62px;
			width: 190px;
		}
			#${name}UpdateBtn span{
		 		background-image: url("brand/ctm/images/buttons/green_btn_60px_right.png");
		 		padding: 23px 10px 23px 0px;
				font-size: 18px;
			}
		.${name}Content{
			padding: 0 10px 10px 10px;
			color: white;
		}
			.${name}Content .help_icon{
			 	margin-top: 1px;
			 	background-image: url("brand/ctm/images/icons/grey_info.png");
			}
			.${name}Content h5 .help_icon {
				display: inline-block;
				float: none;
				position: relative;
				top: 2px;
			}
			.${name}Content .checkboxtag-row{
				float: left;
				margin-bottom: 5px;
			}
			.${name}Content .ambulanceText{
				background-color: #cccccc;
				color: #666666;
				padding: 5px;
				margin: 5px;
				width: 70%;
				display: none;
			}
	
/* COLUMNS */
	.${name}Content .two-columns{
		width: 50%;
		float: left;
	}
	.${name}Content #container4 {
		clear:left;
		float:left;
		width:100%;
		<%-- overflow:hidden; --%>
		position: relative;
	}
	.${name}Content #container3 {
		clear:left;
		float:left;
		width:100%;
		position:relative;
		right:25%;
	}
	.${name}Content #container2 {
		clear:left;
		float:left;
		width:100%;
		position:relative;
		right:25%;
	}
	.${name}Content #container1 {
		float:left;
		width:100%;
		position:relative;
		right:25%;
	}
	.${name}Content .four-columns{
		float:left;
		width:25%;
		position:relative;
		overflow:hidden;
		left: 75%;
	}

	.${name}Content .${name}-ambulance-summary {
		position: absolute;
		top: 194px;
		width: 436px;
		padding-left: 2px;
		padding-right: 2px;
	}

	.${name}Content .${name}-ambulance-summary h5 {
		font-weight: normal;
		margin-bottom: 5px;
		margin-top: 5px;
	}

	.callcentre.stage-0 .${name}Content {
		padding-bottom: 75px;
	}

	.callcentre.stage-0 .${name}Content .${name}-ambulance-summary {
		top: 484px;
		width: 614px;
	}
<%--  FILTERS --%>
	.${name}Filters {
		background: #ccc;
		padding: 8px;
	}
	.${name}Filters select {
		border-color: #666;
	}
	.${name}Filters .fieldrow_label {
		width: 92px;
		margin-right: 0;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var ${name}Handler = new Object();
	${name}Handler = {
		init: function(){
			$("#ChooseBenefits").on("click", function(e){
				$('#${name}UpdateBtn').unbind("click"); <%-- will be set/reset in resultsBenefitsMgr.init() --%>
				
				resultsBenefitsMgr.init(function(){
					$("#ChooseBenefits").fadeOut();
					$("#${name}CloseBtn").fadeIn();
				
					<%-- Add class to tell elements to be repositioned --%>
					$('#results-fixed').addClass('extended');
					$('#results-container').addClass('extended');
					Results.resizePage();
					
					$(".${name}ContentContainer").slideDown(FixedResults.updateTop);
				});
				e.preventDefault();
			});
			
			$("#${name}CloseBtn").on("click", function(e){
				$("#ChooseBenefits").fadeIn();
				$("#${name}CloseBtn").fadeOut();
				$(".${name}ContentContainer").slideUp(function(){				
					<%-- Add class to tell elements to be repositioned --%>
					$('#results-fixed').removeClass('extended');
					$('#results-container').removeClass('extended');
					Results.resizePage();
				});
				e.preventDefault();
			});
		}
	};
</go:script>

<go:script marker="js-head">
	var ResultsBenefitsManager = function() {
		var incrementTransactionId = false;
		var	that = this,
			elements = {},
			prefix = "${name}_";

		this.init = function( callback ) {
			$('#${name}UpdateBtn').on("click", function(){
				that.updateBackward(true);
			});
			
			if( typeof callback == "function" ) {
				callback();
			}
		};
		<%-- Using defined category names for Health in the Database --%>
		this.getCategory = function() {
		
			var hospitalCount = $('#${name}ContentContainer').find('.hospital :checked').length;
			var extrasCount = $('#${name}ContentContainer').find('.extras :checked').length;

			if(hospitalCount > 0 && extrasCount > 0) {
				return 'Combined'
			} else if (hospitalCount > 0) {
				return 'Hospital'
			} else if (extrasCount > 0) {
				return 'GeneralHealth'
			} else {
				return 'None';
			};
		};

		<%-- Updates the questionset benefits from the results page --%>
		this.updateBackward = function(incrementTransactionId) {
			healthChoices.prefillBenefitsList();
			<%-- If price filter is present update it --%>
			if(typeof priceMinSlider !== "undefined"){
				priceMinSlider.reset();
			};
			$("#${name}CloseBtn").trigger('click');
			Health.fetchPrices(ResultsBenefitsManager.incrementTransactionId);
			QuoteEngine.poke();
			ResultsBenefitsManager.incrementTransactionId = true;
		};
	};

	var resultsBenefitsMgr = new ResultsBenefitsManager();
</go:script>

<go:script marker="onready">
	${name}Handler.init();

	$('.health-benefits-healthSitu').on('change',function() {
		healthChoices.setSituation($(this).val());
	});

	<%-- Hook up clicks on benefits checkboxes --%>
	$('#${name}ContentContainer input:checkbox').each(function(){
		$(this).click(function(){
			var benefit = $(this).attr("id").split("Extras_")[1];
			if($(this).is(":checked")) {
				healthChoices.addBenefit(benefit);
			} else {
				healthChoices.removeBenefit(benefit);
			}
		});
	});
</go:script>

