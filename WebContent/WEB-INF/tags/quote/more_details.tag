<%@ tag description="The Bridging Page Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<c:set var="css">
	/* STRUCTURE */
		#columns{
			/* display: table; */
			width: 100%;
			height: 100%;
			position: relative;
			
			overflow-y: auto;
			/* padding: 0px 1em; */
		}
		.md-left-column{
			float: left;
			width: 55%;
			padding-right: 5px;
			height: 100%;
		}
		.md-right-column{
			float: right;
			width: 38%;
			margin-right: 10px;
		}
	
	/* SPECIFIC */
		#md-brand {
			width: 100%;
			border-bottom: 1px solid #CCCCCC;
			margin-bottom: 30px;
		}
			#md-brand .icon {
				float:left;
		    	margin:0 24px 12px 12px;
			}
			#md-brand .title{ 
				margin-top: 11px;
				float: left;
			}
				#md-brand .title h2 {
					font-size: 26px;
					color: #4B5053;
				}
				#md-brand .title h3 {
					font-size: 18px;
					font-family: "SunLt Light", "Open Sans", Helvetica, Arial, sans-serif
				}
				
			#md-lead-no{
				float: right;
				margin-top: 23px;
			}
				#md-lead-no .quoteNoTitle{
					color: #989898;
					font-weight: bold;
					font-size: 11px;
					text-align: right;
				}
				#md-lead-no .quoteNo{
					font-size: 22px;
					font-weight: bold;
					text-align: right;
				}
		#md-included h5{
			margin-top: 0;
		}
		
		#md-additional-excess .excessRow{
			width: 100%;
			font-size: 12px;
			margin: 0;
			padding: 0;
			background: url(brand/ctm/images/bullet_edit.png) left 4px no-repeat;
		}
			#md-additional-excess .excessRow .excessRowInfo{
				position: relative;
			}
				#md-additional-excess .excessRow .excessDesc{
					font-size: 13px;
					width: 85%;
					margin: 0 0 0.7em 14px;
				}
				#md-additional-excess .excessVal{
					width: 11%;
					font-weight: bold;
					font-size: 15px;
				}
		
		#md-pds p{
			padding: 3px 0;
		}
		
		#md-details{
			margin-top: 30px;
		}
		
		#md-quote{
			margin: 10px 0 25px 0;
		}
			#md-quote p,
			#md-quote a{
				line-height: initial;
				font-size: 13px;
			}
			
			#md-special-offer{
				margin-bottom: 10px;
			}
				#md-special-offer p,
				#md-special-offer a{
					font-size: 12px;
					font-weight: bold;
				}
				#md-special-offer h5{
					margin-top: 0px;
					color: black;
				}
			
			#md-online-discount{
				color: #999999;
				margin-bottom: 8px;
			}
			
			#md-price{
				background-color: white;
				border: 1px solid #d3d3d3;
				padding: 10px;
			}
				#md-price p{
					padding: 4px 0;
				}
				#md-price .prices{
					border-top: 1px solid #E3E8EC;
					padding: 10px 0;
				}
				#md-price .prices:first-child{
					border-top: none;
					padding-top: 5px;
				}
					#md-price .prices .period{
						float: left;
						width: 20%;
						font-weight: bold;
						font-size: 110%;
					}
					#md-price .prices .period.annual{
						margin-top: 7px;
					}
					#md-price .prices .price{
						float: right;
						width: 75%;
					}
						#md-price .prices .price .bold{
							font-size: 120%;
						}
					#md-price #md-annual-price{
						font-size: 2.5em;
						font-weight: bold;
						display: block;
					}
			.moreDetailsDialogContainer a.button#go-to-insurer {
				width: 100%;
			}
			.moreDetailsDialogContainer a.button#go-to-insurer span{
				font-size: 20px;
				padding-top: 5px;
			}
		
		#md-calls{
			position: relative;
			float: left;
		}
			#md-calls-buttons{
				margin: 0 10px;
			}
				#md-calls-buttons > a.button{
					z-index: 1;
					float: left;
					height: 36px;
				}
				#md-calls-buttons a#CrCallDir.button{
					margin-right: 27px;
				}
					#md-calls-buttons a#CrCallBac.button span{
						padding: 7px 8px 6px 0px;
					}
					#md-calls-buttons > a.button span{
						font-size: 12px;
						padding: 7px 15px 5px 0px;
						margin-left: 3px;
					}
						#md-calls-buttons a.button span img{
							margin-right: 7px;
						}
		
		#md-offline,
		#md-offline .tab,
		#md-callback .tab{
			margin-bottom: 0;
			
			-webkit-border-bottom-right-radius: 0;
			-webkit-border-bottom-left-radius: 0;
			-khtml-border-radius-bottomright: 0;
			-khtml-border-radius-bottomleft: 0;
			-moz-border-radius-bottomright: 0;
			-moz-border-radius-bottomleft: 0;
			border-bottom-right-radius: 0;
			border-bottom-left-radius: 0;
		}
		#md-offline,
		#md-callback{
			position: relative;
			border: none;
		}
		.hide-shadow{
			width: 100%;
			position: absolute;
			height: 14px;
			top: 0;
			left: 0;
		}
		#md-offline .hide-shadow,
		#md-callback .hide-shadow{
			background: #e8e8e8;
		}
		#md-offline .hide-shadow{
			-webkit-border-top-right-radius: 4px;
			-khtml-border-radius-topright: 4px;
			-moz-border-radius-topright: 4px;
			border-top-right-radius: 4px;
		}
		#md-callback .hide-shadow{
			-webkit-border-top-left-radius: 4px;
			-khtml-border-radius-topleft: 4px;
			-moz-border-radius-topleft: 4px;
			border-top-left-radius: 4px;
		}
		#md-offline-quote-no .hide-shadow.lightgrey{
			background: #e8e8e8;
			top: -14px;
		}
		#md-offline-quote-no .hide-shadow{
			background: #dad8d9;
		}
		#offline,
		#callback{
			display: none;
			position: absolute;
			width: 100%;
		}
			#md-offline .tab,
			#md-callback .tab{
				width: 43%;
				position: absolute;
				border: none;
				top: -55px;
				height: 38px;
			}
			#md-offline .tab{
				left: 0px;
			}
			#md-callback .tab{
				right: 0px;
			}
			#md-offline #md-phone-no{
				font-size: 2.5em;
				font-weight: bold;
				padding: 2px 0 5px 0;
			}
		#md-offline-quote-no{
			background-color: #dad8d9;
			margin-bottom: 10px;
			padding: 10px 0;
			text-align: center;			
			
			-webkit-border-top-right-radius: 0;
			-webkit-border-top-left-radius: 0;
			-khtml-border-radius-topright: 0;
			-khtml-border-radius-topleft: 0;
			-moz-border-radius-topright: 0;
			-moz-border-radius-topleft: 0;
			border-top-right-radius: 0;
			border-top-left-radius: 0;
			
			position: relative;
			<css:box_shadow blurRadius="10" color="0,0,0,0.7" />
		}
			#md-offline-quote-no #offline-quote-no{
				font-weight: bold;
				text-align: center;
				font-size: 1.8em;
			}
		
		#md-callback #enter-details{
			font-size: 15px;
			margin-top: 3px;
		}
		#md-callback .fieldrow_label{
			width: 100px;
			margin: 12px 14px 10px 5px;
		}
		#md-callback .fieldrow_legend{
			width: 0px;
			padding: 0;
			margin: 0;
		}
		#md-callback .fieldrow_value{
			margin-left: 0px;
			max-width: 184px;
		}
			#md-callback .fieldrow_value input{
				height: 26px;
				width: 166px;
			}
			#md-callback .fieldrow_value label.error{
				display: block;
			}
			.moreDetailsDialogContainer #md-callback a.button#CrCallBacSub{
				margin-right: 11px;
				margin-bottom: 0;
			}
	
	/* GENERAL */
		.moreDetailsDialogContainer h5{
			color: #0C4DA2;
			margin-top: 10px;
			margin-bottom: 0.1em;
		}
		
		.moreDetailsDialogContainer a{
			font-size: 100%;
		}
		
		.moreDetailsDialogContainer ul{
			margin-bottom: 15px;
		}
		.moreDetailsDialogContainer ul li{
			list-style-image: url(brand/ctm/images/bullet_edit.png);
			list-style-position: outside;
			margin: 0 0 0.6em 14px;
		}
		
		.moreDetailsDialogContainer .green{
			color: #0DB14B;
		}
		
		.moreDetailsDialogContainer p{
			line-height: 20px;
		}
		
		.moreDetailsDialogContainer .rounded-corners{
			-moz-border-radius: 4px;
			-webkit-border-radius: 4px;
			-khtml-border-radius: 4px;
			border-radius: 4px;
		}
		
		.grey-panel {
			background-color: #e8e8e8;
			border: 1px solid #d9d9d9;
			padding: 10px;
			margin-bottom: 10px;
        	
        	<css:box_shadow blurRadius="10" color="0,0,0,0.7" />
		}
			.moreDetailsDialogContainer .grey-panel div.hr{
				border: none;
				border-top: 1px solid #bfbfbf;
				border-bottom: 1px solid white;
				margin: 10px 0;
			}

		.moreDetailsDialogContainer div.hr{
			border: none;
			border-bottom: 1px solid #CCCCCC;
			margin: 15px 0;
		}
		
		.moreDetailsDialogContainer .bullet{
			background: url(brand/ctm/images/bullet_edit.png) left center no-repeat;
			width: 15px;
			height: 100%;
			float: left;
		}
		
		.moreDetailsDialogContainer .narrower{
			width: 85%;
			margin: 10px auto 0px auto;
		}
	
	
	/* DIALOG */
		.moreDetailsDialogContainer.ui-dialog .ui-dialog-content{
			overflow: hidden;
		}
		
		.moreDetailsDialogContainer .more-details-template{
			padding: 0px 0.5em;
		}
</c:set>

<%-- HTML --%>
<c:set var="onOpen">
	$("#columns").height( $(window).height() - 256 );
</c:set>
<ui:dialog
	id="moreDetails"
	titleDisplay="false"
	contentBorder="false"
	dialogBackgroundColor="#fff"
	width="920"
	height="$(window).height()-100"
	extraCss="${css}"
	onOpen="${onOpen}" />

<core:js_template id="more-details-template">
	
	<div class="more-details-template">
	
		<div id="md-brand">
			<div class="icon"><img src="common/images/logos/product_info/[#= productId #].png" alt="[#= productDes #]"></div>
			<div class="title"><div id="scrape-productName"><h2>[#= productDes #]</h2><h3>[#= headline.name #]</h3></div></div>
			
			<div id="md-lead-no">
				<div class="quoteNoTitle">QUOTE NUMBER</div>
				<div class="quoteNo">[#= leadNo #]</div>
			</div>
			<core:clear />
		</div>
		
		<div id="columns">
			<a href="#" class="dialogHackLink">
				Jquery UI Dialog Hack - this link needs to stay here, otherwise the dialog scrolls to the first tabbable/focusable element of the content
			</a>
			<div class="md-left-column">
			
				<div id="md-included">
					<div id="scrape-inclusions">
						<h5>What's included</h5>
						<p>This company has not provided any content for that section at the moment</p>
					</div>
				</div>
				
				<div class="hr"></div>
				
				<div id="md-extras">
					<div id="scrape-extras">
						<h5>Extras</h5>
						<p>This company has not provided any content for that section at the moment</p>
					</div>
				</div>
				
				<div class="hr"></div>
				
				<div id="md-benefits">
					<div id="scrape-benefits">
						<h5>Benefits</h5>
						<p>This company has not provided any content for that section at the moment</p>
					</div>
				</div>
				
				<div class="hr"></div>
				
				<div id="md-conditions">
					<h5>Special Conditions</h5>
					<ul></ul>
				</div>
				
				<div class="hr"></div>
				
				<div id="md-additional-excess-container" style="display:none;">
				<div id="md-additional-excess">
					<h5>Additional Excess</h5>
				</div>
				
				<div class="hr"></div>
				</div>
				
				<div id="md-pds">
					<h5>Product Disclosure Statement</h5>
					<p>This is a brief summary. Conditions apply. Please read the Product Disclosure Statement <a href='javascript:showDoc("[#= pdsaUrl #]")'>Part A</a> and <a href='javascript:showDoc("[#= pdsbUrl #]")'>Part B</a> for more information.</p>
				</div>
				
				<div class="hr"></div>
				
				<div id="md-disclaimer">
					<h5>Disclaimer</h5>
					<p>[#= disclaimer #]</p>
				</div>
				
				<div class="hr"></div>
				
				<div id="md-about">
					<div id="scrape-about">
						<h5>About [#= productDes #]</h5>
						<p>[#= headline.des #]</p>
					</div>
				</div>
				
				<div id="md-details">
					<p>Underwriter: [#= underwriter #]</p>
					<p>AFS Licence No: [#= afsLicenceNo #]</p>
				</div>
				
			</div>
			
			<div class="md-right-column">
			
				<div id="md-quote" class="rounded-corners grey-panel">
				
					<div id="md-special-offer">
						<h5>Special Offer</h5>
						<p>[#= headline.feature #]</p>
					</div>
					
					<div class="hr"></div>
					
					<div id="md-online-discount"><p>Annual and Monthly prices below include the 10% online discount.</p></div>
					
					<div id="md-price" class="rounded-corners">
						<div class="prices">
							<div class="period annual">Annual:</div>
							<div class="price annual"><span id="md-annual-price" class="green bold">$[#= headline.lumpSumTotal #]</span> Annual [#= headline.priceText #]</div>
							<core:clear />
						</div>
						<div class="prices">
							<div class="period monthly">Monthly:</div>
							<div class="price monthly"></div>
							<core:clear />
						</div>
						<div class="prices">
							<div class="period">Excess:</div>
							<div class="price"><span class="green bold">$[#= excess.total #]</span> <span class="excessConditions">refer to Special Conditions and Additional Excess below</span></div>
							<core:clear />
						</div>
					</div>
					
					<div id="md-online" class="narrower">
						<a href="#" class="button" id="go-to-insurer"><span>Loading...</span></a>
						<p class="text-center">Please have your payment details ready. Your transaction will be completed on the insurer's site.</p>
					</div>
					
				</div>
				
				<div id="md-calls">
					<div id="md-calls-buttons">
						<a href="#" class="button offline" id="CrCallDir"><span><img src="common/images/icons/phone-white.png" title="Call direct"  alt="Phone icon" />Call direct</span></a>
						<a href="#" class="button callback" id="CrCallBac"><span><img src="common/images/icons/phone-operator-white.png" title="Get a call back"  alt="Phone operator icon" />Get a call back</span></a>
						<core:clear />
					</div>
					
					<core:clear />
					
					<div id="offline">
						<div id="md-offline" class="rounded-corners grey-panel">
							<div class="tab grey-panel rounded-corners"></div>
							<div class="hide-shadow"></div>
							
							<p class="text-center"><strong>Call direct on</strong></p>
							<p class="text-center" id="md-phone-no">[#= telNo #]</p>
							<p class="text-center">[#= openingHours #]</p>
						</div>
						<div id="md-offline-quote-no" class="rounded-corners offline">
							<p>Please provide the quote number</p>
							<div class="hide-shadow"></div>
							<div class="hide-shadow lightgrey"></div>
							<div id="offline-quote-no" class="quoteNo">[#= leadNo #]</div>
						</div>
					</div>
					
					<div id="callback">
						<div id="md-callback" class="rounded-corners grey-panel">
							<div class="tab grey-panel rounded-corners"></div>
							<div class="hide-shadow"></div>
							
							<form:form name="callback" action="" id="callbackform" method="post">
							
								<div id="enter-details">Enter your details below and we'll get someone to call you.</div>
							
								<div class="hr"></div>
							
								<form:row label="Your name:">
									<field:input xpath="CrClientName" title="Your name" required="false" className="contact-name" />
								</form:row>
								
								<form:row label="Contact Number:">
									<field:contact_telno xpath="CrClientTel" required="true" className="contact-phone" />
								</form:row>

								<a href="#" class="button" id="CrCallBacSub"><span>Submit</span></a>
								
								<core:clear />
								
							</form:form>
							
						</div>
					</div>
					<core:clear />
				</div>
				
				<core:clear />
				
				<div id="md-promo">
					<div id="scrape-ad"></div>
				</div>
			</div>
			
		</div>

	<%-- CLEAR + FOOTER --%>
		<core:clear />
		
		
		
		<core:clear />
	</div>
	
</core:js_template>

<core:js_template id="more-details-excess-template">
	<div class='excessRow'>
		<div class="excessRowInfo">
			<div class='excessDesc'>[#= description #]</div>
			<div class='excessVal'>[#= amount #]</div>
		</div>
	</div>
</core:js_template>

<ui:dialog id="callbackRequest" title="Call back request recorded" width="500">
	<strong>Thank you!</strong><br/><br/>Your Call request has been sent to the insurer's message centre who will be in touch as soon as possible.
</ui:dialog>
							
<go:script marker="js-head">

	// Australian phone number
	jQuery.validator.addMethod("phoneAU", function(value, element) {
		return this.optional(element) || /^(\+?61|0)\d{9}$/.test(value.replace(/\s+/g, ""));
	}, "Please specify a valid phone number");
	
	var moreDetailsHandler = new Object();
	
	moreDetailsHandler = {
	
		_productId: false,
		_product: false,
		_leadNo: "",
		_scrapes: {},
		_callDirectLeadFeedSent: false,
		_callDirectLeadFeedAjaxCall: false,
		_touchEventSent: false,
	
		init : function(prod) {
		
			moreDetailsHandler._productId = prod;
			moreDetailsHandler._product = Results.getResult("productId", prod);
			
			if(moreDetailsHandler._product.available == "Y"){
				moreDetailsHandler.buildTemplate();
				moreDetailsHandler.getScrapes();
				moreDetailsHandler.setEvents();
				moreDetailsHandler.showHideActions();
				
				if(moreDetailsHandler._productId == "PAYD-01-01"){
					$("#md-offline-quote-no").hide();
					$("#md-lead-no").hide();
				};
				moreDetailsDialog.open();
			}
			
		},
		
		getScrapes : function(callback){
			if( typeof moreDetailsHandler._scrapes[moreDetailsHandler._productId] == "undefined") {		
			var dat = {
				"type": "carBrandScrapes",
				"code": moreDetailsHandler._productId,
				"group": "car"
			};
			
			$.ajax({
				url: "ajax/json/get_scrapes.jsp",
				data: dat,
				type: "POST",
				async: true,
				success: function(json){
						
					if(json && json.scrapes && json.scrapes.length > 0){
						$.each(json.scrapes, function(key, scrape){
							if(scrape.html != ''){
								$( scrape.cssSelector.replace( '#', '#scrape-' ) ).html( scrape.html );
							}
						});
						moreDetailsHandler._scrapes[moreDetailsHandler._productId] = json.scrapes;
							
							if(typeof callback == "function"){
								callback();
							}
					}
				},
				dataType: "json",
				error: function(obj,txt){
					FatalErrorDialog.exec({
						message:		"An undefined error has occured - please try again later.",
						page:			"more_details.tag",
						description:	"moreDetailsHandler.getScrapes() - An error occurred when trying to get the scrapes: " + txt,
						data:			dat
					});
				},
				timeout:50000	
			});
			} else {
				$.each(moreDetailsHandler._scrapes[moreDetailsHandler._productId], function(key, scrape){
					if(scrape.html != ''){
						$( scrape.cssSelector.replace( '#', '#scrape-' ) ).html( scrape.html );
					}
				});
				
				if(typeof callback == "function"){
					callback();
				}
			}
			
		},
		
		buildTemplate : function(){
			
			//templates
			var moreDetailsTemplate 		= $("#more-details-template").html();
			var moreDetailsExcessTemplate	= $("#more-details-excess-template").html();
			
			// result
			var res = moreDetailsHandler._product;
			
			// main dialog template
			if(res.headlineOffer == 'ONLINE' && res.brandCode == 'BUDD'){
				res.headline.priceText = "Online Premium (indicative price &ndash; includes 10% online discount)";
			} else {
				res.headline.priceText = "Premium (indicative price)";
				
			}
			
			// opening hours prep
			res.openingHours = res.openingHours.replace(' and ', '</p><p class="text-center">');
			res.openingHours = res.openingHours.replace('Monday to Friday', '<strong>MON-FRI</strong>');
			res.openingHours = res.openingHours.replace('Saturday', '<strong>SAT</strong>');
							
			var dialogContent = $(parseTemplate(moreDetailsTemplate, res));
			
			// if only the monthly instalment value is available (eg for Real PAYD), only show that values instead of instalments
			if( res.headline.instalmentFirst == res.headline.instalmentPayment ){
				dialogContent.find(".price.monthly").html('<span class="green bold">$' + $().number_format(res.headline.instalmentPayment) + '</span> Monthly ' + res.headline.priceText);
			}else{
				dialogContent.find(".price.monthly").html('<span class="green bold">$'+$().number_format(res.headline.instalmentFirst)+'</span> and '+res.headline.instalmentCount+' additional payments of $'+$().number_format(res.headline.instalmentPayment)+' Monthly '+res.headline.priceText);
			}
			
			// Feature text and terms link
			if (res.headline.terms && res.headline.terms!=''){
				var termsLink = $("<a>").attr("href","javascript:Terms.show('"+res.productId+"');").text("Offer terms");
				dialogContent.find("#md-special-offer p").append(" ").append(termsLink);
			}
			
			// callback submit button
			dialogContent.find('#CrCallBacSub').on('click', function(){
				
				$("#callbackform").validate().resetNumberOfInvalids();
				var numberOfInvalids = 0;
				
				// Validate the form
				$('#callbackform :input').each(function(index) {
					var id=$(this).attr("id");
					if (id){
						$("#callbackform").validate().element("#" + id);
					}
				});
		
				var isValid=($("#callbackform").validate().numberOfInvalids() == 0);
				if (isValid){
					$(this).unbind('callback');
					moreDetailsHandler.trackClicks($(this).attr('id'));
					moreDetailsHandler.requestCallback();
				}
				return false;
			});
			
			// clean up
			if(res.leadNo == ''){
				dialogContent.find('#md-lead-no').hide();
			}
			if(res.headline.feature == ''){
				dialogContent.find('#md-special-offer, #md-special-offer + div.hr').hide();
			}
			if(res.headline.des == ''){
				dialogContent.find('#md-about').hide();
			}
			
			// hide/show the online discount text
			var onlineDiscountText = dialogContent.find('#md-online-discount');
			if(res.headlineOffer == 'ONLINE' && res.brandCode == 'BUDD'){
				onlineDiscountText.show();
			} else {
				onlineDiscountText.hide();
			}
			
			
			// Missing PDS B, change text to reflect the unique PDS
			if(res.pdsbUrl == ""){
				dialogContent.find("#md-pds p").html("This is a brief summary. Conditions apply. Please read the <a href=\"javascript:showDoc('"+ res.pdsaUrl +"')\">Product Disclosure Statement</a> for more information.");
			}
						
			// Add any conditions
			var condTag = $(dialogContent).find('#md-conditions ul');
			if (res.conditions){
	
				if (res.conditions.condition instanceof Array) {
					$.each(res.conditions.condition, function() {
						condTag.append("<li>"+this+"</li>");
					});
				} else if(res.conditions.condition != ''){
					condTag.append("<li>"+res.conditions.condition+"</li>");
				} else {
					$(dialogContent).find('#md-conditions, #md-conditions + div.hr').hide();
				}
			} else {
				$(dialogContent).find('#md-conditions, #md-conditions + div.hr').hide();
			}
			
			// Add any additional excess
			if (res.excess) {
				if (res.excess.excess) {
					var excessTag = $(dialogContent).find("#md-additional-excess");
					$.each(res.excess.excess, function(key, value) {
						excessTag.append($(parseTemplate(moreDetailsExcessTemplate, this)));
						if(key == res.excess.excess.length - 1 ){
							// no bottom line on the last row
							var lastBottomLine = excessTag.find(".bottom-line")[key];
							$(lastBottomLine).removeClass('bottom-line');
							// no bottom padding on the last row
							/*
							var lastExcessRow = excessTag.find(".excessRow")[key];
							$(lastExcessRow).css('padding-bottom', '0');
							*/
						}
					});
					$(dialogContent).find("#md-additional-excess-container").show();
				}
	
			}
			
			// Hide 'refer to special conditions text' when there are none.
			// (Note that Woolworths and Real are hardcoded here, this is until a pending ticket resolves their issues in a global way)
			if((res.conditions == '' && (res.excess == null || res.excess && res.excess.excess == null)) || (res.productId == 'WOOL-01-01' || res.productId == 'WOOL-01-02'|| res.productId == 'REIN-01-01'|| res.productId == 'REIN-01-02')){
				$(dialogContent).find("#md-price .excessConditions").hide();
			}

			$("#moreDetailsDialog").html(dialogContent);
			
			// update leadNo in case they are not set in the results object
			moreDetailsHandler.getLeadNo(function(leadNo){
				
				if(leadNo != null && leadNo != ""){
				
					$('#go-to-insurer span').html('Go to Insurer');
					
					// apply online link
					$('#go-to-insurer').on('click', function(){

						$(this).unbind('click');
						moreDetailsHandler.applyOnline();
						
						return false;
					});
					
					$("#moreDetailsDialog .quoteNo").html(leadNo);
					
					$("#moreDetailsDialog .quoteNo").show();
					$("#md-lead-no").show();
					
				} else {
					$("#md-offline-quote-no p").hide();
				}
				
			});
			
			$("#callbackform").validate({
				rules: {
					CrClientName: "required",
					CrClientTelinput: {
						validateTelNo:true
						}
		},
				messages: {
					CrClientTelinput: {
						validateTelNo: "Please specify a valid phone number"
						}
				}
			});
		
			var crClientTelinput = $("#CrClientTelinput");

			crClientTelinput.keyup(function(event) {
				setPhoneMask($(this));
			});

			crClientTelinput.on('blur', function() {
					var id = $(this).attr('id');
					var hiddenFieldName = id.substr(0, id.indexOf('input'));
					var hiddenField = $('#' + hiddenFieldName);
				phoneNumberUpdated($(this), hiddenField , $(this).prop('required'));
			});
			setPhoneMask(crClientTelinput);

			//IE 7 and 8 support
			setUpPlaceHolder(crClientTelinput);
		},

		setEvents: function(){
		
			$("#CrCallDir").on('click', function(){
				$("#moreDetailsDialog #offline").show();
				$("#moreDetailsDialog #callback").hide();
				
				moreDetailsHandler.trackClicks($(this).attr('id'));

				moreDetailsHandler.saveCallDirectLeadFeed();
			});
			
			$("#CrCallBac").on('click', function(){
				$("#moreDetailsDialog #callback").show();
				$("#moreDetailsDialog #offline").hide();
				
				moreDetailsHandler.trackClicks($(this).attr('id'));
			});
			
			$("#moreDetailsDialog .fieldrow_label").on('click', function(){
				$(this).next().children('input').focus();
			});
			
		},
		
		trackClicks: function(elementId){
			
			if(moreDetailsHandler._product.leadNo != null && moreDetailsHandler._product.leadNo != ""){
				Track.bridgingClick(moreDetailsHandler._product.transactionId, moreDetailsHandler._product.leadNo, moreDetailsHandler._productId, elementId);
			} else {
				moreDetailsHandler.getLeadNo(function(leadNo){
					Track.bridgingClick(moreDetailsHandler._product.transactionId, leadNo,  moreDetailsHandler._productId, elementId);
				});
			}
			
		},
		
		getLeadNo: function(callback){
		
			if(moreDetailsHandler._product.leadNo != "" && moreDetailsHandler._product.leadNo != null){
			
				if(typeof callback == "function"){
					callback(moreDetailsHandler._product.leadNo);
				}
				
				return moreDetailsHandler._product.leadNo;
				
			} else {
				
				if (!moreDetailsHandler._product.refnoUrl) {
					return "";
				}
				
				var url = moreDetailsHandler._product.refnoUrl.split("?");
				$.ajax({
					url : url[0],
					data : url[1],
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success : function(leadNo){
					
						if (leadNo != "" && leadNo != null) {
						
							moreDetailsHandler._product.leadNo = leadNo;
							Results._currentPrices[Results.getResultPosition(moreDetailsHandler._productId)].leadNo = leadNo;
							
							if(typeof callback == "function"){
								callback(leadNo);
							}
							
						}
						
					},
					timeout:10000,
					async : true
		
				});
				
			}
			
		},
		
		showHideActions : function(){
		
			// reset
			$('#md-online, #moreDetailsDialog .offline, #moreDetailsDialog .callback').hide();
			$("#md-callback .tab").css('right', '0px').css('left', 'initial');
			
			actionsCode = '';
			
			// availabilities
			var onlineAvailable;
			var offlineAvailable;
			var callbackAvailable;
			
			if( $('.car_modifications :checked').val() == 'Y' ){
				onlineAvailable = moreDetailsHandler._product.onlineAvailableWithModifications;
				offlineAvailable = moreDetailsHandler._product.offlineAvailableWithModifications;
				callbackAvailable = moreDetailsHandler._product.callbackAvailableWithModifications;
			} else {
				onlineAvailable = moreDetailsHandler._product.onlineAvailable;
				offlineAvailable = moreDetailsHandler._product.offlineAvailable;
				callbackAvailable = moreDetailsHandler._product.callbackAvailable;
			}
			
			// ONLINE
			if (onlineAvailable == "Y" && moreDetailsHandler._product.onlinePrice && !isNaN(moreDetailsHandler._product.onlinePrice.lumpSumTotal) ){
				actionsCode += 'O';
				$('#md-online').show();
			}
			
			//OFFLINE
			if (offlineAvailable == "Y" && moreDetailsHandler._product.offlinePrice && !isNaN(moreDetailsHandler._product.offlinePrice.lumpSumTotal)){
				actionsCode += 'P';
				$('#moreDetailsDialog .offline').show();
			}
			// CALLBACK
			if (callbackAvailable == "Y"){
				actionsCode += 'C';
				$('#moreDetailsDialog .callback').show();
			}
			
			if(actionsCode.indexOf('C') != -1 && actionsCode.indexOf('P') == -1){
				$("#md-callback .tab").css('right', 'initial').css('left', '0px');
			}
			
			// if phone but not callback, extend phone button
			if(actionsCode.indexOf('C') == -1){
				$("#CrCallDir").css('margin-right', '0').css('width', '308px');
				$("#md-offline .tab").css('width', '308px');
			}
			
			// if callback but not phone, extend callback
			if(actionsCode.indexOf('P') == -1){
				$("#CrCallBac").css('margin-left', '0').css('width', '308px');
				$("#md-callback .tab").css('width', '308px');
			}
			
		},
		
		applyOnline: function(){
			moreDetailsDialog.close();
			Transferring.show(moreDetailsHandler._product.productDes);
			moreDetailsHandler.getLeadNo(function(){
				Track.transfer(moreDetailsHandler.getLeadNo(), "${data['current/transactionId']}", moreDetailsHandler._productId);
			
				var popTop = screen.height + 300;
				var url = "transferring.jsp?url="+escape(moreDetailsHandler._product.quoteUrl)
							+ "&trackCode="+moreDetailsHandler._product.trackCode
							+ "&brand=" + escape(moreDetailsHandler._product.productDes)
							+ "&msg=" + $("#transferring_"+moreDetailsHandler._productId).text();
	
				if ($.browser.msie) {
					var popOptions="location=1,menubar=1,resizable=1,scrollbars=1,status=1,titlebar=1,toolbar=1,top=0,left=0,height="+screen.availHeight+",width="+screen.availWidth;
					window.open(url , "_blank", popOptions);
				} else {
					window.open(url , "_blank");
				}
				 
				moreDetailsHandler.recordTouchAction("A");

				$("#transferring-popup")
					.delay(4000)
					.queue(function(next) {
						Transferring.hide();
	    				next();
					});
					
			});
		},
		
		saveCallDirectLeadFeed: function(){

			if(moreDetailsHandler._callDirectLeadFeedSent || (moreDetailsHandler._callDirectLeadFeedAjaxCall && moreDetailsHandler._callDirectLeadFeedAjaxCall.readyState < 4) ){
				return;
			}

			if( $("#CrClientName").val() != ''){
				var clientName = $("#CrClientName").val();
			} else if( $("#quote_drivers_regular_firstname").val() != '' || $("#quote_drivers_regular_surname").val() != '' ) {
				var clientName = $("#quote_drivers_regular_firstname").val() + " " + $("#quote_drivers_regular_surname").val();
			}else{
				var clientName = '';
			}

			var crClientTelinput = $("#CrClientTel").val();
			if( crClientTelinput != ''){
				var clientTel = crClientTelinput;
			} else if( $("#quote_contact_phone").val() != '' ) {
				var clientTel = $("#quote_contact_phone").val();
			}else{
				var clientTel = '';
			}

			var dat = {
				source: 'CTMCAR',
				leadNo: moreDetailsHandler.getLeadNo(),
				client: clientName,
				clientTel: clientTel,
				state: $("#quote_riskAddress_state").val(),
				brand: moreDetailsHandler._productId.split('-')[0],
				message: 'CTM - Car Vertical - Call direct',
				phonecallme: 'CallDirect'
			}

			// ajax call
			moreDetailsHandler._callDirectLeadFeedAjaxCall = $.ajax({
				url: "ajax/write/lead_feed_save.jsp",
				data: dat,
				type: "POST",
				async: true,
				dataType: "text",
				timeout:60000,
				cache: false,
				success: function(result){

					if(!result){
						FatalErrorDialog.register({
							message:		"An error occurred when trying to record a call direct lead feed.",
							page:			"quote:more_details.tag",
							description:	"moreDetailsHandler.saveCallDirectLeadFeed(). An error occurred when trying to record a call direct lead feed: invalid result sent back",
							data:			dat
						});
					}

					moreDetailsHandler._callDirectLeadFeedSent = true;

					moreDetailsHandler.recordTouchAction("CD");


					return true;
				},
				error: function(obj,txt){
					FatalErrorDialog.register({
						message:		"An error occurred when trying to record a call direct lead feed.",
						page:			"quote:more_details.tag",
						description:	"moreDetailsHandler.requestCallback() - An error occurred when trying to record a call direct lead feed. AJAX request failed: " + txt,
						data:			dat
					});
				}
			});

		},

		requestCallback: function(){
		
			moreDetailsDialog.close(function(){
			
				Loading.show("Transmitting your call request...", function(){
				
					var dat = $('#callbackform').serialize();
					
					var dat = {
						source: 'CTMCAR',
						leadNo: moreDetailsHandler.getLeadNo(),
						client: $("#CrClientName").val(),
						clientTel: $("#CrClientTel").val(),
						state: $("#quote_riskAddress_state").val(),
						brand: moreDetailsHandler._productId.split('-')[0],
						message: 'CTM - Car Vertical - Call me now',
						phonecallme: 'GetaCall'
					}
					if(moreDetailsHandler._product.vdn){
						$.extend(dat, {vdn: moreDetailsHandler._product.vdn});
					}
						
					// ajax call
					$.ajax({
						url: "ajax/write/lead_feed_save.jsp",
						data: dat,
						type: "POST",
						async: true,
						dataType: "json",
						timeout:60000,
						cache: false,
						success: function(response){
							if(!response){
								Loading.hide(function(){
									FatalErrorDialog.exec({
										message:		"An error occurred when trying to record a callback request - please try again later.",
										page:			"quote:more_details.tag",
										description:	"moreDetailsHandler.requestCallback(). An error occurred when trying to record a callback request: no response sent back."+" RESPONSE:"+response,
										data:			dat
									});
								});
							} else {
								if (response.result == true) {
								Loading.hide(function(){
									callbackRequestDialog.open();

										moreDetailsHandler.recordTouchAction("CB");


								});
								} else {
									Loading.hide(function(){
										FatalErrorDialog.exec({
											message:		"An error occurred when trying to record a callback request - please ensure you have suplied all required information and try again later.",
											page:			"quote:more_details.tag",
											description:	"moreDetailsHandler.requestCallback(). An error occurred when trying to record a callback request."+" RESPONSE:"+response.message,
											data:			dat
										});
									});
							}
							}
						},
						error: function(obj,txt){
							Loading.hide(function(){
							FatalErrorDialog.exec({
									message:		"An communication problem occurred when trying to record a callback request, please check your connection and try again later.",
								page:			"quote:more_details.tag",
									description:	"moreDetailsHandler.requestCallback() - An error occurred when trying to record a callback request. AJAX request failed: " + txt + " | " + obj,
								data:			dat
							});
							});
						}	
					});
					
				});
			
			});
			
		},

		recordTouchAction :function(type){

			if(moreDetailsHandler._touchEventSent == false){

				moreDetailsHandler._touchEventSent = true;

				$.ajax({url:"ajax/write/car_quote_report.jsp?touch="+type,data:" ",cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
		}
				});
		
	}
		}
	
	}

</go:script>