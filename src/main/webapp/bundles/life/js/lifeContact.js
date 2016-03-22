;(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {};

    var $suppliersMoreInfoLink,
        $privacyStatementMoreInfoLink;

    function initLifeContact() {
        _initFields();
        _initEventListeners();
        _initPreload();
    }

    function _initFields() {
        $suppliersMoreInfoLink = $('.suppliersMoreInfo');
        $privacyStatementMoreInfoLink = $('.privacyStatementMoreInfo');
    }

    function _initEventListeners() {

        $suppliersMoreInfoLink.on('click', function showModal(){
            displayModal('Participating Suppliers', 'suppliers', 'participatingSuppliers');
            meerkat.modules.optIn.updateOptinText();
        });

        $privacyStatementMoreInfoLink.on('click', function showModal(){
            displayModal('Privacy Statement', 'privacty-statement', 'privacyStatement');
        });
    }

    function displayModal(title, hashID, templateName) {
        var template = _.template($('#'+templateName).html());

        modalId = meerkat.modules.dialogs.show({
            title : title,
            hashId : hashID,
            className : hashID +'-modal',
            htmlContent: template(),
            closeOnHashChange: true,
            openOnHashChange: false
        });

        return false;
    }

    function _initPreload() {
        $('#life_contactDetails_call').val( $('#life_contactDetails_contactNumber').val().length ? 'Y' : 'N');
    }

    meerkat.modules.register("lifeContact", {
        init: initLifeContact,
        events: events
    });
})(jQuery);