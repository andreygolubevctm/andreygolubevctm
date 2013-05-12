<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 					value="${go:nameFromXpath(xpath)}" />
	<%-- Set these as session scope to be used later --%>
	<c:set var="xpathBenefitsExtras" value="${xpath}/benefitsExtras"  />


<%-- HTML --%>

<%-- Selection Pre-Heading --%>
<div id="${name}-selection" class="health-benefits">
	
	<simples:dialogue id="4" mandatory="false" />
	<simples:dialogue id="5" mandatory="true" />
	<simples:dialogue id="6" mandatory="false" />
	
	<p class="intro"><%-- Completed via JS-Object --%></p>
	<form:row label="Your Situation" className="health-benefits-healthSitu-group">
		<field:general_select xpath="${xpath}/healthSitu" type="healthSitu" className="health-benefits-healthSitu" required="true" title="situation type" />			
	</form:row>

	<%-- Benefits Table --%>
	<div id="${name}-selection-benefits" class="health-benefits-hospital col1of2 columns">
		<form:fieldset legend="Personalise your hospital benefits" className="no-background-color" helpId="286">
			<health:checkbox xpath="${xpathBenefitsExtras}/PrHospital" 				title="Private Hospital"	value="Y" required="false" className="hspb" label="true" />
				<health:info id="253" />
			<health:checkbox xpath="${xpathBenefitsExtras}/PuHospital" 				title="Private Patient in Public Hospital"	value="Y" required="false" className="hspb" label="true" />
				<health:info id="254" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Cardiac" 					title="Heart Surgery"						value="Y" required="false" className="hspb" label="true" />
				<health:info id="255" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Obstetric" 				title="Birth Related Services" 				value="Y" required="false" className="hspb" label="true" />
				<health:info id="256" />
			<health:checkbox xpath="${xpathBenefitsExtras}/AssistedReproductive" 	title="Assisted Reproduction eg. IVF"		value="Y" required="false" className="hspb" label="true" />
				<health:info id="257" />
			<health:checkbox xpath="${xpathBenefitsExtras}/CataractEyeLens" 			title="Major Eye Surgery"					value="Y" required="false" className="hspb" label="true" />
				<health:info id="258" />
			<health:checkbox xpath="${xpathBenefitsExtras}/JointReplacement" 		title="Joint Replacement"					value="Y" required="false" className="hspb" label="true" />
				<health:info id="259" />
			<health:checkbox xpath="${xpathBenefitsExtras}/PlasticNonCosmetic" 		title="Non Cosmetic Plastic Surgery"		value="Y" required="false" className="hspb" label="true" />
				<health:info id="260" />
			<!--<health:checkbox xpath="${xpathBenefitsExtras}/Podiatric" 				title="Surgery by Podiatrist" 				value="Y" required="false" className="hspb" label="true" />
				<health:info id="261" />-->
			<health:checkbox xpath="${xpathBenefitsExtras}/Sterilisation" 			title="Sterilisation"						value="Y" required="false" className="hspb" label="true" />
				<health:info id="262" />
			<health:checkbox xpath="${xpathBenefitsExtras}/GastricBanding" 			title="Gastric Banding"						value="Y" required="false" className="hspb" label="true" />
				<health:info id="263" />
			<health:checkbox xpath="${xpathBenefitsExtras}/RenalDialysis" 			title="Dialysis"							value="Y" required="false" className="hspb" label="true" />
				<health:info id="264" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Palliative" 				title="Palliative Care" 					value="Y" required="false" className="hspb" label="true" />
				<health:info id="265" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Psychiatric" 				title="In-Hospital Psychiatry"				value="Y" required="false" className="hspb" label="true" />
				<health:info id="266" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Rehabilitation" 			title="In-Hospital Rehabilitation" 			value="Y" required="false" className="hspb" label="true" />
				<health:info id="267" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Ambulance" 				title="Ambulance" 							value="Y" required="false" className="hspb" label="true" />
				<health:info id="284" />				
		</form:fieldset>
	</div>

	<%-- Extras Table --%>
	<div id="${name}-selection-extras" class="health-benefits-extras col2of2 columns">
		<form:fieldset legend="Personalise your extras benefits" className="no-background-color" helpId="285">			
			<health:checkbox xpath="${xpathBenefitsExtras}/DentalGeneral" 		title="General Dental"			value="Y" required="false" className="extb" label="true" />
				<health:info id="269" />
			<health:checkbox xpath="${xpathBenefitsExtras}/DentalMajor" 			title="Major Dental"			value="Y" required="false" className="extb" label="true" />
				<health:info id="270" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Endodontic" 			title="Endodontic"				value="Y" required="false" className="extb" label="true" />
				<health:info id="271" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Orthodontic" 			title="Orthodontic"				value="Y" required="false" className="extb" label="true" />
				<health:info id="272" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Optical" 				title="Optical"					value="Y" required="false" className="extb" label="true" />
				<health:info id="273" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Physiotherapy" 		title="Physiotherapy"			value="Y" required="false" className="extb" label="true" />
				<health:info id="274" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Chiropractic" 		title="Chiropractic"			value="Y" required="false" className="extb" label="true" />
				<health:info id="275" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Podiatry" 			title="Podiatry"				value="Y" required="false" className="extb" label="true" />
				<health:info id="276" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Acupuncture" 			title="Acupuncture"				value="Y" required="false" className="extb" label="true" />
				<health:info id="277" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Naturopath" 			title="Naturopathy"				value="Y" required="false" className="extb" label="true" />
				<health:info id="278" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Massage" 				title="Remedial Massage"		value="Y" required="false" className="extb" label="true" />
				<health:info id="279" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Psychology" 			title="Psychology"				value="Y" required="false" className="extb" label="true" />
				<health:info id="280" />
			<health:checkbox xpath="${xpathBenefitsExtras}/GlucoseMonitor" 		title="Glucose Monitor"			value="Y" required="false" className="extb" label="true" />
				<health:info id="281" />
			<health:checkbox xpath="${xpathBenefitsExtras}/HearingAid" 			title="Hearing Aids"			value="Y" required="false" className="extb" label="true" />
				<health:info id="282" />
			<health:checkbox xpath="${xpathBenefitsExtras}/NonPBS" 				title="Non PBS Pharmaceuticals"	value="Y" required="false" className="extb" label="true" />
				<health:info id="283" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Orthotics" 			title="Orthotics"				value="Y" required="false" className="extb" label="true" />
				<health:info id="298" />
			<health:checkbox xpath="${xpathBenefitsExtras}/SpeechTherapy" 		title="Speech Therapy"			value="Y" required="false" className="extb" label="true" />
				<health:info id="297" />
			<health:checkbox xpath="${xpathBenefitsExtras}/OccupationalTherapy" 	title="Occupational Therapy"	value="Y" required="false" className="extb" label="true" />
				<health:info id="296" />
			<health:checkbox xpath="${xpathBenefitsExtras}/Dietetics" 			title="Dietetics"				value="Y" required="false" className="extb" label="true" />
				<health:info id="295" />
			<health:checkbox xpath="${xpathBenefitsExtras}/EyeTherapy" 			title="Eye Therapy"				value="Y" required="false" className="extb" label="true" />
				<health:info id="294" />
			<health:checkbox xpath="${xpathBenefitsExtras}/LifestyleProducts"	title="Lifestyle Products"		value="Y" required="false" className="extb" label="true" />
				<health:info id="293" />
							
			<%--
			<health:checkbox xpath="${xpathBenefitsExtras}/Ambulance" 		title="Ambulance"				value="Y" required="false" className="extb" label="true" />
				<health:info id="284" />
			 --%>				
		</form:fieldset>
	</div>
	<div class="clear"><!-- empty --></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
	.health-benefits .intro {
		margin-top:20px;
		margin-bottom:20px;
	    font-size: 1.2em;
	    line-height: 125%;		
	}
	.health-benefits-healthSitu-group .fieldrow_label {
		text-align:left;
		width:auto;
		padding-right:20px;
	}
	#${name}-selection .columns {
		overflow:auto;
	}
	#${name}-selection .columns label, #${name}-selection .columns input {
		/*float:left;
		margin-top:10px;*/
	}
	#${name}-selection .columns input {
		/*clear:left;
		margin-right:10px;*/
	}
	#${name}-selection .columns .content {
		min-height:440px;
	}
	
	#${name} .clear {
		clear: both;
	}
	
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var HealthBenefits = {

	<%-- This is to make sure the faux button is visible if it needs to be --%>
	_resetButtons: function(){
		if( $('#health_situation-selection:visible, #next-step:visible').length == 2) {
			$('#next-step').hide();
		};
	},
	
	applyNoteListeners : function()
	{
		$('#health_situation_healthSitu').on("change", function(){
				HealthBenefits.showHideNotes(false);
		});
		
		slide_callbacks.register({
			mode:		'after', 
			slide_id:	0, 
			callback:	function(){ HealthBenefits.showHideNotes(false, 0); HealthBenefits._resetButtons(); }
		});
	},
	
	showHideNotes : function( force_hide, delay )
	{
		var delay = delay || 400;
		
		var callback =  function() {
		
		var cover = $('#health_situation_healthSitu').val();
		
		HealthBenefits.updateIntro( cover );
			
		if( $("#health_benefits").is(":visible") )
		{
			force_hide == force_hide || false;
			
			var target = $("#health_benefits-selection");
			
			var y_offset = 132;
<c:if test="${not empty callCentre}">
			
			// adjustment for callcentre dialog boxes
			y_offset += 370;
</c:if>
			
			if( !force_hide && cover == "YS" )
			{
				hints.add({
					target:		target, 
					id:			"cover_ys1", 
					content:	"If you have an active lifestyle, you may want to consider extras like physiotherapy or even cover for expensive treatments like knee reconstructions.",
					group:		"cover_ys",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
				
				hints.add({
					target:		target, 
					id:			"cover_ys2", 
					content:	"More about cover for <a href='javascript:HintsDetailDialog.launch(\"young-singles\");'>young singles</a>",
					group:		"cover_ys",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
			}
			else
			{
				hints.remove("cover_ys1");
				hints.remove("cover_ys2");
			}
			
			if( !force_hide && cover == "YC" )
			{
				hints.add({
					target:		target, 
					id:			"cover_yc1", 
					content:	"Thinking of starting a family? Waiting periods for pregnancy or birth-related services are generally 12 months. Dont' leave it too late.", 
					group:		"cover_yc",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
				hints.add({
					target:		target, 
					id:			"cover_yc2", 
					content:	"More about cover for <a href='javascript:HintsDetailDialog.launch(\"young-couples\");'>young couples</a>", 
					group:		"cover_yc",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
			}
			else
			{
				hints.remove("cover_yc1");
				hints.remove("cover_yc2");
			}
			
			if( !force_hide && cover == "CSF" )
			{
				hints.add({
					target:		target, 
					id:			"cover_csf1", 
					content:	"Waiting periods for <a href='javascript:HintsDetailDialog.launch(\"birth-related-services\");'>pregnancy and birth related services</a> are generally 12 months. Don't leave it too late", 
					group:		"cover_csf",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
				hints.add({
					target:		target, 
					id:			"cover_csf2", 
					content:	"For extra peace of mind, it may be worth considering cover for <a href='javascript:HintsDetailDialog.launch(\"assisted-reproductive-services\");'>assisted reproductive services</a> like IVF.", 
					group:		"cover_csf",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
				hints.add({
					target:		target, 
					id:			"cover_csf3", 
					content:	"More about <a href='javascript:HintsDetailDialog.launch(\"couples-starting-family\");'>couples starting a family</a>", 
					group:		"cover_csf",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
			}
			else
			{
				hints.remove("cover_csf1");
				hints.remove("cover_csf2");
				hints.remove("cover_csf3");
			}
			
			if( !force_hide && cover == "FK" )
			{
				hints.add({
					target:		target, 
					id:			"cover_fk1", 
					content:	"Cover for braces usually has a 12 month waiting period. Some funds will pay more toward these services the longer you are with them.",
					group:		"cover_fk",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
				hints.add({
					target:		target, 
					id:			"cover_fk2", 
					content:	"More about <a href='javascript:HintsDetailDialog.launch(\"families\");'>cover for families</a>",
					group:		"cover_fk",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
			}
			else
			{
				hints.remove("cover_fk1");
				hints.remove("cover_fk2");
			}
			
			if( !force_hide && cover == "M" )
			{
				hints.add({
					target:		target, 
					id:			"cover_m1", 
					content:	"The waiting period for joint replacement is generally 2 months unless it's a pre-existing condition in which case 12 months will apply.", 
					group:		"cover_m",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
				hints.add({
					target:		target, 
					id:			"cover_m2", 
					content:	"More information about cover for <a href='javascript:HintsDetailDialog.launch(\"mature-couples\");'>mature couples</a>", 
					group:		"cover_m",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
			}
			else
			{
				hints.remove("cover_m1");
				hints.remove("cover_m2");
			}
			
			if( !force_hide && cover == "ATP" )
			{
				hints.add({
					target:		target, 
					id:			"cover_atp", 
					content:	"If you earn over $84,000 as a single or $168,000 as a family, you  will have to pay  additional  tax if you don't have private hospital cover.  More on the <a href='javascript:HintsDetailDialog.launch(\"medicare-levy-surcharge\");'>Medicare Levy Surcharge</a>.", 
					group:		"cover_atp",
					position:	"top",
						y_offset:	y_offset,
						x_offset:	20
				});
			}
			else
			{
				hints.remove("cover_atp");
			}
		}
		};
		
		setTimeout(function() {	
			callback();
		}, delay);
	},
	
	updateIntro : function( situ )
	{
		var intro = "We have identified the following hospital benefits and extras for your situation. <br /> However please go ahead and personalise these to suit your specific needs.";
		
		switch( situ )
		{
			case "YS":
				intro = "You're young, free and single. We've provided some options that may suit you. To make sure we find you the right cover, let's start with a little more information about you and your needs.";
				break;
			case "YC":
				intro = "You're a young couple. We've provided some options that may suit you. To make sure we find the right Health Cover for the both of you - let's find out more about your needs.";
				break;
			case "CSF":
				intro = "Congratulations on starting a family. We've provided some options that may suit you. To make sure we find you the right cover, we'll need a little more information about you and your new family's needs.";
				break;
			case "FK":
				intro = "You're a family.  Here are some options that may suit you.<br />To start comparing, we'll need a little more information about you and your family's needs.";
				break;
			case "M":
				intro = "You're a mature couple.  Here are some options that may suit you. To make sure we find the appropriate cover for you both, we'll need to know a little more about your needs.";
				break;
			case "ATP":
				intro = "We're showing you the minimum requirement to avoid the Medicare Levy Surcharge. However, why not take the time to consider whether you'd like a more comprehensive level of cover.";
				break;
			case "LC":
			case "LBC":
			case "O":
			default:
				intro = "Whatever your situation - you're in the right place to compare Health Insurance .  To get you started, we've provided some options that may suit you.  To help us find you the appropriate cover, we'll need to know a little more about your needs.";
				break;
		}
		
		$("#health_benefits-selection").find(".intro").first().empty().append( intro );
	}	
};
</go:script>

<go:script marker="onready">
	$('#${name}-selection').find('.health-info-icon').on('click', function(){
		$(this).siblings('.health-info-text').slideToggle('fast');
	});
	
	$('.health-benefits-healthSitu').on('change',function() {
		healthChoices.setSituation($(this).val());
		HealthBenefits.showHideNotes(false, 0);
	});	
	
	$('#health_benefits input:checkbox').each(function(){
		$(this).click(function(){
			var benefit = $(this).attr("id").split("Extras_")[1];
			if($(this).is(":checked")) {
				healthChoices.addBenefit(benefit);
			} else {
				healthChoices.removeBenefit(benefit);
			}
		});
	});
	
	HealthBenefits.applyNoteListeners();
</go:script>