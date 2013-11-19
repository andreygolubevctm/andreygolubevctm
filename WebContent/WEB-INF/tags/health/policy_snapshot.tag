<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A snapshot of all of the policy exclusions, inclusions and restrictions"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- HTML --%>
<div id="policy_snapshot" class="health_policy_snapshot">
	<ul>
		<li class='tab0'><a href="#confirmation-0">Product Information</a></li>
        <li><a href="#confirmation-1">Your Cover</a></li>
        <li><a href="#confirmation-2">Your Exclusions</a></li>
        <li><a href="#confirmation-3">What happens next?</a></li>
    </ul>

	<div id="confirmation-0">
		<div class="content"></div>
		<div class="about">
			<h5>About the fund</h5>
			<div>Loading...</div>
		</div>
	</div>

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
		<div class="clear"></div>
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
		<div class="clear"></div>
    </div>
    
    <div id="confirmation-3">    	
    	<div class="whats-next">
    		<h4>Your application has been submitted to <span class="fund">the fund</span> for processing... this is what happens next</h4>
    		<div class="content next-info-container"><!--  Add more here --></div>
    	</div>
    </div>    
</div>

<%-- Dialog --%>
<c:set var="onOpen">$('#more_snapshotDialog .content').tabs('option', 'selected', $('#more_snapshotDialog').dialog('option', 'dialogTab'));</c:set>
<c:set var="onClose">healthPolicySnapshot.J_product = false;</c:set>
<ui:dialog
		id="more_snapshot"
		title="Policy Information"
		titleDisplay="true"
		contentBorder="true"
		width="896"
		height="680"
		onOpen="${onOpen}"
		onClose="${onClose}"
		>
	<div id="snapshotSide">
		<div class="pricing">
			<div class="premium">
				<strong></strong>
				<span class="frequency"></span>
			</div>
			<div class="rebatelhc"></div>
		</div>
		<div class="actions">
			<img src="brand/ctm/images/results/results_text_call_us.png" width=156 height=37 alt="Call us on 1800 77 77 12" />
			<p>Quote your reference no.</p>
			<p id="snapshotRefNo">###</p>
			<div class="divider"></div>
			<a href="javascript:void(0)" class="applynow" title="Apply now"><!-- button --></a>
			<div id="snapshotChatOnline"></div>
		</div>
		<div class="whybuy">
			<health:assurance_panel />
		</div>
</div>
	<div id="snapshotContent" class="content"></div>
</ui:dialog>



<%-- TEMPLATES --%>
<core:js_template id="policy-snapshot-productinfo">
		<div class="head [#= info.ProductType #]">
			<div class="logo"><img src="common/images/logos/health/[#= info.provider #].png" alt="[#= info.provider #]" /></div>
			<h4>[#= info.productTitle #]</h4>
			<p class="h">See <a href="/${data.settings.styleCode}/[#= promo.hospitalPDF #]" target="_blank">policy brochure</a></p>
			<p class="e">See <a href="/${data.settings.styleCode}/[#= promo.extrasPDF #]" target="_blank">policy brochure</a></p>
			<p class="c">See <a href="/${data.settings.styleCode}/[#= promo.hospitalPDF #]" target="_blank">hospital brochure</a> and <a href="/${data.settings.styleCode}/[#= promo.extrasPDF #]" target="_blank">extras brochure</a></p>
		</div>
		<div class="excess [#= info.ProductType #]">
			<div><h5>Excess:</h5> [#= hospital.inclusions.excess #]</div>
			<div><h5>Excess waivers:</h5> [#= hospital.inclusions.waivers #]</div>
			<div><h5>Co-payment / % Hospital Contribution:</h5> [#= hospital.inclusions.copayment #]</div>
		</div>
		<div class="discount [#= info.ProductType #]">
			<h5>Discounts</h5>
			<div class="content"></div>
		</div>
		<div class="promo [#= info.ProductType #]">
			<h5>Promotions &amp; offers</h5>
			<div class="content"></div>
		</div>
</core:js_template>

<core:js_template id="policy-snapshot-inclusions-template">
	<li class="[#= publicHospital #]" data-id="publicHospital">Public Hospital</li>
	<li class="[#= privateHospital #]" data-id="privateHospital">Private Hospital</li>
	<p class="PDF">See <a href="/${data.settings.styleCode}/[#= hospitalPDF #]" target="_blank">policy description</a> for more information</p>
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
	<p class="PDF">See <a href="/${data.settings.styleCode}/[#= extrasPDF #]" target="_blank">policy description</a> for more information</p>
</core:js_template>



<%-- JAVASCRIPT --%>
<go:script marker="js-head">

healthPolicySnapshot = {
	_ajaxPending:false,
	_ajaxPendingNextInfo: false,
	_whatsNextFund:false,
	_aboutFund:false,
	J_product: false,
	$J_productHtml: false,
	
	init: function(){
		this._rendered = false;
		
		$('#policy_details').on('click', 'a.more', function(){
			$('#more_snapshotDialog').dialog({ 'dialogTab':0 }).dialog('open');
			healthPolicySnapshot.updatePremium();
			Track.onMoreInfoClick( id );
		});
	},
	
	create: function(){
		this.J_product = this.J_product || Results.getSelectedProduct();
		
		if (!this.J_product) {
			return false;
		};
		
		healthPolicySnapshot.destroy();
		
		<%-- Create a memory DOM object and clean --%>
		var $_obj = $('#policy_snapshot').clone();			
		$_obj.find('div ul.items').empty();
				
		<%-- Prevent product info template from breaking --%>
		if (!this.J_product.hospital) {
			this.J_product.hospital = {};
			this.J_product.hospital.inclusions = {};
			this.J_product.hospital.inclusions.excess = '';
			this.J_product.hospital.inclusions.waivers = '';
		}
		<%-- Product info template --%>
		var _html = $(parseTemplate( $("#policy-snapshot-productinfo").html(), this.J_product) );
		$_obj.find('#confirmation-0 .content').html(_html);
			<%-- Highlight product info excess --%>
			var $e = $_obj.find('#confirmation-0 .excess div:nth-child(1)');
			if ($e.length) {
				$e.html( $e.html().replace(/(\\$\d+)/, '<b>$1</b>') );
			}
			<%-- Dedupe links to brochures --%>
			if (this.J_product.promo.hospitalPDF == this.J_product.promo.extrasPDF) {
				$_obj.find('.head .e, .head .c').hide();
				$_obj.find('.head .h').show();
			}
			<%-- Reference number --%>
			$('#snapshotRefNo').text(this.J_product.transactionId);
			<%-- Premium --%>
			healthPolicySnapshot.updatePremium();
		
		<%-- Create the Hospital Part --%>
		if (this.J_product.info.ProductType != 'GeneralHealth'){
			<%-- HTML --%>
			var _inclusionsHTML = $(parseTemplate( $("#policy-snapshot-inclusions-template").html(), this.J_product.hospital.inclusions) );
			var _hospitalHTML = $(parseTemplate( $("#policy-snapshot-hospital-template").html(), this.J_product.hospital.benefits) );

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
		if (this.J_product.info.ProductType != 'Hospital') {
			<%-- Parse template and add to JS-DOM-Object --%>
			var _extrasHTML = $(parseTemplate( $("#policy-snapshot-extras-template").html(), this.J_product.extras) );
			
			$_obj.find('.extras .covered ul').html( _extrasHTML );
			<%-- Remove undesirables --%>
			$_obj.find('.extras .covered ul li.N').remove();
			$_obj.find('.extras .covered ul p.PDF').appendTo( $_obj.find('.extras div.PDF') );
			$_obj.find('.extras').show();			
		} else {
			<%-- Don't show the extras part at all --%>
			$_obj.find('.extras').hide();
		};
		
		<%-- Render the results --%>
		$('#policy_snapshot, #more_snapshotDialog .content').html( $_obj.html() ).tabs().tabs( "option", "disabled", this._rendered );
		
		<%-- Hiding the exclusion tab --%>
		if (this.J_product.info.ProductType != 'GeneralHealth') {
			$('#policy_snapshot, #more_snapshotDialog').find('.ui-tabs-nav li:nth-child(3)').show();
		} else {
			$('#policy_snapshot, #more_snapshotDialog').find('.ui-tabs-nav li:nth-child(3)').hide();
		};
		
		<%-- Changing the what's next headings --%>
		$('#policy_snapshot').find('.whats-next > h4 span').text( this.J_product.info.providerName );
		$('#more_snapshotDialog').find('.whats-next > h4').text('Once you press the submit button...');
		$('#mainform').find('.health_declaration span').text( this.J_product.info.providerName  );

		<%-- Discount text if applicable --%>
		if (typeof this.J_product.promo.discountText !== 'undefined' && this.J_product.promo.discountText != '') {
			$('#snapshotContent .discount').show().find('.content').html(this.J_product.promo.discountText);
			$("#health_payment_details-selection").find(".definition").show().html(this.J_product.promo.discountText);
		} else {
			$('#snapshotContent .discount').hide().find('.content').empty();
			$("#health_payment_details-selection").find(".definition").hide().empty();
		};
		
		<%-- Promotions text if applicable --%>
		if (typeof this.J_product.promo.promoText !== 'undefined' && this.J_product.promo.promoText != '') {
			$('#confirmation_offers, #snapshotContent .promo').show().find('.content').html(this.J_product.promo.promoText);
			<%-- Attach dialog popup --%>
			$('#confirmation_offers .dialogPop, #snapshotContent .promo .dialogPop').off('click.generic').on('click.generic', function(){
				generic_dialog.display($(this).attr('data-content'), $(this).attr('title'));
			});
			} else {
			$('#confirmation_offers, #snapshotContent .promo').hide().find('.content').empty();
			};
			
		<%-- Buttons --%>
			$('#snapshotSide .applynow').on('click', healthPolicySnapshot.applyNow);
			
		<%-- What happens next information --%>
		if (Health._mode == HealthMode.CONFIRMATION) {
			$('.next-info-container').html( Health._confirmation.data.whatsNext );
			} else {
			if (healthPolicySnapshot._whatsNextFund != this.J_product.info.provider) {
				$('.next-info-container').html('Loading...');
				healthPolicySnapshot._fetchNextInfo(this.J_product.info.provider, '.next-info-container');
			};
			};

		<%-- About the fund information --%>
		if (Health._mode == HealthMode.CONFIRMATION) {
			$('#confirmation_about').find('.content').first().html( Health._confirmation.data.about );
			} else {
			var selector = '#snapshotContent .about div, #confirmation_about .content';
			if (healthPolicySnapshot._aboutFund != this.J_product.info.provider) {
				healthPolicySnapshot._aboutFund = this.J_product.info.provider;
				$(selector).html('Loading...');
				healthPolicySnapshot._fetchAboutFund(this.J_product.info.provider, selector);
			}
			else {
				$(selector).html(Health.aboutHTML);
			}
			};
		
		this._rendered = true;
		return true;
	},
	
	updatePremium: function(){
		this.J_product = this.J_product || Results.getSelectedProduct();
		
		<%-- Premium --%>
		var pf = Results.getSelectedPremium();
		var freq = paymentSelectsHandler.getFrequency();
		if(freq == ''){
			freq = pf.period;
		}else{
			switch( freq )
			{
				case 'W':
					freq = 'weekly';
					break;
				case 'F':
					freq = 'fortnightly';
					break;
				case 'Q':
					freq = 'quarterly';
					break;
				case 'H':
					freq = 'halfyearly';
					break;
				case 'A':
					freq = 'annually';
					break;
				default:
					freq = 'monthly';
					break;
			};
		}
		<%-- if the policy snapshot is visible, and the final price has been calculated, then display that price
			We need to ensure a confirmation retrieval is not using the LHC free prices
		--%>
		if( Health._mode == HealthMode.CONFIRMATION ||
			( $("#policy_details .premium").is(":visible") && ( $("#policy_details .premium:visible").attr("data-text") == $("#policy_details .premium:visible strong").html() ) )
		){
			pf.text = this.J_product.premium[freq].text;
			pf.rebate = this.J_product.premium[freq].pricing;
		} else {
			pf.text = this.J_product.premium[freq].lhcfreetext;
			pf.rebate = this.J_product.premium[freq].lhcfreepricing;
		}
		$('#snapshotSide .pricing .premium').attr("data-text", this.J_product.premium[freq].text);
		$('#snapshotSide .pricing .premium').attr("data-lhcfreetext", this.J_product.premium[freq].lhcfreetext);
		Results._refreshSimplesTooltipContent($('#snapshotSide .pricing .premium'));
		$('#snapshotSide .pricing .premium strong').html(pf.text.replace(/\.(\d\d)/, '.<span>$1</span>'));
		$('#snapshotSide .pricing .frequency').text(pf.label);
		$('#snapshotSide .pricing .rebatelhc').text(pf.rebate);
			
	},

	applyNow: function() {
		$('#more_snapshotDialog').dialog('close');
		Results.applyNow(healthPolicySnapshot.$J_productHtml, 'Online_B');
	},

	destroy: function(){
		$('#snapshotSide .applynow').off('click');
		$('#policy_snapshot, #more_snapshotDialog').find('div ul.items, div.PDF').empty();
		$('#confirmation-order-summary').find('h3.product').text('');
		$('#confirmation_offers').find('.content').html( '' );
		this._rendered = false;
	},
	
	<%-- Fetch the fund information to do with applying for the policy --%>
	_fetchNextInfo: function(_provider, selector) {
		if (healthPolicySnapshot._ajaxPendingNextInfo) {
			if (typeof(this.ajaxReqNextInfo) !== 'undefined') {
				this.ajaxReqNextInfo.abort();
			}
		};
		healthPolicySnapshot._ajaxPendingNextInfo = true;
		this.ajaxReqNextInfo = 
		$.ajax({
			url: "health_fund_info/"+ _provider +"/next_info.html",
			dataType: "html",
			type: "GET",
			async: true,
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
				healthPolicySnapshot._ajaxPendingNextInfo = false;
				healthPolicySnapshot._whatsNextFund = _provider;
				healthPolicySnapshot._nextInfoHTML = htmlResult;
				$(selector).html(healthPolicySnapshot._nextInfoHTML);
				if(typeof $(selector + " .next-info-all") != 'undefined') {
					$(selector + " .next-info-all").load("health_fund_info/next_info_all_funds.html");
				}
			},
			error: function(obj,txt){
				healthPolicySnapshot._ajaxPendingNextInfo = false;
				healthPolicySnapshot._nextInfoHTML = '<p>Apologies. This information did not download successfully.</p>';
				$(selector).html(healthPolicySnapshot._nextInfoHTML);
			}
		});
	},
		
	_fetchAboutFund: function(_provider, selector) {
		if (healthPolicySnapshot._ajaxPending) {
			if (typeof(this.ajaxReq) !== 'undefined') {
				this.ajaxReq.abort();
}
		};
		healthPolicySnapshot._ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "health_fund_info/"+ _provider +"/about.html",
			dataType: "html",
			type: "GET",
			async: true,
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
				Health.aboutHTML = htmlResult;
				$(selector).html(Health.aboutHTML);
				return true;
		},
			error: function(obj,txt){
				healthPolicySnapshot._ajaxPending = false;
				Health.aboutHTML = '<p>Apologies. This information did not download successfully.</p>';
				$(selector).html(Health.aboutHTML);
				return false;
		}
	});
	}
}
</go:script>

<go:script marker="onready">
	healthPolicySnapshot.init();
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
	
	.more_snapshotDialogContainer .ui-dialog-titlebar {
		height: auto;
		padding: 12px 2em !important;
	}

	#more_snapshotDialog {
		padding: 20px;
	}

	#snapshotContent {
		width: 600px;
		float: left;
	}

	#snapshotContent #confirmation-0 {
		padding: 20px;
		line-height: 1.35;
	}
	#confirmation-0 .logo {
		width: 90px;
		height: 45px;
		padding: 5px 10px;
		text-align: center;
		float: left;
		margin-right: 20px;
		box-shadow: 0 0 2px 2px #d9d9d9;
		border-radius: 5px;
	}
	#confirmation-0 .head h4 {
		padding: 0;
		margin: 0;
	}
	#confirmation-0 .head p, #snapshotContent .head p a {
		color: #666;
		font-family: segoe ui, Arial, sans-serif;
		font-weight: bold;
		font-size: 13px;
	}
	#confirmation-0 .head .h, #confirmation-0 .head .e, #confirmation-0 .head .c {
		display: none;
	}
	#confirmation-0 .Hospital .h, #confirmation-0 .GeneralHealth .e, #confirmation-0 .Combined .c {
		display:block;
	}
	#confirmation-0 .excess b {
		color: #093;
		font-size: 18px;
	}
	#confirmation-0 .excess {
		clear: left;
		padding-top: 20px;
	}
	#confirmation-0 .excess.GeneralHealth {
		display: none;<%-- No excess for Extras-only product --%>
	}
	#confirmation-0 .excess h5 {
		display: inline-block;
	}
	#confirmation-0 h5 {
		padding: 0;
		color: #000;
	}
	#confirmation-0 .discount, #confirmation-0 .promo, #confirmation-0 .about {
		border-top: 2px solid #d9d9d9;
		padding-top: 15px;
		margin-top: 20px;
	}
	#confirmation-0 .promo.GeneralHealth {
		border-top: none;
	}

	#snapshotSide {
		width: 208px;
		float: right;
	}
	#snapshotSide .pricing, #snapshotSide .actions {
		border: 3px solid #d9d9d9;
		margin-bottom: 15px;
	}
	#snapshotSide .pricing {
		padding: 15px;
		text-align: center;
	}
	#snapshotSide .pricing .premium {
		background: #F3F9FE;
		padding: 10px;
		border-radius: 5px;
		border: 1px solid #fff;
		box-shadow: 0 0 1px 1px #d9d9d9;
		margin-bottom: 8px;
	}
	#snapshotSide .pricing .premium strong {
		display: block;
		color: #FF4000;
		font-size: 28px;
		font-weight: bold;
		margin-bottom: 3px;
	}
	#snapshotSide .pricing .premium strong span {
		font-size: 80%;
	}
	#snapshotSide .pricing .frequency {
		color: #747474;
		font-weight: bold;
		text-transform: uppercase;
	}
	#snapshotSide .pricing .rebatelhc {
		color: rgb(145, 149, 162);
		font-size: 11px;
	}
	#snapshotSide .actions {
		background: #093;
		padding: 20px 10px 15px;
		text-align: center;
	}
	#snapshotSide .actions img {
		margin-bottom: 5px;
	}
	#snapshotSide .actions p {
		margin: 5px 0;
		font-size: 15px;
		color: #0E4F1B;
	}
	#snapshotSide .actions .applynow {
		display: block;
		width: 169px;
		height: 41px;
		background: url(brand/ctm/images/results/snapshot_btn_applynow.png) 0 0 no-repeat;
		margin: 10px auto 0;
	}
	#snapshotChatOnline {
		margin: 8px auto 0;
	}
	#snapshotRefNo {
		font-weight: bold;
	}
	#snapshotSide .divider {
		width: 202px;
		height: 31px;
		background: url(brand/ctm/images/results/snapshot_side_or.png);
		margin: 8px 0;
		margin-left: -10px;
	}
	<%-- Hide things from application stage --%>
	.stage-3 #snapshotSide .actions .divider,
	.stage-3 #snapshotSide .actions .applynow,
	.stage-4 #snapshotSide .actions .divider,
	.stage-4 #snapshotSide .actions .applynow,
	.stage-5 #confirmation-0,
	.stage-5 .tab0 {
		display:none;
	}	
	.whybuy .health-assurance-message {
		display:block
	}
</go:style>
