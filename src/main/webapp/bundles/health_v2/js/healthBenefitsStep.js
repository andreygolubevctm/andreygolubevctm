;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $coverType,  //Stores the jQuery object for cover type select field in situation page
        $benefitsForm, //Stores the jQuery object for the main benefits form
        $hiddenFields,
        $hospitalCoverToggles,
        $hospitalCover,
        $allHospitalButtons,
        $defaultCover,
        $hasIconsDiv,
        changedByCallCentre = false;

    var events = {
            healthBenefitsStep: {
                CHANGED: 'HEALTH_BENEFITS_CHANGED'
            }
        },
        moduleEvents = events.healthBenefitsStep;

    function init(){
        $(document).ready(function(){
            if (meerkat.site.pageAction === "confirmation") return false;

            // Store the jQuery objects
            $coverType = $('#health_situation_coverType');
            $defaultCover = $('#health_benefits_covertype_customise');
            $benefitsForm = $('#benefitsForm');
            $hiddenFields = $('#mainform').find('.hiddenFields');

            if (meerkat.modules.splitTest.isActive(13)) {
                $hospitalCover = $('.Hospital_container');
                $hospitalCoverToggles = $('.hospitalCoverToggles a'),
                $allHospitalButtons = $hospitalCover.find('input[type="checkbox"]'),
                // done this way since it's an a/b test and
                $hasIconsDiv = $('.healthBenefits').find('.hasIcons');

                // setup groupings
                // extras middle row
                var htmlTemplate = _.template($('#extras-mid-row-groupings').html()),
                    htmlContent = htmlTemplate();

                $(htmlContent).insertBefore(".HLTicon-physiotherapy");

                // extras last row
                htmlTemplate = _.template($('#extras-last-row-groupings').html()),
                    htmlContent = htmlTemplate();

                $(htmlContent).insertBefore(".HLTicon-glucose-monitor");

                if (meerkat.modules.deviceMediaState.get() === 'xs') {
                    $hasIconsDiv.removeClass('hasIcons');
                }

                // preselect hospital extras and hospital medium
                $('#health_situation_coverType_C').trigger('click');
            }

            setupPage();
            eventSubscriptions();
        });
    }

    function eventSubscriptions() {

        $benefitsForm.find('.CTM-plus label').on('click', function() {
            showMoreBenefits();
        });

        $benefitsForm.find('.benefits-side-bar .btn-edit').on('click', function() {
            $coverType.val('C').change();
        });

        $('#health_situation_healthSitu')
        .add('#health_healthCover_primary_dob')
        .add('#health_situation_healthCvr').on('change',function(event) {
            prefillBenefits();
        });

        // align titles when breakpoint changes
        meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function breakpointChanged(states) {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "benefits") {
                alignTitle();
            }
        });


        if (meerkat.modules.splitTest.isActive(13)) {
            toggleBenefits();
            hospitalCoverToggleEvents();

            $(document).on('click', 'a.tieredLearnMore', function showBenefitsLearnMoreModel() {
                showModal();
            });

            // setup icons
            $('.health-situation-healthCvrType').find('label:first-child').addClass("icon-hospital-extras").end().find('label:nth-child(2)').addClass('icon-hospital-only').end().find('label:last-child').addClass('icon-extras-only');

            meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter(){
                $hasIconsDiv.removeClass('hasIcons');
            });

            meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function editDetailsEnterXsState() {
                $hasIconsDiv.addClass('hasIcons');
            });
        }
    }

    function setDefaultCover() {
        if (meerkat.modules.deviceMediaState.get() === 'xs') {
            if (!$('.hospitalCoverToggles.visible-xs a.benefit-category').hasClass('active')) {
                $('.hospitalCoverToggles.visible-xs a.benefit-category[data-category="medium"]').trigger('click');
            }
        } else {

            if (!$('.hospitalCoverToggles.hidden-xs a.benefit-category').hasClass('active')) {
                $('.hospitalCoverToggles.hidden-xs a.benefit-category[data-category="medium"]').trigger('click');
            }
        }
    }

    function toggleBenefits() {
        var $hospitalSection = $('.Hospital_container').closest('fieldset'),
            $extrasSection = $('.GeneralHealth_container .children').closest('fieldset');
        $coverType.find('input').on('click', function selectCoverType(){
            switch($(this).val().toLowerCase()) {
                case 'c':
                    $hospitalSection.slideDown();
                    $extrasSection.slideDown();
                    setDefaultCover();
                    break;
                case 'h':
                    $hospitalSection.slideDown();
                    $extrasSection.slideUp();
                    setDefaultCover();

                    $extrasSection.find('input[type="checkbox"]').prop('checked', false);
                    break;
                case 'e':
                    $hospitalSection.slideUp();
                    $extrasSection.slideDown();
                    $hospitalCoverToggles.prop("checked", false);
                    $allHospitalButtons.prop('checked', false).prop('disabled', false);
                    break;
                default:
                    $hospitalSection.slideUp();
                    $extrasSection.slideUp();
                    $hospitalCoverToggles.prop("checked", false);
                    $allHospitalButtons.prop('checked', false).prop('disabled', false);
                    $extrasSection.find('input[type="checkbox"]').prop('checked', false);
                    break;
            }
        });
    }

    function showModal() {
        var htmlTemplate = _.template($('#benefits-explanation').html()),
            htmlContent = htmlTemplate(),
            modalName = 'benefits-learn-more';

        modalId = meerkat.modules.dialogs.show({
            htmlContent : '<div class="'+modalName+'-wrapper"></div>',
            hashId : modalName,
            className: modalName,
            closeOnHashChange : true,
            onOpen : function(modalId) {
                var $benefitsLearnMore = $('.'+modalName+'-wrapper', $('#' + modalId));
                $benefitsLearnMore.html(htmlContent).show();
            }
        });
        return modalId;
    }

    function setupPage() {
        $benefitsForm.find('.hasShortlistableChildren').each(function(){
            var $this = $(this);

            if (meerkat.modules.splitTest.isActive(13)) {

                //This is for the split test. The classNames in the database need to remain as is for the default but we need to force an icon
                 $this.find('.category[class*="CTMNoIcon"]').each(function() {
                 var newClass = $(this).attr('class').replace('CTMNoIcon','CTM');
                    $(this).removeClass().addClass(newClass);
                 });
            } else {
                // wrap icons and non-icons items so we can style them differently
                $this.find('.category[class*="HLTicon-"], .category[class*="CTM-"]').wrapAll('<div class="hasIcons"></div>');
                $this.find('.category[class*="noIcon"]').wrapAll('<div class="noIcons"></div>');
                $this.find('.noIcons').insertAfter($this.find('.hasIcons'));
            }

            // fix positioning of label and help
            $this.find('.category[class*="CTM-"] label, .hasIcons .category[class*="HLTicon-"] label').each(function(){
                $el = $(this);
                var labelTxt = $("<span/>").addClass('iconLabel').append($.trim($el.text().replace('Need Help?','')));
                var helpLnk = $el.find('a').detach();
                $el.empty().append(helpLnk).append("<br>").append(labelTxt);
            });

            // Move the subtitle
            $this.find('.subTitle').insertAfter($this.find('.hasIcons'));
        });

        if (!meerkat.modules.splitTest.isActive(13)) {
            // Move the sidebar to the end of the container
            $benefitsForm.find('.sidebarHospital').insertAfter($benefitsForm.find('.extrasCover'));

            // For loading in, if coverType is not selected, but benefits have been selected (mostly for all old quotes, back port to coverType)
            if ($coverType.val() === '') {
                updateCoverTypeByBenefitsSelected();
            }
        }

        // For loading in, update benefits page layout. letting this default to '' for tiered benefits
        changeLayoutByCoverType($coverType.val());
    }

    function hospitalCoverToggleEvents() {
        var currentCover = 'customised',
            previousCover = 'customised',
            $hospitalBenefitsSection = $('.Hospital_container .children'),
            $limitedCover = $('#health_situation_accidentOnlyCover'),
            $coverType = $('#health_benefits_covertype'),
            $accidentCover = $('#accidentCover');

        $hospitalCoverToggles.on('click', function toggleHospitalCover(){
            var $item = $(this);
            currentCover = $item.data('category');

            // set the active button
            $hospitalCoverToggles.removeClass('active');
            $item.addClass('active');

            // set the hidden field
            $coverType.val(currentCover);

            // uncheck all tickboxes
            $allHospitalButtons.prop('checked', false).prop('disabled', false);
            $limitedCover.prop('checked', false);
            $accidentCover.prop('checked', false);

            switch(currentCover) {
                case 'top':
                    $hospitalBenefitsSection.slideDown();
                        $allHospitalButtons.prop('checked', true);
                    break;
                case 'limited':
                    $hospitalBenefitsSection.slideUp(function(){
                        $(this).prop('checked', false);
                        $limitedCover.prop('checked', true);
                    });

                    $("input[name='health_benefits_benefitsExtras_PrHospital'], input[name='health_situation_accidentOnlyCover']").prop('checked', true);

                    break;
                default:
                    $hospitalBenefitsSection.slideDown();
                    var $coverButtons = $hospitalCover.find('.'+currentCover+' input[type="checkbox"]');
                    if (currentCover !== 'customised') {
                        $allHospitalButtons.not($coverButtons);
                    } else {
                        var classToSelect = previousCover === 'top' ? '' : '.'+previousCover;
                        $coverButtons = $hospitalCover.find(classToSelect+' input[type="checkbox"], .customise input[type="checkbox"]');
                    }

                    // setup for customised options to be completed later
                    $coverButtons.each(function() {
                        $(this).prop('checked', true);
                    });
                break;
            }

            // disable all buttons if customise is not selected
            if (currentCover !== 'customised')
            {
                $allHospitalButtons.prop('disabled', true);
            }

            $hospitalCover.find('.coverExplanation.'+previousCover+'Cover').addClass('hidden').end().find('.coverExplanation.'+currentCover+'Cover').removeClass('hidden');
            previousCover = currentCover;
        });
    }

    function disableFields() {
        if ($hospitalCoverToggles.filter('.active').data('category') !== 'customised') {
            $allHospitalButtons.prop('disabled', true);
        }
    }

    function enableFields() {
        $allHospitalButtons.prop('disabled', false);
    }

    function alignTitle() {
        // only align the title if it is a combined cover and no in mobile breakpoint
        if ($coverType.val() !== 'C' || meerkat.modules.deviceMediaState.get() === 'xs') {
            $benefitsForm.find('.custom-col-lg .title').height('auto');
        } else {
            var targetHeight = $benefitsForm.find('.custom-col-sm .title').height() + 9; // other col's height plus margin
            $benefitsForm.find('.custom-col-lg .title').height(targetHeight);
        }
    }

    function showMoreBenefits() {
        $benefitsForm.find('.CTM-plus').fadeOut('fast');
        $benefitsForm.find('.subTitle').slideDown('fast');
        $benefitsForm.find('.noIcons').slideDown('fast', function(){
            alignSidebarHeight();
        });
    }

    function checkAndHideMoreBenefits() {
        // if any nonIcons benefits selected, do not hide
        if ($benefitsForm.find('.noIcons input:checked').length > 0) return;

        $benefitsForm.find('.subTitle').slideUp('fast');
        $benefitsForm.find('.noIcons').slideUp('fast');
        $benefitsForm.find('.CTM-plus').fadeIn('fast');
    }

    function changeLayoutByCoverType(coverType) {
        switch(coverType) {
            case 'H':
                $benefitsForm.find('.sidebarHospital').fadeOut('fast');
                $benefitsForm.find('.extrasCover').fadeOut('fast');
                $benefitsForm.find('.sidebarExtras').fadeIn('fast');
                $benefitsForm.find('.hospitalCover').removeClass('custom-col-sm').addClass('custom-col-lg').fadeIn('fast', function(){
                    movePageTitleToColumn();
                });
                break;
            case 'E':
                $benefitsForm.find('.sidebarExtras').fadeOut('fast');
                $benefitsForm.find('.hospitalCover').removeClass('custom-col-lg').addClass('custom-col-sm').fadeOut('fast');
                $benefitsForm.find('.sidebarHospital').fadeIn('fast');
                $benefitsForm.find('.extrasCover').fadeIn('fast', function(){
                    movePageTitleToColumn();
                });
                break;
            default:
                $benefitsForm.find('.benefits-side-bar').fadeOut('fast');
                $benefitsForm.find('.hasShortlistableChildren').fadeIn('fast', function(){
                    $benefitsForm.find('fieldset > div').first().prepend($benefitsForm.find('.section h2'));
                });
                alignTitle();
        }
    }

    function movePageTitleToColumn() {
        $benefitsForm.find('.custom-col-lg').first().prepend($benefitsForm.find('h2'));
    }

    function updateCoverTypeByBenefitsSelected() {
        // after the re-design we only have two hidden fields for the old yes/no toggle, check these first
        var isHospitalCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_Hospital"]').val() === 'Y',
            isExtraCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_GeneralHealth"]').val() === 'Y';

        // In case the above hidden fields are empty, check children benefits as well
        isHospitalCover = isHospitalCover || $benefitsForm.find('.hospitalCover input:checked').length > 0;
        isExtraCover = isExtraCover || $benefitsForm.find('.extrasCover input:checked').length > 0;

        if (isHospitalCover && isExtraCover) {
            $coverType.val('C');
        } else if (isHospitalCover) {
            $coverType.val('H');
        } else if (isExtraCover) {
            $coverType.val('E');
        } else {
            $coverType.val('');
        }

        $coverType.change();
    }

    function alignSidebarHeight() {
        // no need to align if no sidebar is showing
        if ($coverType.val() === 'C' || $coverType.val() === '') return;

        var $hospitalMainCol = $benefitsForm.find('.hospitalCover'),
            $extrasMainCol = $benefitsForm.find('.extrasCover'),
            $hospitalSidebar = $benefitsForm.find('.sidebarHospital .sidebar-wrapper'),
            $extrasSidebar = $benefitsForm.find('.sidebarExtras .sidebar-wrapper');

        var hospitalMainColHeight = $hospitalMainCol.height() + 15, // plus bottom padding;
            extrasMainColHeight = $extrasMainCol.height() + 15; // plus bottom padding;

        // reset
        $hospitalSidebar.height('auto');
        $extrasSidebar.height('auto');

        if (hospitalMainColHeight > $extrasSidebar.height()) {
            $extrasSidebar.height(hospitalMainColHeight);
        }

        if (extrasMainColHeight > $hospitalSidebar.height()) {
            $hospitalSidebar.height(extrasMainColHeight);
        }
    }

    function updateHiddenFields(coverType) {
        var $hiddenHospitalCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_Hospital"]'),
            $hiddenExtraCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_GeneralHealth"]');

        switch(coverType) {
            case 'C':
                $hiddenHospitalCover.val('Y');
                $hiddenExtraCover.val('Y');
                break;
            case 'H':
                $hiddenHospitalCover.val('Y');
                $hiddenExtraCover.val('');
                break;
            case 'E':
                $hiddenHospitalCover.val('');
                $hiddenExtraCover.val('Y');
                break;
        }
    }

    /*
    * All below functions are moved from original healthBenefits.js (drop down version)
    * */

    function resetBenefitsSelection(){
        $benefitsForm.find("input[type='checkbox']").prop('checked', false);
        $hiddenFields.find(".benefit-item").val('');
    }

    function populateBenefitsSelection(checkedBenefits, isReset){

        if(isReset){
            resetBenefitsSelection();
        }

        for(var i = 0; i < checkedBenefits.length; i++){
            var path = checkedBenefits[i];
            $benefitsForm.find("input[name='health_benefits_benefitsExtras_" + path + "']").prop('checked', true);
        }

    }

    function getBenefitsForSituation(situation, isReset, callback){

        if(situation === ""){
            populateBenefitsSelection([], isReset);
            if (typeof callback === 'function') {
                callback();
            }
            return;
        }

        meerkat.modules.comms.post({
            url:"ajax/csv/get_benefits.jsp",
            data: {
                situation: situation
            },
            errorLevel: "silent",
            cache:true,
            onSuccess:function onBenefitSuccess(data){
                var defaultBenefits = data.split(',');
                populateBenefitsSelection(defaultBenefits, isReset);
                if (typeof callback === 'function') {
                    callback();
                }
            }
        });

    }

    // Rules and logic to decide which code to be sent to the ajax call to prefill the benefits
    function prefillBenefits(){
        //if callCentre user made change on benefits dropdown, do not prefill
        // TODO: fix it when call centre start using V2. For now, it will always be false
        if(changedByCallCentre) return;

        var healthSitu = $('#health_situation_healthSitu').val(),// 3 digit code from step 1 health situation drop down.
            healthSituCvr = getHealthSituCvr();// 3 digit code calculated from other situations, e.g. Age, cover type

        if(healthSituCvr === '' || healthSitu === 'ATP'){// if only step 1 healthSitu has value or ATP is selected, reset the benefits and call ajax once
            getBenefitsForSituation(healthSitu, true);
        }else{
            getBenefitsForSituation(healthSitu, true, function(){// otherwise call ajax twice to get conbined benefits.
                getBenefitsForSituation(healthSituCvr, false);
            });
        }
    }

    // Get 3 digit code for health situation cover based on cover type and age bands
    // YOU = Young [16-30] Single/Couple
    // MID = Middle [31-55] Single/Couple
    // MAT = Mature [56-120] Single/Couple
    // FAM = Family and SP Family (all ages)
    function getHealthSituCvr() {
        var cover = $('#health_situation_healthCvr').val(),
            primary_dob = $('#health_healthCover_primary_dob').val(),
            partner_dob = $('.healthDetailsHiddenFields').find('input[name="health_healthCover_partner_dob"]').val() || primary_dob,
            primary_age = 0, partner_age = 0, ageAverage = 0,
            healthSituCvr = '';

        if(cover === 'F' || cover === 'SPF'){
            healthSituCvr = 'FAM';
        } else if((cover === 'S' || cover === 'SM' || cover === 'SF') && primary_dob !== '') {
            ageAverage = meerkat.modules.utils.returnAge(primary_dob, true);
            healthSituCvr = getAgeBands(ageAverage);
        } else if(cover === 'C' && primary_dob !== '' && partner_dob !== '') {
            primary_age = meerkat.modules.utils.returnAge(primary_dob),
                partner_age = meerkat.modules.utils.returnAge(partner_dob);
            if ( 16 <= primary_age && primary_age <= 120 && 16 <= partner_age && partner_age <= 120 ){
                ageAverage = Math.floor( (primary_age + partner_age) / 2 );
                healthSituCvr = getAgeBands(ageAverage);
            }
        }

        return healthSituCvr;
    }

    // use age to calculate the Age Bands
    function getAgeBands(age){
        if(16 <= age && age <= 30){
            return 'YOU';
        }else if(31 <= age && age <= 55){
            return 'MID';
        }else if(56 <= age && age <= 120){
            return 'MAT';
        }else{
            return '';
        }
    }

    // reset benefits for devs when use product title to search
    function resetBenefitsForProductTitleSearch() {
        if (meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi' || meerkat.site.environment === 'nxs'){
            if ($.trim($('#health_productTitleSearch').val()) !== ''){
                resetBenefitsSelection();
            }
        }
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function getSelectedBenefits(){

        var benefits = [];

        // hidden fields, 2 only, Hospital and GeneralHealth
        $( "#mainform input.benefit-item" ).each(function( index, element ) {
            var $element = $(element);
            if($element.val() == 'Y'){
                var key = $element.attr('data-skey');
                benefits.push(key);
            }
        });

        // other benefits
        $('#benefitsForm').find("input[type='checkbox']").each(function( index, element ) {
            var $element = $(element);
            if($element.is(':checked')){
                var key = $element.attr('name').replace('health_benefits_benefitsExtras_', '');
                benefits.push(key);
            }
        });

        return benefits;

    }

    meerkat.modules.register('healthBenefitsStep', {
        init: init,
        events: events,
        alignTitle: alignTitle,
        checkAndHideMoreBenefits: checkAndHideMoreBenefits,
        changeLayoutByCoverType: changeLayoutByCoverType,
        updateCoverTypeByBenefitsSelected: updateCoverTypeByBenefitsSelected,
        alignSidebarHeight: alignSidebarHeight,
        setDefaultCover: setDefaultCover,
        enableFields: enableFields,
        disableFields: disableFields,
        updateHiddenFields: updateHiddenFields,
        resetBenefitsSelection: resetBenefitsSelection,
        resetBenefitsForProductTitleSearch: resetBenefitsForProductTitleSearch,
        getSelectedBenefits:getSelectedBenefits
    });

})(jQuery);