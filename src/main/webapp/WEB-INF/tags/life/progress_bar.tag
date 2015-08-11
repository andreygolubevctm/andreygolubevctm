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
			<a href="javascript:void(0);"><span>1. </span>Your Details</a>
		</li>
		<li id="step-2" class="navStep ">
			<a href="javascript:void(0);"><span>2. </span>Compare</a>
		</li>
		<li id="step-3" class="navStep">
			<a href="javascript:void(0);"><span>3. </span>Enquire</a>
		</li>
		<li id="step-4" class="navStep">
			<a href="javascript:void(0);"><span>4. </span>Confirmation</a>
		</li>
	</ul>
	<a href="javascript:void(0);" id="start-new-quote" class="smlbtn" title="Start New Quote"><span>Start New Quote</span></a>
</div>

<form:active_progress_bar />

<go:script marker="onready">
	<%-- The progress bar is hidden after the first slide so only need to provide action for entering the results page --%>
	var active_progress_bar = new ActiveProgressBar({
	<c:choose>
		<c:when test="${xpath eq 'life'}">
		ignore : [1]
		</c:when>
		<c:otherwise>
		milestones : {
			1:{
				enter : {
					forward : function(){
						$('#next-step').trigger("click");
					}
				}
			}
		}
		</c:otherwise>
	</c:choose>
	});
</go:script>

<go:script marker="onready">

	$("#start-new-quote").click(function(){
		LifeQuote.restartQuote();
	});

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