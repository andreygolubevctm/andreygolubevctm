<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" required="true" rtexprvalue="true" description="Presentation text title" %>
<%@ attribute name="sub" required="false" rtexprvalue="true" description="Tagline directly below the title" %>
<%@ attribute name="disclaimer" required="true" rtexprvalue="true" description="Disclaimer text" %>
<%@ attribute name="disclosure" required="false" rtexprvalue="true" description="Disclosure text" %>
<%@ attribute name="moreBtn" required="true" rtexprvalue="true" description="Use the more button tag too" %>
<%@ attribute name="hiddenInitially" required="true" rtexprvalue="true" description="Hide the bar via css until you enable it in other code later" %>

<%@ attribute name="callToAction" fragment="true" %>

<%--
	Colours used:

	#485f94 blue
	#0db14b green
	#fe8814 orange
	#e4e6d8 lightgray
	#d5d6cb middlegray
	#7f807a darkgray
--%>

<go:style marker="css-head">
	.floatyBar {
		position:fixed;
		left:0;
		right:0;
		bottom:0px;
		padding: 5px;
		background:#485f94;
		z-index: 99999;
		zoom: 1;
	}
	.floatyBar p {
		margin: 0;
		padding: 0;
	}

	/* IE 6 */
	* html .floatyBar {
		position:absolute;
		top:expression((0-(footer.offsetHeight)+(document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight)+(ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop))+'px');
		zoom: 1;
		z-index: 99999;
	}

	.pageWidth {
		width: 980px;
		margin: 0 auto;
		position: relative;
		overflow: hidden;
		clear: both;
	}
	.thankyou {
		float: right;
		width: 506px;
		color: white;
		padding-left: 70px;
		padding-top: 5px;
	}
	.thankyou a.btn.arrow-right {
		float: right;
		margin-top: 10px;
		clear:right;
	}
	.thankyou h4 {
		color: white;
	}
	.disclaimer,
	.disclosure {
		float: left;
		color: #e4e6d8;
		width: 404px; /*2 columns, if we had any*/
		margin: 5px auto;
		clear: left;
	}
	.disclaimer p,
	.disclosure p {
		font-size: 11px;
		line-height: 12px;
	}
	span.greyBg{
		background-color: #e4e6d8;
		float: left;
		margin-right: 5px;
	}
	span.arrowImg{
		background: transparent url(brand/ctm/images/icons/arrow_down_blue.png) -3px 2px no-repeat;
		width: 15px;
		height: 10px;
		float: left;
	}

	/*Makes the moreBtn work*/
	#moreBtn.override {
		margin-bottom: 76px;
	}
	#moreBtn.override .moreBtnInner {
		height: auto;
		width: auto/*209px*/;
		line-height: 1;
	}
</go:style>

<c:if test="${hiddenInitially == 'true'}">
	<go:style marker="css-head">
		#call_to_action_bar {
			display: none;
		}
	</go:style>
</c:if>

<div id="call_to_action_bar">
	<c:if test="${moreBtn == 'true'}">
		<!-- add the more btn (itemId Id of container want to scroll too + scrollTo position of that item eg: top or bottom) -->
		<agg:moreBtn itemId="footer" outerClassName="override" innerClassName="btn orange halfRound" btnTxt="&hellip; SEE MORE &hellip;" scrollTo="top"/>
	</c:if>

	<div class="floatyBar blue">
		<div class="pageWidth">
			<div class="thankyou">
				<jsp:invoke fragment="callToAction" />
				<h4>${title}</h4>
				<c:if test="${not empty sub}"><p>${sub}</p></c:if>
			</div>
			<div class="disclaimer">
				<p>${disclaimer}</p>
			</div>
			<div class="disclosure">
				<p>${disclosure}</p>
			</div>
		</div>
	</div>
</div>