<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="A snapshot of all of the policy exclusions, inclusions and restrictions"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- HTML --%>
<div id="policy_snapshot" class="health_policy_snapshot">
	<ul>
        <li><a href="#confirmation-1">Your Cover</a></li>
        <li><a href="#confirmation-2">Your Exclusions</a></li>
        <li><a href="#confirmation-3">What happens next?</a></li>
    </ul>
    <div id="confirmation-1">    	
    	<%-- Hospital area --%>
    	<div class="hospital">
    		<h4>Hospital Benefits</h4>
    		<div class="covered">
	    		<h5>You are covered for</h5>
	    		<ul class="items"></ul>
    		</div>
    		<div class="restricted">
    			<h5>You have restricted cover for</h5>
    			<ul class="items"></ul>
    		</div>
    		<div class="PDF"></div>   		
    	</div>
    	<%-- Extras area --%>
   		<div class="extras">
   			<h4>Extras</h4>
   			<div class="covered">
   				<h5>You are covered for</h5>
   				<ul class="items"></ul>
   			</div>
   			<div class="PDF"></div>
   		</div>
   		<br clear="all" /> 	
    </div>
    
    <div id="confirmation-2">		
 		<%-- Hospital area --%>
    	<div class="hospital">  
    		<div class="excluded">
    			<h4>Your Hospital Exclusions</h4>
    			<ul></ul>
    		</div>	
    		<div class="PDF"></div>
    	</div> 
    	<br clear="all" />
    </div>
    
    <div id="confirmation-3">    	
    	<div class="whats-next">
    		<h4>Your application has been submitted to <span class="fund">the fund</span> for processing... this is what happens next</h4>
    		<div class="content next-info-container"><!--  Add more here --></div>
    	</div>
    </div>    
</div>

<%-- The empty container --%>
<div id="more_snapshot">
	<div class="content"></div>
	<div class="dialog_footer"></div>
</div>


<%-- TEMPLATES --%>
<core:js_template id="policy-snapshot-inclusions-template">
	<li class="[#= publicHospital #]" data-id="publicHospital">Public Hospital</li>
	<li class="[#= privateHospital #]" data-id="privateHospital">Private Hospital</li>
	<p class="PDF">See <a href="/${data.settings.styleCode}/[#= hospitalPDF #]" target="_blank">Policy description</a> for more information</p>
</core:js_template>

<core:js_template id="policy-snapshot-hospital-template">
	<li class="[#= Cardiac.covered #]" data-id="Cardiac">Heart Surgery</li>
	<li class="[#= Obstetric.covered #]" data-id="Obstetric">Birth Related Services</li>
	<li class="[#= AssistedReproductive.covered #]" data-id="AssistedReproductive">Assisted Reproduction</li>
	<li class="[#= CataractEyeLens.covered #]" data-id="CataractEyeLens">Major Eye Surgery</li>
	<li class="[#= JointReplacement.covered #]" data-id="JointReplacement">Joint Replacement</li>
	<li class="[#= PlasticNonCosmetic.covered #]" data-id="PlasticNonCosmetic">Non Cosmetic Plastic Surgery</li>
	<!--<li class="[#= Podiatric.covered #]" data-id="Podiatric">Surgery by Podiatrist</li>-->
	<li class="[#= Sterilisation.covered #]" data-id="Sterilisation">Sterilisation</li>
	<li class="[#= GastricBanding.covered #]" data-id="GastricBanding">Gastric Banding</li>
	<li class="[#= RenalDialysis.covered #]" data-id="RenalDialysis">Dialysis</li>
	<li class="[#= Palliative.covered #]" data-id="Palliative">Palliative Care</li>
	<li class="[#= Psychiatric.covered #]" data-id="Psychiatric">In-Hospital Psychiatry</li>
	<li class="[#= Rehabilitation.covered #]" data-id="Rehabilitation">In-Hospital Rehabilitation</li>
	<c:if test="${not empty callCentre}">
		<li class="N exclusions_cover" data-id="exclusions.cover">[#= exclusions.cover #]</li>
	</c:if>
</core:js_template>

<core:js_template id="policy-snapshot-extras-template">
	<li class="[#= DentalGeneral.covered #]" data-id="DentalGeneral">General Dental</li>
	<li class="[#= DentalMajor.covered #]" data-id="DentalMajor">Major Dental</li>
	<li class="[#= Endodontic.covered #]" data-id="Endodontic">Endodontic</li>
	<li class="[#= Orthodontic.covered #]" data-id="Orthodontic">Orthodontic</li>
	<li class="[#= Optical.covered #]" data-id="Optical">Optical</li>
	<li class="[#= Physiotherapy.covered #]" data-id="Physiotherapy">Physiotherapy</li>
	<li class="[#= Chiropractic.covered #]" data-id="Chiropractic">Chiropractic</li>
	<li class="[#= Podiatry.covered #]" data-id="Podiatry">Podiatry</li>
	<li class="[#= Acupuncture.covered #]" data-id="Acupuncture">Acupuncture</li>
	<li class="[#= Naturopathy.covered #]" data-id="Naturopathy">Naturopathy</li>
	<li class="[#= Massage.covered #]" data-id="Massage">Remedial Massage</li>
	<li class="[#= Psychology.covered #]" data-id="Psychology">Psychology</li>
	<li class="[#= GlucoseMonitor.covered #]" data-id="GlucoseMonitor">Glucose Monitor</li>
	<li class="[#= HearingAids.covered #]" data-id="HearingAids">Hearing Aids</li>
	<li class="[#= NonPBS.covered #]" data-id="NonPBS">Non PBS Pharmaceuticals</li>
	<li class="[#= Orthotics.covered #]" data-id="Orthotics">Orthotics</li>
	<li class="[#= SpeechTherapy.covered #]" data-id="SpeechTherapy">Speech Therapy</li>
	<li class="[#= OccupationalTherapy.covered #]" data-id="OccupationalTherapy">Occupational Therapy</li>
	<li class="[#= Dietetics.covered #]" data-id="Dietetics">Dietetics</li>
	<li class="[#= EyeTherapy.covered #]" data-id="EyeTherapy">Eye Therapy</li>
	<li class="[#= LifestyleProducts.covered #]" data-id="LifestyleProducts">Lifestyle Products</li>
	<p class="PDF">See <a href="/${data.settings.styleCode}/[#= extrasPDF #]" target="_blank">Policy description</a> for more information</p>
</core:js_template>



<%-- JAVASCRIPT --%>
<go:script marker="js-head">

healthPolicySnapshot = {
	_ajaxPending:false,
	_whatsNextFund:false,
	_aboutFund:false,
	
	init: function(){
		this._rendered = false;
	},
	
	create: function(){
		var J_product = Results.getSelectedProduct();
		
		if(!J_product){
			return false;
		};
		
		healthPolicySnapshot.destroy();
		
		<%-- Create a memory DOM object and clean --%>
		var $_obj = $('#policy_snapshot').clone();			
		$_obj.find('div ul.items').empty();
				
		
		<%-- Create the Hospital Part --%>
		if( J_product.info.ProductType != 'GeneralHealth' ){
			<%-- HTML --%>
			var _inclusionsHTML = $(parseTemplate( $("#policy-snapshot-inclusions-template").html(), J_product.hospital.inclusions) );
			var _hospitalHTML = $(parseTemplate( $("#policy-snapshot-hospital-template").html(), J_product.hospital.benefits) );

			$_obj.find('.hospital .covered ul').html( _inclusionsHTML ).append( _hospitalHTML );
			$_obj.find('.hospital .covered').find('p.PDF').appendTo(  $_obj.find('.hospital div.PDF') );	
			
			<%-- Restricted pieces --%>
			var _R = $_obj.find('.hospital .covered').find('li.R');
			
			if( _R.length > 0 ) {
				_R.appendTo( $_obj.find('.hospital .restricted ul')  );
				$_obj.find('.hospital .restricted').show();
			} else {
				$_obj.find('.hospital .restricted').hide();
			};
			
			<%-- Excluded Objects --%>
			var _N = $_obj.find('.hospital .covered').find('li.N');
			
			if( _N.length > 0 ) {
				$_obj.find('.hospital .excluded ul').empty();
				_N.appendTo( $_obj.find('.hospital .excluded ul')  );
			} else {
				$_obj.find('.hospital .excluded ul').html('<li class="N">Please See Policy Description</li>');
			};
			
			$_obj.find('.hospital').show();						
		} else {
			$_obj.find('.hospital').hide();
		};		
				
		
		<%-- Create the Extras Part --%>
		if( J_product.info.ProductType != 'Hospital' ){
			<%-- Parse template and add to JS-DOM-Object --%>
			var _extrasHTML = $(parseTemplate( $("#policy-snapshot-extras-template").html(), J_product.extras) );
			
			$_obj.find('.extras .covered ul').html( _extrasHTML );
			<%-- Remove undesirables --%>
			$_obj.find('.extras .covered ul li.N').remove();
			$_obj.find('.extras .covered ul p.PDF').appendTo( $_obj.find('.extras div.PDF') );
			$_obj.find('.extras').show();			
		} else {
			<%-- Don't show the extras part at all --%>
			$_obj.find('.extras').hide();
		};
		
		
		<%-- CREATE: the next information part if not already rendered --%>			
		if(Health._mode == 'confirmation'){
			$_obj.find('.next-info-container').html( Health._confirmation.data.whatsNext );
		} else {
			if( healthPolicySnapshot._whatsNextFund != J_product.info.provider ){
				$_obj.find('.next-info-container').html(  healthPolicySnapshot._fetchNextInfo(J_product.info.provider)  );
			};
		};
		
		<%-- Create the about information and at it to the render --%>
		if(Health._mode == 'confirmation'){
			 $('#confirmation_about').find('.content').first().html( Health._confirmation.data.about );
		} else {
			if( healthPolicySnapshot._aboutFund != J_product.info.provider ){
			    $('#confirmation_about').find('.content').first().html( Health.fetchAbout( J_product.info.provider ) );
			    healthPolicySnapshot._aboutFund = J_product.info.provider;
			};		
		};
		
		<%-- Render the results --%>
		$('#policy_snapshot, #more_snapshot .content').html( $_obj.html() ).tabs().tabs( "option", "disabled", this._rendered );				
		
			<%-- Hiding the exclusion tab --%>
			if( J_product.info.ProductType != 'GeneralHealth' ){
				$('#policy_snapshot, #more_snapshot').find('.ui-tabs-nav li:nth-child(2)').show();
			} else {
				$('#policy_snapshot, #more_snapshot').find('.ui-tabs-nav li:nth-child(2)').hide();
			};
			
			<%-- Changing the what's next headings --%>
			$('#policy_snapshot').find('.whats-next > h4 span').text( J_product.info.providerName );
			$('#more_snapshot').find('.whats-next > h4').text('Once you press the submit button...');
			
		$('#confirmation_offers').find('.content').html( J_product.promo.promoText );		
		$('#mainform').find('.health_declaration span').text( J_product.info.providerName  );
		
			<%-- Discount text if applicable --%>
			if( J_product.promo.discountText != ''){
				$("#health_payment_details-selection").find(".definition").show().html(J_product.promo.discountText);
			} else {
				$("#health_payment_details-selection").find(".definition").hide().empty();
			};

			<%-- Promotions text if applicable --%>
			if( J_product.promo.promoText != ''){
				$("#confirmation_offers").show().find('.content').html(J_product.promo.promoText);
			} else {
				$("#confirmation_offers").hide().find('.content').empty();
			};
		
		this._rendered = true;
		return true;
	},
	
	destroy: function(){
		$('#policy_snapshot, #more_snapshot').find('div ul.items, div.PDF').empty();
		$('#confirmation-order-summary').find('h3.product').text('');
		$('#confirmation_offers').find('.content').html( '' );
		this._rendered = false;
	},
	
	<%-- Fetch the fund information to do with applying for the policy --%>
	_fetchNextInfo: function(_provider){
		if (healthPolicySnapshot._ajaxPending){
			return; // already one in progress
		};
		healthPolicySnapshot._ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "health_fund_info/"+ _provider +"/next_info.html",
			dataType: "html",
			type: "GET",
			async: false,
			timeout:30000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(htmlResult){
				healthPolicySnapshot._ajaxPending = false;
				healthPolicySnapshot._nextInfoHTML = htmlResult;
				healthPolicySnapshot._whatsNextFund = _provider;
			},
			error: function(obj,txt){
				healthPolicySnapshot._ajaxPending = false;
				healthPolicySnapshot._nextInfoHTML = '<p>Apologies. This information did not download successfully.</p>';
			}
		});
		<%-- NOTE: this is used by the save confirmation function --%>
		return healthPolicySnapshot._nextInfoHTML;
	}
		
}

</go:script>


<go:script marker="jquery-ui">
	$('#more_snapshot').dialog({
		title: 'Policy Information',
		show: {
			effect: 'clip',
			complete: function(){
				$('#more_snapshot .content').tabs('option', 'selected', $('#more_snapshot').dialog('option', 'dialogTab'));
			}
		},
		autoOpen: false,
		hide: 'clip', 
		'modal':true, 
		'width':637,
		'minWidth':500, 'minHeight':600,  
		'autoOpen': false,
		'draggable':false,
		'resizable':false,
		close: function(){
			//$(".applyByPhoneDialog").hide();	
		},
		open: function(){
			$('#more_snapshot .content').tabs('option', 'selected', $('#more_snapshot').dialog('option', 'dialogTab'));
			$('.ui-widget-overlay').bind('click', function () { $('#more_snapshot').dialog('close'); });
		}
	});
</go:script>


<go:script marker="onready">
	healthPolicySnapshot.init();
	
	$('#policy_details').on('click','a.more', function(){
		$('#more_snapshot').dialog("open").dialog({ 'dialogClass':'show-close', 'dialogTab':0});
	});
	
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	.health_policy_snapshot div li {
		display:none;
	}
	.health_policy_snapshot div .covered li.Y,
	.health_policy_snapshot div .excluded li.N,
	.health_policy_snapshot div .restricted li.R {
		display:block;
	}
	
	.health_policy_snapshot div li.PDF {
		display:block;
		margin-top:24px;
	}
	
	health_policy_snapshot .PDF {
		font-size:12px;
		line-height:120%;
		padding-left:20px;
	}
	
	health_policy_snapshot .PDF a {
		font-size:100%;
	}
	
	.show-close .ui-dialog-titlebar-close {
		display:block;
	}
	#more_snapshot {
		display:none;
	}	
</go:style>