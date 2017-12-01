/**
 * tripType module provides a common interface to retrieve current trip type selections.
 */
;(function($){

	var meerkat = window.meerkat;

	var optins = {
		cruise : {
			$e : null,
			label : "Cruising",
			active : false
		},
		snow : {
			$e : null,
			label : "Snow sports",
			active : false
		},
		adventure : {
			$e : null,
			label: "Adventure sports",
			active : false
		}
	};

	function init(){
		$(document).ready(function(){
			optins.cruise.$e = $('#travel_tripType_cruising');
			optins.snow.$e = $('#travel_tripType_snowSports');
			optins.adventure.$e = $('#travel_tripType_adventureSports');
			optins.cruise.$e
				.add(optins.snow.$e)
				.add(optins.adventure.$e)
				.off("change.triptype")
				.on("change.triptype",function(){
					optins.cruise.active = optins.cruise.$e.is(":checked");
					optins.snow.active = optins.snow.$e.is(":checked");
					optins.adventure.active = optins.adventure.$e.is(":checked");
				});
			optins.cruise.$e.trigger("change.triptype");
			_addEventListener();
		});
	}

	function _addEventListener() {
        $('.trip_type input').click(function () {
            if ($(this).closest('label').hasClass('active')) {
                $(this).closest('label').removeClass('active');
                $(this).prop('checked', false);
            } else {
                $(this).closest('label').addClass('active');
                $(this).prop('checked', true);
            }
        });
	}

	function exists() {
		return optins.cruise.active || optins.snow.active || optins.adventure.active;
	}

	function get() {
		return optins;
	}

	meerkat.modules.register('tripType', {
		init: init,
		get: get,
		exists: exists
	});

})(jQuery);
