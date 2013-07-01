<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%--ATTRIBUTES --%>
<%@ attribute name="objRef" required="true" rtexprvalue="true"	description="A reference to the parent javascript object" %>

<%-- HTML --%>
<div id="wrong_answer_panel" class="innertube">
	<a href="javascript:void(0);" id="giveup"><!-- give up button --></a>
	<a href="javascript:void(0);" id="tryagain"><!-- try again button --></a>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
var WrongAnswerPanel = function() {

	var hide = function() {
		${objRef}.hide();
	};

	var quit = function() {
		window.location.replace('http://www.comparethemeerkat.com.au/');
	};

	$('#giveup').on('click', quit);
	$('#tryagain').on('click', hide);
}

var wrong_answer_panel = new WrongAnswerPanel();
</go:script>

<%-- STYLE --%>
<go:style marker="css-head">
#wrong_answer_panel {
	width:				100%;
	height:				100%;
	background:			#CFB955 url(brand/ctm/competition/meerkat_rewards/img/wrongAnswerBg.jpg) 50% 50% no-repeat;
	margin:				0 auto;
}

#wrong_answer_panel a,
#wrong_answer_panel a.giveup {
	position: 			absolute;
	width:				135px;
	height:				60px;
	top: 				175px;
	background:			transparent url(brand/ctm/competition/meerkat_rewards/img/giveUp.png) top left no-repeat;
	display:			block;
}
#wrong_answer_panel a#giveup {
	left: 				10px;
}

#wrong_answer_panel a#tryagain {
	right: 				10px;
	background:			transparent url(brand/ctm/competition/meerkat_rewards/img/tryAgain.png) top left no-repeat;
}
</go:style>