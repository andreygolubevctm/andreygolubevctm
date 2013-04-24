<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
	</ul>
	<a href="javascript:UtilitiesQuote.restartQuote();" id="start-new-quote" class="smlbtn" title="Start New Quote"><span>Start New Quote</span></a>
	<a href="javascript:QuoteEngine.gotoSlide({index: 0});" id="revise-details" class="smlbtn" title="Revise Details"><span>Revise Details</span></a>
</div>

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
</go:style>