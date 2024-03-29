<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ include file="/WEB-INF/tags/taglib.tagf" %>
    <session:get settings="true" />
    <c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>

    <%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand) --%>
    <c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
    <c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
    <c:if test="${fn:endsWith(hostOrigin, '/')}">
    <c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
    </c:if>

    <c:set var="content">
    <%--Important use JSP comments as whitespace is being removed--%>
    <%--
    =======================
    HIF
    =======================
    --%>
    var healthFunds_HIF = {
        $firstnames: $('#health_application_primary_firstname, #health_application_partner_firstname'),
        $surnames: $('#health_application_primary_surname, #health_application_partner_firstname, .health_dependant_details .nestedGroup .fieldrow:not(.selectContainerTitle):nth(1) input[type=text]'),
        $emigrateRow: {
            primary: null,
            partner: null
        },
        $emigrate: {
            primary: null,
            partner: null
        },
        emigrateYesText: 'As you selected Yes, HIF will require a copy of your <span>partners </span>Medicare Eligibility letter which states the date at which you became eligible to receive Medicare benefits. This letter will assist HIF in determining if a Lifetime Health Cover age loading will need to be added to the amount quoted in this application.',
        $emigrateYesTextHTML: {
            primary: null,
            partner: null
        },
        $partnerRelRow: null,
        $partnerAuthLevelRow: null,
        schoolMinAge: 21,
        schoolMaxAge: 30,
        $paymentStartDate: $('#health_payment_details_start'),
        $paymentType : $('#health_payment_details_type input'),
        $paymentFrequency : $('#health_payment_details_frequency'),
        $claimsY: $('#health_payment_details_claims_Y'),
        $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
        set: function() {
            <%--Build Primary emigrate question --%>
            if (!_.isNull(healthFunds_HIF.$emigrateRow.primary)) {
                healthFunds_HIF.$emigrateRow.primary.show();
            } else {
                <c:set var="fieldXpath" value="health/application/hif/primaryemigrate" />
                <c:set var="id" value="health_application_primary_emigrateRow" />

                <c:set var="html">
                    <form_v2:row fieldXpath="${fieldXpath}" id="${id}" label="Have you immigrated to Australia since 1 July 2000 or since your 31st birthday?">
                        <field_v2:array_radio xpath="${fieldXpath}" required="true" title="" items="Y=Yes,N=No" />
                    </form_v2:row>
                </c:set>

                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

                $('#health_application_primary_genderRow').after('<c:out value="${html}" escapeXml="false" />');

                healthFunds_HIF.$emigrateRow.primary = $('#health_application_primary_emigrateRow');
                healthFunds_HIF.$emigrate.primary = healthFunds_HIF.$emigrateRow.primary.find(':input');

                if (_.isNull(healthFunds_HIF.$emigrateYesTextHTML.primary)) {
                    var emigrateYesTextHTML = "<div class='col-xs-12 hidden' id='emigrate-primary-yes-text'>" + healthFunds_HIF.emigrateYesText + "</div>";
                    healthFunds_HIF.$emigrateRow.primary.append(emigrateYesTextHTML);
                    healthFunds_HIF.$emigrateYesTextHTML.primary = $('#emigrate-primary-yes-text');
                }
            }

            healthFunds_HIF.$emigrate.primary.on('change.HIF', function() {
                healthFunds_HIF.$emigrateYesTextHTML.primary.toggleClass('hidden', $(this).val() !== 'Y');
            });

            healthFunds_HIF.$emigrateYesTextHTML.primary.toggleClass('hidden', !healthFunds_HIF.$emigrate.primary.filter('[value=Y]').is(':checked'));

            <%-- Contact Point question--%>
            meerkat.modules.healthFunds.showHowToSendInfo('HIF', true);

            <%-- Build Partner relationship question --%>
            if (!_.isNull(healthFunds_HIF.$partnerRelRow)) {
                healthFunds_HIF.$partnerRelRow.show();
            } else {
                <c:set var="html">
                    <c:set var="fieldXpath" value="health/application/hif/partnerrel" />
                    <form_v2:row id="health_application_partner_partnerrelRow" fieldXpath="${fieldXpath}" label="Relationship to you" renderLabelAsSimplesDialog="true">
                    <field_v2:array_select xpath="${fieldXpath}"
                            required="true"
                            title="Relationship to you" items="=Please choose...,2=Partner,3=Spouse" placeHolder="Relationship" disableErrorContainer="${true}" />
                    </form_v2:row>
                </c:set>

                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                $('#health_application_partner_genderRow').after('<c:out value="${html}" escapeXml="false" />');

                healthFunds_HIF.$partnerRelRow = $('#health_application_partner_partnerrelRow');
            }

            <%-- Build Partner emigrate question --%>
            if (!_.isNull(healthFunds_HIF.$emigrateRow.partner)) {
                healthFunds_HIF.$emigrateRow.partner.show();
            } else {
                <c:set var="fieldXpath" value="health/application/hif/partneremigrate" />
                <c:set var="id" value="health_application_partner_emigrateRow" />

                <c:set var="html">
                    <form_v2:row fieldXpath="${fieldXpath}" id="${id}" label="Has your partner immigrated to Australia since 1 July 2000 or since their 31st birthday?">
                        <field_v2:array_radio xpath="${fieldXpath}" required="true" title="" items="Y=Yes,N=No" />
                    </form_v2:row>
                </c:set>

                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

                $('#health_application_partner_partnerrelRow').after('<c:out value="${html}" escapeXml="false" />');

                healthFunds_HIF.$emigrateRow.partner = $('#health_application_partner_emigrateRow');
                healthFunds_HIF.$emigrate.partner = healthFunds_HIF.$emigrateRow.partner.find(':input');

                if (_.isNull(healthFunds_HIF.$emigrateYesTextHTML.partner)) {
                    var emigrateYesTextHTML = "<div class='col-xs-12 hidden' id='emigrate-partner-yes-text'>" + healthFunds_HIF.emigrateYesText + "</div>";
                    healthFunds_HIF.$emigrateRow.partner.append(emigrateYesTextHTML);
                    healthFunds_HIF.$emigrateYesTextHTML.partner = $('#emigrate-partner-yes-text');
                }
            }

            healthFunds_HIF.$emigrate.partner.on('change.HIF', function() {
                healthFunds_HIF.$emigrateYesTextHTML.partner.toggleClass('hidden', $(this).val() !== 'Y');
            });

            healthFunds_HIF.$emigrateYesTextHTML.partner.toggleClass('hidden', !healthFunds_HIF.$emigrate.partner.filter('[value=Y]').is(':checked'));

            <%-- Build Partner authority level question --%>
            if (!_.isNull(healthFunds_HIF.$partnerAuthLevelRow)) {
                healthFunds_HIF.$partnerAuthLevelRow.show();
            } else {
                <c:set var="fieldXpath" value="health/application/hif/partnerAuthorityLevel" />
                <c:set var="id" value="health_application_partner_authorityLevelRow" />

                <c:set var="html">
                <form_v2:row fieldXpath="${fieldXpath}" id="${id}" label="What level of authority would you like them to have over your health insurance policy?">
                    <field_v2:array_select xpath="${fieldXpath}" required="true" title="" items="=Please choose...,AUTSP=Equal - So they can make enquiries and sign on behalf of both policyholders (not including termination of policy),AUTCL=Secondary - I just want them to be able to make a claim on my behalf" />
                </form_v2:row>
                </c:set>

                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

                $('#health_application_partner_emigrateRow').after('<c:out value="${html}" escapeXml="false" />');

                healthFunds_HIF.$partnerAuthLevelRow = $('#health_application_partner_authorityLevelRow');
            }

            var dependantsString = 'HIF defines a dependant as a child of an adult covered by the policy as long as the child is not married or in a de facto relationship.<br/><br/>' +
                'They allow you to cover child dependents on a family policy until the age of 21. Student dependants can be covered up until the age of 31 as long as they are enrolled and studying on a full-time basis at a HIF recognised educational or training institution.<br/><br/>';

            var dependentString2 = "";
            if (meerkat.site.isCallCentreUser) {
                dependentString2 = "For more details, check <a target='_new' href='https://ctm.livepro.com.au/goto/dependent-children-rules1'>KATS</a>.";
            }
            dependantsString += dependentString2;

            meerkat.modules.healthFunds._dependants(dependantsString);

            meerkat.modules.healthDependants.updateConfig({ showSchoolFields: true, schoolMinAge: healthFunds_HIF.schoolMinAge, schoolMaxAge: healthFunds_HIF.schoolMaxAge, showRelationship: true, showFullTimeField: true });
            <%--maxAge drives validation for dependant DOB like age >= meerkat.modules.healthDependants.getMaxAge() then invalid with some possible additional conditions--%>
            <%--and school age drives show/hide behaviour for school name, full-time, etc. fields like (age >= providerConfig.schoolMinAge && age <= providerConfig.schoolMaxAge) { show group of fields if true in the settings }--%>
            <%--so as we're invalidating age with >= maxAge and hiding school fields with > schoolMaxAge we need to set maxAge 1 year after schoolMaxAge--%>
            meerkat.modules.healthDependants.setMaxAge(healthFunds_HIF.schoolMaxAge + 1);

            <%-- First/Surname maxlength --%>
            healthFunds_HIF.$firstnames.attr('maxlength', 16);
            healthFunds_HIF.$surnames.attr('maxlength', 25);

            meerkat.messaging.subscribe(meerkat.modules.healthDependants.events.DEPENDANTS_RENDERED, function() {
                $('.health_dependant_details input[name*="_firstName"]').attr('maxlength', 16);
                $('.health_dependant_details input[name*="_lastname"]').attr('maxlength', 25);
                $('.health_dependant_details input[name*="_school"]').attr('maxlength', 30);
            });

            $(document).on('change.HIF', '.health_dependant_details .selectContainerTitle select', function() {
                if ($(this).val()) {
                    var value = $(this).val(),
                        $relationship = $(this).closest('.health_dependant_details').find('.health_dependant_details_relationshipGroup select');

                    $relationship.val(value === 'MR' ? 'Son' : 'Dtr');
                }
            });

            meerkat.modules.healthFundTimeOffset.onInitialise({
                weekends: true,
                coverStartRange: {
                    min: 0,
                    max: 90
                },
                renderPaymentDaysCb: healthFunds_HIF.renderPaymentDays
            });

            <%-- Previous fund --%>
            $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID')
                .setRequired(false)
                .attr('maxlength', '10');

            <%-- Authority --%>
            $('#health_previousfund_primary_authority').setRequired(true, 'HIF require authorisation to contact your previous fund');
            $('#health_previousfund_partner_authority').setRequired(true, 'HIF require authorisation to contact your partner\'s previous fund');

            meerkat.modules.healthFunds._previousfund_authority(true);

            <%--Age requirements for applicants--%>
            <%--primary--%>
            healthFunds_HIF.$_dobPrimary = $('#health_application_primary_dob');
            <%--partner--%>
            healthFunds_HIF.$_dobPartner = $('#health_application_partner_dob');

            healthFunds_HIF.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
            healthFunds_HIF.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

            <%-- show health payment day script--%>
            if (meerkat.site.isCallCentreUser) {
                meerkat.modules.healthApplicationDynamicScripting.togglePaymentDayScript(true);
            }

            healthFunds_HIF.$paymentType.on('change.HIF', function renderPaymentDaysPaymentType(){
                healthFunds_HIF.renderPaymentDays();
            });

            healthFunds_HIF.$paymentFrequency.on('change.HIF', function renderPaymentDaysFrequency(){
                healthFunds_HIF.renderPaymentDays();
            });

            <%--credit card & bank account frequency & day frequency--%>
            meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': true, 'annually': true });
            meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': true, 'annually': true });

            <%--credit card options--%>
            meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
            meerkat.modules.healthCreditCard.render();

            meerkat.modules.paymentGateway.setup({
                "paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
                "name" : 'health_payment_gateway',
                "src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
                "origin": '${hostOrigin}', <%-- the CTM host origin --%>
                "providerCode": 'hif',
                "brandCode": '${pageSettings.getBrandCode()}',
                "handledType" :  {
                    "credit" : true,
                    "bank" : false
                },
                "paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
                "updateValidationSelectors" : meerkat.modules.healthPaymentStep.updateValidationSelectorsPaymentGateway,
                "resetValidationSelectors" : meerkat.modules.healthPaymentStep.resetValidationSelectorsPaymentGateway,
                "getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
            });

            <%--trigger claims yes--%>
            healthFunds_HIF.$claimsY.trigger('click');

            <%--set discount text--%>
            healthFunds_HIF.$paymentTypeContainer.text('HIF offers a 4% discount for annual payments or 2% discount for half-yearly payments');
        },
        renderPaymentDays: function() {
        	var policyStartDate = $('#health_payment_details_start').val();
        	if( meerkat.modules.dateUtils.isDate( policyStartDate ) ) {
				var offsetDays = 3;
				var offsetTime = (60 * 60 * 24 * offsetDays) * 1000;
				var startDate = meerkat.modules.dateUtils.returnDate(policyStartDate).getTime();
				var todayDate = new Date(new Date(meerkat.modules.utils.getUTCToday()).setHours(0, 0, 0, 0)).getTime();
				var paymentModel = {
					min: offsetDays,
					max: 20,
					weekends: false,
					businessDaysOnly: true,
					noMinAfterOffsetPassed: true
				};

				if (['monthly', 'quarterly', 'halfyearly'].indexOf(healthFunds_HIF.$paymentFrequency.val()) > -1) {
                    paymentModel.maxDay = 28; <%-- do not allow selection of 29,30,31 --%>
				}

				healthFunds_HIF.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '');
				meerkat.modules.healthFunds.setPayments(paymentModel);

				var _html = meerkat.modules.healthPaymentDay.paymentDays($('#health_payment_details_start').val());
				meerkat.modules.healthPaymentDay.paymentDaysRender($('.health_payment_bank_details-policyDay'), _html);
				meerkat.modules.healthPaymentDay.paymentDaysRender($('.health_payment_credit_details-policyDay'), _html);
			}
        },
        unset: function() {
            meerkat.modules.healthFunds._reset();

            healthFunds_HIF.$emigrateRow.primary.hide();
            healthFunds_HIF.$partnerRelRow.hide();
            healthFunds_HIF.$emigrateRow.partner.hide();
            healthFunds_HIF.$partnerAuthLevelRow.hide();

            <%--dependant definition off--%>
            meerkat.modules.healthFunds._dependants(false);

            <%--Previous fund--%>
            $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID')
                .setRequired(true)
                .removeAttr('maxlength');

            $('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);

            <%--Authority Off--%>
            meerkat.modules.healthFunds._previousfund_authority(false);

            <%--Age requirements for applicants (back to default)--%>
            healthFunds_HIF.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
            healthFunds_HIF.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

            healthFunds_HIF.$emigrate.primary.off('change.HIF');
            healthFunds_HIF.$emigrate.partner.off('change.HIF');
            $(document).off('change.HIF', '.health_dependant_details .selectContainerTitle select');

            meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);
            meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);

            <%-- First/Surname maxlength --%>
            healthFunds_HIF.$firstnames.attr('maxlength', 24);
            healthFunds_HIF.$surnames.attr('maxlength', 20);

            meerkat.messaging.unsubscribe(meerkat.modules.healthDependants.events.DEPENDANTS_RENDERED, function() {
                $('.health_dependant_details input[name*="_firstName"]').attr('maxlength', 24);
                $('.health_dependant_details input[name*="_lastname"]').attr('maxlength', 20);
                $('.health_dependant_details input[name*="_school"]').attr('maxlength', 30);
            });

            meerkat.modules.paymentGateway.reset();

            <%--reset claims yes selection--%>
            healthFunds_HIF.$claimsY.prop('checked', false).parent().removeClass('active');

            <%--reset discount text--%>
            healthFunds_HIF.$paymentTypeContainer.text('');
        }
    };
    </c:set>
    <c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />