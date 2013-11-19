<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="navContainer">
	<ul id="steps">
		<!-- Menu item state if completed -->
		<li id="step-1" class="current navStep">
			<a href="javascript:void(0);"><span>1. </span>Fuel Details</a>
		</li>
		<li id="step-2" class="navStep last-child">
			<a href="javascript:void(0);"><span>2. </span>Fuel Prices</a>
		</li>
	</ul>	
</div>