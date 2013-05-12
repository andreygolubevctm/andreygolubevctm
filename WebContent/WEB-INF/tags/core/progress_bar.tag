<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
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
		<li id="step-6" class="navStep last-child">
			<a href="javascript:void(0);" class="last"><span>6.</span> Other info</a>
		</li>
	</ul>
</div>

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
	$(window).hashchange( function(){
		if (location.hash.indexOf("result") === -1){
			$('#steps').show();
			$('#summary-header').hide();
		}
	})
</go:script>
