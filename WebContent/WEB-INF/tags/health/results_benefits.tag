<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="xpathBenefitsExtras">health_benefits_benefitsExtras</c:set>
<c:set var="nameBenefitsExtras" value="${go:nameFromXpath(xpathBenefitsExtras)}" />

<%-- HTML --%>
<div class="${name}">
	<div class="${name}Header">
		<div class="${name}HeaderText">
			<h4>What matters to you?</h4>
			<p>When considering health policies, it's important you review the included hospital and extras benefits. Personalise these quotes by choosing benefits to suit your needs.</p>
			<core:clear />
		</div>
		<div class="${name}HeaderActions">
			<a href="javascript:void(0);" id="${name}Btn" title="Choose Benefits"><span>Choose Benefits</span></a>
			<a href="javascript:void(0);" id="${name}CloseBtn" title="Close Choose Benefits Panel"></a>
		</div>
		<core:clear />
	</div>
</div>

<div class="${name}ContentContainer">
	<div class="hr"></div>
	
	<div class="${name}Content">
		<div class="two-columns">
			<h5>Personalise your <strong>hospital benefits</strong></h5>
		</div>
		<div class="two-columns">
			<h5>Personalise your <strong>Extra benefits</strong></h5>
		</div>
		
		<div id="container4">
			<div id="container3">
				<div id="container2">
					<div id="container1">
						<div id="col1" class="hospital four-columns">
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/PrHospital" 				title="Private Hospital"	value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_253"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/PuHospital" 				title="Private Patient in Public Hospital"	value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_254"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Cardiac" 					title="Heart Surgery"						value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_255"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Obstetric" 				title="Birth Related Services" 				value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_256"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/AssistedReproductive" 	title="Assisted Reproduction eg. IVF"		value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_257"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/CataractEyeLens" 			title="Major Eye Surgery"					value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_258"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/JointReplacement" 		title="Joint Replacement"					value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_259"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/PlasticNonCosmetic" 		title="Non Cosmetic Plastic Surgery"		value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_260"></div>
								<core:clear />
						</div>
						<div id="col2" class="hospital four-columns">
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Sterilisation" 			title="Sterilisation"						value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_262"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/GastricBanding" 			title="Gastric Banding"						value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_263"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/RenalDialysis" 			title="Dialysis"							value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_264"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Palliative" 				title="Palliative Care" 					value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_265"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Psychiatric" 				title="In-Hospital Psychiatry"				value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_266"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Rehabilitation" 			title="In-Hospital Rehabilitation" 			value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_267"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Ambulance" 				title="Ambulance" 							value="Y" required="false" className="hspb" label="true" />
								<div class="help_icon" id="help_284"></div>
								<core:clear />
							<core:clear />
							<div class="ambulanceText"></div>
						</div>
						<div id="col3" class="extras four-columns">
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/DentalGeneral" 		title="General Dental"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_269"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/DentalMajor" 			title="Major Dental"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_270"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Endodontic" 			title="Endodontic"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_271"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Orthodontic" 			title="Orthodontic"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_272"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Optical" 				title="Optical"					value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_273"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Physiotherapy" 		title="Physiotherapy"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_274"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Chiropractic" 		title="Chiropractic"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_275"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Podiatry" 			title="Podiatry"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_276"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Acupuncture" 			title="Acupuncture"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_277"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Naturopath" 			title="Naturopathy"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_278"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Massage" 				title="Remedial Massage"		value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_279"></div>
								<core:clear />
						</div>
						<div id="col4" class="extras four-columns">
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Psychology" 			title="Psychology"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_280"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/GlucoseMonitor" 		title="Glucose Monitor"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_281"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/HearingAid" 			title="Hearing Aids"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_282"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/NonPBS" 				title="Non PBS Pharmaceuticals"	value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_283"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Orthotics" 			title="Orthotics"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_298"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/SpeechTherapy" 		title="Speech Therapy"			value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_297"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/OccupationalTherapy" 	title="Occupational Therapy"	value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_296"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/Dietetics" 			title="Dietetics"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_295"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/EyeTherapy" 			title="Eye Therapy"				value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_294"></div>
								<core:clear />
							<health:checkbox theme="grey" xpath="${xpath}/${xpathBenefitsExtras}/LifestyleProducts"	title="Lifestyle Products"		value="Y" required="false" className="extb" label="true" />
								<div class="help_icon" id="help_293"></div>
								<core:clear />
						</div>
					</div>
				</div>
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
	}

/* HEADER */
	.${name}HeaderText{
		width: 80%;
		float: left;
	}
		.${name}HeaderText h4,
		.${name} p{
			display: inline;
			color: white;
		}
		.${name} p{
			*margin-left: 5px; /* IE7 hack */
		}
	.${name}HeaderActions{
		float: right;
		text-align: left;
		position: relative;
	}
		#${name}Btn{
			display: block;
			height: 33px;
			width: 150px;
			background-repeat: no-repeat;
			background-image: url('brand/ctm/images/buttons/grey_btn_left.png');
			cursor: pointer;
			text-decoration: none;
			text-align: center;
		}
		#${name}Btn span{
			display: block;
			padding: 9px 10px 10px 0;
			color: #666;
			font-size: 14px;
			font-weight: 600;
			background: url('brand/ctm/images/buttons/grey_btn_right.png') right top no-repeat;
			margin-left: 9px;
			text-align: center;
		}
		#${name}CloseBtn{
			position: absolute;
			right: 0;
			top: 0;
			width: 20px;
			height: 20px;
			display: none;
			background-image: url("brand/ctm/images/icons/grey_close_btn.png");
		}
/* CONTENT */
	.${name}ContentContainer{
		background-color: #999;
		z-index: 21;
		position: relative;
		top: -5px;
		<css:rounded_corners value="5" corners="bottom" />
		display: none;
		zoom: 1;
		margin-bottom: -5px;
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
		overflow:hidden;
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
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var ${name}Handler = new Object();
	${name}Handler = {
		init: function(){
			$("#${name}Btn").on("click", function(e){
			
				$('#${name}UpdateBtn').unbind("click"); // will be set/reset in resultsBenefitsMgr.init()
				
				resultsBenefitsMgr.init(function(){
					$("#${name}Btn").fadeOut();
					$("#${name}CloseBtn").fadeIn();
				
					// Add class to tell elements to be repositioned
					$('#results-fixed').addClass('extended');
					Results.resizePage();
					
					$(".${name}ContentContainer").slideDown();
				});
				e.preventDefault();
				
				return false;
			});
			
			$("#${name}CloseBtn").on("click", function(e){
				$("#${name}Btn").fadeIn();
				$("#${name}CloseBtn").fadeOut();
				$(".${name}ContentContainer").slideUp(function(){				
					// Add class to tell elements to be repositioned
					$('#results-fixed').removeClass('extended');
					Results.resizePage();
				});
				
				e.preventDefault();
				
				return false;
			});
		}
	};
</go:script>

<go:script marker="js-head">
	var ResultsBenefitsManager = function() {

		var	that = this,
			elements = {},
			prefix = "${name}_";

		this.init = function( callback ) {
			
			harvest();
			
			this.updateForward();
			
			$('#${name}UpdateBtn').on("click", function(){
				Health.generateNewQuote();
				that.updateBackward();
			});
			
			if( typeof callback == "function" ) {
				callback();
			}
		};
		
		// Retrieve all the values from the benefits slide and store
		var harvest = function() {
			elements = new Object();
			$('#health_benefits-selection-benefits, #health_benefits-selection-extras').find('input:checkbox').each(function(){
				var benefit = {
					id:			$(this).attr('id'),
					source:		$(this),
					target:		$('#' + prefix + $(this).attr('id'))	
				};
				
				elements[benefit.id] = benefit;
			});
		};
		
		// Updates the results page benefits from the questionset
		this.updateForward = function() {
			for(var i in elements) {
				elements[i].target.attr('checked', elements[i].source.is(':checked'));
				if( elements[i].source.is(':disabled') ) {
					elements[i].target.attr('disabled', 'disabled'); 
				} else {
					elements[i].target.removeAttr('disabled'); 
				};
			};
		};
		
		// Updates the questionset benefits from the results page
		this.updateBackward = function() {
			for(var i in elements) {
				elements[i].source.attr('checked', elements[i].target.is(':checked'));
			};
			healthChoices.prefillBenefitsList();
			$("#${name}CloseBtn").trigger('click');
			Health.fetchPrices();
		};
	};

	var resultsBenefitsMgr = new ResultsBenefitsManager();
</go:script>

<go:script marker="onready">
	${name}Handler.init();
</go:script>

<%-- VALIDATION --%>
