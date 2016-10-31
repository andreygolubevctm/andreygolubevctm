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
		$callbackTime,
		$callbackName,
		$callDetailsPanel,
		$contactDetailsName,
		$callbackMobileHiddenInput,
		$callbackMobileInput,
		$callbackOtherNumHiddenInput,
		$callbackOtherNumInput,
		$contactDetailsNumberInput,
		$contactDetailsNumberHiddenInput,
		$applicationFirstname,
		$applicationSurname,
		$applicationOtherNumHiddenInput,
		$applicationOtherNumInput,
		$applicationMobileHiddenInput,
		$applicationMobileInput;

	var events = {
        callbackModal: {
            CALLBACK_MODAL_OPEN : "CALLBACK_MODAL_OPEN"
        }
    };

	
	initHealthCallback =  function(){
		applyEventListeners();

		day = new Date();
        
		timezone = -day.getTimezoneOffset();
		direction = timezone >= 0 ? '%2B' : '%2D';
		offset = direction + ('00'+(timezone / 60)).slice(-2) + ':' + ('00'+(timezone % 60)).slice(-2);
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
			var anchorText = $(this).text() === 'view all times' ? 'show today only' : 'view all times';
			$(this).text(anchorText);
            $('.all-times-callback-modal, .today-hours-callback-modal').toggleClass('hidden');
        });

		$(document).on('click', '.callbackDay .btn', function() {
			var $this = $(this).find('input');
			var date = $this.data('date');
			var options = getDailyHours($this.data('dayname'));

			$callbackTime.children('option').remove();

			if(options.length > 2) {
				$(options).each(function(index, val) {
					var option = document.createElement('option');
					option.value = date + 'T' + convertTo24Hour(val) + ':00' + offset;
					option.text = val;
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
			}
			setPickATimeLabel($this);
		});


        $(document).on('click', '#callBackNow', function(e) {
        	e.preventDefault();
			var settings = { url : "spring/rest/health/callMeNow.json" };
			callMeBack(settings);
        });

        $(document).on('click', '#callBackLater', function(e) {
        	e.preventDefault();
			var settings = {
				url : "spring/rest/health/callMeBack.json",
				scheduledTime : $('#health_callback_time').val()
			};

			callMeBack(settings);
        });

		$(document).on('hide.bs.modal', '.health-callback', function(e){
			updateJourneyFormNameNumber();
		});

		$(document).on('show.bs.modal', '.modal', function (e) {
			if($(this).find('#health-callback')) {
				$(this).addClass('health-callback');

				initComplete = false;
				meerkat.messaging.publish(events.callbackModal.CALLBACK_MODAL_OPEN);
	            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#health-callback-form'));

				if (meerkat.modules.deviceMediaState.get() == 'xs') {
					$('button').each(function() {
						var $link = $(this).parent();
						var $linkParent = $(this).parent().parent();

						$linkParent.prepend($link);
					});

				}
			}

			_initFields();
			updateCBModalFields();
		});
    }

	function _initFields() {
		// init fields
		$pickATimeLabel = $('#pickATimeLabel').find('label');
		origLabel = $.trim($pickATimeLabel.text());
		$pickATimeLabel.text(origLabel + " today:");

		$callbackTime = $('.callbackTime'); // call me back later select box
		$callbackName = $('#health_callback_name'); // name field
		$callDetailsPanel = $('.call-details'); // call details panel on confirmation page

		$callbackMobileHiddenInput = $('#health_callback_mobileinput');
		$callbackMobileInput = $('#health_callback_mobile');
		$callbackOtherNumHiddenInput = $('#health_callback_otherNumber');
		$callbackOtherNumInput = $('#health_callback_otherNumberinput');

		// contact details page details
		$contactDetailsName = $('#health_contactDetails_name');
		$contactDetailsNumberInput = $('#health_contactDetails_flexiContactNumberinput');
		$contactDetailsNumberHiddenInput = $('#health_contactDetails_flexiContactNumber');

		// application details page fields
		$applicationFirstname = $('#health_application_primary_firstname');
		$applicationSurname = $('#health_application_primary_surname');
		$applicationOtherNumHiddenInput = $('#health_application_other');
		$applicationOtherNumInput = $('#health_application_otherinput');
		$applicationMobileHiddenInput = $('#health_application_mobile');
		$applicationMobileInput = $('#health_application_mobileinput');
	}

	function updateCBModalFields() {
		if ($.trim($contactDetailsName.val()).length > 0) {
			$callbackName.val($contactDetailsName.val());
		}

		if ($.trim($contactDetailsNumberInput.val()).length > 0) {
			$callbackMobileHiddenInput.val($contactDetailsNumberHiddenInput.val());
			$callbackMobileInput.val($contactDetailsNumberInput.val());
		}
	}

	function updateJourneyFormNameNumber() {
		if ($.trim($callbackName.val()).length > 0) {
			var name = $callbackName.val();
			$contactDetailsName.val(name);

			var splitName = name.split(" ");
			$applicationFirstname.val(splitName[0]);
			$applicationSurname.val( splitName.slice(1).join(" ") );
		}

		if ($.trim($callbackMobileInput.val()).length > 0) {
			$contactDetailsNumberHiddenInput.val($callbackMobileHiddenInput.val());
			$contactDetailsNumberInput.val($callbackMobileInput.val());

			$applicationMobileHiddenInput.val($callbackMobileHiddenInput.val());
			$applicationMobileInput.val($callbackMobileInput.val());
		}

		if ($.trim($callbackOtherNumInput.val()).length > 0) {
			$contactDetailsNumberHiddenInput.val($callbackOtherNumHiddenInput.val());
			$contactDetailsNumberInput.val($callbackOtherNumInput.val());

			$applicationOtherNumHiddenInput.val($callbackOtherNumHiddenInput.val());
			$applicationOtherNumInput.val($callbackOtherNumInput.val());
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

			var name = $callbackName.val();

			$('.thanks-name').html(name);

			var data = 'name=' + name,
				mobileNumber = $('#health_callback_mobileinput').val(),
				otherNumber = $('#health_callback_otherNumberinput').val();

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
						htmlTemplate;
					if (result.status == 200) {
						htmlTemplate = _.template($('#thankyou-template').html());

						var selectedDate = settings.scheduledTime ? getLabelFormattedDate(selectedDateObj) : "Today, " + getLabelFormattedDate(new Date()),
							selectedTime = settings.scheduledTime ? $callbackTime.children('option:selected').text() : "within 30 mins";

						obj = {
							name: $callbackName.val(),
							contact_number: $('.cbContactNumber').not('.hidden').find('input[type=text]').val(),
							selectedDate: selectedDate,
							selectedTime: selectedTime
						};
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
		// Current defaulting to Aus Eastern Standard until timezones can handled backend along with a rolling date range

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

	function convertTo24Hour(time) {
		if(time !== null) {
			var newTime = new Date(Date.parse(meerkat.modules.dateUtils.format(new Date(), "YYYY/MM/DD") + " " + time.replace(/\s(am|pm)/g, ''))),
				min = newTime.getMinutes() < 10 ? "0" + newTime.getMinutes() : newTime.getMinutes();

			return newTime.getHours()+":"+min;
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
