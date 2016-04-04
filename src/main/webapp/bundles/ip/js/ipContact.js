;(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {};

    var $suppliersMoreInfoLink,
        $privacyStatementMoreInfoLink;

    function initIPContact() {
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
            displayModal('Privacy Statement', 'privacy-statement', 'privacyStatement');
        });
    }

    function displayModal(title, hashID, templateName) {
        var template = _.template($('#'+templateName).html());

        meerkat.modules.dialogs.show({
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
        $('#ip_contactDetails_call').val( $('#ip_contactDetails_contactNumber').length && $('#ip_contactDetails_contactNumber').val().length ? 'Y' : 'N');
    }

    meerkat.modules.register("ipContact", {
        init: initIPContact,
        events: events
    });
})(jQuery);