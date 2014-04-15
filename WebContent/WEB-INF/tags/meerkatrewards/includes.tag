<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<meerkatrewards:popup id="wrong_answer" minWidth="350" maxWidth="425" height="375">
	<meerkatrewards:wrong_answer objRef="wrong_answer" />
</meerkatrewards:popup>

<meerkatrewards:popup id="robesize_chart" minWidth="514" maxWidth="544" height="324">
	<meerkatrewards:robesize_chart />
</meerkatrewards:popup>

<meerkatrewards:popup id="fatal_error" minWidth="340" maxWidth="340" height="180">
	<meerkatrewards:fatal_error />
</meerkatrewards:popup>

<script>
<%-- Removed to prevent overwriting the jQuery version needed for address tag
	document.write('<script src=' +
	('__proto__' in {} ? 'brand/ctm/competition/meerkat_rewards/js/vendor/zepto' : 'brand/ctm/competition/meerkat_rewards/js/vendor/jquery') +
	'.js><\/script>');--%>
</script>

<script src="brand/ctm/competition/meerkat_rewards/js/foundation.min.js"></script>

<script>
$(document).foundation();
</script>

<!--[if lt IE 9]>
<script src="brand/ctm/competition/meerkat_rewards/js/vendor/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var MeerkatRewards = function() {
	var that		= this,
		submitting	= false,
		elements	= {};

	this.init = function() {
		elements = {
			firstname		: $('#firstname'),
			lastname		: $('#lastname'),
			addr_unit		: $('#address_unitShop'),
			addr_num		: $('#address_streetNum'),
			addr_std_street	: $('#address_streetSearch'),
			addr_street		: $('#address_nonStdStreet'),
			addr_suburb		: $('#address_suburbName'),
			addr_cur_suburb	: $('.groupAddressSuburb .custom.dropdown').first(),
			addr_state		: $('#address_state'),
			addr_code		: $('#address_postCode'),
			addr_manual		: $('#address_nonStd'),
			email			: $('#email'),
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

		$('span.robesize').on('click', function(){
			$('span.robesize').removeClass('error');
		});

		$('#size_guide').on('click', showRobeSizes);
	};

	this.resetAddress = function() {
		elements.addr_unit.removeClass('error');
		elements.addr_num.removeClass('error');
		elements.addr_std_street.removeClass('error');
		elements.addr_street.removeClass('error');
		elements.addr_suburb.removeClass('error');
		elements.addr_code.removeClass('error');
		elements.addr_cur_suburb.removeClass('error');
	}

	var getFormData = function() {
		return {
			firstname	: $.trim(elements.firstname.val()),
			lastname	: $.trim(elements.lastname.val()),
			address		: $.trim(getAddress()),
			email		: $.trim(elements.email.val()),
			robesize	: $.trim($('input[name=robesize]:checked').val())
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
						url: "ajax/write/meerkat_rewards.jsp",
						data: dat,
						type: "POST",
						async: true,
						dataType: "json",
						timeout:60000,
						cache: false,
						beforeSend : function(xhr,setting) {
							var url = setting.url;
							var label = "uncache",
							url = url.replace("?_=","?" + label + "=");
							url = url.replace("&_=","&" + label + "=");
							setting.url = url;
						},
						success: function(json){
							submitting = false;
							showSuccess(json);
							return false;
						},
						error: function(data){
							submitting = false;
							showFailure(data.responseText);
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
		window.location.replace('http://www.comparethemeerkat.com.au/robecompetition/confirmation.html');
	};

	var showFailure = function( errors ) {
		fatal_error.show();
		fatal_error_obj.fire(errors);
	};

	var showRobeSizes = function() {
		robesize_chart.show();
	};

	var showWrongAnswer = function() {
		$('span.answer').each(function(){
			if($(this).hasClass('checked')) {
				$(this).removeClass('checked');
				$('#answer_wrong').prop('checked', null);
			}
		});
		wrong_answer.show();
	};

	var validate = function() {
		var is_valid = true;

		if( !isValidAnswer() ) {
			is_valid = false;
		}

		if( !isValidRobeSize() ) {
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

		if( !isValidAddress() ) {
			is_valid = false;
		}

		return is_valid;
	};

	var isValidEmailAddress = function(emailAddress) {
		var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
		return pattern.test(emailAddress);
	};

	var isValidAddress = function() {
		var is_valid = true;

		if( elements.addr_manual.is(':checked') && $.trim(elements.addr_num.val()) == '' ) {
			is_valid = false;
			elements.addr_num.addClass('error');
		} else {
			elements.addr_num.removeClass('error');
		}

		if( !elements.addr_manual.is(':checked') && $.trim(elements.addr_std_street.val()) == '' ) {
			is_valid = false;
			elements.addr_std_street.addClass('error');
		} else {
			elements.addr_std_street.removeClass('error');
		}

		if( elements.addr_manual.is(':checked') && $.trim(elements.addr_street.val()) == '' ) {
			is_valid = false;
			elements.addr_street.addClass('error');
		} else {
			elements.addr_street.removeClass('error');
		}

		if( elements.addr_manual.is(':checked') && $.trim(elements.addr_suburb.val()) == '' ) {
			is_valid = false;
			elements.addr_suburb.addClass('error');
		} else {
			elements.addr_suburb.removeClass('error');
		}

		if( $.trim(elements.addr_code.val()) == '' ) {
			is_valid = false;
			elements.addr_code.addClass('error');
		} else {
			elements.addr_code.removeClass('error');
		}

		if(!elements.addr_manual.is(':checked') && elements.addr_unit.is(':visible') && $.trim(elements.addr_unit.val()) == '') {
			is_valid = false;
			elements.addr_unit.addClass('error');
		} else {
			elements.addr_unit.removeClass('error');
		}

		if( elements.addr_manual.is(':checked') && $.trim(elements.addr_suburb.val()) == '' ) {
			is_valid = false;
			elements.addr_cur_suburb.addClass('error');
		} else {
			elements.addr_cur_suburb.removeClass('error');
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

	var isValidRobeSize = function() {
		var is_valid = false;

		$('input[name=robesize]:checked').each(function(){
			is_valid = true;
		});

		$('span.robesize').each(function(){
			if( !is_valid ) {
				$(this).addClass('error');
			} else {
				$(this).removeClass('error');
			}
		});

		return is_valid;
	};

	var getAddress = function() {
		var val = {
			unit	: $.trim(elements.addr_unit.val()),
			num		: $.trim(elements.addr_num.val()),
			street	: $.trim(elements.addr_street.val()),
			suburb	: $.trim(elements.addr_suburb.val()),
			state	: $.trim(elements.addr_state.val()),
			code	: $.trim(elements.addr_code.val())
		};

		var output = '';

		if( val.street == '' ) {
			val.street = $.trim(elements.addr_std_street.val());
			output = val.street + ' ' + val.code;
		} else {
			if(val.street.charAt( val.street.length - 1 ) == ".") {
				val.street = val.street.substr(0, (val.street.length - 1));
			}
			output = val.num + ' ' + val.street + ', ' + val.suburb + ' ' + val.state + ' ' + val.code;
		}

		if( val.unit != '' ) {
			output = val.unit + '/' + output;
		}

		return output;
	};

	this.getAddress = getAddress;
};

var meerkatRewards = new MeerkatRewards();
</go:script>
<go:script marker="onready">
meerkatRewards.init();
</go:script>