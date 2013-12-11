<%@ tag description="The Comparison Bar for the Brands"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical"	required="true"	 	rtexprvalue="true"	 description="The vertical using the tag" %>

<%-- EXTERNAL JS --%>
<go:script marker="js-href" href="common/js/compare/Compare.js" />
<go:script marker="js-href" href="common/js/compare/CompareView.js" />
<go:script marker="js-href" href="common/js/compare/CompareModel.js" />

<%-- HTML --%>
<div class="compareBar vertical_${vertical}">
	<div class="compareBarContent">
		<a href="javascript:void(0)" class="compareBackButton compareBarButton"><span class="compareLeftArrow"></span>Back</a>
		<div class="comparedProducts">
			<div class="selectedProdTxt"></div>
			<ul class="comparedProductsList">
				<li class="noneSelected compareBox">
					<span class="compareBoxLogo" ></span>
					<div class="compareCloseIcon"></div>
					<span id="noneSelectedText1" class="noneSelectedText" >NONE</span>
				</li>
				<li class="noneSelected compareBox">
					<span class="compareBoxLogo" ></span>
					<div class="compareCloseIcon"></div>
					<span id="noneSelectedText2" class="noneSelectedText" >NONE</span>
				</li>
				<li class="noneSelected compareBox">
					<span class="compareBoxLogo" ></span>
					<div class="compareCloseIcon"></div>
					<span id="noneSelectedText3" class="noneSelectedText" >NONE</span>
				</li>
				<core:clear />
			</ul>
		</div>
		<a href="javascript:void(0)" class="<%--compareBarButton --%>btn green compareBtn compareInActive">Compare</a>
		<div class="compareNavButtons">
			<a href="javascript:void(0)" class="resultsLeftNav compareBarButton comparePrevButton inactive"><span class="compareLeftArrow"></span>Prev</a>
			<a href="javascript:void(0)" class="resultsRightNav compareBarButton compareNextButton">Next<span class="compareRightArrow"></span></a>
		</div>
		<core:clear />
	</div>
</div>

<%-- CSS --%>
<go:style marker="css-head">

	.compareBar{
		background: #e4e6d8;
		z-index: 10001;
		display: none;
		width: 100%;
	}
	.compareBarContent {
		margin: 0 auto;
		max-width: 980px;
		font-family: "SunLTBoldRegular", "Open Sans", Helvetica, Arial, sans-serif;
		font-weight: 300;
	}
	.compareBar.fixed-top {
		<css:box_shadow horizontalOffset="0" verticalOffset="1" blurRadius="10" spread="0" color="#A9A9A9" />
	}
	.fixedThree {
		margin: 58px auto 0 !important;
	}

	.compareBarButton{
		background-color: #d5d6cb;
		margin: 0 1px;
		color: #999a92;
		text-decoration: none;
		height: 51px;
		padding: 0 15px;
		font-family: "SunLTBoldRegular", "Open Sans", Helvetica, Arial, sans-serif;
		font-weight: 300;
		font-size: 15px;
		line-height: 51px;
		vertical-align: middle;
	}
		.compareLeftArrow,
		.compareRightArrow{
			display: inline-block;
			width: 6px;
			height:10px;
			background-image: url(brand/ctm/images/icons/arrows_horiz.png);
		}
		.compareLeftArrow{
			background-position: 6px 40px;
			margin-right: 20px;
		}
		.compareRightArrow{
			margin-left: 20px;
			background-position: 0 40px;
		}
		.compareBarButton:hover{
			background-color: #485f94;
			color: white;
		}
			.compareBarButton:hover .compareLeftArrow{
				background-position: 6px 0;
			}
			.compareBarButton:hover .compareRightArrow{
				background-position: 0 0;
			}

	.compareBackButton,
	.comparedProducts {
		float: left;
	}
	.comparedProducts {
		margin: 3px 0 0 5px;
	}
		.selectedProdTxt {
			width: 81px;
			height: 5px;
			display: block;
			background:url(brand/ctm/images/quote_result/selectedProdTxt.png) no-repeat 0 0;
			margin: 2px 0 0 5px;
		}
		.comparedProductsList{
			overflow: hidden;
			padding: 5px 5px 0 0;
		}
		.comparedProductsList li{
			display: inline-block;
			margin: 0 5px;
			width: 30px;
			height: 30px;
		}
			.compareBox {
				border-color: #204422;
				border-style: solid;
				border-width: 1px;
			}
			.compareBoxLogo {
				display:none;
				float: left;
				height: 30px;
				width: 30px;
			}
			.noneSelected {
				<css:gradient topColor="#c8cabd" bottomColor="#e4e6d8" />
			}
				.noneSelectedText {
					color: #204422;
					font-size: 8px;
					font-weight: 700;
					margin-top: 10px;
					margin-left: 5px;
					float: left;
					display: inline-block;
					*display:inline;
					zoom:1;
				}
			.compareCloseIcon {
				width: 14px;
				height: 14px;
				border: 1px solid #000;
				position: relative;
				right: -8px;
				float: right;
				top: -36px;
				-webkit-border-radius: 10px;
				-moz-border-radius: 10px;
				border-radius: 10px;
				background:#000 url(brand/ctm/images/quote_result/closeIcon.gif) no-repeat center center;
				display: none;
				cursor: pointer;
			}

		.btn.compareBtn, .compareBtn {
			float: left;
			margin-top: 13px;
		}
		.compareInActive, .compareInActive:hover {
			opacity: 0.5 !important;
			color: white !important;
			cursor: default;
			-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";
			filter: alpha(opacity=50);
			background-color: #0db14b;
		}
	.compareNavButtons{
		float: right;
		height: 100%;
	}
		.compareNavButtons .compareBarButton{
			float: left;
		}
		.compareNavButtons .inactive,
		.compareNavButtons .inactive:hover{
			opacity: 0.3;
			-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=30)";
			filter: alpha(opacity=30);

			background-color: #d5d6cb;
			color: #999a92;
			cursor: default;
		}
			.compareNavButtons .inactive:hover .compareLeftArrow{
				background-position: 6px 40px;
			}
			.compareNavButtons .inactive:hover .compareRightArrow{
				background-position: 0px 40px;
			}
</go:style>