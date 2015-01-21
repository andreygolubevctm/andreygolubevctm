<%@ tag description="Results summary tag"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"					required="true"	 	rtexprvalue="true"	 description="The vertical using the tag" %>
<%@ attribute name="verticalTitle"				required="false"	rtexprvalue="true"	 description="The vertical title to display" %>

<%-- VARIABLES --%>
<c:if test="${empty verticalTitle}"><c:set var="verticalTitle" value="${go:TitleCase(vertical)}" /></c:if>

<div id="summary-header">
	<div class="verticalIcon ${vertical}Icon"></div>
	<div class="verticalTitle">
			<span class="verticalTitleCompare">Compare </span><span class="resultsVerticalName">${verticalTitle}</span> Insurance Quotes<span class="verticalTitleSpecific"> for a</span>:
			<span class="resultsSummary"></span>
	</div>
	<div class="resultsSummaryButtons">
		<a href="javascript:void(0);" data-SaveQuote="true" class="results-button summarySaveButton" >
			<span></span>Save Quote
		</a>
		<a href="javascript:void(0);" data-revisedetails="true" class="results-button summaryGreyButton summaryEditDetailsButton" >
			<span></span>Edit Details
		</a>
		<core:clear/>
	</div>
	<core:clear/>
</div>

<%-- JS --%>
<go:script marker="js-head">
	Summary = new Object();
	Summary = {
		init: function(){

		},

		setVerticalName: function( name ){
			$(".resultsVerticalName").html( name );
		},

		set: function( text ){
			$(".resultsSummary").html( text );
		}
	}
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#summary-header {
		font-family: "SunLTLightRegular", Arial, Helvetica, sans-serif;
		color: #666;
		font-size: 1.2em !important;
		position: relative;
		display: none;
	}

	.verticalTitle {
		display: block;
		font-size: 1.2em !important;
		float: left;
		margin-top: 7px;
	}

	.verticalIcon{
		width: 60px;
		height: 60px;
		margin: 0 20px 0 0;
		display: block;
		float: left;
	}

	.${vertical}Icon {
		background: url('brand/ctm/images/quote_result/${vertical}Icon.png') no-repeat center center;
	}

	.resultsSummary{
		font-size: 31px;
		color: #666;
		display: block;
		font-family: SunLTBoldRegular, Arial, Helvetica, sans-serif;
		max-width: 610px;
	}

	.resultsSummaryButtons{
		float: right;
		margin-top: 10px;
	}
	.results-button {
		text-decoration: none;
		font-size: 1.2em !important;
		font-family: Arial, Helvetica, sans-serif;
		font-size: 100%;
		float: right;
		padding: 10px 10px 10px 35px;
		<css:rounded_corners value="6" />
		position: relative;
	}
		.results-button span{
			position: absolute;
			left: 10px;
			top: 10px;
			width: 20px;
			height: 20px;
		}
		.summaryGreyButton {
			color: #666;
			border: 1px solid #dbdbdb;
			<css:gradient topColor="#ffffff" bottomColor="#e3e3e3" />
			<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="1" blurRadius="10" color="white" inset="true" />
			text-shadow: 0 1px 0 white;
		}
		.summaryEditDetailsButton {
			margin-right: 10px;
		}
		.summaryGreyButton.updateButton {
			float:left;
			padding:7px;
			font-size:17px !important;
			margin-left:10px;
		}
		.summaryEditDetailsButton span {
			background: url(brand/ctm/images/quote_result/editIcon.png) no-repeat 0 0;
		}
	.summarySaveButton {
		color: #FFF;
		border: 1px solid #008a25;
		<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="1" blurRadius="10" color="#00C960" inset="true" />
		<css:gradient topColor="#00B14B" bottomColor="#009934"/>
	}
		.summarySaveButton span {
			background: url(brand/ctm/images/quote_result/saveQuoteIcon.png) no-repeat 0 0;
		}

	#summary-header .resultsSummaryButtons a#save,
	#summary-header .resultsSummaryButtons a#revise{
		float: none;
		margin: 0 0 0 10px;
	}

	#summary-header h2 {
		color: #333333;
		font-family: "SunLT Light",Arial,Helvetica,sans-serif;
		font-size: 22px;
		font-weight: normal;
		line-height:44px;
	}
</go:style>