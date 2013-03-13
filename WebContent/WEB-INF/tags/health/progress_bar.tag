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
			<a href="javascript:void(0);"><span>1. </span>You</a>
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
		<li id="step-5" class="navStep last-child">
			<a href="javascript:void(0);"><span>5. </span>Purchase</a>
		</li>
		<li id="step-6" class="navStep last-child">
			<a href="javascript:void(0);"><span>6. </span>Confirmation</a>
		</li>				
	</ul>	
</div>

<%-- CSS --%>
<go:style marker="css-head">
	body.stage-5 #next-step,
	body.stage-5 #prev-step {
		display:none !important;
	}
</go:style>