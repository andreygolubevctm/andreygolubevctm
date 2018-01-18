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
    $claimsAccountOptin: $('#health_payment_bank_claims'),
    hasPartner: false,
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
                            <p><strong>HBF <span class="saver-flexi">Saver </span>Flexi Extras</strong> allows you to choose your extras cover for your needs, pick any <strong><span class="flexi-available">4</span> extras</strong> from the selection below to build the right cover for your needs.</p>
                        </div>
                        <div class="flexi-message">You have selected <span class="flexi-selected text-tertiary"></span> of your <span class="flexi-available text-tertiary">4</span> <span class="text-tertiary">available</span> extras cover inclusions, <strong class="text-warning"><span class="flexi-remaining"></span> more selections remaining</strong></div>
                        <div class="flexi-message-complete hidden">You have selected all of your <span class="flexi-available">4</span> available extras cover inclusions.</div>

                        <ul class="flexi-extras-icons">
                            <li class="flexi-icon HLTicon-general-dental" data-value="GDL"><field_v2:help_icon helpId="269" /><br />General Dental</li>
                            <li class="flexi-icon HLTicon-major-dental"  data-value="MDL"><field_v2:help_icon helpId="555" /><br />Major Dental<span class="non-saver"> &amp; Orthodontics</span></li>
                            <li class="flexi-icon HLTicon-optical" data-value="OPT"><field_v2:help_icon helpId="273" /><br />Optical</li>
                            <li class="flexi-icon HLTicon-eye-therapy non-saver" data-value="EYT"><field_v2:help_icon helpId="294" /><br />Eye Therapy</li>
                            <li class="flexi-icon HLTicon-podiatry" data-value="POD"><field_v2:help_icon helpId="556" /><br />Podiatry</li>
                            <li class="flexi-icon HLTicon-physiotherapy" data-value="PHY"><field_v2:help_icon helpId="274" /><br />Physiotherapy</li>
                            <li class="flexi-icon HLTicon-exercise-physiology non-saver" data-value="EXP"><field_v2:help_icon helpId="559" /><br />Exercise Physiology</li>
                            <li class="flexi-icon HLTicon-chiropractor" data-value="CHI"><field_v2:help_icon helpId="275" /><br />Chiropractic</li>
                            <li class="flexi-icon HLTicon-osteopathy"  data-value="OST"><field_v2:help_icon helpId="562" /><br />Osteopathy</li>
                            <li class="flexi-icon HLTicon-non-pbs-pharm" data-value="PHA"><field_v2:help_icon helpId="283" /><br />Pharmacy</li>
                            <li class="flexi-icon HLTicon-remedial-massage" data-value="REM"><field_v2:help_icon helpId="279" /><br />Remedial Massage</li>
                            <li class="flexi-icon HLTicon-speech-therapy non-saver" data-value="SPT"><field_v2:help_icon helpId="297" /><br />Speech Therapy</li>
                            <li class="flexi-icon HLTicon-occupational-therapy non-saver" data-value="OCT"><field_v2:help_icon helpId="296" /><br />Occupational Therapy</li>
                            <li class="flexi-icon HLTicon-psychology non-saver" data-value="PSY"><field_v2:help_icon helpId="280" /><br />Psychology</li>
                            <li class="flexi-icon HLTicon-naturopathy non-saver" data-value="NAT"><field_v2:help_icon helpId="278" /><br />Natural Therapies</li>
                            <li class="flexi-icon HLTicon-dietetics non-saver" data-value="NTN"><field_v2:help_icon helpId="561" /><br />Nutritionist</li>
                            <li class="flexi-icon HLTicon-appliances non-saver" data-value="APP"><field_v2:help_icon helpId="558" /><br />Appliances</li>
                            <li class="flexi-icon HLTicon-lifestyle-products non-saver" data-value="HLP"><field_v2:help_icon helpId="293" /><br />Healthy living programs</li>
                            <li class="flexi-icon HLTicon-ambulance" data-value="UAM"><field_v2:help_icon helpId="557" /><br />Urgent Ambulance</li>
                        </ul>
                        <field_v2:validatedHiddenField xpath="health/application/hbf/flexiextras" additionalAttributes=' data-rule-flexiExtras="true"' />
                    </form_v2:fieldset>
                </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

                $('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

            }

            var $hbf_flexi_extras = $('#hbf_flexi_extras'),
                    $flexiExtrasHidden = $('#health_application_hbf_flexiextras'),
                    isSaver = meerkat.modules.healthResults.getSelectedProduct().info.productTitle.indexOf('Saver Flexi') > -1;

            if (isSaver === true) {
                $hbf_flexi_extras.find('.non-saver').hide();
                $hbf_flexi_extras.find('.saver-flexi').show();
                $hbf_flexi_extras.find('.flexi-available').text('4');
                $hbf_flexi_extras.find('.HLTicon-major-dental').find('.help-icon').removeAttr('data-hasqtip aria-describedby').attr('data-content', 'helpid:555');
            } else {
                $hbf_flexi_extras.find('.non-saver').show();
                $hbf_flexi_extras.find('.saver-flexi').hide();
                $hbf_flexi_extras.find('.flexi-available').text('10');
                $hbf_flexi_extras.find('.HLTicon-major-dental').find('.help-icon').removeAttr('data-hasqtip aria-describedby').attr('data-content', 'helpid:560');
            }

            $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon').on('click.HBF', function onFlexiExtraClick() {
                var $this = $(this);
                if ($this.hasClass('disabled')) {return;}
                toggleFlexiExtra($this.data('value'), !$this.hasClass('active'))
            });

            <%-- preload --%>
            updateFromHiddenField();

            function toggleFlexiExtra(value, state){
                $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon').filter(function filterByValue() {
                    return $(this).data('value')=== value;
                }).toggleClass('active', state);

                return updateHiddenField();
            }

            function updateHiddenField() {
                var selectedExtrasArray = $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon.active').map(function() {
                            return $(this).data('value');
                        }).get(),
                        selectedCount = selectedExtrasArray.length,
                        availableCount = $hbf_flexi_extras.find('.flexi-available:first').text(),
                        remainingCount =  availableCount - selectedCount;

                $flexiExtrasHidden.val(selectedExtrasArray.join());

                if (remainingCount > 0) {
                    $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon.disabled').removeClass('disabled');
                    $hbf_flexi_extras.find('.flexi-message-complete').addClass('hidden');
                    $hbf_flexi_extras.find('.flexi-message').removeClass('hidden');
                    $hbf_flexi_extras.find('.flexi-selected').text(selectedCount);
                    $hbf_flexi_extras.find('.flexi-remaining').text(remainingCount);
                } else if (remainingCount === 0){
                    $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon:not(.active)').addClass('disabled');
                    $hbf_flexi_extras.find('.flexi-message-complete').removeClass('hidden');
                    $hbf_flexi_extras.find('.flexi-message').addClass('hidden');
                    $flexiExtrasHidden.valid();
                } else {
                    <%-- remainingCount < 0, reset, only happens when user selected Flexi extra then go back selects Saver --%>
                    $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon.active').removeClass('active');
                    $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon.disabled').removeClass('disabled');
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

                $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon').each(function() {
                    var value = $(this).data('value');
                    return toggleFlexiExtra(value, $.inArray( value, values ) > -1);
                });
            }

            $.validator.addMethod('flexiExtras', function() {
                var isValid = $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon.active').length - $hbf_flexi_extras.find('.flexi-available:first').text() === 0;
                $hbf_flexi_extras.toggleClass('has-error', !isValid);
                return isValid;
            });

        }

        <%--Contact Point question--%>
        meerkat.modules.healthFunds.showHowToSendInfo('HBF', true);

        <%-- Increase minimum age requirement for applicants from 16 to 18 --%>
        healthFunds_HBF.$_dobPrimary = $('#health_application_primary_dob');
        healthFunds_HBF.$_dobPartner = $('#health_application_partner_dob');
        healthFunds_HBF.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under 18");
        healthFunds_HBF.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under 18");

        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('A dependent must be under 25, not married or living in a de facto relationship, and studying full time or earning less than $21,250 taxable income per calendar year.');

        <%--schoolgroups and defacto--%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:false, 'schoolMinAge':18, 'schoolMaxAge':24, showSchoolIdField:false });

        <%-- Authority Fund Name --%>
        meerkat.modules.healthFunds._previousfund_authority(true);
        healthFunds_HBF.$primaryAuthorityInput = $('#health_previousfund_primary_authority');
        healthFunds_HBF.$partnerAuthorityInput = $('#health_previousfund_partner_authority');
        healthFunds_HBF.$primaryAuthority = healthFunds_HBF.$primaryAuthorityInput.parents('.health_previous_fund_authority');
        healthFunds_HBF.$partnerAuthority = healthFunds_HBF.$partnerAuthorityInput.parents('.health_previous_fund_authority');
        healthFunds_HBF.originalPartnerAuthorityLabelHtml = healthFunds_HBF.$partnerAuthority.find('label').html();

        healthFunds_HBF.hasPartner = (_.isFunction(meerkat.modules.health.hasPartner) && meerkat.modules.health.hasPartner()) || (_.isFunction(meerkat.modules.healthChoices.hasPartner) && meerkat.modules.healthChoices.hasPartner());


        if (healthFunds_HBF.hasPartner === true) {
            healthFunds_HBF.$primaryAuthority.addClass('hidden');
            healthFunds_HBF.$partnerAuthority.find('label').text('We authorise HBF to contact our previous fund(s) to obtain a clearance certificate');
        } else {
            healthFunds_HBF.$primaryAuthority.removeClass('hidden');
            healthFunds_HBF.$partnerAuthority.find('label').text(healthFunds_HBF.originalPartnerAuthorityLabelHtml);
        }
        healthFunds_HBF.$primaryAuthorityInput.prop('required',true).attr('data-msg-required','Your authorisation is required');
        if (healthFunds_HBF.hasPartner === true) {
            healthFunds_HBF.$partnerAuthorityInput.prop('required',true).attr('data-msg-required','Your authorisation is required');
        }

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: false,
            coverStartRange: {
                min: 0,
                max: 30
            }
        });

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        <%-- Email not compulsory, but when you select email as how to sent you, then it is required --%>
        var $emailField = $("#health_application_email");
        $emailField.setRequired(false);
        $('input[name="health_application_contactPoint"]').on('change.HBF', function onHowToSendChange(){
            $emailField.setRequired($('#health_application_contactPoint_E').is(':checked')).valid();
        });

        meerkat.modules.healthPaymentPolicyDay.updatePaymentEventListeners(healthFunds_HBF.updateMessage, "HBF");

		<%-- Unset the refund optin radio buttons --%>
		healthFunds_HBF.$claimsAccountOptin.find("input:checked").each(function(){
		  $(this).prop("checked",null).trigger("change");
		});
    },
    updateMessage: function() {
        var deductionText = 'Your account will be debited within the next 48 hours.';
        meerkat.modules.healthPaymentPolicyDay.populatePaymentDay( deductionText);
    },
    unset: function(){
        var $hbf_flexi_extras = $('#hbf_flexi_extras');

        <%-- Hide Fund specific questions --%>
        $hbf_flexi_extras.find('.flexi-extras-icons .flexi-icon').off('click.HBF');
        $hbf_flexi_extras.hide();

        <%-- How to send information --%>
        meerkat.modules.healthFunds.hideHowToSendInfo();

        <%-- Age requirements for applicants (back to default) --%>
        healthFunds_HBF.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_HBF.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);
        delete healthFunds_HBF.$_dobPrimary;
        delete healthFunds_HBF.$_dobPartner;

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%-- Reset dependants config --%>
        meerkat.modules.healthDependants.resetConfig();

        <%--Authority off--%>
        healthFunds_HBF.$partnerAuthority.find('label').html(healthFunds_HBF.originalPartnerAuthorityLabelHtml);
        meerkat.modules.healthFunds._previousfund_authority(false);

        <%-- let set this back to its original state --%>
        $('input[name="health_application_contactPoint"]').off('change.HBF');
        $("#health_application_email").setRequired(true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();

        meerkat.modules.healthPaymentPolicyDay.reset("HBF",healthFunds_HBF);

        healthFunds_HBF.$primaryAuthorityInput.prop('required',null).attr('data-msg-required',null);
        if (healthFunds_HBF.hasPartner === true) {
            healthFunds_HBF.$partnerAuthorityInput.prop('required',null).attr('data-msg-required',null);
        }

    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />