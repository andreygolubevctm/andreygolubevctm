<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Competition is over --%>
<c:redirect url="http://www.comparethemeerkat.com.au/" />

<core:doctype />
<go:html startTag="<!--[if IE 8]><html class='no-js lt-ie9' lang='en' > <![endif]--><!--[if gt IE 8]><!--> <html class='no-js' lang='en' > <!--<![endif]-->">

<c:set var="formName" value="competitionForm" />

<%-- HTML --%>
<head>
	<meta charset="utf-8" />
	<title>Win 1000 delicious grubs</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width" />

<%-- STYLESHEETS --%>
	<link rel="shortcut icon" type="image/x-icon" href="common/images/favicon.ico">
	<link rel="stylesheet" href="brand/ctm/competition/meerkat_rewards/css/foundation.css" />
	<link rel="stylesheet" href="brand/ctm/competition/meerkat_rewards/css/octoberpromo.css" />
	<link rel="stylesheet" href="brand/ctm/competition/meerkat_rewards/css/custom_ecomm.css" />
	<script src="brand/ctm/competition/meerkat_rewards/js/vendor/custom.modernizr.js"></script>

	<%-- Inline css included with tags --%>
	<style type="text/css">
		<go:insertmarker format="STYLE" name="css-head" />
	</style>

<%-- JAVASCRIPT --%>
	<%-- jQuery, jQuery UI and plugins--%>
	<script type="text/javascript" src="common/js/jquery-1.7.2.min.js"></script>
	<%--<script type="text/javascript" src="brand/ctm/competition/meerkat_rewards/js/vendor/jquery.js"></script>
	<script type="text/javascript" src="common/js/jquery-ui-1.8.22.custom.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.address-1.3.2.js"></script>
	<script type="text/javascript" src="common/js/quote-engine.js"></script>
	<script type="text/javascript" src="common/js/scrollable.js"></script>
	<script type="text/javascript" src="common/js/jquery.tooltip.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.corner-2.11.js"></script>
	<script type="text/javascript" src="common/js/jquery.numeric.pack.js"></script>
	<script type="text/javascript" src="common/js/jquery.scrollTo.js"></script>
	<script type="text/javascript" src="common/js/jquery.maxlength.js"></script>
	<script type="text/javascript" src="common/js/jquery.number.format.js"></script>
	<script type="text/javascript" src="common/js/jquery.titlecase.js"></script>
	<script type="text/javascript" src="common/js/jquery.aihcustom.js"></script>
	<script type="text/javascript" src="common/js/jquery.pngFix.pack.js"></script>
	<script type="text/javascript" src="common/js/qtip/jquery.qtip.min.js"></script>
	--%>
	<script type="text/javascript" src="common/js/jquery.maskedinput-1.3-co.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.metadata.js"></script>
	<script type="text/javascript" src="common/js/jquery.validate.pack-1.7.0.js"></script>
	<script type="text/javascript" src="common/js/jquery.validate.custom.js"></script>
	<script type="text/javascript" src="common/js/jquery.bgiframe.js"></script>

	<%-- External (href) javascript files included with tags --%>
	<go:insertmarker format="HTML" name="js-href" />

	<%-- Inline Javascript included with tags --%>
	<go:script>
		// Head javascript
		<go:insertmarker format="SCRIPT" name="js-head" />

		// jQuery UI
		$(function() {
			<go:insertmarker format="SCRIPT" name="jquery-ui" />
		});

		// jQuery document.onready
		$(document).ready(function() {
			//$(document).pngFix();

			//FIX: need method to check if IE needs to validate form
			// jQuery validation rules & messages
			$("#${formName}").validate({
				rules: {
					<go:insertmarker format="SCRIPT" name="jquery-val-rules" delim=","/>
				},
				messages: {
					<go:insertmarker format="SCRIPT" name="jquery-val-messages" delim=","/>
				},
				submitHandler: function(form) {
					form.submit();
				},
				onkeyup: function(element) {
					var element_id = jQuery(element).attr('id');
					if ( !this.settings.rules.hasOwnProperty(element_id) || this.settings.rules[element_id].onkeyup == false) {
						return;
					};
				},
				ignore: ":disabled",
				meta: "validate",
				debug: false
			});

			<go:insertmarker format="SCRIPT" name="onready" />
		});

	</go:script>
</head>

	<body id="competition">

<!-- #1: BEGIN SUPERTAG TOP CODE v2.0.20 -->
<script type="text/javascript">
var superT_dcd=new Date();
document.write("\x3Cscr"+"ipt type=\"text/javascript\" src=\"//c.supert.ag/compare-the-market/compare-the-market/supertag.js?_dc="+Math.ceil(superT_dcd.getUTCMinutes()/5,0)*5+superT_dcd.getUTCHours().toString()+superT_dcd.getUTCDate()+superT_dcd.getUTCMonth()+superT_dcd.getUTCFullYear()+"\"\x3E\x3C/scr"+"ipt\x3E");
</script>
<!-- Do NOT remove the following <script>...</script> tag: SuperTag requires the following as a separate <script> block -->
<script type="text/javascript">
if(typeof superT!="undefined"){if(typeof superT.t=="function"){superT.t();}}
</script>
<!-- #1: END SUPERTAG TOP CODE -->

<div class="large-12 columns mainCont">
	<%-- <div class="meerkatLogo"><a href="http://www.comparethemeerkat.com.au/"><img src="brand/ctm/competition/meerkat_rewards/img/meerkatLogo.png" /></a></div> --%>

<div class="row">
	<div class="large-12 large-centered columns panel contentCont">
		<div id="lidbehind" class="row">
			<div id="lidbottom"></div>
			<div id="lid" class="large-12 columns">

			<div class="row">
				<div class="large-12 columns">
					<div class="heroImage">
						<img src="brand/ctm/competition/october_promo/1000grubs_header.png"><br>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="large-12 columns">
					<div class="panel panelForm">
						<div id="panelEntryForm" class="panelInside">
							<p class="intro" style="margin-bottom:1.6em">To reward Australias for knowing difference between Meerkat and Market, I giving away 1,000 delicious grubs! They even be paw-prepared by Sergei, for humans consumption.</p>

							<h3>Enter my <span>1,000 Grub</span><br>&#8216;One-Question&#8217; competition</h3>

							<h4>Ahem. To find good insurance deal I would go to...</h4>


<%-- HTML --%>
<jsp:element name="form">
	<jsp:attribute name="id">${formName}</jsp:attribute>
	<jsp:attribute name="class">custom</jsp:attribute>
	<jsp:attribute name="name">${formName}</jsp:attribute>
	<jsp:attribute name="method">POST</jsp:attribute>
	<jsp:attribute name="action">ajax/write/october_promo.jsp</jsp:attribute>
	<jsp:attribute name="autocomplete">off</jsp:attribute>
	<jsp:body>




<%-- HTML --%>
<div class="row">
		<div class="large-10 columns large-centered" style="margin-bottom:1em">
			<label for="answer_wrong">
				<input name="answer" type="radio" id="answer_wrong" value='N' style="display:none;">
				<span class="answer custom radio"></span>
				<div class="radioLabel"><strong>compare</strong>the<strong>meerkat</strong>.com.au</div>
			</label>
			<label for="answer_right">
				<input name="answer" type="radio" id="answer_right" value='Y' style="display:none;">
				<span class="answer custom radio"></span>
				<div class="radioLabel"><strong>compare</strong>the<strong>market</strong>.com.au</div>
			</label>
		</div>

	<div class="large-12 columns">

		<h4>Please enter your details for contact:</h4>

		<div class="row nohover">
			<div class="small-4 columns">
				<label for="firstname" class="right inline">First name</label>
			</div>
			<div class="small-8 columns">
				<input id="firstname" type="text" name="competition_firstname" value="" maxlength="30">
			</div>
		</div>

		<div class="row nohover">
			<div class="small-4 columns">
				<label for="lastname" class="right inline">Last name</label>
			</div>
			<div class="small-8 columns">
				<input id="lastname" type="text" name="competition_lastname" value="" maxlength="30">
			</div>
		</div>

		<div class="row nohover">
			<div class="small-4 columns">
				<label for="email" class="right inline">Email address</label>
			</div>
			<div class="small-8 columns">
				<input id="email" type="email" name="competition_email" value="" maxlength="50">
			</div>
		</div>

		<div class="row nohover">
			<div class="small-4 columns">
				<label for="phone" class="right">Phone<br><span style="font-size:80%">(including area code)</span></label>
			</div>
			<div class="small-8 columns">
				<input id="phone" type="tel" name="competition_phone" value="" maxlength="10">
			</div>
		</div>

		<!-- Inputs and Submits -->
		<div class="row enter_competition_wrapper">
			<div class="large-12 columns">
				<a href="javascript:void(0);" id="enter_competition" class="buttonMeerkat hide-text">Give me the grubs</a>
			</div>
		</div>

	</div> <!-- large-12 columns -->
</div> <!-- Row -->




	</jsp:body>
</jsp:element>





						</div><!-- /panelEntryForm -->



						<div id="panelWrongAnswer" style="display:none">
							<div class="panelInside">
								<h3>Wrong answer, you Lamington Cake!</h3>
								<div class="large-6 columns">
									<a href="#" id="giveup" class="hide-text">Give up, I am mongoose</a>
								</div>
								<div class="large-6 columns">
									<a href="#" id="tryagain" class="hide-text">Try again</a>
								</div>
								<img class="aleksandr" src="brand/ctm/competition/october_promo/aleksandr.png">
							</div>
						</div><!-- /panelWrongAnswer -->



						<div id="panelConfirmation" style="display:none" class="panelInside">
							<h3>Meerkat. Market. Congratulations on know difference</h3>

							<p class="intro" style="text-transform:uppercase; margin:-0.2em auto 1.4em">You now have chance to win 1,000 grubs as paw-prepared by Sergei. Good luck!</p>

							<p>Competition is running to 1<sup>st</sup> November.<br>See winner announcement on my <a href="https://www.facebook.com/Comparethemeerkat.com.au" style="text-decoration:underline">Facebooks page</a> on 5<sup>th</sup> November.</p>

							<p class="intro">Now prove you know difference!</p>
							<p class="intro">You could also win <span>$1,000 cash</span>.<br>Not as tasty as grubs though.</p>
							<p class="intro">To win visit:</p>
							<a href="http://www.comparethemarket.com.au/win" class="buttonMarket"><img src="brand/ctm/competition/october_promo/CTM-button.png"></a>
						</div><!-- /panelConfirmation -->

					</div><!-- /panelForm -->
				</div><!-- /large-5 columns -->
			</div>


			<footer class="row">
				<div class="large-12 columns">
					<p class="legal">
						*Mongoose need not apply. <a href="http://www.comparethemeerkat.com.au/competition/termsandconditions.pdf" target="_blank">Competition terms and conditions</a>
						<%-- <a href="#" onclick="meerkatRewards.showSuccess(); return false">Success</a> --%>
					</p>

					<div class="legal">
						"Make many sharings of my competition..."<br><br>

						<!-- FB -->
						<iframe src="//www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.comparethemeerkat.com.au&amp;send=false&amp;layout=button_count&amp;width=200&amp;show_faces=false&amp;font&amp;colorscheme=light&amp;action=like&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:80px; height:21px;" allowTransparency="true"></iframe>

						<!-- Twitter -->
						<a href="https://twitter.com/share" class="twitter-share-button" data-url="http://www.comparethemeerkat.com.au/win">Tweet</a>
						<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

						<!-- G+ -->
						<div class="g-plusone" data-size="medium" data-href="http://www.comparethemeerkat.com.au/"></div>
					</div>

					<div class="large-12 columns crest"></div>
				</div>
			</footer>



		</div><!-- /lid -->
	</div><!-- /lidbehind -->
</div>

<!-- #2: BEGIN SUPERTAG BOTTOM CODE v2.0.20 -->
<script type="text/javascript">
if(typeof superT!="undefined"){if(typeof superT.b=="function"){superT.b();}}
</script>
<!-- Do NOT remove the following <script>...</script> tag: SuperTag requires the following as a separate <script> block -->
<script type="text/javascript">
if(typeof superT!="undefined"){if(typeof superT.b2=="function"){superT.b2();}}
</script>
<!-- #2: END SUPERTAG BOTTOM CODE -->






<%--
<meerkatrewards:popup id="wrong_answer" minWidth="310" maxWidth="380" height="375">
	<div id="wrong_answer_panel" class="innertube" style="width:100%; height:100%;">
		<a href="javascript:void(0);" id="giveup"><!-- give up button --></a>
		<a href="javascript:void(0);" id="tryagain"><!-- try again button --></a>
	</div>
</meerkatrewards:popup>
<div id="wrong_answer" class="reveal-modal">
	<div id="wrong_answer_panel" class="innertube">
		<a class="close-reveal-modal"><!-- close dialog button --></a>
		<a href="javascript:void(0);" id="giveup"><!-- give up button --></a>
		<a href="javascript:void(0);" id="tryagain"><!-- try again button --></a>
	</div>
</div>
--%>

<go:script marker="onready">
$('.contentCont').animate({'padding-top':216}, 2000);

var WrongAnswerPanel = function() {

	var hide = function() {
		$('#panelEntryForm').show();
		$('#panelWrongAnswer').hide();
		return false;
	};

	var quit = function() {
		window.location.href = 'http://www.comparethemeerkat.com.au/';
		return false;
	};

	$('#giveup').on('click', quit);
	$('#tryagain').on('click', hide);
}

var wrong_answer_panel = new WrongAnswerPanel();
</go:script>
<go:style marker="css-head">
<%--
#wrong_answer {
	padding: 0;
	background: transparent;
	border: 0;
	-webkit-box-shadow: none;
	box-shadow: none;
}
#wrong_answer .close-reveal-modal {
	position: 			absolute;
	width:				31px;
	height:				31px;
	right: 				-8px;
	top: 				-8px;
	z-index: 			1002;
	background:			transparent url(brand/ctm/competition/meerkat_rewards/img/close.png) top left no-repeat;
	display:			block;
}

#wrong_answer_panel {
	max-width: 425px;
	height: 375px;
	width:  100%;
	margin: 0 auto;
	background: #CFB955 url(brand/ctm/competition/meerkat_rewards/img/wrongAnswerBg.jpg) 50% 50% no-repeat;
	position: relative;
	-webkit-box-shadow: 0 0 10px rgba(0, 0, 0, 0.4);
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.4);
}

#wrong_answer_panel a,
#wrong_answer_panel a.giveup {
	position: 			absolute;
	width:				135px;
	height:				60px;
	top: 				100px;
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
--%>
</go:style>


<meerkatrewards:popup id="fatal_error" minWidth="340" maxWidth="340" height="180">
	<meerkatrewards:fatal_error />
</meerkatrewards:popup>



<script src="brand/ctm/competition/meerkat_rewards/js/foundation.min.js"></script>
<script>
$(document).foundation();
</script>
<!--[if lt IE 9]>
<script src="brand/ctm/competition/meerkat_rewards/js/vendor/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>




<go:script marker="js-head">
var MeerkatRewards = function() {
	var that		= this,
		submitting	= false,
		elements	= {};

	this.init = function() {
		elements = {
			firstname		: $('#firstname'),
			lastname		: $('#lastname'),
			email			: $('#email'),
			phone			: $('#phone'),
			submit			: $('#enter_competition'),
			logo			: $('#meerkatLogo')
		};

		elements.submit.on('click', enter);

		elements.logo.on('click', quit);

		$('div.radioLabel').on('click', function(){
			$(this).siblings('span').trigger('click');
		});

		$('span.answer').on('click', function(){
			$('span.answer').removeClass('error');
		});

		$('#answer_wrong').on('change', showWrongAnswer);
	};

	var getFormData = function() {
		return {
			competition_firstname	: $.trim(elements.firstname.val()),
			competition_lastname	: $.trim(elements.lastname.val()),
			competition_email		: $.trim(elements.email.val()),
			competition_phone		: $.trim(elements.phone.val())
		};
	};

	var quit = function() {
		window.location.replace('http://www.comparethemeerkat.com.au/');
	};

	var enter = function() {

		if( validate() ) {
			if( isCorrectAnswer() ) {
				if( !submitting ) {
					submitting = true;
					var dat = getFormData();
					$.ajax({
						url: "ajax/write/october_promo.jsp",
						data: dat,
						type: "POST",
						async: true,
						dataType: "json",
						timeout: 60000,
						cache: false,
						beforeSend: function(xhr,setting) {
							var url = setting.url;
							var label = "uncache",
							url = url.replace("?_=","?" + label + "=");
							url = url.replace("&_=","&" + label + "=");
							setting.url = url;
						},
						success: function(json) {
							submitting = false;
							if (json && json.result && json.result == 'OK')
								showSuccess(json);
							else
								showFailure(json);
							return false;
						},
						error: function(obj, txt, errorThrown) {
							submitting = false;
							showFailure(txt + ' ' + errorThrown);
							return false;
						}
					});
				}
			} else {
				showWrongAnswer();
			}
		}
	};

	var showSuccess = function() {
		$('#panelEntryForm').hide();
		$('#panelConfirmation').show();
	};
	this.showSuccess = showSuccess;

	var showFailure = function( errors ) {
		fatal_error.show();
		fatal_error_obj.fire(errors);
	};

	var showWrongAnswer = function() {
		$('span.answer').each(function(){
			if($(this).hasClass('checked')) {
				$(this).removeClass('checked');
				$('#answer_wrong').prop('checked', null);
			}
		});
		//wrong_answer.show();
		//$('#wrong_answer').foundation('reveal', 'open');

		$('#panelEntryForm').hide();
		$('#panelWrongAnswer').show();
	};

	var validate = function() {
		var is_valid = true;

		if( !isValidAnswer() ) {
			is_valid = false;
		}

		if( $.trim(elements.firstname.val()) == '' ) {
			is_valid = false;
			elements.firstname.addClass('error');
		} else {
			elements.firstname.removeClass('error');
		}

		if( $.trim(elements.lastname.val()) == '' ) {
			is_valid = false;
			elements.lastname.addClass('error');
		} else {
			elements.lastname.removeClass('error');
		}

		if( !isValidEmailAddress(elements.email.val()) ) {
			is_valid = false;
			elements.email.addClass('error');
		} else {
			elements.email.removeClass('error');
		}

		if( !isValidPhone(elements.phone.val()) ) {
			is_valid = false;
			elements.phone.addClass('error');
		} else {
			elements.phone.removeClass('error');
		}

		return is_valid;
	};

	var isValidEmailAddress = function(emailAddress) {
		var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
		return pattern.test(emailAddress);
	};

	var isValidPhone = function(phone) {
		var is_valid = false;

		var pattern = new RegExp(/^\d+$/);
		if (pattern.test(phone) && ($.inArray(phone.substr(0,2), ['02','03','07','08','04']) !== -1 || phone.substr(0,4) == '0550')) {
			return true;
		}
		return is_valid;
	};

	var isValidAnswer = function() {
		var is_valid = false;

		$('input[name=answer]:checked').each(function(){
			is_valid = true;
		});

		$('span.answer').each(function(){
			if( !is_valid ) {
				$(this).addClass('error');
			} else {
				$(this).removeClass('error');
			}
		});

		return is_valid;
	};

	var isCorrectAnswer = function() {
		var is_valid = false;

		if( isValidAnswer() ) {
			$('input[name=answer]:checked').each(function(){
				is_valid = $(this).val() == 'Y';
			});
		}

		return is_valid;
	};
};

var meerkatRewards = new MeerkatRewards();
</go:script>
<go:script marker="onready">
meerkatRewards.init();
</go:script>


	</body>
</go:html>