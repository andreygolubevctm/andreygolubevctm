
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

	initHealthCallback =  function(){
		applyEventListeners();

		day = new Date();
        
		timezone = -day.getTimezoneOffset();
		direction = timezone >= 0 ? '+' : '-';
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

        $(document).on('click', '.callbackDay .btn', function(e) {
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
		var url = "/spring/rest/health/callMeNow.json";
		var data = 'name=' + $('#health_callback_name').val();

		var mobileNumber = $('#health_callback_mobile').val(),
			otherNumber = $('#health_callback_otherPhone').val();
		
		if(mobileNumber) {
			data += '&mobileNumber=' + mobileNumber;
		}
		if(otherNumber) {
			data += '&otherNumber=' + otherNumber;
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

		var data = 'name=' + $('#health_callback_name').val();

		var mobileNumber = $('#health_callback_mobile').val(),
			otherNumber = $('#health_callback_otherPhone').val();
		
		if(mobileNumber) {
			data += '&mobileNumber=' + mobileNumber;
		}
		if(otherNumber) {
			data += '&otherNumber=' + otherNumber;
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
		var startTime, endTime, currentTime, startOffset = '00';
		var now = new Date();
		var options = [];
		var isAmPm;

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
				currentHours = parseInt(currentTime.substring(0, 2));
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
		    var hours = time.substr(0, 2);
		    if(time.indexOf('am') != -1 && hours == 12) {
		        time = time.replace('12', '00');
		    }
		    if(time.indexOf('pm')  != -1 && hours < 12) {
		        time = time.replace(hours, parseInt(hours) + 12);
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
		getDailyHours: getDailyHours
	});


})(jQuery);