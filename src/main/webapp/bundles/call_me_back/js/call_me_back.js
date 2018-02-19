;(function ($, undefined) {

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

        $callbackLater,
        $callmebackForm,
        $scheduledTime,
        $callbackStandAloneContent,
        $cmbsaError,

        $contactName,
        $contactPhone,
        $openingHoursTimeZone,
        $callbackDayDD,
        $rightNowTimeDate,

        _now = false,
        _dayString = "",

        _isClosed = false,
        _isOpenRightNow = false,   /* false if it is before the store opening time */
        aestOffset = 600;  // this offset is AEST, not the AEDT offset... as it would be 660 while daylight saving is in play

    function initCallMeBack() {
        jQuery(document).ready(function($) {
            if (!$('body.call-me-back-stand-alone').length) return;


            $callbackLater = $('#cmb-sa-callBackLater');
            $callmebackForm = $('#standalone-callback-form');
            $scheduledTime = $('#callmeback_sa_time');

            applyEventListeners();

            initComplete = false;
            _initFields();

            $('#journeyEngineLoading').hide();


            day = new Date();

            timezone = -day.getTimezoneOffset();
            direction = timezone >= 0 ? '%2B' : '%2D';
            offset = direction + ('00'+(timezone / 60)).slice(-2) + ':' + ('00'+(timezone % 60)).slice(-2);

            // only need to do this once
            if (!initComplete) {
                getCallCentreTimes();
                initComplete = true;
            }

        });
    }

    function applyEventListeners() {

        $(document).on('change', '.cmb-sa-callbackDayDD', function() {
            var $this = $(this).find("option:selected");
            var date = $this.data('date');
            var options = getDailyHours($this.data('dayname'));

            $callbackTime.children('option').remove();

            _now = false;
            _dayString = "";

            $callbackLater.html('Call Me Later <span class="icon icon-arrow-right">&nbsp;</span>');
            if(options.length > 2) {
                _isClosed = false;
                $(options).each(function(index, val) {
                    var option = document.createElement('option');
                    option.value = date + 'T' + convertTo24Hour(val) + ':00' + offset;
                    option.text = val + " " + $openingHoursTimeZone;      //meerkat.site.openingHoursTimeZone;

                    if (index === 0 && _isOpenRightNow && $this.val() === 'Today') {
                        option.text = "Now";
                        $callbackLater.html('Call Me Now <span class="icon icon-arrow-right">&nbsp;</span>');
                        _now = true;
                        _dayString = $this.val();
                    } else if ($this.val() === 'Today' || $this.val() === 'Tomorrow') {
                        _dayString = $this.val();
                    }

                    $callbackTime.append(option);
                });
            } else {
                /** TODO: Original architecture is too inflexible and needs to be re-written from the ground up */
                    // get tomorrow
                var $tomorrow = $(this).find("option:selected").next();
                options = getDailyHours($tomorrow.data('dayname'));

                var option = document.createElement('option');
                option.value = $tomorrow.data('date') + 'T' + convertTo24Hour(options[0]) + ':00' + offset;
                option.text = 'Call me at next available time';
                $callbackTime.append(option);

                _dayString = "Tomorrow";

                _isClosed = true;
            }

            setPickATimeLabel($this);
        });

        $(document).on('change', '#callmeback_sa_time', function() {
            _now = false;

            if ($(this).find("option:selected").text() == "Now") {
                $callbackLater.html('Call Me Now <span class="icon icon-arrow-right">&nbsp;</span>');
                _now;
            } else {
                $callbackLater.html('Call Me Later <span class="icon icon-arrow-right">&nbsp;</span>');
            }
        });

        $(document).on('click', '#cmb-sa-callBackLater', function(e) {
            // .valid() needs to be called twice to ensure click is not ignored if validation was initially false but now true
            $callmebackForm.valid();
            if ($callmebackForm.valid()) {

                var settings,
                    $this = $(this);


                if (_now) {
                    settings = {
                        url : "spring/rest/health/callMeNowWidget.json"
                    };
                } else {
                    settings = {
                        url : "spring/rest/health/callMeBackWidget.json",
                        scheduledTime : $scheduledTime.val()
                    };
                }

                $this.addClass('inactive disabled');
                meerkat.modules.loadingAnimation.showInside($this, true);

                callMeBack(settings);
            }
        });
    }

    function _initFields() {
        // init fields
        $pickATimeLabel = $('#cmb-sa-pickATimeLabel').find('label');
        origLabel = $.trim($pickATimeLabel.text());
        $callbackTime = $('.cmb-sa-callbackTime'); // call me back later select box
        $openingHoursTimeZone = $('.cmbSaOpeningHoursTimeZone').text();

        $contactName = $('#callmeback_sa_name');    // name field
        $contactPhone = $('#callmeback_sa_mobileinput');
        $callbackStandAloneContent = $('.callmeNowStandaloneContent');
        $cmbsaError = $('.cmb-sa-error');

        meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($callmebackForm);
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
                    page:			'call_me_back.js',
                    description:	"Error loading url: " + settings.url + ' : ' + textStatus + ' ' + errorThrown,
                    data:			data
                };

                // TODO: log error rather than error dialog
                if(!meerkat.modules.dialogs.isDialogOpen("openingHoursErrorDialog") && errorMessage) {
                    meerkat.modules.errorHandling.error(errorObject);

                    $callbackStandAloneContent.addClass('hidden');
                    $cmbsaError.removeClass('hidden');
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
                $('.cmb-sa-callbackDayDD option:first').attr('selected','selected').change();
            }
        });
    }

    function callMeBack(settings) {

        var name = $contactName.val(),
            phone = $contactPhone.val();

        $('.callme-sa-contact-name-thanks').html(name);

        var data = 'name=' + name;

        if (phone) {
            data += '&mobileNumber=' + phone;
            data += '&transactionId=-1';
            $('.callme-sa-contact-phone-thanks').text(phone);
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
                $callbackStandAloneContent.addClass('hidden');

                var today = new Date();
                if (result.status == 200) {

                    $('.cmb-sa-thankyou').removeClass('hidden');

                    var selectedDate, selectedTime;

                    if (selectedDateObj == null) {
                        selectedDate = "Today, " + getLabelFormattedDate(today);
                        selectedTime = "within 30 mins";
                    } else {

                        if (_dayString.length > 0) {
                            _dayString = _dayString + ", ";
                        }
                        if (_now) {
                            selectedDate = "Today, " + getLabelFormattedDate(today);
                            selectedTime = "within 30 mins";   // within 30 mins was used when a time was not required for an immediate callback
                        } else {
                            selectedDate = settings.scheduledTime ? _dayString + getLabelFormattedDate(selectedDateObj) : "Today, " + getLabelFormattedDate(today);
                            selectedTime = settings.scheduledTime ? "at " + $callbackTime.children('option:selected').text() : "within 30 mins";   // within 30 mins was used when a time was not required for an immediate callback
                        }
                    }

                    if (_isClosed) {
                        var tomorrow = new Date();
                        tomorrow.setDate(today.getDate()+1);
                        selectedDate = "Tomorrow, " + getLabelFormattedDate(tomorrow);
                        selectedTime = "within 30 mins of opening";
                    }

                    $('.returnCallDate').text(selectedDate);
                    $('.returnCallTime').text(selectedTime);

                } else {
                    $cmbsaError.removeClass('hidden');
                }
            }
        });

    }

    function setDaySelection() {
        var i = 0,
            count = 0,
            dayName;

        $callbackDayDD = $('.cmb-sa-callbackDayDD');
        firstDay = getShortDayOfWeekName(day.getDay());

        while(count < 4) {

            dayName = getShortDayOfWeekName((day.getDay() + i) % 7);

            if(checkStartTimeSupplied(dayName)) {
                var dayDate = new Date();
                dayDate.setDate(dayDate.getDate() + i);
                $('.cmb-sa-callbackDayDD option:nth-child('+(count+1)+'n)').attr('data-dayname',dayName).attr('data-date', meerkat.modules.dateUtils.dateValueServerFormat(dayDate));

                if(dayName == firstDay && count === 0) {
                    dayName = 'Today';
                }
                $('.cmb-sa-callbackDayDD option:nth-child('+(count+1)+'n)').text(dayName);

                count++; // counting to 4
            }

            i++;
        }
    }

    // this just checks if the call center opens on a particular day - not if the call centre is currently open or has already closed
    function checkStartTimeSupplied(dayName) {
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

        // set to brisbane AEST
        now.setMinutes(now.getMinutes()+now.getTimezoneOffset()+aestOffset);

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
                    if (rightNow >= openingTime) {
                        startTime = rightNowStartTime;
                        $rightNowTimeDate = rightNowStartTime;
                        _isOpenRightNow = true;
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

    meerkat.modules.register("call_me_back", {
        init: initCallMeBack
    });

})(jQuery);