<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">
	#featureDesc { font-size: 11px; color: #000000; font-weight: normal; width: 200px; padding: 0px; text-align: right; vertical-align: middle; }
	#featureValue { font-size: 11px; color: #0F4BDF; font-weight: normal; width: 137px; padding: 0px; text-align: center; height: 27px; vertical-align: middle; }
	#productLogo { text-align: center; }
	.premiumRow { height: 40px }
	.solidline { border-bottom: solid 1px #E3E8EC; }
	#premiumHeading, #premiumAmount { font-size: 14px; color: #000000; font-weight: bold; text-align: right; }
	#premiumAmount { text-align: center; }
	#premiumHeadingSubTxt, #premiumAmountSubTxt { font-size: 11px; color: #000000; font-weight: normal; text-align: right; line-height: 12px; }
	.ui-icon-closethink { display: none; }
	.pdsLink { margin: 3px; }
	.applyButtons { margin: 3px; }	
	.instalmentDetail { display:inline-block; font-size:9px; text-align:centre; margin-right:8px; margin-top:5px; }
		
	tooltip, .tooltipLink { text-decoration: none; }
	#compareDialog { padding-bottom: 15px; }

	#compareDialogHeading { width: 211px; height: 19px; position: absolute; top: 10px; left: 12px; display: none; }	
							
	#compareDialogClose   { background: url(common/images/dialog/close.png) no-repeat;
							width: 36px; height: 34px; position: absolute; top: 0px; margin-top: -34px; left: 608px; cursor: pointer; display: none; }
							
	#compareDialogFooter  { background: url(common/images/dialog/footer.gif) no-repeat scroll left top transparent;
							width: 637px; height: 17px; display: none; }
			
</go:style>

<%-- HTML --%>
<div id="compareDialog"></div>

<%-- JAVASCRIPT --%>
<go:script>
	var omnitureCompareProducts = "";
	function show_Doc(docName){
		var url="${data['settings/pds-url']}"+docName+".pdf";
		window.open(url,docName,"width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
	}
</go:script>
<go:script marker="js-head">
	function closeCompareDialog() {
		$('.ui-dialog #compareDialog').dialog('close');
	}
</go:script>
<go:script marker="jquery-ui">

	// increase the default animation speed to exaggerate the effect
	$.fx.speeds._default = 600;

	$('#compareDialog').dialog({ 
		'show': 'clip',
		'hide': 'clip', 
		'modal':true,  
		'width':637, 'height':680, 
		'minWidth':637, 'minHeight':640, 
		'autoOpen': false,
		'draggable':false,
		'resizable':false,
		'title':'Compare Additional Features',
   		close: function(){ 
			$('.compareDialog').hide();
   		}
	});
		
	$('.ui-dialog').append('<div id="compareDialogHeading" class="compareDialog"></div><div id="compareDialogClose" onClick="closeCompareDialog()" class="compareDialog"></div><div id="compareDialogFooter" class="compareDialog"></div>')
	
	function buildRow(idx,data){
		var row = '';
		if (idx==0) { row += "<td id='featureDesc' class='solidline'>" + $(data).attr('desc') + "</td>"; }			
   		row += "<td id='featureValue' class='solidline'>";
  			row += $(data).text();									   			
  			row += "</td></tr>";
  			return row;
	}	
	
	$('.compare-selected').click(function() {	
		var products=new Array();
		// each of the item's in the basket will have a prefix of "result_"
		for (var i in Basket.basketItems){
			products[i]=Basket.basketItems[i].substring(7);
			omnitureCompareProducts += ';' + Results.getResult(products[i]).productDes + ' ' + Results.getResult(products[i]).headline.name + ',';
		}
		omnitureCompareProducts = omnitureCompareProducts.substring(0, omnitureCompareProducts.length - 1);
				
		$('#compareDialog').html('');				
		var prodLen = products.length;		
		var parms 	= "products="+products;
		
		if (prodLen>1 && prodLen<5) {
		
			$.ajax({
				url: "ajax/xml/compare.jsp",
				async: false,
				dataType: "xml",
				data: parms,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function(data){												
												
					var idx = 0;
												
					var compareTableData = "<table id='compareTableData'><tr>";
 					
 					$(data).find("product").each(function() {
 						
 						compareTableData += "<td><table id='product'><tr>";
 						
 						// Product Logo
 						var prod = $(this).find("code").text();
 						if (idx==0) compareTableData += "<td></td>";
 						compareTableData += "<td id='productLogo'><img src='common/images/logos/compare/" + prod + ".png'></td></tr>";
 							 						
						$(this).find("feature").each(function(index) {
							
							compareTableData += "<tr>";
							
							if (index==0) {
								
								// Premium
								if (idx==0) compareTableData += "<td class='premiumRow solidline'><div id='premiumHeading'>Premium</div><div id='premiumHeadingSubTxt'>indicative price<br></div></td>";
								compareTableData += "<td class='premiumRow solidline'><div id='premiumAmount'>" + $('#result_'+prod+' .price.headline' ).html() + "</div></td></tr>";
								
								// Excess 
								compareTableData += "<tr>";
								if (idx==0) compareTableData += "<td id='featureDesc' class='solidline'>Excess</td>";
								compareTableData += "<td id='featureValue' class='solidline'>"+$('#excess_'+prod).html()+"</td></tr>";												
								compareTableData += buildRow(idx,$(this));
							
							} else {
							
								compareTableData += buildRow(idx,$(this));

							}
						});

						// PDS Links						
						var pdsLinks = (( $('#pdsaUrl_'+prod).html().length>0 )?"<a href='javascript:showDoc(\""+$('#pdsaUrl_'+prod).html()+"\")'>"+ (( $('#pdsaDesShort_'+prod).html().length>0 )? $('#pdsaDesShort_'+prod).html() : "Part A") +"</a>&nbsp;":"")+
									   (( $('#pdsbUrl_'+prod).html().length>0 )?"<a href='javascript:showDoc(\""+$('#pdsbUrl_'+prod).html()+"\")'>"+ (( $('#pdsbDesShort_'+prod).html().length>0 )? $('#pdsbDesShort_'+prod).html() : "Part B") +"</a>":"");
						
						compareTableData += "<tr>";
						if (idx==0) compareTableData += "<td id='featureDesc' class='solidline'>Product Disclosure Statements</td>";
						compareTableData += "<td id='featureValue' class='solidline'>"+pdsLinks+"</td></tr>";	

						// Apply online/phone buttons
						compareTableData += "<tr>";
						if (idx==0) compareTableData += "<td></td>";
						compareTableData += "<td style='text-align:center; padding-top: 5px'>";
						
				   		compareTableData += "<a class='tinybtn' href='javascript:closeCompareDialog();moreDetailsHandler.init(\""+prod+"\")'>"+
											"<span>+ More Details</span></a><br>";
							
			  				compareTableData += "</td></tr></table></td>";
										
						idx=1;
						compareTableData = compareTableData.replace("[xx,xxx]",Results.getResult(prod).headline.kms);		
 					});
 					
					compareTableData += "</tr></table>";

					$('.ui-dialog #compareDialog').html(compareTableData);				
					$("#compareDialogHeading, #compareDialogFooter").show();
					
					
										
					$('.ui-dialog #compareDialog').dialog('open');
					$('.compareDialog').show();
					
					//omnitureReporting(32);
					
					$(".tooltips").append("&nbsp;<img src='common/images/icon_help.png'>");
					$(".tooltips[title]").tooltip({effect: 'slide', slideOffset: 5});
					
					return false;
					
		   		},
		   		timeout: 5000,
					error:function(xhr,err){
				    FatalErrorDialog.display("readyState: "+xhr.readyState+"\nstatus: "+xhr.status, parms);
				    FatalErrorDialog.display("responseText: "+xhr.responseText, parms);
				}
		   		
			});							
		}	
				
	});				

</go:script>					