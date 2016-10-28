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
		$callDetailsPanel;

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
			var date = $this.attr('data-date');
			var options = getDailyHours($this.attr('data-dayname'));

			if(options.length > 0) {
				$callbackTime.children('option').remove();
				$(options).each(function() {
					var option = document.createElement('option');
					option.value = date + 'T' + convertTo24Hour(this) + ':00' + offset;
					option.text = this;
					$callbackTime.append(option);
				});
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

		$(document).on('show.bs.modal', '.modal', function (e) {
			if($(this).find('#health-callback')) {
				$(this).addClass('health-callback');

				initComplete = false;
				meerkat.messaging.publish(events.callbackModal.CALLBACK_MODAL_OPEN);
	            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#health-callback-form'));
				//meerkat.modules.health.configureContactDetails();

				if (meerkat.modules.deviceMediaState.get() == 'xs') {
					$('button').each(function() {
						var $link = $(this).parent();
						var $linkParent = $(this).parent().parent();

						$linkParent.prepend($link);
					});

				}
			}

			// init fields
			$pickATimeLabel = $('#pickATimeLabel').find('label');
			origLabel = $.trim($pickATimeLabel.text());
			$pickATimeLabel.text(origLabel + " today:");

			$callbackTime = $('.callbackTime'); // call me back later select box
			$callbackName = $('#health_callback_name'); // name field
			$callDetailsPanel = $('.call-details'); // call details panel on confirmation page
		});
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
        	firstDay = getShortDayOfWeekName(day.getDay());

        while(count < 4) {

			var dayName = getShortDayOfWeekName((day.getDay() + i) % 7);

			if(checkOpen(dayName)) {
				var dayDate = new Date();
				dayDate.setDate(dayDate.getDate() + i); 

				var dd = dayDate.getDate();
				var mm = dayDate.getMonth() + 1;
				var yyyy = dayDate.getFullYear();

		       	$('.callbackDay .btn:nth-child('+(count+1)+'n) input').attr('data-dayname',dayName).attr('data-date', yyyy + '-'+ mm + '-'+ dd);

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
		    currentHours = '0',
		    startOffset = '00';
		var now = new Date();
		var options = [];
		var isAmPm;
		var timezoneOffset = 0 ; //(timezone/60) - 10;
		// Current defaulting to Aus Eastern Standard until timezones can handled backend along with a rolling date range

		
		$.each(hours, function() {
			if(this.description.substring(0, 3) === dayName) {
				startTime = convertTo24Hour(this.startTime),
				endTime = convertTo24Hour(this.endTime).substring(0, 2);

				if(startTime === '00:00') {
					return options;	
				}

				if(dayName == firstDay) {
					if(now.getMinutes() > 30) {
						startOffset = '30';
					}

					startTime = ('00' + (now.getHours() + 1)).slice(-2) + ':' + startOffset;
				}
				currentTime = startTime;

				while(currentHours != endTime) {
					isAmPm = ' am';
					currentHours = parseInt(currentTime.substring(0, 2));
					currentMins = currentTime.substring(3, 5);

					if(currentHours >= 12) {
						isAmPm = ' pm';
					}

					if(currentHours >= 13) {
						currentTime = ('00' + (currentHours - 12)).slice(-2) + ':' + ('00'+currentMins).slice(-2);
					}

					options.push(currentTime + isAmPm);

					if (currentMins === '00') {
						currentMins = '30';
					} else {
						currentMins = '00';
						currentHours += 1;
					}

					currentTime = ('00'+currentHours).slice(-2) + ':' + ('00'+currentMins).slice(-2);
				}
			}
		});

		return options;
	}

	function convertTo24Hour(time) {

		if(time !== null) {
		    var hour = time.substr(0, 2);
		    if(time.indexOf('am') != -1 && hour == 12) {
		        time = time.replace('12', '00');
		    }
		    if(time.indexOf('pm')  != -1 && hour < 12) {
		        time = time.replace(hour, parseInt(hour) + 12);
		    }
		    return time.replace(/( am| pm)/, '');
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
		events: events,
		getDailyHours: getDailyHours
	});

})(jQuery);
