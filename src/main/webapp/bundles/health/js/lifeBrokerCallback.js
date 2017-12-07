/*

Handling of the callback popup

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		day,
		timezone = '',
		hours = [],
		firstDay = '',
		$pickATimeLabel,
		origLabel = '',
		selectedDateObj,
		initComplete = false,
		$callbackTime,

        $lbContactName,
		$lbContactDOB,
		$lbContactGender,
		$lbContactState,
		$lbContactPostCode,
		$lbContactPhone,
		$lbContactEmail,
        $lbContactTransactionId,

		_isClosed = false,
		aedtOffset = 600;

    function initLifeBrokerCallback(){
         jQuery(document).ready(function($) {
            if (typeof meerkat.site === 'undefined') return;
            if (meerkat.site.pageAction !== "confirmation") return;

			applyEventListeners();

			day = new Date();

			timezone = -day.getTimezoneOffset();
			direction = timezone >= 0 ? '%2B' : '%2D';
			offset = direction + ('00'+(timezone / 60)).slice(-2) + ':' + ('00'+(timezone % 60)).slice(-2);

         });
	}

    function applyEventListeners() {

        $(document).on('click', '.lb-switch', function(e) {

        	e.preventDefault();
            var $this = $(this).parent().parent();

            var $other = $this.siblings().filter('.hidden');

			// only need to do this once
			if (!initComplete) {
				getCallCentreTimes();
				initComplete = true;
			}

            $other.toggleClass('hidden');
            $this.toggleClass('hidden');

		});

		$(document).on('click', '.lb-callbackDay .btn', function() {
			var $this = $(this).find('input');
			var date = $this.data('date');
			var options = getDailyHours($this.data('dayname'));

			$callbackTime.children('option').remove();

			if(options.length > 2) {
				_isClosed = false;
				$(options).each(function(index, val) {
					var option = document.createElement('option');
					option.value = date + ' ' + convertTo24Hour(val) + ':00';
					option.text = val + " AEDT";
					$callbackTime.append(option);
				});
			} else {
				/** TODO: Original architecture is too inflexible and needs to be re-written from the ground up */
				// get tomorrow
				var $tomorrow = $(this).next().find('input');
				options = getDailyHours($tomorrow.data('dayname'));

				var option = document.createElement('option');
				option.value = $tomorrow.data('date') + ' ' + convertTo24Hour(options[0]) + ':00';
				option.text = 'Call me at next available time';
				$callbackTime.append(option);

				_isClosed = true;
			}
			setPickATimeLabel($this);
		});

        $(document).on('click', '#lb-callBackNow', function(e) {
        	e.preventDefault();

			var settings = {
                    url : "spring/lifebroker/lead/send",
                    scheduledTime : rightNow()
                },
                $this = $(this);

			$this.addClass('inactive disabled');
			meerkat.modules.loadingAnimation.showInside($this, true);


			callMeBack(settings);
        });

        $(document).on('click', '#lb-callBackLater', function(e) {
        	e.preventDefault();

			var settings = {
					url : "spring/lifebroker/lead/send",
					scheduledTime : $('#health_callback_lb-time').val()
				},
				$this = $(this);

			$this.addClass('inactive disabled');
			meerkat.modules.loadingAnimation.showInside($this, true);

			callMeBack(settings);
        });

        $(document).on('click', '#health_simples_dialogue-checkbox-98', function (e) {
            $('.callbackLeadsContent').toggleClass('hidden');

            initComplete = false;

            _initFields();
        });

    }

	function _initFields() {
		// init fields
		$pickATimeLabel = $('#lb-pickATimeLabel').find('label');
		origLabel = $.trim($pickATimeLabel.text());
		$callbackTime = $('.lb-callbackTime'); // call me back later select box
		$lbContactName = $('.lbContactName');
        $lbContactDOB = $('.lbContactDOB');
        $lbContactGender = $('.lbContactGender');
        $lbContactState = $('.lbContactState');
        $lbContactPostCode = $('.lbContactPostCode');
        $lbContactPhone = $('.lbContactPhone');
        $lbContactEmail = $('.lbContactEmail');
        $lbContactTransactionId = $('.lbContactTransactionId');
	}

	function setPickATimeLabel($target) {
		selectedDateObj = getSelectedCallbackDate($target);
	}

	function getSelectedCallbackDate($target) {
		var selectedDate = $target.data('date');
		return new Date(selectedDate);
	}

	function getLabelFormattedDate(selectedDateObj) {
		return meerkat.modules.dateUtils.format(selectedDateObj, "dddd, Do MMM");
	}

	function getCallCentreTimes() {

		var lifeBrokerCallCentreTimes = {"openingHours":[
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Monday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0},
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Tuesday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0},
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Wednesday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0},
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Thursday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0},
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Friday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0},
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Saturday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0},
			{"openingHoursId":0,"startTime":"09:00 am","endTime":"08:00 pm","description":"Sunday","date":"","daySequence":null,"hoursType":null,"effectiveStart":null,"effectiveEnd":null,"verticalId":0}
		]};

		hours = [];
		$.each(lifeBrokerCallCentreTimes.openingHours, function() {
			hours.push(this);
		});

		setDaySelection();
		$callbackTime.children('option').remove();

		// preselect today
		$('.lb-callbackDay .btn').first().trigger('click');
	}

    function getAge(dateString) {
        var today = new Date();
        var birthDate = new Date(dateString);
        var age = today.getFullYear() - birthDate.getFullYear();
        var m = today.getMonth() - birthDate.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        return age;
    }

	function callMeBack(settings) {

		/* might be wise to wrap the logic in here inside a check to ensure that date and times are selected */

		var name = $lbContactName.text();

		var data = 'name=' + name,
            phone = $lbContactPhone.text(),
			email = $lbContactEmail.text(),
            postcode = $lbContactPostCode.text();

        data += '&email=' + email;
        data += '&phone=' + phone;
        data += '&postcode=' + postcode;

        if (settings.scheduledTime) {
			data += '&call_time=' + settings.scheduledTime;
		}

		return meerkat.modules.comms.get({
			url: settings.url,
			data: data,
			dataType: 'json',
			errorLevel: "silent",
			useDefaultErrorHandling: false,
			onComplete: function (result) {
				$('.simples-lifebroker-leads').addClass('hidden');
                $('.callbackLeadsContent').addClass('hidden');

				var today = new Date();
				if (result.status == 200) {

					if (result.responseJSON.success) {
                        $('.callbackLeadsContent-thankyou').removeClass('hidden');


                        var selectedDate, selectedTime;

                        if (selectedDateObj == null) {
                            selectedDate = "Today, ";
                            selectedTime = "within 30 mins";
						} else {
                            selectedDate = settings.scheduledTime ? getLabelFormattedDate(selectedDateObj) : "Today, " + getLabelFormattedDate(today);
                            selectedTime = settings.scheduledTime ? $callbackTime.children('option:selected').text() : "within 30 mins";   /* within 30 mins was used when a time was not required for an immediate callback  */
						}

                        if (_isClosed) {
                            var tomorrow = new Date();
                            tomorrow.setDate(today.getDate()+1);
                            selectedDate = "Tomorrow, " + getLabelFormattedDate(tomorrow);
                            selectedTime = "within 30 mins of opening";
                        }

                        var clientRef = result.responseJSON.client_reference;

                        $('.returnCallDate').text(selectedDate);
                        $('.returnCallTime').text(selectedTime);
                        $('.returnCallClientRef').text(clientRef);

					} else {
                        $('.callbackLeadsContent-error').removeClass('hidden');
					}

				} else {
                    $('.callbackLeadsContent-error').removeClass('hidden');
				}
			}
		});

	}


	function setDaySelection() {
		var i = 0,
			count = 0,
			dayName;

		firstDay = getShortDayOfWeekName(day.getDay());

		while(count < 5) {

			dayName = getShortDayOfWeekName((day.getDay() + i) % 7);

			if(checkOpen(dayName)) {
				var dayDate = new Date();
				dayDate.setDate(dayDate.getDate() + i);

				$('.lb-callbackDay .btn:nth-child('+(count+1)+'n) input').attr('data-dayname',dayName).attr('data-date', meerkat.modules.dateUtils.dateValueServerFormat(dayDate));

				if(dayName == firstDay && count === 0) {
					dayName = 'Today';
				}
				$('.lb-callbackDay .btn:nth-child('+(count+1)+'n) span').text(dayName);
				count++; // counting to 4
			}

			i++;
		}
	}

	function checkOpen(dayName) {
		var open = false;
		$.each(hours, function() {
			if(this.description.substring(0, 3) === dayName) {
				if(this.startTime) {
					open = true;
				}
			}
		});
		return open;
	}

	function getDailyHours(dayName) {
		var startTime, endTime, currentTime,
		    startOffset = '00',
			now = new Date(),
			options = []; //(timezone/60) - 10;

		// set to brisbane AEDT
		now.setMinutes(now.getMinutes()+now.getTimezoneOffset()+aedtOffset);

		$.each(hours, function() {

			if(this.description.substring(0, 3) === dayName) {
				startTime = convertTo24Hour(this.startTime);

				if(startTime === '00:00') {
					return options;
				}

				if(dayName == firstDay) {
					if(now.getMinutes() > 30) {
						startOffset = '30';
					}

					startTime = ('00' + (now.getHours() + 1)).slice(-2) + ':' + startOffset;
				}

				// NOTE: format must use the YYYY/MM/DD pattern otherwise it breaks mobile. Desktop is too lenient
				currentTime = Date.parse(meerkat.modules.dateUtils.format(now, "YYYY/MM/DD") + " " + startTime);
				endTime = Date.parse(meerkat.modules.dateUtils.format(now, "YYYY/MM/DD") + " " + this.endTime);

				// check if call centre is closed past the end time
				if (currentTime  < endTime) {
					currentTime = new Date(currentTime); // convert to a date object
					while (Date.parse(currentTime) < endTime) {
						options.push(formatTime(currentTime));
						currentTime.setMinutes(currentTime.getMinutes() + 30); // advance 30 minutes
					}
				}
			}
		});

		return options;
	}

	function formatTime(dateObj) {
		var hours = dateObj.getHours(),
			min = dateObj.getMinutes() < 10 ? "0"+dateObj.getMinutes() : dateObj.getMinutes(),
			ampm = dateObj.getHours() >= 12 ? 'pm' : 'am';

			hours = hours % 12;
			hours = hours ? hours : 12; // the hour '0' should be '12'

		return hours+":"+min+" "+ampm;
	}



    function rightNow() {
        var now = new Date();
		return meerkat.modules.dateUtils.dateValueServerFormat(new Date()) + " " + now.getHours().toString() + ':' + now.getMinutes().toString() + ':00';
    }


	function convertTo24Hour(time) {
		if(time !== null) {
			var newTime = new Date(Date.parse(meerkat.modules.dateUtils.format(new Date(), "YYYY/MM/DD") + " " + time, '')),
				min = newTime.getMinutes() < 10 ? "0" + newTime.getMinutes() : newTime.getMinutes(),
				hours = newTime.getHours() < 10 ? "0" + newTime.getHours() : newTime.getHours();

			return hours+":"+min;
		}
		return '00:00';
	}

	function getShortDayOfWeekName(dayNum) {
		var shortDayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

		if(dayNum > 6) {
			dayNum = dayNum % 7;
		}
		return shortDayNames[dayNum];
	}

	meerkat.modules.register("lifeBrokerCallback", {
		init: initLifeBrokerCallback
	});

})(jQuery);
