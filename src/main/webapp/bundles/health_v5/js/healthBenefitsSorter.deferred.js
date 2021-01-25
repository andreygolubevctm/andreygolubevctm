;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            sortBenefits:  "SORT_BENEFITS"
        },
        $elements = null;

    function init() {
        $elements = {
            hospital:   $('#sortable-hospital'),
            extras:     $('#sortable-extras')
        };

        eventSubscriptions();
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.sortBenefits, function(){
            _.defer(sort);
        });
    }

    function sort() {
        var topics = ["hospital","extras"];
        var $sortables = {
            extrasChecked: [],
            extrasUnchecked: [],
			hospitalChecked: [],
			hospitalUnchecked: []
        };
		// 1 detach each element and put into sortable obj
        _.each(topics, function(topic) {
            $elements[topic].find(".short-list-item").each(function(){
                var $row = $(this);
                var term = topic + ($row.hasClass("active") ? "Checked" : "Unchecked");
                var data = {
                	sortKey: $row.attr("data-sortable-key"),
					element: $row.detach()
                };
                $sortables[term].push(data);
            });
        });
		// 2 sort each array by benefit name
        var keys = _.keys($sortables);
        for(var k=0; k < keys.length; k++) {
        	var key = keys[k];
        	$sortables[key] = _.sortBy($sortables[key], 'sortKey');
		}
		// 3 Add items back into form in reverse order
		var sortablesOrder = ["Checked","Unchecked"];
		_.each(topics, function(topic){
			_.each(sortablesOrder, function(list){
				_.each($sortables[topic + list], function(row) {
					$elements[topic].append(row.element);
				});
			});

		});
    }

    meerkat.modules.register('healthBenefitsSorter', {
        init: init,
        events: moduleEvents
    });

})(jQuery);