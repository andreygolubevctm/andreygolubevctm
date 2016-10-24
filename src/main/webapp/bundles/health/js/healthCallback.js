
/*

Handling of the callback popup

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		day,
		timezone = '';
		hours = [],
		times = [],
		firstDay = '';

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

       		getCallCentreTimes();

            $other.toggleClass('hidden');
            $this.toggleClass('hidden');
        });

        $(document).on('click', '.view-all-times', function(e) {
        	e.preventDefault();
            $('.all-times').toggleClass('hidden');
        });

        $(document).on('click', '.callbackDay .btn', function() {
	       	var $this = $(this).find('input');
	        var date = $this.attr('data-date');
	        var options = getDailyHours($this.attr('data-dayname'));

	        if(options.length > 0) {
	        	$('.callbackTime > option').remove();
	        	$(options).each(function() {
	        		var option = document.createElement('option');
	        		option.value = date + 'T' + convertTo24Hour(this) + ':00' + offset;
	        		option.text = this;
	        		$('.callbackTime').append(option);
	        	});
	        }
        });

        $(document).on('click', '#callBackNow', function(e) {
        	e.preventDefault();
            executeCallBackNow();
        });

        $(document).on('click', '#callBackLater', function(e) {
        	e.preventDefault();
            executeCallBackLater();
        });

		$(document).on('show.bs.modal', '.modal', function (e) {
			if($(this).find('#health-callback')) {
				$(this).addClass('health-callback');

				meerkat.messaging.publish(events.callbackModal.CALLBACK_MODAL_OPEN);
	            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#health-callback-form'));
				meerkat.modules.health.configureContactDetails();

				if (meerkat.modules.deviceMediaState.get() == 'xs') {
					$('button').each(function() {
						var $link = $(this).parent();
						var $linkParent = $(this).parent().parent();

						$linkParent.prepend($link);
					});

				}
			}
		});

    }

	function getCallCentreTimes() {
		url = "spring/openinghours/data.json?vertical=health";
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
   	        	$('.callbackTime > option').remove();

			}
		});
	}

	function executeCallBackNow() {
		var url = "spring/rest/health/callMeNow.json";
		var name = $('#health_callback_name').val();
		$('.thanks-name').html(name);

		var data = 'name=' + name;

		var mobileNumber = $('#health_callback_mobileinput').val(),
			otherNumber = $('#health_callback_otherNumberinput').val();
		
		if(mobileNumber) {
			data += '&mobileNumber=' + mobileNumber;
			$('.thanks-contact-number').html(mobileNumber);
		}
		if(otherNumber) {
			data += '&otherNumber=' + otherNumber;
			$('.thanks-contact-number').html(otherNumber);
		}

		return meerkat.modules.comms.post({
			url: url,
			data: data,
			dataType: 'json',
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
				$('.alert-success').toggleClass('hidden');
			}
		});
	}

	function executeCallBackLater() {
		var url = "spring/rest/health/callMeBack.json";
		var name = $('#health_callback_name').val();
		$('.thanks-name').html(name);

		var data = 'name=' + name;

		var mobileNumber = $('#health_callback_mobileinput').val(),
			otherNumber = $('#health_callback_otherNumberinput').val();
		
		if(mobileNumber) {
			data += '&mobileNumber=' + mobileNumber;
			$('.thanks-contact-number').html(mobileNumber);
		}
		if(otherNumber) {
			data += '&otherNumber=' + otherNumber;
			$('.thanks-contact-number').html(otherNumber);
		}

		data += '&scheduledDateTime=' + $('#health_callback_time').val();

		return meerkat.modules.comms.post({
			url: url,
			data: data,
			dataType: 'json',
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
				$('.alert-success').toggleClass('hidden');
			}
		});	
	}

	function setDaySelection() {
        var i = 0;
        var count = 0;

        firstDay = getShortDayOfWeekName(day.getDay());

        while(count < 4) {

			dayName = getShortDayOfWeekName((day.getDay() + i) % 7);

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

	function offsetDatetime(time, offset) {
		// Time needs to be 24hour in format  12:00

	    var hour = time.substr(0, 2);
		
		hour = parseInt(hour) + offset;
	    time = time.replace(hour, ('00'+hour).slice(-2));
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
