<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>


<%-- HTML --%>
<form:fieldset legend="When would you like your policy to start">	
	<form:row label="Commencement date">
		<field:commencement_date xpath="roadside/options/commencementDate" 
								 required="true" />
	</form:row>
</form:fieldset>
<form:fieldset legend="Inspiration">
	<form:row label="What inspired you to quote with us today?">
	<field:import_select xpath="roadside/linkChdId" 
					 url="/WEB-INF/option_data/hear_about_us.html"
					 title="what prompted you to quote with us today"
					 className="linkChdId" 
					 required="true" />
	</form:row>	
</form:fieldset>

<form:fieldset legend="Security, Website Terms of Use &amp; Financial Services Guide">
		
	<field:sar_captcha_code required="false" />
	
	<form:fullrow id="termsRow">
		Please confirm you:<br />
		<p>are accessing this service to obtain a quote as (or on behalf of) a genuine customer,</p>
		<p>are not using this service or the website for commercial or competitive purposes (as further detailed in the <a href="javascript:void(0)"  data-url="${pageSettings.getSetting('websiteTermsUrl')}" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>.)</p>
		
		<field:array_radio xpath="roadside/terms"
			required="false" className="terms" id="terms"
			items="Y=Yes,N=No" title="You must agree to the Website Terms of Use before we can proceed with a quote" />		
	</form:fullrow>
	
</form:fieldset>	

<go:script marker="onready">
	$(function() {
		$("#terms, #fsg").buttonset();
	});
</go:script>

<%-- VALIDATION --%>
<go:validate selector="quote_terms" rule="agree" parm="true" message="In order to continue, you must agree to the Website Terms of Use."/>
<go:validate selector="quote_fsg" rule="agree" parm="true" message="In order to continue, you must acknowledge you have read the Financial Services Guide."/>

<%-- CSS --%>
<go:style marker="css-head">
	#terms {
		display:inline-block;
		zoom:1;
		*display:inline;		
   	}  	
	.termsLink {
		font-size: 12px;
	}
	#termsRow {
		width: 490px;
		height: 100px;
		margin-top: -15px;
		margin-bottom: 5px;
	}
	#termsRow p {
		width: 372px;
		display:inline-block;
		zoom:1;
		*display:inline;
		background: url("common/images/bullet_dot.png") no-repeat left 3px;
		padding-left:13px;
		margin-bottom:3px;
	}
	#termsText {
		width: 390px;
	}
	#fsgRow {
		width:490px;
		height:25px;
		*margin-top: -15px;
		margin-bottom:3px;
	}
	#fsgRow p{
		width:385px;
		display:inline-block;
		zoom:1;
		*display:inline;
	}
	#fsg {
		display:inline-block;
		zoom:1;
		*display:inline;		
   	}
	
	@media screen and (-webkit-min-device-pixel-ratio:0) {
		#terms {
	    	margin-top: -35px;
	   	} 
		#fsg {
	    	margin-top: -25px;
	   	}
		#termsRow {
			margin-top: -25px;
		}	   	
		#help_22 {
			margin-top: -50px;
		}
		#fsgRow {
			height: 35px;
		}
	}
</go:style>
<go:script marker="js-href" href="common/js/swfobject.js" />
	<go:script marker="jquery-ui">
		// Quick config
		var labels  = ['Not important', 'Neutral', 'Important'];
		var min 	= 1;
		var max 	= 3;
		
		// Init everything. We'll do it the long way because it's easier to fetch children
		$('#bigSliders .sliderWrapper').each(function() {
			var related = $(this).find('input');
			var label = $(this).find('span');
			
			$(this).find('.slider').slider({
				'min': min,
				'max': max,
				'value': related.val(),
				'animate': true,
				change: function(event, ui) {
					$(related).val(ui.value);
					$(label).html(labels[ui.value-1]);
				}
			});
			
			// Manually set the label
			$(label).html(labels[related.val()-1]);
		});
		$("#rank-by-price").click(function(){
			$("#bigSliders .sliderWrapper .slider").each(function(){
				$(this).slider("value",2);
			});
			omnitureReporting(4);
			$("#show-results").click();
		});
		$("#show-results").click(function(){
			omnitureReporting(8);
			Interim.disable();
			Interim.showResultsClicked = true;
			
			$("#results-buttons").fadeOut("fast");
			$("#results-contacting").fadeIn("fast");
			ContinueFlash();
		});	
	</go:script>
<go:script marker="js-head">
var Interim = new Object();
Interim = {
	forceTimeout : 0,
	flashPart1Shown : false,
	flashPart2Shown : false,
	showResultsClicked : false,	
	resultsAvailable : false,
	isActive : false, 
	ajaxPending : false,
	ajaxReq : false,
	
	show : function(){
		this.resultsAvailable = false;
		this.flashPart1Shown = false;
		this.flashPart2Shown = false;
		this.showResultsClicked = false;
		
		// Attach the interim class to the help popup and hide-mask 
		$("#helpHide").addClass("interim").bgiframe();
		$("#helpPanel").addClass("interim");
		if ($.browser.msie) {
			$("#helpHide").detach().appendTo("#ieflashMask");
			$("#helpPanel").detach().appendTo("#ieflashMask");
			$("#ieflashMask").show();
		}
				
			
		// Hide the "Retrieving" animation and buttons
		$("#results-buttons").hide();
		$("#results-contacting").hide();
		
		// Hide the last stage of the quote		
		$(".quote-step-6").fadeOut("fast");
		
		// Show the animation
		// Detach and reattach to fire the animation
		if ($.browser.msie) {
				try { 
					var flash = document.getElementById("flashContent");
					flash.play();
					//$("#flashContent").flash(function() { this.Play() });
				} catch(e) {
				}		
		}
		
			
		Results.clear();
		Results.resetExcess();		
		
		this._fetchPrices();
				
		$("#flashWrapper").show();
		$("#flashWrapper").delay(5400).queue("fx", function(next){
			$("#results-buttons").fadeIn();
			
			Interim.flashPart1Shown = true;
			
			Interim.enable();
			
			next();
		});
		this.isActive = true;
	},
	hide : function() {
		this.isActive = false;
		$("#flashWrapper").hide();		
		
		// Remove the interim class to the help popup and hide-mask
		$("#helpHide").removeClass("interim");
		$("#helpPanel").removeClass("interim");	
		if ($.browser.msie){
			$("#helpHide").detach().appendTo("#helpContainer");
			$("#helpPanel").detach().appendTo("#helpContainer");
			$("#ieflashMask").hide();
		}
		this._cancelRequest();
	},
	transitionToResults : function(){
		if (Interim.isActive) {
			$("#flashWrapper").delay(10).queue("fx",function(next){
				Results.show();
				Interim.hide();
				next();
			});
		}
	},
	_cancelRequest : function() {
		if (this.ajaxPending && this.ajaxReq) {
			try {
				this.ajaxReq.abort();
			} catch(e) {}
		}	
	},
	_fetchPrices : function(){
		//log("_fetchPrices called");
	
		if (this.ajaxPending){
			//log("ajax WAS pending");
			this._cancelRequest();
		}
		var dat = $("#mainform").serialize();
		dat+="&transactionId="+referenceNo.getTransactionID();
		this.ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/sar_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				//log("Returned from car_quote_results");
				this.ajaxPending = false;	
				if (Interim.isActive) {
					//log("Interim WAS active");
					
					Results.update(jsonResult.results.price);
					
					Interim.resultsAvailable = true;
					
					//log("Interim.flashPart2Shown: "+Interim.flashPart2Shown);
					//log("Interim.skipAnim: "+Interim.skipAnim);
					//log("Interim.flashPart1Shown: "+Interim.flashPart1Shown);
					//log("Interim.showResultsClicked: "+Interim.showResultsClicked);
					
					// If the flash has completed, go straight to the results.
					if (Interim.flashPart2Shown || Interim.skipAnim) {
					
						//log("Calling transation to results...");
						Interim.transitionToResults();	
					
					// If the initial flash displayed, and show results is not visible (i.e. has been clicked)
					// Continue the flash				
					} else if (Interim.flashPart1Shown && Interim.showResultsClicked) {
						//log("Calling continue flash");
						ContinueFlash();
					}
				}
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				this.ajaxPending = false;
				FatalErrorDialog.display("An error occurred when fetching prices:" + txt, dat);
			},
			timeout:60000
		});
	},
	
	disable : function(){
		$('#bigSliders .sliderWrapper .slider').slider("disable");
		$('#bigSliders').find('.help_icon').hide();
	}, 
	
	enable : function(){
		$('#bigSliders .sliderWrapper .slider').slider("enable");
		$('#bigSliders').find('.help_icon').show();
	}
}
</go:script>



