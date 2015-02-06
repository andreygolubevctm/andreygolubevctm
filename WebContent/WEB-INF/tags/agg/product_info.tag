<%@ tag description="PromoTerms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">
	#results-popup {
		width:450px;
		height:auto;
		z-index:2001;
		display:none;
		position:absolute;
	}
	#results-popup h5{
		display: block;
		font-size: 17px;
		font-weight: bold;
		height: 70px;
		padding-left: 19px;
		padding-top: 15px;
		margin-bottom: -25px;
		background: transparent url("common/images/dialog/header_540.gif") 0 0 no-repeat;
		width:481px;
		padding-right:40px;
		overflow:hidden;
		line-height:20px;
		padding-top:15px;
		padding-bottom:10px;
		word-break:break-all;
	}
	#results-popup h6 {
		font-size: 15px;
		font-weight:bold;
		margin:10px;
	}
	#results-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_850.gif") no-repeat;
		width:850px;
		height:57px;
		display:block;
	}
/*	#results-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin-top:10px;
		margin-right:15px;
		float:right;
	}
	#results-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}*/
/*	#results-popup .close-button {
		background: url("common/images/dialog/close.png") no-repeat scroll 0 0 transparent;
		height: 34px;
		left: 824px;
		position: relative;
		top: 0;
		width: 36px;
		display: inline-block;
	}*/
	#results-popup .back-button {
		background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
		height: 37px;
		position: relative;
		width: 140px;
		margin-top:10px;
		margin-right:5px;
		float:right;
	}
	#results-popup .back-button:hover {
		background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#results-popup .content {
		background: white url("common/images/dialog/content_850.gif") repeat-y;
		padding:10px;
		overflow: hidden;
		min-height:400px;
		*height:auto;
	}

	#results-popup .content p {
		margin-bottom: 9px;
		font-size: 11px;
		margin: 10px 10px;
	}
	#terms-overlay {
		position:absolute;
		top:0px;
		left:0px;
		z-index:1000;
	}
	#termsScrollDiv {
		height: 355px;
		overflow-y: scroll;
		width:836px;
	}
	#results-popup, #results-popup .buttons{width:540px;}
	#results-popup .content{
		background: url("common/images/dialog/content_540.gif") repeat-y scroll 0 0 white;
	}
	#results-popup .buttons{
		background: url("common/images/dialog/buttonpane_540.gif") no-repeat scroll 0 0 transparent;
		position:relative;
	}
	#results-popup .close-button{
		left: 512px;
	}
	#results-popup .infoDes {
		font-size: 13px;
		margin: 20px 15px;
		padding: 15px 10px;
		border: 1px solid #E3E8EC;
	}
	#results-popup .infoDes a {
		color: 	#1C3F94;
		text-decoration: none;
	}
	#results-popup .infoDes a:hover{
		text-decoration: underline;
	}
	#results-popup .termsbtnbig {
		background:url("common/images/button-terms-conditions-square.gif") no-repeat;
		margin:0 15px;
		height:37px;
		width:110px;
		position:absolute;
		left:10px;
		top:8px;
	}


</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var ResultsPopup = new Object();
	ResultsPopup = {

		popid: '',
		popredirurl: '',
		popCustInfo: '',
		show: function(id,url,custInfo){

			this.popid = id;
			this.popredirurl = url;
			this.popCustInfo = custInfo;

			var row_template = $("#buy-details-row-template").html();
			var details = Results.getResult(id);

			$("#results-popup .content").html('');
			$("#results-popup h5").html(details.des);

			//clean out buttons - and add new ones
			var buttonHTML = '<a href="javascript:void(0);" data-applyOnline="true" data-id="' + details.productId + '" class="buybtnbig mt10"><span>Buy</span></a>';
			if(typeof details.info.terms !== 'undefined') {
				buttonHTML += '<a href="' + details.info.terms.text + '" class="termsbtnbig mt10" target="_blank"></a>';
			}

			$("#results-popup .buttons").html(buttonHTML);

			var objectArray = [];
			var orderArray = [];
			//sort the results into alphabetic order by the final object description

			$.each(details.info, function(a){
				if(this.order != ''){
					orderArray[this.order] = a;
				}
				objectArray.push( [details.info[a].desc,a] );
			});

			objectArray = this.arraySort(orderArray, objectArray);

			$.each(objectArray, function(index, tag){
				if(  details.info[tag[1]]['value'] && details.info[tag[1]]['value'] > 0  ){
					$("#results-popup .content").append($(parseTemplate(row_template, details.info[tag[1]])));
				}
			});

			if(typeof custInfo !== "undefined" && custInfo){
				var infoDes = $("<div>")
								.attr('class','infoDes')
								.html(details.infoDes+'&nbsp; <a href="' + custInfo + '" target="_blank">See PDS</a>');
			$("#results-popup .content").append(infoDes);
			} else {
				if (details.infoDes && details.infoDes != ''){
								var infoDes = $("<div>")
								.attr('class','infoDes')
								.html(details.infoDes);
			$("#results-popup .content").append(infoDes);
				}
			}


			var overlay = $("<div>").attr("id","terms-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px",
											"width":$(document).width()+"px"
										});

			$("body").append(overlay);
			$(overlay).fadeIn("fast");
			// Show the popup
			$("#results-popup").center().show("slide",{"direction":"down"},300);

			// add overlay click & hover functionality
			$("#terms-overlay").hover(function() {
				$(this).css('cursor','pointer');
			}, function() {
				$(this).css('cursor','auto');
			});
			$("#terms-overlay").click(function() {
				ResultsPopup.hide();
			});


		},
		arraySort : function(orderArray, objectArray){
			var sortedArray = [];
			if(orderArray.length > 0){
				$.each(orderArray, function(a){
					$.each(objectArray, function(b){
						if(orderArray[a] == objectArray[b][1]){
							sortedArray.push( [objectArray[b][0], objectArray[b][1]]);
						}
					})
				})
				return sortedArray;
			} else {
				objectArray.sort();
				return objectArray;
			}


		},
		hide : function(){
			$("#results-popup").hide("slide",{"direction":"down"},300);
			$("#terms-overlay").remove();
		},
		init : function(){
			$("#results-popup").hide();
		}
	}

	$(document).on('click','a[data-applyonline=true]',function(){
		applyOnline($(this).data('id'));
	})


	function applyOnline(id) {

			omnitureProduct=id;
			if (id){
				var details = Results.getResult(id);
			} else {
				var details = Results.getResult(ResultsPopup.popid);
				id = ResultsPopup.popid;
			}
			var popTop = screen.height + 300;
			var url = "transferring.jsp?transactionId="+details.transactionId+"&trackCode="+details.trackCode + "&brand="+details.provider+"&productId="+id+"&vertical=roadside";
			//omnitureReporting(4);

			if (details.handoverType === "post")
			{
				url += "&handoverType="+details.handoverType+"&handoverData="+encodeURIComponent(details.handoverData)+"&handoverURL="+encodeURIComponent(details.handoverUrl)+"&handoverVar="+(details.handoverVar);
			}

			if (!details.conditions || jumpToUrl) {
				try {
					Track.transfer('',details.transactionId, id);
				} catch(e) {
					// ignore
				}
			}
			if ($.browser.msie) {
				var popOptions="location=1,menubar=1,resizable=1,scrollbars=1,status=1,titlebar=1,toolbar=1,top=0,left=0,height="+screen.availHeight+",width="+screen.availWidth;
				window.open(url , "_blank", popOptions);
			} else {
				window.open(url , "_blank");
			}

			$("#transferring-popup")
				.delay(4000)
				.queue(function(next) {
					next();
				});
			return;


	}
</go:script>
<go:script marker="jquery-ui">
	$("#results-popup .ok-button, #results-popup .close-button").click(function(){
		ResultsPopup.hide();
	});

</go:script>
<go:script marker="onready">
	ResultsPopup.init();
</go:script>
<%-- HTML --%>
<div id="results-popup">
	<a href="javascript:void(0);" class="close-button"></a>

	<h5></h5>

	<div class="content"></div>

	<div class="buttons">
		<a href="javascript:void(0);" data-applyOnline="true" data-id="" class="buybtnbig mt10"><span>Buy</span></a>
	</div>
</div>

<%-- BUY DETAILS POPUP ROW TEMPLATE --%>
<core:js_template id="buy-details-row-template">
	<div class="pop_row">
		<div class="leftcol">[#= desc #]</div>
		<div class="rightcol b">[#= text #]</div>
		<div class="clear"></div>
	</div>
</core:js_template>
