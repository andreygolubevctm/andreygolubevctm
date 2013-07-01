<%@ tag description="Quick Capture Form for fuel - container to switch out forms"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="data" value="*PARAMS" />

<div id="aside">
	<form:form action="ajax/write/fuel_signup.jsp" method="POST" id="quickForm" name="frmQuick">
		<fuel:sign_up />
	</form:form>
	<div class="aside">
		<div class="head"><h3>Car Insurance</h3></div>
		<div class="body">
			<p class="text">Don't just save on fuel<br /> Compare Comprehensive Car Insurance and you could save!<p>
			<p class="link">
				<ui:button href="/ctm/car_quote.jsp" classNames="compare-car-insurance" theme="green">Compare Car Insurance</ui:button>
			</p>
		</div>
	</div>
</div>

<%-- JQUERY UI --%>
<go:script marker="onready">
	<%-- As there are no nested forms in HTML5 browsers, attach to the content co-ordinates --%>

	var pageload = true;
	$(window).bind("resize", adjustaside);
	function adjustaside() {
		var pagestate = $('#page').css('display');
		$('#page').css('display', 'block');
		var asideOffset = $('#page').offset();
		$('#page').css('display', pagestate);
		if (pageload){
			$('#aside').css('top', asideOffset.top + 'px');
			pageload = false;
		}
		$('#aside').css('left', asideOffset.left + 'px');
	}
	adjustaside();

</go:script>


<go:style marker="css-head">
	#left-panel {
		width:200px;
		background:none;
		margin-left:10px;
	}
	#aside {
		position:absolute;
		left:0;
		top:0;
		z-index:21;
		width:200px;
		margin:30px 0 0 5px;
			display:none;		
	}
	#quickForm {
		position:relative;
		width:200px;
		padding:0;
		height:auto;
		margin-bottom:24px;
	}
		#quickForm .head, #aside .aside .head {
			background:url("common/images/bg_form_aside.png") center top no-repeat;
			padding:5px 5px 0 5px;
			min-height:20px;
			white-space:
		}
		#quickForm .body,  #aside .aside .body {
			background:url("common/images/bg_form_aside.png") center bottom no-repeat;
			padding:5px;
			min-height:80px;
		}
			#aside .aside .body, #aside .aside .head {
				background-image:url("common/images/bg_form_aside.png");
			}		
		
	#quickForm h3, #aside .aside h3 {
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		color:#4a4f51;
		font-size:16px;
		padding:20px 10px 0px 10px;
	}
	#quickForm p {
		font-size:12px;
	}
		#quickForm .head p {
			padding:10px 5px 5px 5px;
		}
	#aside .aside p.text  {
		font-size:14px;
		line-height:130%;
		padding:5px;
		margin:5px;
	}
	#aside .link {
		margin-bottom:15px;
	}
	#aside #quickForm .link {
		margin-bottom:25px;
	}
	#quickForm .caption {
		position:absolute;
		bottom:15px;
		left:15px;
		font-size:9px;
	}
	
	#quickForm span.error {
		color:#EC0001;
	}	
	
	#quickForm label.error {
			position:absolute;
			top:2px;
			left:auto;
			border-bottom:1px solid #ff0000;
			border-top:1px solid #ff0000;
			right:8px;
			font-size:10px;
			font-weight:normal;
			background-color:#FFF;
			padding:5px 2px 5px 12px;
			min-height:11px;
			width:99px;
			z-index:50;
			color:#FF0000;
			background-position:2px 4px;
		}
		
			#quickForm .terms label.error {
				left:auto;
				top:0;
				right:0;				
			} 
		
		#quickForm input:focus + label.error, #quickForm label.error:hover, #quickForm .fieldrow:hover label.error, #quickForm .terms:hover label.error {
			left:-999em;
		}
		
	#resultsPage {
		min-height:620px;
	}
	
	#results-information {
		margin-left:0;
	}
	
	#results-table, #results-header, div.compare-header {
		width:730px;
		padding-left:230px;
	}
	
		.fuel #results-container .address {
			width:220px;
		}
		.fuel #results-container .provider {
			width:200px;
		}
		.fuel #results-container .price1,
		.fuel #results-container .price2 {
			width:231px;
		}
		.result-row div.message {
			width:711px;
		}
	
	div.compare-header {
		left:auto;
	}
	
	.result-row {
		width:725px;
	}
		.result-row .address, #results-header .address {
			width:255px;
		}
	
	a.compare-car-insurance{
		width: 170px;
		padding: 10px 0;
		margin: 10px;
		font-size: 12px;
	}
	
</go:style>