;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var $checkboxes;

    function initFuelDetails() {
        $(document).ready(function() {
            $checkboxes = $("#checkboxes-all input");
           _registerEventListeners();
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("change", "#checkboxes-all input", _onChangeCheckbox);
    }

    /**
     * Checks the number of selected checkboxes and toggles their availability
     * @param e
     * @private
     */
    function _onChangeCheckbox(e) {
        var $unchecked = $checkboxes.filter(":not(:checked)"),
            $checked = $checkboxes.filter(":checked");

        if($checked.length >= 2)
            $unchecked.attr("disabled", "disabled");
        else
            $checkboxes.removeAttr("disabled");

        var checkedValues = $checked.map(function(){ return this.value; }).get().join(",");
        $("#fuel_hidden").val(checkedValues);
        $("label[for='fuel_hidden']").remove();
        $checkboxes.removeClass("has-error");
    }

    meerkat.modules.register("fuelDetails", {
        init: initFuelDetails
    });
})(jQuery);