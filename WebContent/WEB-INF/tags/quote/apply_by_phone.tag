<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="applyByPhoneDialog" class="applyByPhoneDialog AOL_APB">
<div class="abpDialog">
	
	<div id="abpSummary" class="AOL_APB_summary">
		<div class="icon"></div>
		<div class="title"></div>
		<div class="uws"></div>
		<div class="afs"></div>
	</div>
	
	<%-- 'Column' One --%>
	<div id="abpContent" class="AOL_APB_content">
		
		<%-- Main Tag Content --%>
		<div id="abpAPB" class="AOL_APB_main">
			<div class="AOL_APB_header">
				<h3>Apply by Phone Now</h3>
			</div>
			<div class="phone"></div>
			<div class="phoneHours"></div>
			<div class="reference">
				<p>Reference number: <span></span></p>
			</div>
			<p class="provide"><strong>Please provide your quote reference number to the operator.</strong></p>
			<p class="or"><strong>OR</strong></p>
			<p><strong><a class="button smlbtn"><span>Continue Online</span></a></strong></p>
		</div>
			
		<%-- Terms and Conditions --%>	
		<div id="abpPDS" class="AOL_APB_PDS">
			<h5>Product Disclosure Statement</h5>
			<p>Please read the Product Disclosure Statements<br /> before deciding to buy: <span class="abpPDSlinks"></span></p>
			<h5>Disclaimer</h5>
			<p>The indicative quote includes any applicable online discount and is subject to meeting the insurers underwriting criteria and may change due to factors such as:
			<br />- Driver's history or offences or claims
			<br />- Age or licence type or additional drivers
			<br />- Vehicle condition, accessories and modifications</p>
		</div>
	
	</div>
	
	<%-- 'Column' Two (additional content) --%>
	<div id="abpAside" class="AOL_APB_aside">
		<div id="abpQuote" class="AOL_APB_quote">
			<h3>Quote Summary</h3>
			<div class="item">	
				<h4>Phone Premium <em>(indicative price)</em></h4>
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
		<div id="abpOffers" class="AOL_APB_offers">
			<h3>Special Feature/Offer</h3>
			<div class="items"></div>
		</div>
		<div id="abpConditions" class="AOL_APB_conditions">
			<h3>Special Conditions</h3>
			<div class="items"></div>
		</div>
	</div>
	
	<div id="abpProd"></div>
	<br clear="all" />	
</div>	
</div>


<%-- CSS --%>
<go:style marker="css-head">

	#applyByPhoneDialog h2 {
		font-size:17px;
		width:597px;
		padding:20px 20px 0px 20px;
		margin:-12px -12px 0 -12px;			
	}
	#abpSummary {
		overflow: auto;
	}
	#abpSummary .icon {
		float:left;
    	margin:0 24px 12px 12px;
	}
	#abpSummary .title {
		font-size:17px;
		margin-bottom:12px;
	}
	#abpSummary .uws, #abpSummary .afs {
		font-size:11px;
		color:#808080;
	}
	
	#abpContent {
		width:386px;
		float:left;
		margin-left:6px;		
	}	
		#abpAPB {
			text-align:center;
		}
		#abpAPB p {
			margin:.2em 0;
		}
		#abpAPB .phoneHours {
			font-size:11px;
		}
		#abpAPB .phone {
			font-size:36px;
			margin:6px auto;
		}
		#abpAPB .reference {
			width:50%;
			margin:12px auto;
			padding:12px;
			font-size:12px;
			font-weight:bold;
			border-radius:12px;
		}
			#abpAPB .reference span {
				display:block;
				font-size:18px;
			}
		#abpAPB p.or {
			margin:10px;
		}
		#abpAPB .button {
			margin:0 auto;
		}			
		#abpPDS {			
			padding:20px;			
		}
			#abpPDS h5 {
				margin-top:20px;
				margin-bottom:.5em;
			}
			#abpPDS h5:first-child {
				margin-top:0;
			}
			.abpPDSlinks a {
				display:block;
				margin:.2em 0;
			}
		
	#abpAside {
		float: right;
		width: 200px;
		margin-right:6px;
	}
		#abpQuote, #abpOffers, #abpConditions {
			padding:10px;
			width:180px;
			min-height:48px;			
		}
			#abpAside h3 {
				font-size:14px;
				font-weight:bold;
				display:inline-block;
				width:100%;
			}
			#abpQuote h4 {
				font-size:100%;
				margin-bottom:.2em;
			}
			#abpQuote h4 em {
				font-size: 85%;
				font-style: normal;
			}
		.AOL_APB_quote .item {
			padding:10px 0;
		}
		#abpSpecial {
		}
		#abpConditions {
		}
		
#applyByPhoneClose {
	background: url(common/images/dialog/close.png) no-repeat;
	width: 36px; height: 31px;
	position: absolute; top:16px; right: 9px;
	cursor: pointer; display: none;
}			  						 
#applyByPhoneFooter {
	background: url("common/images/dialog/footer.gif") no-repeat scroll left top transparent;
	width: 637px; height: 14px;
	clear:both;
	display:none;
}
#applyByPhoneDialog {
	overflow:hidden;
}
#abpProd {
	display:none;
}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$('#applyByPhoneDialog').dialog({
		title: 'Apply By Phone',
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
			$(".applyByPhoneDialog").hide();	
		},
		dialogClass: 'applyByPhone'
		});		
		
	$('.applyByPhone').append('<div id="applyByPhoneClose" class="applyByPhoneDialog" onclick="closeApplyByPhoneDialog()"></div><div id="applyByPhoneFooter" class="applyByPhoneDialog">')

</go:script>

<go:script marker="js-head">
	function applyByPhone(prod) {	
		k_button.setCustomVariable(270, Results.getLeadNo(prod));
		
		if (initialClick == true) {
			<%-- TODO: remove this once we are off DISC --%>
			$.ajax({
				url:"ajax/write/car_quote_report.jsp",
				data:{
					transactionId:referenceNo.getTransactionID()
				},
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				}
			});
			<%-- TODO: uncomment this once we are off DISC
				Write.touchQuote("A");--%>
			initialClick = false;
		}
		omnitureProduct=prod;				   
		
		<%-- Create the HTML content before inserting it --%>
		var _html = $('.abpDialog').clone();
		
			_html.find('#abpProd').text(prod);
			
			<%-- SUMMARY --%>
			_html.find('#abpSummary .icon').html("<img src='common/images/logos/results/"+prod+".png' />");
			_html.find('#abpSummary .title').text( $('#productName_'+prod).text()  );
			_html.find('#abpSummary .uws').html('Underwriter: ' + $('#underwriter_'+prod).html() );
			_html.find('#abpSummary .afs').html('AFS Licence No: ' + $('#afsLicenceNo_'+prod).html());
						
			<%-- MAIN CONTENT --%>
			_html.find('#abpAPB .phone').html( $('#telNo_'+prod).html() );
			_html.find('#abpAPB .phoneHours').html( $('#openingHours_'+prod).html() );			
			_html.find('#abpAPB .reference span').html( Results.getLeadNo(prod,"#abpPhoneRefNo") );						
			_html.find('#abpAPB .button').attr('href', 'javascript:applyOnlineToggle("' +prod+ '")' );
			
			<%-- TERMS --%>
			var _links = '';
				if( $('#pdsaUrl_'+prod).html().length > 0 ) {
					_links += "<a href='javascript:showDoc(\""+$('#pdsaUrl_'+prod).html()+"\")'>Product Disclosure Statement Part A</a>";
				};
				if( $('#pdsbUrl_'+prod).html().length>0 ) {
					_links += "<a href='javascript:showDoc(\""+$('#pdsbUrl_'+prod).html()+"\")'>Product Disclosure Statement Part B</a>";
				};						
			_html.find('#abpPDS .abpPDSlinks').html( _links );	
			
			<%-- ASIDE --%>
			//summary
			_html.find('#abpQuote .premium').html( $('#offlinePrice_'+prod).html() );
			_html.find('#abpQuote .excess').html( $('#excess_'+prod).html() );
			_html.find('#abpQuote .vehicle').html( $('#resultsCarDes').html() );
			
			//offers
			if( $('#feature_'+prod).text().length > 0 ) {
				_html.find('#abpOffers').removeClass('hidden').find('.items').html( $('#phoneFeature_'+prod).html() );
			} else {
				_html.find('#abpOffers').html('').addClass('hidden');
			}
			
			//conditions
			if( $('#conditions_'+prod).text().length > 0 ) {
				_html.find('#abpConditions').removeClass('hidden').find('.items').html( $('#conditions_'+prod).html() );
			} else {
				_html.find('#abpConditions').html('').addClass('hidden');
			}
			
			//place back into the html node
			$('#applyByPhoneDialog').html( _html );
			$('.applyByPhoneDialog').show();
			
				<%-- Additional show/hide toggles --%>
				if($("#apply_online_"+prod).css("display") == "block") {
					$('#abpAPB .button, #abpAPB .or').show();
				} else {
					$('#abpAPB .button, #abpAPB .or').hide();
				};
				
				if( _html.find('#abpAPB .reference span').text() == '' ) {
					_html.find('#abpAPB .reference, #abpAPB .provide').css('display:none');
				} else {
					_html.find('#abpAPB .reference, #abpAPB .provide').css('display:block');
				};			
			
			$('#applyByPhoneDialog').dialog('open').dialog({ dialogClass:'no-close'});
			Track.transferInit('PHONE',Results.getLeadNo(prod),Results.getTranId(prod),prod);
			//omnitureReporting(31);		
	}
		
	function closeApplyByPhoneDialog() {
		$('#applyByPhoneDialog').dialog('close');
	}		
		
</go:script>