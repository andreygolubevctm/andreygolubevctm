;(function($, undefined) {

    var $checkboxes;

    function initLmiForm() {


        $(document).ready(function() {
            $checkboxes = $("#startForm input[type='checkbox']");
            _registerEventListeners();
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("change", "#startForm input[type='checkbox']", _onClickCheckbox);
    }

    function _onClickCheckbox(e) {
        var $unchecked = $checkboxes.filter(":not(:checked)"),
            $checked = $checkboxes.filter(":checked");

        if($checked.length >= 12)
            $unchecked.attr("disabled", "disabled");
        else
            $checkboxes.removeAttr("disabled");

        $checkboxes.removeClass("has-error");
    }

    meerkat.modules.register("lmiForm", {
        init: initLmiForm,
        events: {}
    });

})(jQuery);