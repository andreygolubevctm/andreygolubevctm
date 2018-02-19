<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>

<%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand). --%>
<c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
<c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
<c:if test="${fn:endsWith(hostOrigin, '/')}">
    <c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
</c:if>

<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
TUH
=======================
--%>

var healthFunds_QTU = {
    $paymentStartDate: $('#health_payment_details_start'),
    $paymentType : $('#health_payment_details_type input'),
    $paymentFrequency : $('#health_payment_details_frequency'),
    $medicareFirstName: $('#health_payment_medicare_firstName'),
    $medicareSurname: $('#health_payment_medicare_surname'),
    $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
    $eligibility: null,
    set: function() {
        <%-- Custom questions: Eligibility --%>
        if (healthFunds_QTU.$eligibility !== null) {
            <%-- HTML was already injected so unhide it --%>
            healthFunds_QTU.$eligibility.show();
        }
        else {
            <c:set var="html">
                <c:set var="fieldXpath" value="health/application/qtu" />
                <form_v2:fieldset id="qtu_eligibility" legend="Eligibility" className="primary">
                    <form_v2:row fieldXpath="${fieldXpath}/eligibility" label="Are you or any of your family a current or former union member?"  className="qtumain">
                        <field_v2:general_select type="healthQTUQuestion_eligibility" xpath="${fieldXpath}/eligibility" title="Eligibility reason" required="true" initialText="Please select" disableErrorContainer="${true}" />
                    </form_v2:row>

                    <form_v2:row label="Which union are you a member of?" id="unionId">
                        <field_v2:general_select xpath="${fieldXpath}/union" title="Union" required="true" initialText="----" />
                    </form_v2:row>
                </form_v2:fieldset>
            </c:set>

            $('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

            healthFunds_QTU.$eligibility = $('#qtu_eligibility');
            healthFunds_QTU.$union = $('#health_application_qtu_union');
            healthFunds_QTU.$unionId = $('#unionId');
            healthFunds_QTU.$unionId.hide();

            $('#health_application_qtu_eligibility').on('change',function() {
                if ($(this).val() === 'CURR') {
                    if (healthFunds_QTU.$union.find('option').length === 1) populateDropdownOnKey('healthQTUQuestion_subCURR', healthFunds_QTU.$union);
                    healthFunds_QTU.$unionId.slideDown(200);
                } else {
                    healthFunds_QTU.$unionId.slideUp(200);
                }
            });

            function populateDropdownOnKey(key,$dropDown,originalKey) {
                _.defer(function() {
                    ajaxRequest = meerkat.modules.comms.get({
                        url: "spring/rest/health/dropdown/list.json",
                        data: {
                            type:key
                        },
                        cache: true,
                        useDefaultErrorHandling: false,
                        numberOfAttempts: 3,
                        errorLevel: "fatal",
                        onSuccess: function onSubmitSuccess(resultData) {
                            <%--$dropDown.empty();--%>
                            $.each(resultData,function(k,v) {
                                $dropDown.append($("<option />").val(k).text(v));
                            });

                            return true;
                        },
                        onComplete: function onSubmitComplete() {
                            <%-- Set subreason if set --%>
                            <c:set var="unionxpath" value="${fieldXpath}/union"/>
                            <c:set var="unionval"><c:out value="${data[unionxpath]}" escapeXml="true"/></c:set>
                            <c:if test="${fn:length(unionval) > 0}">
                            healthFunds_QTU.$union.val('<c:out value="${unionval}" escapeXml="true"/>');
                            </c:if>
                            return true;
                        }
                    });
                    if(! _.isUndefined(originalKey)) {
                        $dropDown.val(originalKey).change();
                    }
                });
            }
        }

        <%-- Increase minimum age requirement for applicants from 16 to 18 --%>
        healthFunds_QTU.$_dobPrimary = $('#health_application_primary_dob');
        healthFunds_QTU.$_dobPartner = $('#health_application_partner_dob');
        healthFunds_QTU.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under 18");
        healthFunds_QTU.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under 18");

        <%-- Authority Fund Name --%>
        meerkat.modules.healthFunds._previousfund_authority(true);

        <%-- Dependants --%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');
        meerkat.modules.healthDependants.updateConfig({showFullTimeField:true, showSchoolFields:false, 'schoolMinAge':21, 'schoolMaxAge':25 });

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: true,
            coverStartRange: {
                min: 0,
                max: 90
            },
            renderPaymentDaysCb: healthFunds_QTU.renderPaymentDays
        });

        healthFunds_QTU.$paymentType.on('change.QTU', function renderPaymentDaysPaymentType(){
            healthFunds_QTU.renderPaymentDays();
        });

        healthFunds_QTU.$paymentFrequency.on('change.QTU', function renderPaymentDaysFrequency(){
            healthFunds_QTU.renderPaymentDays();
        });

        healthFunds_QTU.$paymentStartDate.on('changeDate.QTU', function renderPaymentDaysCalendar() {
            healthFunds_QTU.renderPaymentDays();
        });

        <%--Medicare firstname/surname optional--%>
        healthFunds_QTU.$medicareFirstName.setRequired(false);
        healthFunds_QTU.$medicareSurname.setRequired(false);

        <%-- claims account --%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        meerkat.modules.paymentGateway.setup({
            "paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
            "name" : 'health_payment_gateway',
            "src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
            "origin": '${hostOrigin}', <%-- the CTM host origin --%>
            "providerCode": 'qtu',
            "brandCode": '${pageSettings.getBrandCode()}',
            "handledType" :  {
                "credit" : true,
                "bank" : false
            },
            "updateValidationSelectors" : meerkat.modules.healthPaymentStep.updateValidationSelectorsPaymentGateway,
            "resetValidationSelectors" : meerkat.modules.healthPaymentStep.resetValidationSelectorsPaymentGateway,
            "paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
            "getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
        });
    },
    renderPaymentDays: function() {
        <%--
        payments
             maxDay: maximum day in month
             max: number of options to populate the select drop down
             min: add x days to the cover start date so min = 1 == cover date + 1
        --%>
        if (meerkat.modules.healthPaymentStep.getSelectedFrequency() === 'fortnightly') {
            meerkat.modules.healthFunds.setPayments({'min': 1, 'max': 14, 'weekends': false, 'maxDay': 27});
        } else {
            meerkat.modules.healthFunds.setPayments({'min': 1, 'max': 30, 'weekends': true, 'maxDay': 27});
        }

        var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);

        if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
            healthFunds_QTU.$paymentTypeContainer.slideUp();
        } else {
            healthFunds_QTU.$paymentTypeContainer.text('*' + Results.getSelectedProduct().promo.discountText).slideDown();
        }
    },
    unset: function() {
        <%-- Custom questions - hide in case user comes back --%>
        healthFunds_QTU.$eligibility.hide();

        <%-- Age requirements for applicants (back to default) --%>
        healthFunds_QTU.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_QTU.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

        delete healthFunds_QTU.$_dobPrimary;
        delete healthFunds_QTU.$_dobPartner;

        meerkat.modules.healthFunds._dependants(false);
        meerkat.modules.healthDependants.resetConfig();
        meerkat.modules.healthFunds._reset();

        healthFunds_QTU.$paymentType.off('change.QTU');
        healthFunds_QTU.$paymentFrequency.off('change.QTU');
        healthFunds_QTU.$paymentStartDate.off('changeDate.QTU');

        healthFunds_QTU.$medicareFirstName.setRequired(true);
        healthFunds_QTU.$medicareSurname.setRequired(true);

        healthFunds_QTU.$paymentTypeContainer.text('').slideUp();

        meerkat.modules.paymentGateway.reset();
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />