<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<go:style marker="css-head">

	.bubble_row{
		margin-bottom:30px;
		position:relative;
	}

	.bubble_row .speechbubble{
		float:left;
		margin-right:30px;
		min-height: 162px;
	}

	.speechbubble:last-child{
		margin-right:none;
	}

</go:style>

<c:set var="maxBrands" value="12" />

<%-- Bubbles --%>
<div class="bubble_row">
	<ui:speechbubble colour="blue" arrowPosition="right"  width="650">
		<h1>Compare features</h1>
		<p>Simply select the Insurance providers you want to compare products for and start comparing features.<br/>You can choose up to <strong>${maxBrands} providers</strong> to compare.</p>
	</ui:speechbubble>
	<ui:speechbubble colour="green" arrowPosition="left" width="300">
		<h2>Compare price</h2>
		<p>We also compare by price. Get a quote from our participating providers.</p>
		<div class="button_footer">
			<a class="btn orange arrow-right" href="car_quote.jsp">Get a Quote</a>
		</div>
	</ui:speechbubble>

	<div class="cleardiv"></div>

</div>

<%-- Brands selection --%>
<features:brand_selector verticalFeatures="car" displayCoverType="false" max="${maxBrands}" />