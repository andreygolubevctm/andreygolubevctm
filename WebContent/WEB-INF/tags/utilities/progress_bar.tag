<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="navContainer">
	<ul id="steps">
		<!-- Menu item state if completed -->
		<li id="step-1" class="current navStep first-child">
			<a href="javascript:void(0);"><span>1. </span>Household details</a>
		</li>
		<li id="step-2" class="navStep ">
			<a href="javascript:void(0);"><span>2. </span>Choose a plan</a>
		</li>
		<li id="step-3" class="navStep">
			<a href="javascript:void(0);"><span>3. </span>Fill out your details</a>
		</li>
		<li id="step-4" class="navStep">
			<a href="javascript:void(0);"><span>4. </span>Apply Now</a>
		</li>
		<li id="step-5" class="navStep">
			<a href="javascript:void(0);"><span>5. </span>Confirmation</a>
		</li>
	</ul>
	<a href="javascript:UtilitiesQuote.restartQuote();" id="start-new-quote" class="smlbtn" title="Start New Quote"><span>Start New Quote</span></a>
	<a href="javascript:QuoteEngine.gotoSlide({index: 0});" id="revise-details" class="smlbtn" title="Revise Details"><span>Revise Details</span></a>
</div>

<form:active_progress_bar />

<go:script marker="onready">
	<%-- Instantiating ActiveProgressBar will enable the progress bar steps to be clickable --%>
	var active_progress_bar = new ActiveProgressBar({
		milestones : {
			1:{
				exit : function( slide ){
					slide = slide || 0;
					QuoteEngine.gotoSlide({index: slide});
				},
				enter : {
					forward : function(){
						$('#next-step').trigger("click");
					},
					backward : function(){
						QuoteEngine.gotoSlide({index: 1});
					}
				}
			}
		},
		directional : [2]
	});
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	body.stage-4 #next-step,
	body.stage-4 #prev-step {
		display:none !important;
	}

	#navContainer #start-new-quote,
	#navContainer #revise-details {
		position:absolute;
		right:30px;
		top:20px;
		width: 120px;
		z-index: 5;
	}
	#navContainer #start-new-quote{display:none;}
	#navContainer #revise-details{display:none;}
	body.stage-1 #navContainer #revise-details{display:block;}

	#navContainer #start-new-quote span {
		line-height: 11px;
	}

	#steps #step-4.complete a {
		background-image: url(brand/ctm/images/menu_step_current.png) !important;
	}

	#steps #step-5 {
		display: none;
	}
</go:style>