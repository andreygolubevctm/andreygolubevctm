<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- HTML --%>
<div id="applyOnlineDialog" class="applyOnlineDialog AOL_APB">
<div class="aolDialog">
	
	<div id="aolSummary" class="AOL_APB_summary">
		<div class="icon"></div>
		<div class="title"></div>
		<div class="uws"></div>
		<div class="afs"></div>
	</div>
	
	<%-- 'Column' One --%>
	<div id="aolContent" class="AOL_APB_content">
		
		<%-- Main Tag Content --%>
		<div id="aolAOL" class="AOL_APB_main">
			<div class="AOL_APB_header">
				<div id="aolApplyButton"><a class="button"><span>Apply Online</span></a></div>
			</div>
			<p class="or"><strong>OR</strong></p>
			<p><strong><a class="button smlbtn"><span>Continue By Phone</span></a></strong></p>
			<p><strong>Please provide your quote reference number to the operator.</strong></p>
			<div class="reference">
				<p>Reference number: <span></span></p>
			</div>
			<div class="phoneHours"></div>
		</div>
			
		<%-- Terms and Conditions --%>	
		<div id="aolPDS" class="AOL_APB_PDS">
			<h5>Product Disclosure Statement</h5>
			<p>Please read the Product Disclosure Statements<br /> before deciding to buy: <span class="aolPDSlinks"></span></p>
			<h5>Disclaimer</h5>
			<p>The indicative quote includes any applicable online discount and is subject to meeting the insurers underwriting criteria and may change due to factors such as:
			<br />- Driver's history or offences or claims
			<br />- Age or licence type or additional drivers
			<br />- Vehicle condition, accessories and modifications</p>
		</div>
	
	</div>
	
	<%-- 'Column' Two (additional content) --%>
	<div id="aolAside" class="AOL_APB_aside">
		<div id="aolQuote" class="AOL_APB_quote">
			<h3>Quote Summary</h3>
			<div class="item">	
				<h4>Online Premium <em>(indicative price)</em></h4>
				<p class="premium"></p>
			</div>
			<div class="item">		
				<h4>Basic Excess</h4>
				<p class="excess"></p>
			</div>
			<div class="item">	
				<h4>Vehicle</h4>
				<p class="vehicle"></p>
			</div>
		</div>
		<div id="aolOffers" class="AOL_APB_offers">
			<h3>Special Feature/Offer</h3>
			<div class="items"></div>
		</div>
		<div id="aolConditions" class="AOL_APB_conditions">
			<h3>Special Conditions</h3>
			<div class="items"></div>
		</div>
	</div>
	
	<div id="aolProd"></div>
	<br clear="all" />	
</div>	
</div>



<%-- CSS --%>
<go:style marker="css-head">
	#applyOnlineDialog h2 {
		font-size:17px;
		width:597px;
		padding:20px 20px 0px 20px;
		margin:-12px -12px 0 -12px;			
	}
	#aolSummary {
		overflow: auto;
    	padding-top: 12px;
    	margin-top:12px;
	}
	#aolSummary .icon {
		float:left;
    	margin:0 24px 12px 12px;
	}
	#aolSummary .title {
		font-size:17px;
		margin-bottom:12px;
	}
	#aolSummary .uws, #aolSummary .afs {
		font-size:11px;
		color:#808080;
	}
	
	#aolContent {
		width:386px;
		float:left;
		margin-left:6px;		
	}	
		#aolAOL {
			text-align:center;
		}
		#aolAOL p {
			margin:.2em 0;
		}
		#aolAOL .phoneHours {
			font-size:11px;
		}
		#aolAOL .phone {
			font-size:36px;
			margin:6px auto;
		}
		#aolAOL .reference {
			width:50%;
			margin:12px auto;
			padding:12px;
			font-size:12px;
			font-weight:bold;
			border-radius:12px;
		}
			#aolAOL .reference span {
				display:block;
				font-size:18px;
			}
		#aolAOL .smlbtn {
			margin-left:auto;
			margin-right:auto;
			width:130px;
		}	
		#aolPDS {			
			padding:20px;			
		}
			#aolPDS h5 {
				margin-top:20px;
				margin-bottom:.5em;
			}
			#aolPDS h5:first-child {
				margin-top:0;
			}
			.aolPDSlinks a {
				display:block;
				margin:.2em 0;
			}
		
	#aolAside {
		float: right;
		width: 200px;
		margin-right:6px;
	}
		#aolQuote, #aolOffers, #aolConditions {
			padding:10px;
			width:180px;
			min-height:48px;			
		}
			#aolAside h3 {
				font-size:14px;
				font-weight:bold;
				display:inline-block;
				width:100%;				
			}
			#aolQuote h4 {
				font-size:100%;
				margin-bottom:.2em;
			}
			#aolQuote h4 em {
				font-size: 85%;
				font-style: normal;
			}
		.AOL_APB_quote .item {
			padding:10px 0;
		}
		#aolSpecial {
		}
		#aolConditions {
		}
		
.ui-dialog.no-close .ui-dialog-titlebar-close,
.ui-dialog.no-title .ui-dialog-title  {
	display:none;
}
		
#applyOnlineClose {
	background: url(common/images/dialog/close.png) no-repeat;
	width: 36px; height: 31px;
	position: absolute; top:16px; right: 9px;
	cursor: pointer; display: none;
}		  						 
#applyOnlineFooter {
	background: url("common/images/dialog/footer.gif") no-repeat scroll left top transparent;
	width: 637px; height: 14px;
	clear:both;
	display:none;
}
#applyOnlineDialog {
	overflow:hidden;
}
#aolProd {
	display:none;
}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$('#applyOnlineDialog').dialog({
		title: 'Apply Online',
		autoOpen: false,
		show: 'clip',
		hide: 'clip', 
		'modal':true, 
		'width':637,
		'minWidth':500, 'minHeight':600,  
		'autoOpen': false,
		'draggable':false,
		'resizable':false,
		close: function(){
			$(".applyOnlineDialog").hide();	
   		}
	});		
		
	$('.ui-dialog').append('<div id="applyOnlineClose" onclick="closeApplyOnlineDialog()" class="applyOnlineDialog"></div><div id="applyOnlineFooter" class="applyOnlineDialog"></div>');

</go:script>

<go:script marker="js-head">
	var initialClick = true;
	function applyOnline(prod, jumpToUrl) {

		k_button.setCustomVariable(270, Results.getLeadNo(prod));
		
		if (initialClick == true) {
			$.ajax({url:"ajax/write/car_quote_report.jsp",data:" ",cache: false, 
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				}
			});
			initialClick = false;
		}
		// If there are no conditions, jump to the quote page		
		
		var res = Results.getResult(prod); 
		
		if (!res.conditions || jumpToUrl) {
			Track.transfer(Results.getLeadNo(prod),Results.getTranId(prod),prod);
						
			// replace #QUOTENO if present in the URL
			var quoteUrl = $("#quoteUrl_"+prod).text();
			if (quoteUrl.indexOf('QUOTE#')){
				quoteUrl = quoteUrl.replace('QUOTE#',Results.getLeadNo(prod));
				$("#quoteUrl_"+prod).text(quoteUrl);
			}			

			Transferring.show(res.productDes);
			var popTop = screen.height + 300;
			var url = "transferring.jsp?url="+escape($("#quoteUrl_"+prod).text())
						+ "&trackCode="+res.trackCode
						+ "&brand=" + escape(res.productDes)
						+ "&msg=" + $("#transferring_"+prod).text();
												 
			if ($.browser.msie) {
				var popOptions="location=1,menubar=1,resizable=1,scrollbars=1,status=1,titlebar=1,toolbar=1,top=0,left=0,height="+screen.availHeight+",width="+screen.availWidth;
				window.open(url , "_blank", popOptions);
			} else {
				window.open(url , "_blank");
			}
			 
			$("#transferring-popup")
				.delay(4000)
				.queue(function(next) {
					Transferring.hide();
    				next();
				});
						
			return;
		}
		else {
			Track.transferInit('ONLINE',Results.getLeadNo(prod),Results.getTranId(prod),prod);
		}
		
		<%-- Create the HTML content before inserting it --%>
		var _html = $('.aolDialog').clone();
		
			_html.find('#aolProd').text(prod);
			
			<%-- SUMMARY --%>
			_html.find('#aolSummary .icon').html("<img src='common/images/logos/results/"+prod+".png' />");
			_html.find('#aolSummary .title').text( $('#productName_'+prod).text()  );
			_html.find('#aolSummary .uws').html('Underwriter: ' + $('#underwriter_'+prod).html() );
			_html.find('#aolSummary .afs').html('AFS Licence No: ' + $('#afsLicenceNo_'+prod).html());			
			
			<%-- MAIN CONTENT --%>
			_html.find('#aolAOL .phone').html( $('#telNo_'+prod).html() );
			_html.find('#aolAOL .phoneHours').html( $('#openingHours_'+prod).html() );
			_html.find('#aolAOL .reference span').html( Results.getLeadNo(prod) );
			_html.find('#aolAOL .smlbtn').attr('href', 'javascript:applyByPhoneToggle("' +prod+ '")' );
			_html.find('#aolAOL .aolApplyButton .button').attr('href', $("#apply_online_"+prod).attr("href") );
			
			<%-- TERMS --%>
			var _links = '';
				if( $('#pdsaUrl_'+prod).html().length > 0 ) {
					_links += "<a href='javascript:showDoc(\""+$('#pdsaUrl_'+prod).html()+"\")'>Product Disclosure Statement Part A</a>";
				};
				if( $('#pdsbUrl_'+prod).html().length>0 ) {
					_links += "<a href='javascript:showDoc(\""+$('#pdsbUrl_'+prod).html()+"\")'>Product Disclosure Statement Part B</a>";
				};						
			_html.find('#aolPDS .aolPDSlinks').html( _links );
			
			<%-- ASIDE --%>
			//summary
			_html.find('#aolQuote .premium').html( $('#onlinePrice_'+prod).html() );
			_html.find('#aolQuote .excess').html( $('#excess_'+prod).html() );
			_html.find('#aolQuote .vehicle').html( $('#resultsCarDes').html() );
			
			//offers
			if( $('#feature_'+prod).text().length > 0 ) {
				_html.find('#aolOffers').removeClass('hidden').find('.items').html( $('#onlineFeature_'+prod).html() );
			} else {
				_html.find('#aolOffers .items').html('').addClass('hidden');
			}
			
			//conditions
			if( $('#conditions_'+prod).text().length > 0 ) {
				_html.find('#aolConditions').removeClass('hidden').find('.items').html( $('#conditions_'+prod).html() );
			} else {
				_html.find('#aolConditions').html('').addClass('hidden');
			}
			
			//place back into the html node
			$('#applyOnlineDialog').html( _html );
			$('.applyOnlineDialog').show();
			
			$('#applyOnlineDialog').dialog('open').dialog({ dialogClass:'no-close'});
			
			$("#applyOnlineDialog #aolApplyButton .button").click(function(){
				// Call applyOnline again but this time tell it to jump to the url
				aolClickSource = 'Overlay';
				$("#aolApplyButton .button").unbind('click');
				closeApplyOnlineDialog();			
				applyOnline(prod,true);
			});

	}	
	function closeApplyOnlineDialog() {
		$('#applyOnlineDialog').dialog('close');
	}

</go:script>					