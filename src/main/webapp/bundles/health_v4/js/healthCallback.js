/*

Handling of the callback popup

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		day,
		timezone = '',
		hours = [],
		times = [],
		firstDay = '',
		$pickATimeLabel,
		origLabel = '',
		selectedDateObj,
		initComplete = false,
		$callbackFormTmpl,
		$callbackFormContainer,
		$callbackTime,
		$callbackName,
		$callDetailsPanel,
		$contactDetailsName,
		$callbackMobileHiddenInput,
		$callbackMobileInput,
		$callbackOtherNumHiddenInput,
		$callbackOtherNumInput,
		$cbContactNumber,
		$cdContactNumber,
		$contactDetailsNumberInput,
		$requestCallBackLink,
		_isClosed = false,
		aedtOffset = 600;

	var events = {
        callbackModal: {
            CALLBACK_MODAL_OPEN : "CALLBACK_MODAL_OPEN"
        }
    };

	
	initHealthCallback =  function(){
		$callbackFormTmpl = $('#tmpl-health-callback-form');

		applyEventListeners();

		day = new Date();

		timezone = -day.getTimezoneOffset();
		direction = timezone >= 0 ? '%2B' : '%2D';
		offset = direction + ('00' + (timezone / 60)).slice(-2) + ':' + ('00' + (timezone % 60)).slice(-2);
	};

    function applyEventListeners() {

        $(document).on('click', '.toggleCallBack', function(e) {
        	e.preventDefault();
            $('#view_all_hours').toggleClass('hidden');
        });

        $(document).on('click', '.switch', function(e) {

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

			if (meerkat.modules.deviceMediaState.get() == 'xs') {
				$callDetailsPanel.toggleClass('hidden');
			}
		});

        $(document).on('click', '.view-all-times', function(e) {
        	e.preventDefault();
            var anchorText = $(this).text() === 'View All Times ' ? 'Show Today Only ' : 'View All Times ';
            $(this).html(anchorText + "<span class='caret'></span>");
            $(this).toggleClass('dropup');
            $('.all-times-callback-modal, .today-hours-callback-modal').toggleClass('hidden');
        });

        $(document).on('click', '.request-call-back', function (e) {
            e.preventDefault();
            $(this).toggleClass('dropup');
            $('.request-call-panel').toggleClass('hidden');
        });

		$(document).on('click', '.callbackDay .btn', function() {
			var $this = $(this).find('input');
			var date = $this.data('date');
			var options = getDailyHours($this.data('dayname'));

			$callbackTime.children('option').remove();

			if(options.length > 2) {
				_isClosed = false;
				$(options).each(function(index, val) {
					var option = document.createElement('option');
					option.value = date + 'T' + convertTo24Hour(val) + ':00' + offset;
					option.text = val + " - " + _add30Mins(val) + " "+ meerkat.site.openingHoursTimeZone;
					$callbackTime.append(option);
				});
			} else {
				/** TODO: Original architecture is too inflexible and needs to be re-written from the ground up */
				// get tomorrow
				var $tomorrow = $(this).next().find('input');
				options = getDailyHours($tomorrow.data('dayname'));

				var option = document.createElement('option');
				option.value = $tomorrow.data('date') + 'T' + convertTo24Hour(options[0]) + ':00' + offset;
				option.text = 'Call me at next available time';
				$callbackTime.append(option);

				_isClosed = true;
			}
			setPickATimeLabel($this);
		});


        $(document).on('click', '#callBackNow', function(e) {
        	e.preventDefault();

			var settings = { url : "spring/rest/health/callMeNow.json", callback : null},
				$this = $(this);

			settings.callback = function() {
				$this.addClass('inactive disabled');
				meerkat.modules.loadingAnimation.showInside($this, true);
			};


			callMeBack(settings);
        });

        $(document).on('click', '#callBackLater', function(e) {
        	e.preventDefault();

			var settings = {
					url : "spring/rest/health/callMeBack.json",
					scheduledTime : $('#health_callback_time').val(),
					callback : null
				},
				$this = $(this);

			settings.callback = function() {
				$this.addClass('inactive disabled');
				meerkat.modules.loadingAnimation.showInside($this, true);
			};

			callMeBack(settings);
        });

		$(document).on('hide.bs.modal', '.health-callback', function(e){
			updateJourneyFormNameNumber();
		});

		$(document).on('show.bs.modal', '.modal', function (e) {
			if(typeof $(this).find('#health-callback').attr('callbackModal') !== 'undefined') {
				$(this).addClass('health-callback');

				if (meerkat.modules.deviceMediaState.get() == 'xs') {
					$('button').each(function() {
						var $link = $(this).parent();
						var $linkParent = $(this).parent().parent();

						$linkParent.prepend($link);
					});

				}

				_initFields();
				updateCBModalFields();

                initComplete = false;
                meerkat.messaging.publish(events.callbackModal.CALLBACK_MODAL_OPEN);
                meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#health-callback-form'));
			}

		});
    }

    function _add30Mins(twelveHrTimeStr) {
        var now = new Date();
        now.setMinutes(now.getMinutes()+now.getTimezoneOffset()+aedtOffset);
        var suppliedTime = convertTo24Hour(twelveHrTimeStr);
        var timePlus30 = Date.parse(meerkat.modules.dateUtils.format(now, "YYYY/MM/DD") + " " + suppliedTime);
        timePlus30 = new Date(timePlus30);
        timePlus30.setMinutes(timePlus30.getMinutes() + 30); // advance 30 minutes
		return formatTime(timePlus30);
	}

	function _initFields() {
    	// Render callback form to DOM
		$callbackFormContainer = $('#health-callback-form-' + (meerkat.modules.deviceMediaState.get() == 'xs' ? 'mobile' : 'normal'));
		var htmlout = _.template($callbackFormTmpl.html());
		$callbackFormContainer.append(htmlout());

		// init fields
		$pickATimeLabel = $('#pickATimeLabel').find('label');
		origLabel = $.trim($pickATimeLabel.text());
		$pickATimeLabel.text(origLabel + " today:");

		$callbackTime = $('.callbackTime'); // call me back later select box
		$callbackName = $('#health_callback_name'); // name field
		$callDetailsPanel = $('.call-details'); // call details panel on confirmation page

		$callbackMobileInput = $('#health_callback_mobileinput');
		$callbackMobileHiddenInput = $('#health_callback_mobile');
		$callbackOtherNumHiddenInput = $('#health_callback_otherNumber');
		$callbackOtherNumInput = $('#health_callback_otherNumberinput');
		$cbContactNumber = $('.callback-contact-number');
		$cdContactNumber = $('.contact-details-contact-number');

		// contact details page details
		$contactDetailsName = $('#health_contactDetails_name');
		$contactDetailsNumberInput = $('#health_contactDetails_flexiContactNumber');

		$requestCallBackLink = $('.request-call-back');
	}

	function updateCBModalFields() {
		if ($.trim($contactDetailsName.val()).length > 0) {
			$callbackName.val($contactDetailsName.val());
		}

		var contact_number = $.trim($contactDetailsNumberInput.val());

		// insert number in appropriate field
		meerkat.modules.healthContactNumber.insertContactNumber($cbContactNumber, contact_number);
	}

	function updateJourneyFormNameNumber() {
		if ($.trim($callbackName.val()).length > 0) {
			var name = $callbackName.val(),
				contact_number = meerkat.modules.healthContactNumber.getContactNumberFromField($cbContactNumber);

			$contactDetailsName.val(name);

			// insert number in appropriate field
			meerkat.modules.healthContactNumber.insertContactNumber($cdContactNumber, contact_number);
		}
	}

	function setPickATimeLabel($target) {
		selectedDateObj = getSelectedCallbackDate($target);
		if (selectedDateObj.setHours(0, 0, 0, 0) == new Date().setHours(0, 0, 0, 0)) {
			$pickATimeLabel.html(origLabel+" today:");
		} else {
			var formattedDate = getLabelFormattedDate(selectedDateObj);
			$pickATimeLabel.html(origLabel+"<span class='selectedOpeningHoursLabel'>"+formattedDate+"</span>");
		}
	}

	function getSelectedCallbackDate($target) {
		var selectedDate = $target.data('date');
		return new Date(selectedDate);
	}

	function getLabelFormattedDate(selectedDateObj) {
		return meerkat.modules.dateUtils.format(selectedDateObj, "dddd, Do MMM");
	}

	function getCallCentreTimes() {
		var url = "spring/openinghours/data.json?vertical=health",
		data = {};

		return meerkat.modules.comms.get({
			url: url,
			data: data,
			errorLevel: "warning",
			onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {
				if(typeof jqXHR.responseText === "string")
					jqXHR.responseText = JSON.parse(jqXHR.responseText);

				var errorMessage = (jqXHR.responseText.error[0] && jqXHR.responseText.error[0].message) ? jqXHR.responseText.error[0].message : false;

				var errorObject = {
					errorLevel:		settings.errorLevel,
					message:		errorMessage,
					page:			'healthCallback.js',
					description:	"Error loading url: " + settings.url + ' : ' + textStatus + ' ' + errorThrown,
					data:			data
				};

				if(!meerkat.modules.dialogs.isDialogOpen("openingHoursErrorDialog") && errorMessage) {
					meerkat.modules.errorHandling.error(errorObject);
				}
			},
			onSuccess: function(result) {
				hours = [];
				$.each(result.openingHours, function() {
					hours.push(this);
				});

		        setDaySelection();
				$callbackTime.children('option').remove();

				// preselect today
				$('.callbackDay .btn').first().trigger('click');
			}
		});
	}

	function callMeBack(settings) {

		if ($("#health-callback-form").valid()) {

			settings.callback();

			var name = $callbackName.val();

			$('.thanks-name').html(name);

			var data = 'name=' + name,
				mobileNumber = $callbackMobileInput.val(),
				otherNumber = $callbackOtherNumInput.val();

			if (mobileNumber) {
				data += '&mobileNumber=' + mobileNumber;
			}
			if (otherNumber) {
				data += '&otherNumber=' + otherNumber;
			}

			if (settings.scheduledTime) {
				data += '&scheduledDateTime=' + settings.scheduledTime;
			}

			return meerkat.modules.comms.post({
				url: settings.url,
				data: data,
				dataType: 'json',
				errorLevel: "silent",
				useDefaultErrorHandling: false,
				onComplete: function (result) {
					$('.main').addClass('hidden');
					var obj = {},
						htmlTemplate,
						today = new Date();
					if (result.status == 200) {
						htmlTemplate = _.template($('#thankyou-template').html());

						var selectedDate = settings.scheduledTime ? getLabelFormattedDate(selectedDateObj) : "Today, " + getLabelFormattedDate(today),
							selectedTime = settings.scheduledTime ? $callbackTime.children('option:selected').text() : "within 30 mins";


						if (_isClosed) {
							var tomorrow = new Date();
							tomorrow.setDate(today.getDate()+1);
							selectedDate = "Tomorrow, " + getLabelFormattedDate(tomorrow);
							selectedTime = "within 30 mins of opening";
						}

						obj = {
							name: $callbackName.val(),
							contact_number: meerkat.modules.healthContactNumber.getContactNumberFromField($cbContactNumber),
							selectedDate: selectedDate,
							selectedTime: selectedTime
						};

						$requestCallBackLink.hide();
					} else {
						htmlTemplate = _.template($('#error-template').html());
					}

					$('.confirmation-content-panel').append(htmlTemplate(obj)).removeClass('hidden');
					$callDetailsPanel.removeClass('hidden');
				}
			});
		}
	}

	function setDaySelection() {
		var i = 0,
			count = 0,
			dayName;

		firstDay = getShortDayOfWeekName(day.getDay());

		while(count < 4) {

			dayName = getShortDayOfWeekName((day.getDay() + i) % 7);

			if(checkOpen(dayName)) {
				var dayDate = new Date();
				dayDate.setDate(dayDate.getDate() + i);

				$('.callbackDay .btn:nth-child('+(count+1)+'n) input').attr('data-dayname',dayName).attr('data-date', meerkat.modules.dateUtils.dateValueServerFormat(dayDate));

				if(dayName == firstDay && count === 0) {
					dayName = 'Today';
				}
				$('.callbackDay .btn:nth-child('+(count+1)+'n) span').text(dayName);
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

					var rightNowStartTime = ('00' + (now.getHours() + 1)).slice(-2) + ':' + startOffset;

                    // use current time - if current time is after the call centre start time
                    var rightNow = Date.parse(meerkat.modules.dateUtils.format(now, "YYYY/MM/DD") + " " + rightNowStartTime);
                    var openingTime = Date.parse(meerkat.modules.dateUtils.format(now, "YYYY/MM/DD") + " " + startTime);
                    if (rightNow > openingTime) {
                        startTime = rightNowStartTime;
					}

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

	meerkat.modules.register("healthCallback", {
		init: initHealthCallback,
		events: events
	});

})(jQuery);
