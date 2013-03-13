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
			<a href="javascript:void(0);"><span>1. </span>Your Needs</a>
		</li>
		<li id="step-2" class="navStep">
			<a href="javascript:void(0);"><span>2. </span>Your Details</a>
		</li>
		<li id="step-3" class="navStep ">
			<a href="javascript:void(0);"><span>3. </span>Compare</a>
		</li>
		<li id="step-4" class="navStep">
			<a href="javascript:void(0);"><span>4. </span>Apply</a>
		</li>
		<li id="step-5" class="navStep">
			<a href="javascript:void(0);"><span>5. </span>Confirmation</a>
		</li>
	</ul>
	<a href="javascript:void(0);" id="start-new-quote" class="smlbtn" title="Start New Quote"><span>Start New Quote</span></a>
</div>

<go:script marker="onready">

	$("#start-new-quote").click(function(){
		LifeQuote.restartQuote();
	});
	
	<%-- INDUCE: the completed callback for Health
	$('#next-step').on('click', function(){
		if( $(this).closest('body.stage-1',['html']).length > 0 ){
			if( QuoteEngine.validate() ){
				QuoteEngine.preCompleted();
			};
		};
	});
	$('#prev-step').on('click', function(){
		if( $(this).closest('body.stage-3',['html']).length > 0 ){
			QuoteEngine.preCompleted();
		};
	});
	 --%>
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	body.stage-2 #next-step,
	body.stage-2 #prev-step {
		display:none !important;
	}
	
	#navContainer #start-new-quote {
		position:absolute;
		right:30px;
		top:20px;
		width: 120px;
		z-index: 5;
	}
	#navContainer #start-new-quote {display:none;}
	
	#navContainer #start-new-quote span {
		line-height: 11px;
	}
</go:style>