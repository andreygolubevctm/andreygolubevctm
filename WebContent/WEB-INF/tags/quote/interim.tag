<%@ tag description="The Ranking Slide"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<c:if test="${param.anim == 'N'}">
	<go:script marker="onready">
		Interim.skipAnim = true;
	</go:script>
</c:if>

<%-- CSS --%>
<go:style marker="css-head">
#bigSliders {
	margin-left:2px;
}
#bigSliders .slider {
	background-image:none;
	background-color: transparent;
	height: 21px;
	width: 247px;
	border: none;
	margin-left: 21px;
	display:inline-block;
	cursor:pointer;
	cursor:hand;
}
#bigSliders .ui-slider-handle {
	border: none;
	background: transparent url('common/images/slider-handle.png') no-repeat top left;
	height: 25px;
	width: 47px;
	padding: 0;
	margin-left: -22px;
	margin-top: 6px;
	cursor:e-resize;
}
#bigSliders .sliderWrapper {
	margin: 0px 0 13px 0;
	background: transparent url('common/images/slider-background.gif') no-repeat 0 18px;
	text-align:left;
	width:300px;
	height:41px;
}
#bigSliders .sliderWrapper label {
	font-weight: bold;
	font-size: 14px;
}
#bigSliders .sliderWrapper span {
	color: #0554df;
	font-size: 14px;
}
#bigSliders .help_icon {
	margin-top:-15px;
	margin-left:300px;
	background-image:url("common/images/info-small.png");
}
#results-contacting {
	background:url("common/images/contacting.gif") no-repeat top left;
	width:204px;
	height:39px;
	top:-20px;
	left:153px;
	position:relative;
}
#results-contacting-anim {
	background-image:url("common/images/contacting_anim.gif");
	width:25px;
	height:39px;
	float:right;
}
#show-results, #rank-by-price {
	width: 228px;
	height: 40px;
	display: block;
	text-indent: -9999px;
	margin-bottom: -4px;
	z-index:50;
}
#show-results {
	background: transparent url('common/images/button-show-results.png') no-repeat;
	top:-32px;
	left:152px;
	position:relative;
}
#show-results:hover {
	background: transparent url('common/images/button-show-results-on.png') no-repeat;
}
#rank-by-price {
	background: transparent url('common/images/button-rank.png') no-repeat;
	left:152px;
	position:relative;
	top:-29px;
}
#rank-by-price:hover {
	background: transparent url('common/images/button-rank-on.png') no-repeat;
}
#bigSlidersWrapper {
	left:56px;
	position:relative;
}
#bigSlidersWrapper h4{
	background-image: url('common/images/interim-header.png');
}

#bigSlidersWrapper .content{
	background: transparent url('common/images/interim-container.png') no-repeat bottom left;
	height:283px;
}
#slide6 {
	width:358px;
}
#flashWrapper{
	position:relative;
	margin-top:-800px;
	left:485px;
	display:none;
	width: 473px;
	z-index:1002;
}
#ieflashMask {
	position:relative;
	top:-588px;
	left:0px;
	display:none;
	height:0px;
	width:0px;
	z-index:1005;
}
#no-flash-bubble {
	top: -300px;
	position: relative;
	left: 81px;
}
#no-flash-background {
	margin-left: 305px;
	margin-top: 80px;
}
</go:style>

<%-- JAVASCRIPT --%>
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
		//omnitureReporting(7);
		$("#show-results").click();
	});
	$("#show-results").click(function(){
		//omnitureReporting(8);
		Interim.disable();
		Interim.showResultsClicked = true;

		$("#results-buttons").fadeOut("fast");
		$("#results-contacting").fadeIn("fast");
		ContinueFlash();
	});



</go:script>

<go:script marker="onready">
	$("#flashContent").detach().appendTo("#flashWrapper");


	//if the form changes, switch the flagSaveForm var
	$('#vehicle-selection select').change(function() {
		flagSaveForm = true;
	});

		//action button on the exit form...
		$('#exit-quote a').click(function(e) {
			e.preventDefault();
			Interim._abort(e);
		});

		var onBeforeUnloadFired = false;
		//user leaving so call the function
		$(window).bind('beforeunload', function(e){
		//prevent the alert being called twice
		if (!onBeforeUnloadFired) {
				onBeforeUnloadFired = true;
				if( typeof(flagSaveForm) !== 'undefined' ){
				if( flagSaveForm === true){
					if( !($.browser.msie) ){ //of course IE has an issue
						Interim._abort();
						return "Are you sure?\r\n Navigating away from this page will lose your changes";
					}
				}
				}
		}
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

		/*$("#flashWrapper").show();
		$("#flashWrapper").delay(5400).queue("fx", function(next){
			$("#results-buttons").fadeIn();

			Interim.flashPart1Shown = true;

			Interim.enable();

			next();
		});*/
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

		flagSaveForm = false; //cancel the form abort script

		if (this.ajaxPending){
			//log("ajax WAS pending");
			this._cancelRequest();
		}
		var dat = $("#mainform").serialize();
		this.ajaxPending = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/car_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
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

	_abort : function(e){
		//the page is closed, or unloaded so capture the form as is

		var error = false;

		//check if form needs saving at all
		if( typeof flagSaveForm === 'undefined' ) {
			error = true;
		} else if( flagSaveForm !== true ) {
			error = true;
		}

		if(this.ajaxPending){
			error = true;
		} else {
			this.ajaxPending = true;
		}

		//if there's a reason not to continue, check if the request came from a a:link
		if(error === true){
			if( typeof(e) !== 'undefined' ){
				document.location.href = e.target.href;
			}
			return false;
		}

		//Page unloaded and save form required
		var dat = $("#mainform").serialize();

		$.ajax({
			url: "ajax/json/car_quote_aborted_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				flagSaveForm = false; //has now been saved
				this.ajaxPending = false; //ajax is over
					//if it has come from a link
					if( typeof(e) !== 'undefined' ){
						document.location.href = e.target.href;
					}
				return true;
			},
			error: function(obj,txt){
				//log('failed request');
				return false;
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

<div style="display:none">
<%-- HTML --%>
QUOTE INTERIM

<div id="results-buttons" class="button-wrapper" style="display:none;">
	<a href="javascript:void(0)" id="show-results">Show results</a>
	<a href="javascript:void(0)" id="rank-by-price">Rank results by price</a>
</div>
<div id="results-contacting" style="display:none;">
	<div id="results-contacting-anim"></div>
</div>
</div>
<!-- (START Flash portion) -->
	<go:script marker="js-head">
		/* <![CDATA[ */
			// flash setup
			var vars = {  };
			var params = { scale:'noScale', salign:'lt', menu:'false', quality:'high', base: "", wmode: 'transparent', bgcolor: 'transparent', swliveconnect:'true' };
			var attributes = { id:'flashContent', name:'flashContent', base: "",  swliveconnect:'true' }; // give an id to the flash object
			swfobject.embedSWF("common/flash/interim.swf", "flashContent", "478px", "480px", "8.0.0", "common/flash/expressInstall.swf", vars, params, attributes );

			// call to control flash flv playback
			function ContinueFlash() {
				$(".interim").hide();
				flashCallback();
			}
			function disabledFlash(){
				//log("Attempting to continue Flash");
				try {
						var flash = document.getElementById("flashContent");
						flash.continueFLV();

					// Nasty hack for IE7 - but sometimes it doesn't fire the 2nd part of the animation
					// because it is inheritantly broken
					if ($.browser.msie && parseInt($.browser.version, 10) == 7) {

						Interim.forceTimeout = setTimeout("log('FORCING TRANSITION');flashCallback();",9000);
					}

				} catch(e) {

					//log("Flash Error Occured");
					Interim.flashPart2Shown = true;
					//log("Interim.resultsAvailable" + Interim.resultsAvailable);

					if (Interim.resultsAvailable){
						Interim.transitionToResults();
					}
				}
			}
			// Next steps here
			function flashCallback(videoSection) {
				if (Interim.forceTimeout > 0 ){
					clearTimeout(Interim.forceTimeout);
				}
				Interim.flashPart2Shown = true;
				//log("flashCallBack");
				//log("Interim.resultsAvailable"+Interim.resultsAvailable);
				if (Interim.resultsAvailable){
					Interim.transitionToResults();
				}
			}
		/* ]]> */
	</go:script>
	<div id="flashContent">
		<div id="no-flash">
			<img id="no-flash-background" src="common/images/no-flash-background.jpg" alt="Compare the Market" />
			<img id="no-flash-bubble" src="common/images/no-flash-bubble.gif" alt="Compare the Market" />
		</div>
	</div>

<!-- (END Flash portion) -->
