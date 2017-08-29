;(function($){

    var meerkat = window.meerkat,
        $elements = {
    	    input : null
        };

    function init(){
        $(document).ready(function () {
	        $elements.input = $("#health_payment_details_start");
        });
    }

	// Hook into: (replacement) "update premium" button to determine which panels to display
	function updateEventListeners(functionToCall, name){
        $elements.input.on('changeDate.' + name, functionToCall);
	}

	// Reset Hook into "update premium"
	function resetEventListeners( name){
        $elements.input.off('changeDate.' + name);
	}
    meerkat.modules.register('healthCoverStartDateView', {
        init :               init,
        updateEventListeners : updateEventListeners,
        resetEventListeners : resetEventListeners

    });

})(jQuery);