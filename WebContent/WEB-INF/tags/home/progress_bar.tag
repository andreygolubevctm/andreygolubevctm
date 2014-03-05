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
			<a href="javascript:void(0);"><span>1. </span>Cover</a>
		</li>
		<li id="step-2" class="navStep ">
			<a href="javascript:void(0);"><span>2. </span>Occupancy</a>
		</li>
		<li id="step-3" class="navStep">
			<a href="javascript:void(0);"><span>3. </span>Property</a>
		</li>
		<li id="step-4" class="navStep">
			<a href="javascript:void(0);"><span>4. </span>You</a>
		</li>
		<li id="step-5" class="navStep">
			<a href="javascript:void(0);"><span>5. </span>History</a>
		</li>
		<li id="step-6" class="navStep last-child">
			<a href="javascript:void(0);" class="last"><span>6. </span>Get Quote</a>
		</li>
	</ul>
	<core:clear/>
</div>


<form:active_progress_bar />

<go:script marker="js-href"	href="common/js/jquery.ba-hashchange.min.js"/>
<go:script marker="onready">
	// If the user is clicking browser back button, ensure that the navigation is showing
	// TODO: make this generic across verticals
	$(window).hashchange( function() {
		if (QuoteEngine.getOnResults() && QuoteEngine.getCurrentSlide() == 5){
			Results.reviseDetails();
		}
		QuoteEngine.setOnResults(location.hash.indexOf("result") > -1);
	})

	<%-- The progress bar is hidden after the first slide so only need to provide action for entering the results page --%>
	var active_progress_bar = new ActiveProgressBar({
		milestones : {
			5:{
				enter : {
					forward : function(){
						$('#next-step').trigger("click");
					}
				}
			}
		}
	});
</go:script>

<%-- CSS --%>
<go:style marker="css-head">

</go:style>