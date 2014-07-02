<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div id="navContainer">
	<ul id="steps">
		<!-- Menu item state if completed -->
		<li id="step-1" class="current navStep active ie8sux">
			<a href="javascript:void(0);"><span>1.</span> Your Car</a>
		</li>
		<li id="step-2" class="navStep">
			<a href="javascript:void(0);"><span>2.</span> Car Details</a>
		</li>
		<li id="step-3" class="navStep">
			<a href="javascript:void(0);"><span>3.</span> Driver Details</a>
		</li>
		<li id="step-4" class="navStep">
			<a href="javascript:void(0);"><span>4.</span> More Details</a>
		</li>
		<li id="step-5" class="navStep">
			<a href="javascript:void(0);"><span>5.</span> Address/Contact</a>
		</li>
		<li id="step-6" class="navStep">
			<a href="javascript:void(0);"><span>6.</span> T&amp;Cs</a>
		</li>
		<li id="step-7" class="navStep last-child">
			<a href="javascript:void(0);" class="last"><span>7.</span> Get Quote</a>
		</li>
	</ul>
</div>

<form:active_progress_bar />

<%-- CSS --%>
<go:style marker="css-head">
	.progressBar { float: left; position: absolute;  top: 0px; left: 0px; }
	#progressPointer { z-index: 1000; }
	#progressLeftCorner { z-index: 1001; }
	#progressInterim { z-index: 1002; display: none; }
</go:style>
<go:script marker="js-href"	href="common/js/jquery.ba-hashchange.min.js"/>
<go:script marker="onready">
	// If the user is clicking browser back button, ensure that the navigation is showing
	// TODO: make this generic across verticals
	$(window).hashchange( function() {
		// This expression only equals true in IE at this point, and fixes the
		// compare screen from not closing on browser back button press.
		// At this point Chrome and FF comparisonOpen is always false.
		if (Compare.view.comparisonOpen) {
			Compare.close();
		}
		if (QuoteEngine.getOnResults() && QuoteEngine.getCurrentSlide() == 5){
			Results.reviseDetails();
		}
		QuoteEngine.setOnResults(location.hash.indexOf("result") > -1);
	})
</go:script>

<%-- JS --%>
<go:script marker="onready">
	<%-- Instantiating ActiveProgressBar will enable the progress bar steps to be clickable --%>
	var active_progress_bar = new ActiveProgressBar({
		milestones : {
			7:{
				enter : {
					forward : function(){
						$('#next-step').trigger("click");
					}
				}
			}
		}
	});
</go:script>