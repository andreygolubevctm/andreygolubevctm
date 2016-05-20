<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
HBF
=======================
--%>

var healthFunds_HBF = {
    set: function(){
        healthFunds_HBF.productType = meerkat.modules.healthResults.getSelectedProduct().info.ProductType;
        if (healthFunds_HBF.productType === 'GeneralHealth' || healthFunds_HBF.productType === 'Combined') {
            <%-- Custom question: HBF flexi extras --%>
            if ($('#hbf_flexi_extras').length > 0) {
                $('#hbf_flexi_extras').show();
            }else{

                <c:set var="html">
                    <form_v2:fieldset id="hbf_flexi_extras" legend="" className="primary">
                        <div class="col-sm-8 col-md-4 col-lg-3 hidden-xs no-padding"><img src="assets/graphics/logos/health/HBF.png" /></div>
                        <div class="col-sm-7 col-md-8 col-lg-9 no-padding">
                            <h2>HBF <span class="saver-flexi">Saver </span>Flexi Extras</h2>
                            <p><strong>HBF <span class="saver-flexi">Saver </span>Flexi Extras</strong> allows you to chosse your extras cover for your needs, pick any <strong><span class="flexi-available">4</span> extras</strong> from the selection below to build the right cover for your needs.</p>
                        </div>
                        <div class="flexi-message">You have selected <span class="flexi-selected text-tertiary"></span> of your <span class="flexi-available text-tertiary">4</span> <span class="text-tertiary">available</span> extras cover inclusions, <strong class="text-warning"><span class="flexi-remaining"></span> more selections remaining</strong></div>
                        <div class="flexi-message-complete hidden">You have selected all of your <span class="flexi-available">4</span> available extras cover inclusions.</div>

                        <div class="flexi-extras-icons benefitsIcons">
                            <a href="javascript:;" class="HLTicon-general-dental" data-value="GDL">General Dental</a>
                            <a href="javascript:;" class="HLTicon-major-dental"  data-value="MDL">Major Dental</a>
                            <a href="javascript:;" class="HLTicon-optical" data-value="OPT">Optical</a>
                            <a href="javascript:;" class="HLTicon-eye-therapy non-saver" data-value="EYT">Eye Therapy</a>
                            <a href="javascript:;" class="HLTicon-podiatry" data-value="POD">Podiatry</a>
                            <a href="javascript:;" class="HLTicon-physiotherapy" data-value="PHY">Physiotherapy</a>
                            <a href="javascript:;" class="HLTicon-chiropractor" data-value="CHI">Chiropractic</a>
                            <a href="javascript:;" class="HLTicon-osteopathy"  data-value="OST">Osteopathy</a>
                            <a href="javascript:;" class="HLTicon-non-pbs-pharm" data-value="PHA">Pharmacy</a>
                            <a href="javascript:;" class="HLTicon-remedial-massage" data-value="REM">Remedial Massage</a>
                            <a href="javascript:;" class="HLTicon-speech-therapy non-saver" data-value="SPT">Speech Therapy</a>
                            <a href="javascript:;" class="HLTicon-occupational-therapy non-saver" data-value="OCT">Occupational Therapy</a>
                            <a href="javascript:;" class="HLTicon-psychology non-saver" data-value="PSY">Psychology</a>
                            <a href="javascript:;" class="HLTicon-naturopathy non-saver" data-value="NAT">Naturopathy</a>
                            <a href="javascript:;" class="HLTicon-dietetics non-saver" data-value="NTN">Dietetics</a>
                            <a href="javascript:;" class="HLTicon-hearing-aids non-saver" data-value="APP">Appliances</a>
                            <a href="javascript:;" class="HLTicon-lifestyle-products non-saver" data-value="HLP">Lifestyle Products</a>
                            <a href="javascript:;" class="HLTicon-urgent-ambulance" data-value="UAM">Urgent Ambulance</a>
                        </div>
                        <field_v2:validatedHiddenField xpath="health/application/hbf/flexiextras" additionalAttributes=' data-rule-flexiExtras="true"' />
                    </form_v2:fieldset>
                </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

                $('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');
            }

            var $hbf_flexi_extras = $('#hbf_flexi_extras'),
                    $flexiExtrasHidden = $('#health_application_hbf_flexiextras'),
                    isSaver = meerkat.modules.healthResults.getSelectedProduct().info.productTitle.indexOf('Saver') > -1;

            if (isSaver === true) {
                $hbf_flexi_extras.find('.non-saver').hide();
                $hbf_flexi_extras.find('.saver-flexi').show();
                $hbf_flexi_extras.find('.flexi-available').text('4');
            } else {
                $hbf_flexi_extras.find('.non-saver').show();
                $hbf_flexi_extras.find('.saver-flexi').hide();
                $hbf_flexi_extras.find('.flexi-available').text('10');
            }

            $hbf_flexi_extras.find('.flexi-extras-icons a').on('click.HBF', function onFlexiExtraClick() {
                var $this = $(this);
                if ($this.hasClass('disabled')) {return;}
                toggleFlexiExtra($this.data('value'), !$this.hasClass('active'))
            });

            <%-- preload --%>
            updateFromHiddenField();

            function toggleFlexiExtra(value, state){
                $hbf_flexi_extras.find('.flexi-extras-icons a').filter(function filterByValue() {
                    return $(this).data('value')=== value;
                }).toggleClass('active', state);

                return updateHiddenField();
            }

            function updateHiddenField() {
                var selectedExtrasArray = $hbf_flexi_extras.find('.flexi-extras-icons a.active').map(function() {
                            return $(this).data('value');
                        }).get(),
                        selectedCount = selectedExtrasArray.length,
                        availableCount = $hbf_flexi_extras.find('.flexi-available:first').text(),
                        remainingCount =  availableCount - selectedCount;

                $flexiExtrasHidden.val(selectedExtrasArray.join());

                if (remainingCount > 0) {
                    $hbf_flexi_extras.find('.flexi-extras-icons a.disabled').removeClass('disabled');
                    $hbf_flexi_extras.find('.flexi-message-complete').addClass('hidden');
                    $hbf_flexi_extras.find('.flexi-message').removeClass('hidden');
                    $hbf_flexi_extras.find('.flexi-selected').text(selectedCount);
                    $hbf_flexi_extras.find('.flexi-remaining').text(remainingCount);
                } else if (remainingCount === 0){
                    $hbf_flexi_extras.find('.flexi-extras-icons a:not(.active)').addClass('disabled');
                    $hbf_flexi_extras.find('.flexi-message-complete').removeClass('hidden');
                    $hbf_flexi_extras.find('.flexi-message').addClass('hidden');
                    $flexiExtrasHidden.valid();
                } else {
                    <%-- remainingCount < 0, reset, only happens when user selected Flexi extra then go back selects Saver --%>
                    $hbf_flexi_extras.find('.flexi-extras-icons a.active').removeClass('active');
                    $hbf_flexi_extras.find('.flexi-extras-icons a.disabled').removeClass('disabled');
                    $hbf_flexi_extras.find('.flexi-message-complete').addClass('hidden');
                    $hbf_flexi_extras.find('.flexi-message').removeClass('hidden');
                    $hbf_flexi_extras.find('.flexi-selected').text(0);
                    $hbf_flexi_extras.find('.flexi-remaining').text(availableCount);
                    $flexiExtrasHidden.val('');
                    return false;
                }
                return true;
            }

            function updateFromHiddenField() {
                var values = $flexiExtrasHidden.val().split(',');

                $hbf_flexi_extras.find('.flexi-extras-icons a').each(function() {
                    var value = $(this).data('value');
                    return toggleFlexiExtra(value, $.inArray( value, values ) > -1);
                });
            }

            $.validator.addMethod('flexiExtras', function() {
                var isValid = $hbf_flexi_extras.find('.flexi-extras-icons a.active').length - $hbf_flexi_extras.find('.flexi-available:first').text() === 0;
                $hbf_flexi_extras.toggleClass('has-error', !isValid);
                return isValid;
            });

        }

        <%--Contact Point question--%>
        healthApplicationDetails.showHowToSendInfo('HBF', true);

        <%-- Increase minimum age requirement for applicants from 16 to 18 --%>
        healthFunds_HBF.$_dobPrimary = $('#health_application_primary_dob');
        healthFunds_HBF.$_dobPartner = $('#health_application_partner_dob');
        healthFunds_HBF.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under 18");
        healthFunds_HBF.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under 18");

        <%--dependant definition--%>
        healthFunds._dependants('A dependent must be under 25, not married or living in a de facto relationship, and studying full time or earning less than $21,250 taxable income per calendar year.');

        <%--schoolgroups and defacto--%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:false, 'schoolMinAge':18, 'schoolMaxAge':24, showSchoolIdField:false });

        <%-- Authority Fund Name --%>
        healthFunds._previousfund_authority(true);
        healthFunds_HBF.$primaryAuthority = $('#health_previousfund_primary_authority').parents('.health_previous_fund_authority');
        healthFunds_HBF.$partnerAuthority = $('#health_previousfund_partner_authority').parents('.health_previous_fund_authority');
        healthFunds_HBF.originalPartnerAuthorityLabelHtml = healthFunds_HBF.$partnerAuthority.find('label').html();
        if (meerkat.modules.health.hasPartner() === true) {
            healthFunds_HBF.$primaryAuthority.addClass('hidden');
            healthFunds_HBF.$partnerAuthority.find('label').text('We authorise HBF to contact our previous fund(s) to obtain a clearance certificate');
        } else {
            healthFunds_HBF.$primaryAuthority.removeClass('hidden');
            healthFunds_HBF.$partnerAuthority.find('label').text(healthFunds_HBF.originalPartnerAuthorityLabelHtml);
        }

        <%-- Calendar for start cover --%>
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 365);

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        <%-- Payment deduction dates --%>
        $('#update-premium').on('click.HBF', function() {
            var isBank = meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() !== 'cc';

            if (meerkat.modules.healthPaymentStep.getSelectedFrequency() === 'fortnightly') {
                healthFunds._payments = {
                    'min':0,
                    'max':14,
                    'weekends':true
                };
                meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 0, true, isBank);
            } else {
                meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 0, false, isBank, 28);
            }
        });

        <%-- Email not compulsory, but when you select email as how to sent you, then it is required --%>
        var $emailField = $("#health_application_email");
        $emailField.setRequired(false);
        $('input[name="health_application_contactPoint"]').on('change.HBF', function onHowToSendChange(){
            $emailField.setRequired($('#health_application_contactPoint_E').is(':checked')).valid();
        });
    },
    unset: function(){
        var $hbf_flexi_extras = $('#hbf_flexi_extras');

        <%-- Hide Fund specific questions --%>
        $hbf_flexi_extras.find('.flexi-extras-icons a').off('click.HBF');
        $hbf_flexi_extras.hide();

        <%-- How to send information --%>
        healthApplicationDetails.hideHowToSendInfo();

        <%-- Age requirements for applicants (back to default) --%>
        healthFunds_HBF.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_HBF.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);
        delete healthFunds_HBF.$_dobPrimary;
        delete healthFunds_HBF.$_dobPartner;

        <%--dependant definition off--%>
        healthFunds._dependants(false);

        <%-- Reset dependants config --%>
        meerkat.modules.healthDependants.resetConfig();

        <%--Authority off--%>
        healthFunds_HBF.$partnerAuthority.find('label').text(healthFunds_HBF.originalPartnerAuthorityLabelHtml);
        healthFunds._previousfund_authority(false);

        <%-- let set this back to its original state --%>
        $('input[name="health_application_contactPoint"]').off('change.HBF');
        $("#health_application_email").setRequired(true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();

        <%--off payment deduction dates--%>
        $('#update-premium').off('click.HBF');
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('#health_payment_bank_paymentDay'), false);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('#health_payment_credit_paymentDay'), false);

    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />