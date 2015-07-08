/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

var healthFunds_HCF = {
    set: function() {
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
    },
    unset: function() {}
};

var healthFunds_AHM = {
    set: function() {
        var dependantsString = "ahm Health Insurance provides cover for your children up to the age of 21 plus students who are single and studying full time aged between 21 and 25. Adult dependants outside this criteria can be covered by an additional premium on certain covers";
        if (meerkat.site.content.callCentreNumber !== "") {
            dependantsString += " so please call " + meerkat.site.content.brandDisplayName + ' on <span class="callCentreNumber">' + meerkat.site.content.callCentreNumberApplication + "</span>";
            if (meerkat.site.liveChat.enabled) dependantsString += " or chat to our consultants online";
            dependantsString += " to discuss your health cover needs.";
        } else {
            dependantsString += ".";
        }
        healthFunds._dependants(dependantsString);
        healthDependents.maxAge = 25;
        $.extend(healthDependents.config, {
            school: true,
            schoolMin: 21,
            schoolMax: 24,
            schoolID: true,
            schoolIDMandatory: true,
            schoolDate: true,
            schoolDateMandatory: true
        });
        var list = '<select class="form-control"><option value="">Please choose...</option>';
        list += '<option value="ACP">Australian College of Phys. Ed</option>';
        list += '<option value="ACT">Australian College of Theology</option>';
        list += '<option value="ACTH">ACT High Schools</option>';
        list += '<option value="ACU">Australian Catholic University</option>';
        list += '<option value="ADA">Australian Defence Force Academy</option>';
        list += '<option value="AFTR">Australian Film, TV &amp; Radio School</option>';
        list += '<option value="AIR">Air Academy, Brit Aerospace Flight Trng</option>';
        list += '<option value="AMC">Austalian Maritime College</option>';
        list += '<option value="ANU">Australian National University</option>';
        list += '<option value="AVO">Avondale College</option>';
        list += '<option value="BC">Batchelor College</option>';
        list += '<option value="BU">Bond University</option>';
        list += '<option value="CQU">Central Queensland Universty</option>';
        list += '<option value="CSU">Charles Sturt University</option>';
        list += '<option value="CUT">Curtin University of Technology</option>';
        list += '<option value="DU">Deakin University</option>';
        list += '<option value="ECU">Edith Cowan University</option>';
        list += '<option value="EDUC">Education Institute Default</option>';
        list += '<option value="FU">Flinders University of SA</option>';
        list += '<option value="GC">Gatton College</option>';
        list += '<option value="GU">Griffith University</option>';
        list += '<option value="JCUNQ">James Cook University of Northern QLD</option>';
        list += '<option value="KVBVC">KvB College of Visual Communication</option>';
        list += '<option value="LTU">La Trobe University</option>';
        list += '<option value="MAQ">Maquarie University</option>';
        list += '<option value="MMCM">Melba Memorial Conservatorium of Music</option>';
        list += '<option value="MTC">Moore Theological College</option>';
        list += '<option value="MU">Monash University</option>';
        list += '<option value="MURUN">Murdoch University</option>';
        list += "<option value=\"NAISD\">Natn'l Aborign'l &amp; Islander Skills Dev Ass.</option>";
        list += '<option value="NDUA">Notre Dame University Australia</option>';
        list += '<option value="NIDA">National Institute of Dramatic Art</option>';
        list += '<option value="NSWH">NSW High Schools</option>';
        list += '<option value="NSWT">NSW TAFE</option>';
        list += '<option value="NT">Northern Territory High Schools</option>';
        list += '<option value="NTT">NT TAFE</option>';
        list += '<option value="NTU">Northern Territory University</option>';
        list += '<option value="OLA">Open Learnng Australia</option>';
        list += '<option value="OTHER">Other Registered Tertiary Institutions</option>';
        list += '<option value="PSC">Photography Studies College</option>';
        list += '<option value="QCM">Queensland Conservatorium of Music</option>';
        list += '<option value="QCU">Queensland College of Art</option>';
        list += '<option value="QLDH">QLD High Schools</option>';
        list += '<option value="QLDT">QLD TAFE</option>';
        list += '<option value="QUT">Queensland University of Technology</option>';
        list += '<option value="RMIT">Royal Melbourne Institute of Techn.</option>';
        list += '<option value="SA">South Australian High Schools</option>';
        list += '<option value="SAT">SA TAFE</option>';
        list += '<option value="SCD">Sydney College of Divinity</option>';
        list += '<option value="SCM">Sydney Conservatorium of Music</option>';
        list += '<option value="SCU">Southern Cross University</option>';
        list += '<option value="SCUC">Sunshine Coast University College</option>';
        list += '<option value="SIT">Swinburn Institute of Technology</option>';
        list += '<option value="SJC">St Johns College</option>';
        list += '<option value="SYD">University of Sydney</option>';
        list += '<option value="TAS">TAS High Schools</option>';
        list += '<option value="TT">TAS TAFE</option>';
        list += '<option value="UA">University of Adelaide</option>';
        list += '<option value="UB">University of Ballarat</option>';
        list += '<option value="UC">University of Canberra</option>';
        list += '<option value="UM">University of Melbourne</option>';
        list += '<option value="UN">University of Newcastle</option>';
        list += '<option value="UNC">University of Capricornia Rockhampton</option>';
        list += '<option value="UNE">University of New England</option>';
        list += '<option value="UNSW">University Of New South Wales</option>';
        list += '<option value="UQ">University of Queensland</option>';
        list += '<option value="USA">University of South Australia</option>';
        list += '<option value="USQ">University of Southern Queensland</option>';
        list += '<option value="UT">University of Tasmania</option>';
        list += '<option value="UTS">University of Technlogy Sydney</option>';
        list += '<option value="UW">University of Wollongong</option>';
        list += '<option value="UWA">University of Western Australia</option>';
        list += '<option value="UWS">University of Western Sydney</option>';
        list += '<option value="VCAH">VIC College of Agriculture &amp; Horticulture</option>';
        list += '<option value="VIC">Victorian High Schools</option>';
        list += '<option value="VICT">VIC TAFE</option>';
        list += '<option value="VU">Victoria University</option>';
        list += '<option value="VUT">Victoria University of Technology</option>';
        list += '<option value="WA">Western Australia-High Schools</option>';
        list += '<option value="WAT">WA TAFE</option>';
        list += "</select>";
        $(".health_dependant_details_schoolGroup .row-content").each(function(i) {
            var name = $(this).find("input").attr("name");
            var id = $(this).find("input").attr("id");
            $(this).append(list);
            $(this).find("select").attr("name", name).attr("id", id + "select");
            $(this).find("select").rules("add", {
                required: true,
                messages: {
                    required: "Please select dependant " + (i + 1) + "'s school"
                }
            });
        });
        $(".health_dependant_details_schoolIDGroup input").attr("maxlength", "10");
        healthFunds_AHM.tmpSchoolLabel = $(".health_dependant_details_schoolGroup .control-label").html();
        $(".health_dependant_details_schoolGroup .control-label").html("Tertiary Institution this dependant is attending");
        $(".health_dependant_details_schoolGroup .help_icon").hide();
        $("#health_previousfund_primary_authority").rules("add", {
            required: true,
            messages: {
                required: "AHM require authorisation to contact your previous fund"
            }
        });
        $("#health_previousfund_partner_authority").rules("add", {
            required: true,
            messages: {
                required: "AHM require authorisation to contact your partner's previous fund"
            }
        });
        $("#health_previousfund_primary_memberID").attr("maxlength", "10");
        $("#health_previousfund_partner_memberID").attr("maxlength", "10");
        healthFunds._previousfund_authority(true);
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: true,
            fortnightly: true,
            monthly: true,
            quarterly: true,
            halfyearly: true,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: true,
            fortnightly: true,
            monthly: true,
            quarterly: true,
            halfyearly: true,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankSupply", true);
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankQuestions", true);
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: false,
            diners: false
        };
        creditCardDetails.render();
        $("#update-premium").on("click.AHM", function() {
            if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == "cc") {
                meerkat.modules.healthPaymentDate.populateFuturePaymentDays($("#health_payment_details_start").val(), 3, false, false);
            } else {
                meerkat.modules.healthPaymentDate.populateFuturePaymentDays($("#health_payment_details_start").val(), 3, false, true);
            }
        });
        $(".health-credit_card_details .fieldrow").hide();
        meerkat.modules.paymentGateway.setup({
            paymentEngine: meerkat.modules.healthPaymentGatewayWestpac,
            name: "health_payment_gateway",
            src: "ajax/html/health_paymentgateway.jsp",
            handledType: {
                credit: true,
                bank: false
            },
            paymentTypeSelector: $("input[name='health_payment_details_type']:checked"),
            clearValidationSelectors: $("#health_payment_details_frequency, #health_payment_details_start ,#health_payment_details_type"),
            getSelectedPaymentMethod: meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
        });
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 28);
    },
    unset: function() {
        healthFunds._reset();
        healthFunds._dependants(false);
        $(".health_dependant_details_schoolGroup select").remove();
        $(".health_dependant_details_schoolIDGroup input").removeAttr("maxlength");
        $(".health_dependant_details_schoolGroup .control-label").html(healthFunds_AHM.tmpSchoolLabel);
        delete healthFunds_AHM.tmpSchoolLabel;
        $(".health_dependant_details_schoolGroup .help_icon").show();
        $("#health_previousfund_primary_authority").rules("remove", "required");
        $("#health_previousfund_partner_authority").rules("remove", "required");
        $("#health_previousfund_primary_memberID").removeAttr("maxlength");
        $("#health_previousfund_partner_memberID").removeAttr("maxlength");
        healthFunds._previousfund_authority(false);
        creditCardDetails.resetConfig();
        creditCardDetails.render();
        healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), false);
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        $("#update-premium").off("click.AHM");
        meerkat.modules.paymentGateway.reset();
    }
};

var healthFunds_AUF = {
    set: function() {
        healthFunds._dependants("This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependants do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.");
        $("#clientMemberID").find("input").rules("remove", "required");
        $("#partnerMemberID").find("input").rules("remove", "required");
        healthDependents.config.schoolMin = 23;
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: true,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: true,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
        healthFunds._payments = {
            min: 0,
            max: 5,
            weekends: false
        };
        $("#update-premium").on("click.AUF", function() {
            var _html = healthFunds._paymentDays($("#health_payment_details_start").val());
            healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), _html);
            healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), _html);
        });
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: false,
            diners: false
        };
        creditCardDetails.render();
        healthFunds.applicationFailed = function() {
            meerkat.modules.transactionId.getNew();
        };
    },
    unset: function() {
        healthFunds._reset();
        healthFunds._dependants(false);
        creditCardDetails.resetConfig();
        creditCardDetails.render();
        healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), false);
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        $("#update-premium").off("click.AUF");
        healthFunds.applicationFailed = function() {
            return false;
        };
    }
};

var healthFunds_FRA = {
    $policyDateCreditMessage: $(".health_credit-card-details_policyDay-message"),
    $policyDateBankMessage: $(".health_bank-details_policyDay-message"),
    set: function() {
        healthFunds._dependants("This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.");
        healthFunds._previousfund_authority(true);
        healthFunds.$_optionDR = $(".person-title").find("option[value=DR]").first();
        $(".person-title").find("option[value=DR]").remove();
        $("#update-premium").on("click.FRA", function() {
            var messageField = null;
            if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == "cc") {
                messageField = healthFunds_FRA.$policyDateCreditMessage;
            } else {
                messageField = healthFunds_FRA.$policyDateBankMessage;
            }
            meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay(messageField, $("#health_payment_details_start").val(), [ 1, 15 ], 7);
        });
        healthDependents.config.school = false;
        healthDependents.maxAge = 21;
        $("#clientMemberID input").rules("remove", "required");
        $("#partnerMemberID input").rules("remove", "required");
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankQuestions", true);
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: false,
            diners: false
        };
        creditCardDetails.render();
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
    },
    unset: function() {
        healthFunds._reset();
        healthFunds._dependants(false);
        healthFunds._previousfund_authority(false);
        $(".person-title").append(healthFunds.$_optionDR);
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), false);
        $("#update-premium").off("click.FRA");
        creditCardDetails.resetConfig();
        creditCardDetails.render();
    }
};

var healthFunds_GMH = {
    $policyDateHiddenField: $(".health_details-policyDate"),
    $policyDateCreditMessage: $(".health_credit-card-details_policyDay-message"),
    paymentDayChange: function(value) {
        healthFunds_GMH.$policyDateHiddenField.val(value);
    },
    set: function() {
        healthFunds._previousfund_authority(true);
        healthFunds._dependants("This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.");
        healthDependents.config = {
            school: true,
            defacto: false,
            schoolMin: 21,
            schoolMax: 24
        };
        healthFunds._schoolLabel = $(".health_dependant_details_schoolGroup").first().find(".control-label").text();
        $(".health_dependant_details_schoolGroup").find(".control-label").text("Name of school/employer/educational institution your child is attending");
        $("#clientMemberID input").rules("remove", "required");
        $("#partnerMemberID input").rules("remove", "required");
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: true,
            halfyearly: true,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: true,
            halfyearly: true,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("frequency", {
            weekly: 27,
            fortnightly: 27,
            monthly: 27,
            quarterly: 27,
            halfyearly: 27,
            annually: 27
        });
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankQuestions", true);
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: false,
            diners: false
        };
        creditCardDetails.render();
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
        meerkat.messaging.subscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);
        $("#update-premium").on("click.GMH", function() {
            if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == "cc") {
                meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay(healthFunds_GMH.$policyDateCreditMessage, $("#health_payment_details_start").val(), [ 1 ], 7);
            } else {
                meerkat.modules.healthPaymentDate.populateFuturePaymentDays($("#health_payment_details_start").val(), 14, true, true);
            }
        });
    },
    unset: function() {
        meerkat.messaging.unsubscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);
        healthFunds._reset();
        healthFunds._previousfund_authority(false);
        healthFunds._dependants(false);
        $("#mainform").find(".health_dependant_details_schoolGroup").find(".control-label").text(healthFunds._schoolLabel);
        creditCardDetails.resetConfig();
        creditCardDetails.render();
        $("#update-premium").off("click.GMH");
    }
};

var healthFunds_NIB = {
    set: function() {
        healthApplicationDetails.showHowToSendInfo("NIB", true);
        healthFunds._partner_authority(true);
        healthFunds._dependants("This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.");
        healthDependents.config = {
            school: true,
            defacto: false,
            schoolMin: 21,
            schoolMax: 24
        };
        $("#clientMemberID input").rules("remove", "required");
        $("#partnerMemberID input").rules("remove", "required");
        healthFunds._previousfund_authority(true);
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("frequency", {
            weekly: 27,
            fortnightly: 27,
            monthly: 27,
            quarterly: 27,
            halfyearly: 27,
            annually: 27
        });
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankSupply", true);
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankQuestions", true);
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: true,
            diners: false
        };
        creditCardDetails.render();
        $("#update-premium").on("click.NIB", function() {
            var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
            if (freq == "fortnightly") {
                healthFunds._payments = {
                    min: 0,
                    max: 10,
                    weekends: false,
                    countFrom: "effectiveDate"
                };
            } else {
                healthFunds._payments = {
                    min: 0,
                    max: 27,
                    weekends: true,
                    countFrom: "today",
                    maxDay: 27
                };
            }
            var _html = healthFunds._paymentDays($("#health_payment_details_start").val());
            healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), _html);
            healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), _html);
        });
    },
    unset: function() {
        $("#update-premium").off("click.NIB");
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), false);
        healthApplicationDetails.hideHowToSendInfo();
        healthFunds._reset();
        healthFunds._previousfund_authority(false);
        healthFunds._dependants(false);
        creditCardDetails.resetConfig();
        creditCardDetails.render();
    }
};

var healthFunds_WFD = {
    ajaxJoinDec: false,
    set: function() {
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
        healthFunds._dependants("As a member of Westfund all children aged up to 21 are covered on a family policy. Children aged between 21-24 are entitled to stay on your cover at no extra charge if they are a full time or part-time student at School, college or University TAFE institution or serving an Apprenticeship or Traineeship.");
        healthDependents.config = {
            school: true,
            defacto: false,
            schoolMin: 18,
            schoolMax: 24,
            schoolID: true
        };
        var msg = "Please note that the LHC amount quoted is an estimate and will be confirmed once Westfund has verified your details.";
        $(".health-payment-details_premium .row-content").append('<p class="statement" style="margin-top:1em">' + msg + "</p>");
        $("#health_previousfund_primary_fundName").removeAttr("required");
        $("#health_previousfund_partner_fundName").removeAttr("required");
        $("#clientMemberID input").rules("remove", "required");
        $("#partnerMemberID input").rules("remove", "required");
        healthFunds._previousfund_authority(true);
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankQuestions", true);
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: false,
            diners: false
        };
        creditCardDetails.render();
        $("#update-premium").on("click.WFD", function() {
            var deductionDate = returnDate($("#health_payment_details_start").val());
            var distance = 4 - deductionDate.getDay();
            if (distance < 2) {
                distance += 7;
            }
            deductionDate.setDate(deductionDate.getDate() + distance);
            var day = deductionDate.getDate();
            var isTeen = day > 10 && day < 20;
            if (day % 10 == 1 && !isTeen) {
                day += "st";
            } else if (day % 10 == 2 && !isTeen) {
                day += "nd";
            } else if (day % 10 == 3 && !isTeen) {
                day += "rd";
            } else {
                day += "th";
            }
            var deductionText = "Please note that your first or full payment (annual frequency) " + "will be debited from your payment method on " + healthFunds._getDayOfWeek(deductionDate) + " " + day + " " + healthFunds._getMonth(deductionDate);
            $(".health_credit-card-details_policyDay-message").text(deductionText);
            $(".health_bank-details_policyDay-message").text(deductionText);
            var _dayString = leadingZero(deductionDate.getDate());
            var _monthString = leadingZero(deductionDate.getMonth() + 1);
            var deductionDateValue = deductionDate.getFullYear() + "-" + _monthString + "-" + _dayString;
            $(".health-credit-card_details-policyDay option").val(deductionDateValue);
            $(".health-bank_details-policyDay option").val(deductionDateValue);
        });
        healthFunds_WFD.$_dobPrimary = $("#health_application_primary_dob");
        healthFunds_WFD.$_dobPartner = $("#health_application_partner_dob");
        meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPrimary, 18, "primary person's");
        meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPartner, 18, "partner's");
        healthFunds_WFD.joinDecLabelHtml = $("#health_declaration + label").html();
        healthFunds_WFD.ajaxJoinDec = $.ajax({
            url: "health_fund_info/WFD/declaration.html",
            type: "GET",
            async: true,
            dataType: "html",
            timeout: 2e4,
            cache: true,
            success: function(htmlResult) {
                $("#health_declaration + label").html(htmlResult);
                $("a#joinDeclarationDialog_link").remove();
            },
            error: function(obj, txt) {}
        });
    },
    unset: function() {
        $("#update-premium").off("click.WFD");
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), false);
        healthFunds._reset();
        healthFunds._dependants(false);
        if (healthFunds_WFD.ajaxJoinDec) {
            healthFunds_WFD.ajaxJoinDec.abort();
        }
        $("#health_declaration + label").html(healthFunds_WFD.joinDecLabelHtml);
        $(".health-payment-details_premium .statement").remove();
        $("#health_previousfund_primary_fundName").attr("required", "required");
        $("#health_previousfund_partner_fundName").attr("required", "required");
        healthFunds._previousfund_authority(false);
        meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPrimary, dob_health_application_primary_dob.ageMin, "primary person's");
        meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPartner, dob_health_application_partner_dob.ageMin, "partner's");
        delete healthFunds_WFD.$_dobPrimary;
        delete healthFunds_WFD.$_dobPartner;
    }
};

function returnAge(_dobString, round) {
    var _now = new Date();
    _now.setHours(0, 0, 0);
    var _dob = returnDate(_dobString);
    var _years = _now.getFullYear() - _dob.getFullYear();
    if (_years < 1) {
        return (_now - _dob) / (1e3 * 60 * 60 * 24 * 365);
    }
    var _leapYears = _years - _now.getFullYear() % 4;
    _leapYears = (_leapYears - _leapYears % 4) / 4;
    var _offset1 = (_leapYears * 366 + (_years - _leapYears) * 365) / _years;
    var _offset2;
    if (_dob.getMonth() == _now.getMonth() && _dob.getDate() > _now.getDate()) {
        _offset2 = -.005;
    } else {
        _offset2 = +.005;
    }
    var _age = (_now - _dob) / (1e3 * 60 * 60 * 24 * _offset1) + _offset2;
    if (round) {
        return Math.floor(_age);
    } else {
        return _age;
    }
}

function returnDate(_dateString) {
    if (_dateString === "") return null;
    var dateComponents = _dateString.split("/");
    if (dateComponents.length < 3) return null;
    return new Date(dateComponents[2], dateComponents[1] - 1, dateComponents[0]);
}

function isLessThan31Or31AndBeforeJuly1(_dobString) {
    if (_dobString === "") return false;
    var age = Math.floor(returnAge(_dobString));
    if (age < 31) {
        return false;
    } else if (age == 31) {
        var dob = returnDate(_dobString);
        var birthday = returnDate(_dobString);
        birthday.setFullYear(dob.getFullYear() + 31);
        var now = new Date();
        if (dob.getMonth() + 1 < 7 && (now.getMonth() + 1 >= 7 || now.getFullYear() > birthday.getFullYear())) {
            return true;
        } else if (dob.getMonth() + 1 >= 7 && now.getMonth() + 1 >= 7 && now.getFullYear() > birthday.getFullYear()) {
            return true;
        } else {
            return false;
        }
    } else if (age > 31) {
        return true;
    } else {
        return false;
    }
}

function resetRadio($_obj, value) {
    if ($_obj.val() != value) {
        $_obj.find("input").prop("checked", false);
        $_obj.find("label").removeClass("active");
        if (value != null) {
            $_obj.find("input[value=" + value + "]").prop("checked", "checked");
            $_obj.find("input[value=" + value + "]").parent().addClass("active");
        }
    }
}

function leadingZero(value) {
    if (value < 10) {
        value = "0" + value;
    }
    return value;
}

function formatMoney(value) {
    var parts = value.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
}

var FatalErrorDialog = {
    display: function(sentParams) {
        FatalErrorDialog.exec(sentParams);
    },
    init: function() {},
    exec: function(sentParams) {
        var params = $.extend({
            errorLevel: "silent",
            message: "A fatal error has occurred.",
            page: "undefined.jsp",
            description: null,
            data: null
        }, sentParams);
        meerkat.modules.errorHandling.error(params);
    }
};

var Track = {
    splitTest: function splitTesting(result, supertagName) {
        meerkat.modules.tracking.recordSupertag("splitTesting", {
            version: result,
            splitTestName: supertagName
        });
    }
};

var healthChoices = {
    _cover: "",
    _situation: "",
    _state: "",
    _benefits: new Object(),
    _performUpdate: false,
    initialise: function(cover, situation, benefits) {
        healthChoices.setCover(cover, true, true);
        var performUpdate = this._performUpdate;
        healthChoices.setSituation(situation, performUpdate);
    },
    hasSpouse: function() {
        switch (this._cover) {
          case "C":
          case "F":
            return true;

          default:
            return false;
        }
    },
    hasChildren: function() {
        switch (this._cover) {
          case "F":
          case "SPF":
            return true;

          default:
            return false;
        }
    },
    setCover: function(cover, ignore_rebate_reset, initMode) {
        ignore_rebate_reset = ignore_rebate_reset || false;
        initMode = initMode || false;
        healthChoices._cover = cover;
        if (!ignore_rebate_reset) {
            healthChoices.resetRebateForm();
        }
        if (!healthChoices.hasSpouse()) {
            healthChoices.flushPartnerDetails();
            $("#partner-health-cover, #partner, .health-person-details-partner, #partnerFund").hide();
        } else {
            $("#partner-health-cover, #partner, .health-person-details-partner, #partnerFund").show();
        }
        healthChoices.dependants(initMode);
        healthCoverDetails.displayHealthFunds();
        meerkat.modules.healthTiers.setTiers(initMode);
    },
    setSituation: function(situation, performUpdate) {
        if (performUpdate !== false) performUpdate = true;
        if (situation != healthChoices._situation) {
            healthChoices._situation = situation;
        }
        $("#health_benefits_healthSitu, #health_situation_healthSitu").val(situation);
    },
    isValidLocation: function(location) {
        var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);
        value = $.trim(String(location));
        if (value != "") {
            if (value.match(search_match)) {
                return true;
            }
        }
        return false;
    },
    setLocation: function(location) {
        if (healthChoices.isValidLocation(location)) {
            var value = $.trim(String(location));
            var pieces = value.split(" ");
            var state = pieces.pop();
            var postcode = pieces.pop();
            var suburb = pieces.join(" ");
            $("#health_situation_state").val(state);
            $("#health_situation_postcode").val(postcode).trigger("change");
            $("#health_situation_suburb").val(suburb);
            healthChoices.setState(state);
        } else if (meerkat.site.isFromBrochureSite) {
            $("#health_situation_location").val("");
        }
    },
    setState: function(state) {
        healthChoices._state = state;
    },
    setDob: function(value, $_obj) {
        if (value != "") {
            $_obj.val(value);
        }
    },
    dependants: function(initMode) {
        if (healthChoices.hasChildren() && $(".health_cover_details_rebate :checked").val() == "Y") {
            if (initMode === true) {
                $(".health_cover_details_dependants").show();
            } else {
                $(".health_cover_details_dependants").slideDown();
            }
        } else {
            if (initMode === true) {
                $(".health_cover_details_dependants").hide();
            } else {
                $("#health_healthCover_dependants option:selected").prop("selected", false);
                $("#health_healthCover_income option:selected").prop("selected", false);
                $(".health_cover_details_dependants").slideUp();
            }
        }
    },
    returnCover: function() {
        return $("#health_situation_healthCvr option:selected").text();
    },
    returnCoverCode: function() {
        return this._cover;
    },
    flushPartnerDetails: function() {
        $("#health_healthCover_partner_dob").val("").change();
        $('#partner-health-cover input[name="health_healthCover_partner_cover"]:checked').each(function() {
            $(this).checked = false;
        });
        resetRadio($("#health_healthCover_partnerCover"));
        $('#partner-health-cover input[name="health_healthCover_partner_healthCoverLoading"]:checked').each(function() {
            $(this).checked = false;
        });
        resetRadio($("#health-continuous-cover-partner"));
    },
    resetRebateForm: function() {
        $('#health_healthCover_health_cover_rebate input[name="health_healthCover_rebate"]:checked').each(function() {
            $(this).checked = false;
        });
        resetRadio($("#health_healthCover_health_cover_rebate"));
        $("#health_healthCover_dependants option").first().prop("selected", true);
        $("#health_healthCover_dependants option:selected").prop("selected", false);
        $("#health_healthCover_income option").first().prop("selected", true);
        $("#health_healthCover_income option:selected").prop("selected", false);
        $("#health_healthCover_incomelabel").val("");
        healthCoverDetails.setIncomeBase();
        healthChoices.dependants();
        meerkat.modules.healthTiers.setTiers();
        $(".health_cover_details_dependants").hide();
        $("#health_healthCover_tier").hide();
        $("#health_rebates_group").hide();
    }
};

var healthCoverDetails = {
    getRebateChoice: function() {
        return $("#health_healthCover-selection").find(".health_cover_details_rebate :checked").val();
    },
    setIncomeBase: function(initMode) {
        if ((healthChoices._cover == "S" || healthChoices._cover == "SM" || healthChoices._cover == "SF") && healthCoverDetails.getRebateChoice() == "Y") {
            if (initMode) {
                $("#health_healthCover-selection").find(".health_cover_details_incomeBasedOn").show();
            } else {
                $("#health_healthCover-selection").find(".health_cover_details_incomeBasedOn").slideDown();
            }
        } else {
            if (initMode) {
                $("#health_healthCover-selection").find(".health_cover_details_incomeBasedOn").hide();
            } else {
                $("#health_healthCover-selection").find(".health_cover_details_incomeBasedOn").slideUp();
            }
        }
    },
    displayHealthFunds: function() {
        var $_previousFund = $("#mainform").find(".health-previous_fund");
        var $_primaryFund = $("#clientFund").find("select");
        var $_partnerFund = $("#partnerFund").find("select");
        if ($_primaryFund.val() != "NONE" && $_primaryFund.val() != "") {
            $_previousFund.find("#clientMemberID").slideDown();
            $_previousFund.find(".membership").addClass("onA");
        } else {
            $_previousFund.find("#clientMemberID").slideUp();
            $_previousFund.find(".membership").removeClass("onA");
        }
        if (healthChoices.hasSpouse() && $_partnerFund.val() != "NONE" && $_partnerFund.val() != "") {
            $_previousFund.find("#partnerMemberID").slideDown();
            $_previousFund.find(".membership").addClass("onB");
        } else {
            $_previousFund.find("#partnerMemberID").slideUp();
            $_previousFund.find(".membership").removeClass("onB");
        }
    },
    setHealthFunds: function(initMode) {
        var _primary = $("#health_healthCover_primaryCover").find(":checked").val();
        var _partner = $("#health_healthCover_partnerCover").find(":checked").val();
        var $_primaryFund = $("#clientFund").find("select");
        var $_partnerFund = $("#partnerFund").find("select");
        if (_primary == "Y") {
            if (isLessThan31Or31AndBeforeJuly1($("#health_healthCover_primary_dob").val())) {
                if (initMode) {
                    $("#health-continuous-cover-primary").show();
                } else {
                    $("#health-continuous-cover-primary").slideDown();
                }
            } else {
                if (initMode) {
                    $("#health-continuous-cover-primary").hide();
                } else {
                    $("#health-continuous-cover-primary").slideUp();
                }
            }
        } else {
            if (_primary == "N") {
                resetRadio($("#health-continuous-cover-primary"), "N");
            }
            if (initMode) {
                $("#health-continuous-cover-primary").hide();
            } else {
                $("#health-continuous-cover-primary").slideUp();
            }
        }
        if (_primary == "Y" && $_primaryFund.val() == "NONE") {
            $_primaryFund.val("");
        } else if (_primary == "N") {
            $_primaryFund.val("NONE");
        }
        if (_partner == "Y") {
            if (isLessThan31Or31AndBeforeJuly1($("#health_healthCover_partner_dob").val())) {
                if (initMode) {
                    $("#health-continuous-cover-partner").show();
                } else {
                    $("#health-continuous-cover-partner").slideDown();
                }
            } else {
                if (initMode) {
                    $("#health-continuous-cover-partner").hide();
                } else {
                    $("#health-continuous-cover-partner").slideUp();
                }
            }
        } else {
            if (_partner == "N") {
                resetRadio($("#health-continuous-cover-partner"), "N");
            }
            if (initMode) {
                $("#health-continuous-cover-partner").hide();
            } else {
                $("#health-continuous-cover-partner").slideUp();
            }
        }
        if (_partner == "Y" && $_partnerFund.val() == "NONE") {
            $_partnerFund.val("");
        } else if (_partner == "N") {
            $_partnerFund.val("NONE");
        }
        healthCoverDetails.displayHealthFunds();
    },
    getAgeAsAtLastJuly1: function(dob) {
        var dob_pieces = dob.split("/");
        var year = Number(dob_pieces[2]);
        var month = Number(dob_pieces[1]) - 1;
        var day = Number(dob_pieces[0]);
        var today = new Date();
        var age = today.getFullYear() - year;
        if (6 < month || 6 == month && 1 < day) {
            age--;
        }
        return age;
    }
};

var healthFunds = {
    _fund: false,
    name: "the fund",
    countFrom: {
        TODAY: "today",
        NOCOUNT: "",
        EFFECTIVE_DATE: "effectiveDate"
    },
    minType: {
        FROM_TODAY: "today",
        FROM_EFFECTIVE_DATE: "effectiveDate"
    },
    checkIfNeedToInjectOnAmend: function(callback) {
        if ($("#health_application_provider").val().length > 0) {
            var provider = $("#health_application_provider").val(), objname = "healthFunds_" + provider;
            $(document.body).addClass("injectingFund");
            healthFunds.load(provider, function injectFundLoaded() {
                if (window[objname].processOnAmendQuote && window[objname].processOnAmendQuote === true) {
                    window[objname].set();
                    window[objname].unset();
                }
                $(document.body).removeClass("injectingFund");
                callback();
            }, false);
        } else {
            callback();
        }
    },
    load: function(fund, callback, performProcess) {
        if (fund == "" || !fund) {
            healthFunds.loadFailed("Empty or false");
            return false;
        }
        if (performProcess !== false) performProcess = true;
        if (typeof window["healthFunds_" + fund] === "undefined" || window["healthFunds_" + fund] == false) {
            var returnval = true;
            var data = {
                transactionId: meerkat.modules.transactionId.get()
            };
            $.ajax({
                url: "common/js/health/healthFunds_" + fund + ".jsp",
                dataType: "script",
                data: data,
                async: true,
                timeout: 3e4,
                cache: false,
                beforeSend: function(xhr, setting) {
                    var url = setting.url;
                    var label = "uncache";
                    url = url.replace("?_=", "?" + label + "=");
                    url = url.replace("&_=", "&" + label + "=");
                    setting.url = url;
                },
                success: function() {
                    if (performProcess) {
                        healthFunds.process(fund);
                    }
                    if (typeof callback === "function") {
                        callback(true);
                    }
                },
                error: function(obj, txt) {
                    healthFunds.loadFailed(fund, txt);
                    if (typeof callback === "function") {
                        callback(false);
                    }
                }
            });
            return false;
        }
        if (fund != healthFunds._fund && performProcess) {
            healthFunds.process(fund);
        }
        if (typeof callback === "function") {
            callback(true);
        }
        return true;
    },
    process: function(fund) {
        var O_method = window["healthFunds_" + fund];
        healthFunds.set = O_method.set;
        healthFunds.unset = O_method.unset;
        $("body").addClass(fund);
        healthFunds.set();
        healthFunds._fund = fund;
    },
    loadFailed: function(fund, errorTxt) {
        FatalErrorDialog.exec({
            message: "Unable to load the fund's application questions",
            page: "health:health_funds.tag",
            description: "healthFunds.update(). Unable to load fund questions for: " + fund,
            data: errorTxt
        });
    },
    unload: function() {
        if (healthFunds._fund !== false) {
            healthFunds.unset();
            $("body").removeClass(healthFunds._fund);
            healthFunds._fund = false;
            healthFunds.set = function() {};
            healthFunds.unset = function() {};
        }
    },
    set: function() {},
    unset: function() {},
    applicationFailed: function() {
        return false;
    },
    _memberIdRequired: function(required) {
        if (required) {
            $("#clientMemberID").find("input").rules("add", "required");
            $("#partnerMemberID").find("input").rules("add", "required");
        } else {
            $("#clientMemberID").find("input").rules("remove", "required");
            $("#partnerMemberID").find("input").rules("remove", "required");
        }
    },
    _dependants: function(message) {
        if (message !== false) {
            healthFunds.$_dependantDefinition = $("#mainform").find(".health-dependants").find(".definition");
            healthFunds.HTML_dependantDefinition = healthFunds.$_dependantDefinition.html();
            healthFunds.$_dependantDefinition.html(message);
        } else {
            healthFunds.$_dependantDefinition.html(healthFunds.HTML_dependantDefinition);
            healthFunds.$_dependantDefinition = undefined;
            healthFunds.HTML_dependantDefinition = undefined;
        }
    },
    _previousfund_authority: function(message) {
        if (message !== false) {
            healthFunds.$_authority = $(".health_previous_fund_authority label span");
            healthFunds.$_authorityText = healthFunds.$_authority.eq(0).text();
            healthFunds.$_authority.text(meerkat.modules.healthResults.getSelectedProduct().info.providerName);
            $(".health_previous_fund_authority").removeClass("hidden");
        } else if (typeof healthFunds.$_authority !== "undefined") {
            healthFunds.$_authority.text(healthFunds.$_authorityText);
            healthFunds.$_authority = undefined;
            healthFunds.$_authorityText = undefined;
            $(".health_previous_fund_authority").addClass("hidden");
        }
    },
    _partner_authority: function(display) {
        if (display === true) {
            $(".health_person-details_authority_group").removeClass("hidden");
        } else {
            $(".health_person-details_authority_group").addClass("hidden");
        }
    },
    _reset: function() {
        healthApplicationDetails.hideHowToSendInfo();
        healthFunds._partner_authority(false);
        healthFunds._memberIdRequired(true);
        healthDependents.resetConfig();
    },
    _paymentDays: function(effectiveDateString) {
        if (effectiveDateString == "") {
            return false;
        }
        var effectiveDate = returnDate(effectiveDateString);
        var today = new Date();
        var _baseDate = null;
        if (healthFunds._payments.countFrom == healthFunds.countFrom.TODAY) {
            _baseDate = today;
        } else {
            _baseDate = effectiveDate;
        }
        var _count = 0;
        var _days = 0;
        var _limit = healthFunds._payments.max;
        if (healthFunds._payments.minType == healthFunds.minType.FROM_TODAY) {
            var difference = Math.round((effectiveDate - today) / (1e3 * 60 * 60 * 24));
            if (difference < healthFunds._payments.min) {
                _days = healthFunds._payments.min - difference;
            }
        } else {
            _days = healthFunds._payments.min;
            _limit -= healthFunds._payments.min;
        }
        var _html = '<option value="">Please choose...</option>';
        var continueCounting = true;
        while (_count < _limit) {
            var _date = new Date(_baseDate.getTime() + _days * 24 * 60 * 60 * 1e3);
            var _day = _date.getDay();
            if (typeof healthFunds._payments.maxDay != "undefined" && healthFunds._payments.maxDay < _date.getDate()) {
                _days++;
            } else if (!healthFunds._payments.weekends && (_day == 0 || _day == 6)) {
                _days++;
            } else {
                var _dayString = leadingZero(_date.getDate());
                var _monthString = leadingZero(_date.getMonth() + 1);
                _html += '<option value="' + _date.getFullYear() + "-" + _monthString + "-" + _dayString + '">' + healthFunds._getNiceDate(_date) + "</option>";
                _days++;
                _count++;
            }
        }
        return _html;
    },
    _earliestDays: function(euroDate, a_Match, _exclusion) {
        if (!$.isArray(a_Match) || euroDate == "") {
            return false;
        }
        var _now = returnDate(euroDate);
        _exclusion = 7;
        var _date = new Date(_now.getTime() + _exclusion * 24 * 60 * 60 * 1e3);
        var _html = '<option value="">No date has been selected for you</option>';
        for (var i = 0; i < 31; i++) {
            _date = new Date(_date.getTime() + 1 * 24 * 60 * 60 * 1e3);
            for (a = 0; a < a_Match.length; a++) {
                if (a_Match[a] == _date.getDate()) {
                    var _dayString = leadingZero(_date.getDate());
                    var _monthString = leadingZero(_date.getMonth() + 1);
                    _html = '<option value="' + _date.getFullYear() + "-" + _monthString + "-" + _dayString + '" selected="selected">' + healthFunds._getNiceDate(_date) + "</option>";
                    i = 99;
                    break;
                }
            }
        }
        return _html;
    },
    _paymentDaysRender: function($_object, _html) {
        if (_html === false) {
            healthFunds._payments = {
                min: 0,
                max: 5,
                weekends: false
            };
            _html = '<option value="">Please choose...</option>';
        }
        $_object.html(_html);
        $_object.parent().siblings("p").text("Your payment will be deducted on: " + $_object.find("option").first().text());
        $(".health-bank_details-policyDay, .health-credit-card_details-policyDay").html(_html);
    },
    _getDayOfWeek: function(dateObj) {
        var days = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];
        return days[dateObj.getDay()];
    },
    _getMonth: function(dateObj) {
        var months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
        return months[dateObj.getMonth()];
    },
    _getNiceDate: function(dateObj) {
        var day = dateObj.getDate();
        var year = dateObj.getFullYear();
        return healthFunds._getDayOfWeek(dateObj) + ", " + day + " " + healthFunds._getMonth(dateObj) + " " + year;
    }
};

var healthApplicationDetails = {
    preloadedValue: $("#contactPointValue").val(),
    periods: 1,
    init: function() {
        postalMatchHandler.init("health_application");
    },
    showHowToSendInfo: function(providerName, required) {
        var contactPointGroup = $("#health_application_contactPoint-group");
        var contactPoint = contactPointGroup.find(".control-label span");
        var contactPointText = contactPoint.text();
        contactPoint.text(providerName);
        if (required) {
            contactPointGroup.find("input").rules("add", {
                required: true,
                messages: {
                    required: "Please choose how you would like " + providerName + " to contact you"
                }
            });
        } else {
            contactPointGroup.find("input").rules("remove", "required");
        }
        contactPointGroup.removeClass("hidden");
    },
    hideHowToSendInfo: function() {
        var contactPointGroup = $("#health_application_contactPoint-group");
        contactPointGroup.addClass("hidden");
    },
    addOption: function(labelText, formValue) {
        var el = $("#health_application_contactPoint");
        el.append('<label class="btn btn-form-inverse"><input id="health_application_contactPoint_' + formValue + '" type="radio" data-msg-required="Please choose " value="' + formValue + '" name="health_application_contactPoint">' + labelText + "</label>");
        if (el.find("input:checked").length == 0 && this.preloadedValue == formValue) {
            $("#health_application_contactPoint_" + formValue).prop("checked", true);
        }
    },
    removeLastOption: function() {
        var el = $("#health_application_contactPoint");
        el.find("label").last().remove();
    },
    testStatesParity: function() {
        var element = $("#health_application_address_state");
        if (element.val() != $("#health_situation_state").val()) {
            var suburb = $("#health_application_address_suburbName").val();
            var postcode = $("#health_application_address_postCode").val();
            var state = $("#health_application_address_state").val();
            if (suburb.length && suburb.indexOf("Please select") < 0 && postcode.length == 4 && state.length) {
                $("#health_application_address_postCode").addClass("error");
                return false;
            }
        }
        return true;
    }
};

var healthDependents = {
    _dependents: 0,
    _limit: 12,
    maxAge: 25,
    init: function() {
        healthDependents.resetConfig();
    },
    resetConfig: function() {
        healthDependents.config = {
            fulltime: false,
            school: true,
            schoolMin: 22,
            schoolMax: 24,
            schoolID: false,
            schoolIDMandatory: false,
            schoolDate: false,
            schoolDateMandatory: false,
            defacto: false,
            defactoMin: 21,
            defactoMax: 24
        };
        healthDependents.maxAge = 25;
    },
    setDependants: function() {
        var _dependants = $("#mainform").find(".health_cover_details_dependants").find("select").val();
        if (healthCoverDetails.getRebateChoice() == "Y" && !isNaN(_dependants)) {
            healthDependents._dependents = _dependants;
        } else {
            healthDependents._dependents = 1;
        }
        if (healthChoices.hasChildren()) {
            $("#health_application_dependants-selection").show();
        } else {
            $("#health_application_dependants-selection").hide();
            return;
        }
        healthDependents.updateDependentOptionsDOM();
        $("#health_application_dependants-selection").find(".health_dependant_details").each(function() {
            var index = parseInt($(this).attr("data-id"));
            if (index > healthDependents._dependents) {
                $(this).hide();
            } else {
                $(this).show();
            }
            healthDependents.checkDependent(index);
        });
    },
    addDependent: function() {
        if (healthDependents._dependents < healthDependents._limit) {
            healthDependents._dependents++;
            var $_obj = $("#health_application_dependants_dependant" + healthDependents._dependents);
            $_obj.find("input[type=text], select").val("");
            resetRadio($_obj.find(".health_dependant_details_maritalincomestatus"), "");
            $_obj.find(".error-field label").remove();
            $_obj.find(".has-error, .has-success").removeClass("has-error").removeClass("has-success");
            $_obj.show();
            healthDependents.updateDependentOptionsDOM();
            healthDependents.hasChanged();
            $("html").animate({
                scrollTop: $_obj.offset().top - 50
            }, 250);
        }
    },
    dropDependent: function() {
        if (healthDependents._dependents > 0) {
            $("#health_application_dependants_dependant" + healthDependents._dependents).find("input[type=text]").each(function() {
                $(this).val("");
            });
            $("#health_application_dependants_dependant" + healthDependents._dependents).find("input[type=radio]:checked").each(function() {
                this.checked = false;
            });
            $("#health_application_dependants_dependant" + healthDependents._dependents).find("select").each(function() {
                $(this).removeAttr("selected");
            });
            $("#health_application_dependants_dependant" + healthDependents._dependents).hide();
            healthDependents._dependents--;
            healthDependents.updateDependentOptionsDOM();
            healthDependents.hasChanged();
            if (healthDependents._dependents > 0) {
                $_obj = $("#health_application_dependants_dependant" + healthDependents._dependents);
            } else {
                $_obj = $("#health_application_dependants-selection");
            }
            $("html").animate({
                scrollTop: $_obj.offset().top - 50
            }, 250);
        }
    },
    updateDependentOptionsDOM: function() {
        if (healthDependents._dependents <= 0) {
            $("#health_application_dependants-selection").find(".remove-last-dependent").hide();
            $("#health_application_dependants_threshold").slideDown();
        } else if (!$("#dependents_list_options").find(".remove-last-dependent").is(":visible")) {
            $("#health_application_dependants_threshold").slideUp();
            $("#health_application_dependants-selection").find(".remove-last-dependent").hide();
            $("#health_application_dependants-selection .health_dependant_details:visible:last").find(".remove-last-dependent").show();
        }
        if (healthDependents._dependents >= healthDependents._limit) {
            $("#health-dependants").find(".add-new-dependent").hide();
        } else if ($("#health-dependants").find(".add-new-dependent").not(":visible")) {
            $("#health-dependants").find(".add-new-dependent").show();
        }
    },
    checkDependent: function(e) {
        var index = e;
        if (isNaN(e) && typeof e == "object") {
            index = e.data;
        }
        var dob = $("#health_application_dependants_dependant" + index + "_dob").val();
        var age;
        if (!dob.length) {
            age = 0;
        } else {
            age = healthDependents.getAge(dob);
            if (isNaN(age)) {
                return false;
            }
        }
        healthDependents.addFulltime(index, age);
        healthDependents.addSchool(index, age);
        healthDependents.addDefacto(index, age);
    },
    getAge: function(dob) {
        var dob_pieces = dob.split("/");
        var year = Number(dob_pieces[2]);
        var month = Number(dob_pieces[1]) - 1;
        var day = Number(dob_pieces[0]);
        var today = new Date();
        var age = today.getFullYear() - year;
        if (today.getMonth() < month || today.getMonth() == month && today.getDate() < day) {
            age--;
        }
        return age;
    },
    addFulltime: function(index, age) {
        if (healthDependents.config.fulltime !== true) {
            $("#health_application_dependants-selection").find(".health_dependant_details_fulltimeGroup").hide();
            $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_dob").rules("remove", "validateFulltime");
            $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_dob").rules("add", "limitDependentAgeToUnder25");
            return false;
        }
        if (age >= healthDependents.config.schoolMin && age <= healthDependents.config.schoolMax) {
            $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_fulltimeGroup").show();
        } else {
            $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_fulltimeGroup").hide();
        }
        $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_dob").rules("remove", "limitDependentAgeToUnder25");
        $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_dob").rules("add", "validateFulltime");
    },
    addSchool: function(index, age) {
        if (healthDependents.config.school === false) {
            $("#health_application_dependants-selection").find(".health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup").hide();
            return false;
        }
        if (age >= healthDependents.config.schoolMin && age <= healthDependents.config.schoolMax && (healthDependents.config.fulltime !== true || $("#health_application_dependants_dependant" + index + "_fulltime_Y").is(":checked"))) {
            $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup").show();
            if (healthDependents.config.schoolID === false) {
                $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_schoolIDGroup").hide();
            } else {
                if (this.config.schoolIDMandatory === true) {
                    $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_schoolID").rules("add", {
                        required: true,
                        messages: {
                            required: "Please enter dependant " + index + "'s student ID"
                        }
                    });
                } else {
                    $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_schoolID").rules("remove", "required");
                }
            }
            if (this.config.schoolDate !== true) {
                $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_schoolDateGroup").hide();
            } else {
                if (this.config.schoolDateMandatory === true) {
                    $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_schoolDate").rules("add", {
                        required: true,
                        messages: {
                            required: "Please enter date that dependant " + index + " commenced study"
                        }
                    });
                } else {
                    $("#health_application_dependants-selection").find("#health_application_dependants_dependant" + index + "_schoolDate").rules("remove", "required");
                }
            }
        } else {
            $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup").hide();
        }
    },
    addDefacto: function(index, age) {
        if (healthDependents.config.defacto === false) {
            return false;
        }
        if (age >= healthDependents.config.defactoMin && age <= healthDependents.config.defactoMax) {
            $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_maritalincomestatus").show();
        } else {
            $("#health_application_dependants-selection").find(".dependant" + index).find(".health_dependant_details_maritalincomestatus").hide();
        }
    },
    hasChanged: function() {
        var $_obj = $("#health_application_dependants-selection").find(".health-dependants-tier");
        if (healthCoverDetails.getRebateChoice() == "N") {
            $_obj.slideUp();
        } else if (healthDependents._dependents > 0) {
            $("#health_healthCover_dependants").val(healthDependents._dependents).trigger("change");
            var $_original = $("#health_healthCover_tier");
            $_obj.find("select").html($_original.find("select").html());
            $_obj.find("#health_application_dependants_incomeMessage").text($_original.find("span").text());
            if ($_obj.is(":hidden")) {
                $_obj.slideDown();
            }
        } else {
            $_obj.slideUp();
        }
    }
};

$.validator.addMethod("defactoConfirmation", function(value, element) {
    if ($(element).parent().find(":checked").val() == "Y") {
        return true;
    } else {
        return false;
    }
});

$.validator.addMethod("validateMinDependants", function(value, element) {
    return !$("#${name}_threshold").is(":visible");
});

$.validator.addMethod("limitDependentAgeToUnder25", function(value, element) {
    var getAge = returnAge(value);
    if (getAge >= healthDependents.maxAge) {
        $(element).rules("add", {
            messages: {
                limitDependentAgeToUnder25: "Your child cannot be added to the policy as they are aged " + healthDependents.maxAge + " years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance."
            }
        });
        return false;
    }
    return true;
});

$.validator.addMethod("validateFulltime", function(value, element) {
    var fullTime = $(element).parents(".health_dependant_details").find(".health_dependant_details_fulltimeGroup input[type=radio]:checked").val();
    var getAge = returnAge(value);
    var suffix = healthDependents.config.schoolMin == 21 ? "st" : healthDependents.config.schoolMin == 22 ? "nd" : healthDependents.config.schoolMin == 23 ? "rd" : "th";
    if (getAge >= healthDependents.maxAge) {
        $(element).rules("add", {
            messages: {
                validateFulltime: "Dependants over " + healthDependents.maxAge + " are considered adult dependants and can still be covered by applying for a separate singles policy"
            }
        });
        return false;
    } else if (fullTime === "N" && getAge >= healthDependents.config.schoolMin) {
        $(element).rules("add", {
            messages: {
                validateFulltime: "This policy provides cover for children until their " + healthDependents.config.schoolMin + suffix + " birthday"
            }
        });
        return false;
    }
    return true;
});

creditCardDetails = {
    resetConfig: function() {
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: true,
            diners: false
        };
    },
    render: function() {
        var $_obj = $("#health_payment_credit_type");
        var $_icons = $("#health_payment_credit-selection .cards");
        $_icons.children().hide();
        var _html = '<option id="health_payment_credit_type_" value="">Please choose...</option>';
        var _selected = $_obj.find(":selected").val();
        if (creditCardDetails.config.visa === true) {
            _html += '<option id="health_payment_credit_type_v" value="v">Visa</option>';
            $_icons.find(".visa").show();
        }
        if (creditCardDetails.config.mc === true) {
            _html += '<option id="health_payment_credit_type_m" value="m">Mastercard</option>';
            $_icons.find(".mastercard").show();
        }
        if (creditCardDetails.config.amex === true) {
            _html += '<option id="health_payment_credit_type_a" value="a">AMEX</option>';
            $_icons.find(".amex").show();
        }
        if (creditCardDetails.config.diners === true) {
            _html += '<option id="health_payment_credit_type_d" value="d">Diners Club</option>';
            $_icons.find(".diners").show();
        }
        $_obj.html(_html).find("option[value=" + _selected + "]").attr("selected", "selected");
        return;
    },
    set: function() {
        creditCardDetails.$_obj = $("#health_payment_credit_number");
        creditCardDetails.$_objCCV = $("#health_payment_credit_ccv");
        var _type = creditCardDetails._getType();
        field_credit_card_validation.set(_type, creditCardDetails.$_obj, creditCardDetails.$_objCCV);
    },
    _getType: function() {
        return $("#health_payment_credit_type").find(":selected").val();
    }
};

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, moduleEvents = {
        health: {
            CHANGE_MAY_AFFECT_PREMIUM: "CHANGE_MAY_AFFECT_PREMIUM"
        },
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, hasSeenResultsScreen = false, rates = null, steps = null, stateSubmitInProgress = false;
    function initJourneyEngine() {
        if (meerkat.site.pageAction === "confirmation") {
            meerkat.modules.journeyEngine.configure(null);
        } else {
            initProgressBar(false);
            var startStepId = null;
            if (meerkat.site.isFromBrochureSite === true) {
                startStepId = steps.detailsStep.navigationId;
            } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === "amend") {
                if (meerkat.site.journeyStage === "apply" || meerkat.site.journeyStage === "payment") {
                    startStepId = "results";
                } else {
                    startStepId = meerkat.site.journeyStage;
                }
            }
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
            var transaction_id = meerkat.modules.transactionId.get();
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackQuoteEvent",
                object: {
                    action: "Start",
                    transactionID: parseInt(transaction_id, 10),
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });
            if (meerkat.site.isNewQuote === false) {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Retrieve",
                        transactionID: transaction_id,
                        simplesUser: meerkat.site.isCallCentreUser
                    }
                });
            }
        }
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockHealth(obj) {
            var isSameSource = typeof obj !== "undefined" && obj.source && obj.source === "submitApplication";
            disableSubmitApplication(isSameSource);
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockHealth(obj) {
            enableSubmitApplication();
        });
        $("#health_application-selection").delegate(".changeStateAndQuote", "click", changeStateAndQuote);
    }
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }
    function setJourneyEngineSteps() {
        var startStep = {
            title: "Your Details",
            navigationId: "start",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                $(".health-situation-healthCvr").on("change", function() {
                    healthChoices.setCover($(this).val());
                });
                $(".health-situation-location").on("change", function() {
                    healthChoices.setLocation($(this).val());
                });
                if ($("#health_situation_location").val() !== "") {
                    healthChoices.setLocation($("#health_situation_location").val());
                }
                if ($("#health_privacyoptin").val() === "Y") {
                    $(".slide-feature-emailquote").addClass("privacyOptinChecked");
                }
                if (meerkat.site.pageAction !== "amend" && meerkat.site.pageAction !== "start-again" && meerkat.modules.healthBenefits.getSelectedBenefits().length === 0) {
                    if ($(".health-situation-healthSitu").val() !== "") {
                        $(".health-situation-healthSitu").change();
                    }
                }
                var emailQuoteBtn = $(".slide-feature-emailquote");
                $(".health-contact-details-optin-group .checkbox").on("click", function(event) {
                    var $this = $("#health_privacyoptin");
                    if ($this.val() === "Y") {
                        emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });
                if (meerkat.site.isCallCentreUser === true) {
                    toggleInboundOutbound();
                    toggleDialogueInChatCallback();
                    $("input[name=health_simples_contactType]").on("change", function() {
                        toggleInboundOutbound();
                    });
                    $(".follow-up-call input:checkbox, .simples-privacycheck-statement input:checkbox").on("change", function() {
                        toggleDialogueInChatCallback();
                    });
                }
            }
        };
        var detailsStep = {
            title: "Your Details",
            navigationId: "details",
            slideIndex: 1,
            tracking: {
                touchType: "H",
                touchComment: "HLT detail",
                includeFormData: true
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function onDetailsInit(event) {
                healthCoverDetails.setHealthFunds(true);
                healthCoverDetails.setIncomeBase(true);
                $("#health_healthCover_dependants").on("change", function() {
                    meerkat.modules.healthTiers.setTiers();
                });
                $("#health_healthCover-selection").find(".health_cover_details_rebate").on("change", function() {
                    healthCoverDetails.setIncomeBase();
                    healthChoices.dependants();
                    meerkat.modules.healthTiers.setTiers();
                });
                if (meerkat.site.isCallCentreUser === true) {
                    $("#health_healthCover_incomeBase").find("input").on("change", function() {
                        $("#health_healthCover_income").prop("selectedIndex", 0);
                        meerkat.modules.healthTiers.setTiers();
                    });
                }
                $("#health_healthCover-selection").find(":input").on("change", function(event) {
                    var $this = $(this);
                    if ($this.hasClass("dateinput-day") || $this.hasClass("dateinput-month") || $this.hasClass("dateinput-year")) return;
                    healthCoverDetails.setHealthFunds();
                    if (meerkat.site.isCallCentreUser === true) {
                        loadRates(function(rates) {
                            $(".health_cover_details_rebate .fieldrow_legend").html("Overall LHC " + rates.loading + "%");
                            if (hasPartner()) {
                                $("#health_healthCover_primaryCover .fieldrow_legend").html("Individual LHC " + rates.primaryLoading + "%, overall  LHC " + rates.loading + "%");
                                $("#health_healthCover_partnerCover .fieldrow_legend").html("Individual LHC " + rates.partnerLoading + "%, overall  LHC " + rates.loading + "%");
                            } else {
                                $("#health_healthCover_primaryCover .fieldrow_legend").html("Overall  LHC " + rates.loading + "%");
                            }
                            meerkat.modules.healthTiers.setTiers();
                        });
                    }
                });
                if (meerkat.site.isCallCentreUser === true) {
                    toggleRebateDialogue();
                    $("input[name=health_healthCover_rebate]").on("change", function() {
                        toggleRebateDialogue();
                    });
                }
            },
            onBeforeLeave: function(event) {
                var incomelabel = $("#health_healthCover_income :selected").val().length > 0 ? $("#health_healthCover_income :selected").text() : "";
                $("#health_healthCover_incomelabel").val(incomelabel);
            }
        };
        var benefitsStep = {
            title: "Your Cover",
            navigationId: "benefits",
            slideIndex: 2,
            slideScrollTo: "#navbar-main",
            tracking: {
                touchType: "H",
                touchComment: "HLT benefi",
                includeFormData: true
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            validation: {
                validate: false
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.healthResults.initPage();
            },
            onBeforeEnter: function enterBenefitsStep(event) {
                meerkat.modules.healthBenefits.close();
                meerkat.modules.navMenu.disable();
            },
            onAfterEnter: function(event) {
                if (meerkat.modules.deviceMediaState.get() === "xs") {
                    meerkat.modules.utils.scrollPageTo("html", 0, 1);
                }
                if (meerkat.site.isCallCentreUser === true) {
                    $("#journeyEngineSlidesContainer .journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find(".simples-dialogue").hide();
                }
                if (event.isStartMode === false) {
                    _.defer(function() {
                        meerkat.modules.healthBenefits.open("journey-mode");
                    });
                }
                _.delay(function() {
                    meerkat.modules.healthSegment.filterSegments();
                }, 1e3);
            },
            onAfterLeave: function(event) {
                var selectedBenefits = meerkat.modules.healthBenefits.getSelectedBenefits();
                meerkat.modules.healthResults.onBenefitsSelectionChange(selectedBenefits);
                meerkat.modules.navMenu.enable();
            }
        };
        var contactStep = {
            title: "Your Contact Details",
            navigationId: "contact",
            slideIndex: 2,
            tracking: {
                touchType: "H",
                touchComment: "HLT contac",
                includeFormData: true
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            validation: {
                validate: true
            },
            onInitialise: function onContactInit(event) {},
            onBeforeEnter: function enterContactStep(event) {},
            onAfterEnter: function enteredContactStep(event) {
                meerkat.modules.navMenu.enable();
            },
            onAfterLeave: function leaveContactStep(event) {
                meerkat.messaging.publish(meerkat.modules.tracking.events.tracking.TOUCH, this);
            }
        };
        var resultsStep = {
            title: "Your Results",
            navigationId: "results",
            slideIndex: meerkat.modules.splitTest.isActive(99) ? 3 : 2,
            validation: {
                validate: false,
                customValidation: function validateSelection(callback) {
                    if (meerkat.site.isCallCentreUser === true) {
                        var $_exacts = $(".resultsSlide").find(".simples-dialogue.mandatory:visible");
                        if ($_exacts.length != $_exacts.find("input:checked").length) {
                            meerkat.modules.dialogs.show({
                                htmlContent: "Please complete the mandatory dialogue prompts before applying."
                            });
                            callback(false);
                        }
                    }
                    if (meerkat.modules.healthResults.getSelectedProduct() === null) {
                        callback(false);
                    }
                    callback(true);
                }
            },
            onInitialise: function onInitResults(event) {
                meerkat.modules.healthMoreInfo.initMoreInfo();
            },
            onBeforeEnter: function enterResultsStep(event) {
                if (event.isForward && meerkat.site.isCallCentreUser) {
                    $("#journeyEngineSlidesContainer .journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find(".simples-dialogue").show();
                } else {
                    meerkat.modules.healthResults.resetSelectedProduct();
                }
                if (event.isForward && meerkat.site.isCallCentreUser) {
                    $("#journeyEngineSlidesContainer .journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find(".simples-dialogue").show();
                }
            },
            onAfterEnter: function(event) {
                if (event.isBackward === true) {
                    meerkat.modules.healthResults.onReturnToPage();
                }
                if (event.isForward === true) {
                    meerkat.modules.healthResults.get();
                }
                meerkat.modules.resultsHeaderBar.registerEventListeners();
            },
            onAfterLeave: function(event) {
                meerkat.modules.healthResults.stopColumnWidthTracking();
                meerkat.modules.healthResults.recordPreviousBreakpoint();
                meerkat.modules.healthResults.toggleMarketingMessage(false);
                meerkat.modules.healthResults.toggleResultsLowNumberMessage(false);
                meerkat.modules.healthMoreInfo.close();
                meerkat.modules.resultsHeaderBar.removeEventListeners();
            }
        };
        var applyStep = {
            title: "Your Application",
            navigationId: "apply",
            slideIndex: meerkat.modules.splitTest.isActive(99) ? 4 : 3,
            tracking: {
                touchType: "A"
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function onInitApplyStep(event) {
                healthApplicationDetails.init();
                $(".changes-premium :input").on("change", function(event) {
                    meerkat.messaging.publish(moduleEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
                });
                $("#health_previousfund_primary_fundName, #health_previousfund_partner_fundName").on("change", function() {
                    healthCoverDetails.displayHealthFunds();
                });
                if (meerkat.site.isCallCentreUser === true) {
                    if ($("#health_previousfund_primary_fundName").val() !== "" && $("#health_previousfund_primary_fundName").val() != "NONE" || $("#health_previousfund_partner_fundName").val() !== "" && $("#health_previousfund_partner_fundName").val() !== "NONE") {
                        $(".simples-dialogue-15").first().show();
                    } else {
                        $(".simples-dialogue-15").first().hide();
                    }
                    $("#health_previousfund_primary_fundName, #health_previousfund_partner_fundName").on("change", function() {
                        if ($(this).val() !== "" && $(this).val() !== "NONE") {
                            $(".simples-dialogue-15").first().show();
                        } else if (($("#health_previousfund_primary_fundName").val() === "" || $("#health_previousfund_primary_fundName").val() == "NONE") && ($("#health_previousfund_partner_fundName").val() === "" || $("#health_previousfund_partner_fundName").val() === "NONE")) {
                            $(".simples-dialogue-15").first().hide();
                        }
                    });
                }
                $("#health_application_address_postCode, #health_application_address_streetSearch, #health_application_address_suburb").on("change", function() {
                    healthApplicationDetails.testStatesParity();
                });
                $("#health_application_dependants_income").on("change", function() {
                    $("#mainform").find(".health_cover_details_income").val($(this).val());
                });
                $(".health_dependant_details .dateinput_container input.serialise").on("change", function(event) {
                    healthDependents.checkDependent($(this).closest(".health_dependant_details").attr("data-id"));
                    $(this).valid();
                });
                $(".health_dependant_details_fulltimeGroup input").on("change", function(event) {
                    healthDependents.checkDependent($(this).closest(".health_dependant_details").attr("data-id"));
                    $(this).parents(".health_dependant_details").find(".dateinput_container input.serialise").valid();
                });
                $("#health_application_dependants-selection").find(".remove-last-dependent").on("click", function() {
                    healthDependents.dropDependent();
                });
                $("#health_application_dependants-selection").find(".add-new-dependent").on("click", function() {
                    healthDependents.addDependent();
                });
                $("#health_payment_details_start_calendar").datepicker({
                    clearBtn: false,
                    format: "dd/mm/yyyy"
                }).on("changeDate", function updateStartCoverDateHiddenField(e) {
                    $("#health_payment_details_start").val(e.format());
                    meerkat.messaging.publish(moduleEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
                });
            },
            onBeforeEnter: function enterApplyStep(event) {
                if (event.isForward === true) {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
                    if (typeof selectedProduct.warningAlert !== "undefined" && selectedProduct.warningAlert !== "") {
                        $("#health_application-warning").find(".fundWarning").show().html(selectedProduct.warningAlert);
                    } else {
                        $("#health_application-warning").find(".fundWarning").hide().empty();
                    }
                    this.tracking.touchComment = selectedProduct.info.provider + " " + selectedProduct.info.des;
                    this.tracking.productId = selectedProduct.info.productCode;
                    healthFunds.load(selectedProduct.info.provider);
                    var $slide = $("#journeyEngineSlidesContainer .journeyEngineSlide").slice(meerkat.modules.journeyEngine.getCurrentStepIndex() - 1);
                    $slide.find(".error-field").remove();
                    $slide.find(".has-error").removeClass("has-error");
                    $("#health_declaration input:checked").prop("checked", false).change();
                    healthDependents.setDependants();
                    if ($("#health_contactDetails_contactNumber_mobile").val() === "" && $("#health_contactDetails_contactNumber_other").val() === "" && meerkat.site.isCallCentreUser === false) {
                        $("#health_application_okToCall-group").show();
                    }
                    var min = meerkat.modules.healthPaymentStep.getSetting("minStartDate");
                    var max = meerkat.modules.healthPaymentStep.getSetting("maxStartDate");
                    $("#health_payment_details_start_calendar").datepicker("setStartDate", min).datepicker("setEndDate", max);
                }
            },
            onAfterEnter: function afterEnterApplyStep(event) {
                healthDependents.updateDependentOptionsDOM();
            }
        };
        var paymentStep = {
            title: "Your Payment",
            navigationId: "payment",
            slideIndex: meerkat.modules.splitTest.isActive(99) ? 5 : 4,
            tracking: {
                touchType: "H",
                touchComment: "HLT paymnt",
                includeFormData: true
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function initPaymentStep(event) {
                $("#joinDeclarationDialog_link").on("click", function() {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
                    meerkat.modules.dialogs.show({
                        title: "Declaration",
                        url: "health_fund_info/" + selectedProduct.info.provider.toUpperCase() + "/declaration.html"
                    });
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackOfferTerms",
                        object: {
                            productID: selectedProduct.productId
                        }
                    });
                });
                $("#submit_btn").on("click", function(event) {
                    var valid = meerkat.modules.journeyEngine.isCurrentStepValid();
                    if (meerkat.site.isCallCentreUser === true) {
                        $(".agg_privacy").each(function() {
                            var $this = $(this);
                            $this.find(".error-count").remove();
                            var $errors = $this.find(".error-field label");
                            $this.children("button").after('<span class="error-count' + ($errors.length > 0 ? " error-field" : "") + '" style="margin-left:10px">' + $errors.length + " validation errors in this panel.</span>");
                        });
                    }
                    if (valid) {
                        submitApplication();
                    }
                });
            },
            onBeforeEnter: function enterPaymentStep(event) {
                if (event.isForward === true) {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
                    if (typeof selectedProduct.promo.discountText !== "undefined" && selectedProduct.promo.discountText !== "") {
                        $("#health_payment_details-selection").find(".definition").show().html(selectedProduct.promo.discountText);
                    } else {
                        $("#health_payment_details-selection").find(".definition").hide().empty();
                    }
                    if (typeof selectedProduct.warningAlert !== "undefined" && selectedProduct.warningAlert !== "") {
                        $("#health_payment_details-selection").find(".fundWarning").show().html(selectedProduct.warningAlert);
                    } else {
                        $("#health_payment_details-selection").find(".fundWarning").hide().empty();
                    }
                    $("#mainform").find(".health_declaration span").text(selectedProduct.info.providerName);
                    var $firstnameField = $("#health_payment_medicare_firstName");
                    var $surnameField = $("#health_payment_medicare_surname");
                    if ($firstnameField.val() === "") $firstnameField.val($("#health_application_primary_firstname").val());
                    if ($surnameField.val() === "") $surnameField.val($("#health_application_primary_surname").val());
                    var product = meerkat.modules.healthResults.getSelectedProduct();
                    var mustShowList = [ "GMHBA", "Frank", "Budget Direct", "Bupa", "HIF" ];
                    if ($("input[name=health_healthCover_rebate]:checked").val() == "N" && $.inArray(product.info.providerName, mustShowList) == -1) {
                        $("#health_payment_medicare-selection").hide().attr("style", "display:none !important");
                    } else {
                        $("#health_payment_medicare-selection").removeAttr("style");
                    }
                }
            }
        };
        steps = {
            startStep: startStep,
            detailsStep: detailsStep,
            benefitsStep: benefitsStep,
            resultsStep: resultsStep,
            applyStep: applyStep,
            paymentStep: paymentStep
        };
        if (meerkat.modules.splitTest.isActive(99)) {
            steps.contactStep = contactStep;
        }
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Your Details",
            navigationId: steps.startStep.navigationId,
            matchAdditionalSteps: [ steps.detailsStep.navigationId ]
        }, {
            label: "Your Cover",
            navigationId: steps.benefitsStep.navigationId
        }, {
            label: "Your Results",
            navigationId: steps.resultsStep.navigationId
        }, {
            label: "Your Application",
            navigationId: steps.applyStep.navigationId
        }, {
            label: "Your Payment",
            navigationId: steps.paymentStep.navigationId
        } ]);
        if (meerkat.modules.splitTest.isActive(99)) {
            meerkat.modules.journeyProgressBar.addAdditionalStep("Your Cover", steps.contactStep.navigationId);
        }
    }
    function configureContactDetails() {
        var contactDetailsOptinField = $("#health_contactDetails_optin");
        var contactDetailsFields = {
            name: [ {
                $field: $("#health_contactDetails_name")
            }, {
                $field: $("#health_application_primary_firstname"),
                $otherField: $("#health_application_primary_surname")
            } ],
            dob_primary: [ {
                $field: $("#health_healthCover_primary_dob"),
                $fieldInput: $("#health_healthCover_primary_dob")
            }, {
                $field: $("#health_application_primary_dob"),
                $fieldInput: $("#health_application_primary_dob")
            } ],
            dob_secondary: [ {
                $field: $("#health_healthCover_partner_dob"),
                $fieldInput: $("#health_healthCover_partner_dob")
            }, {
                $field: $("#health_application_partner_dob"),
                $fieldInput: $("#health_application_partner_dob")
            } ],
            email: [ {
                $field: $("#health_contactDetails_email"),
                $optInField: contactDetailsOptinField
            }, {
                $field: $("#health_application_email"),
                $optInField: $("#health_application_optInEmail")
            } ],
            mobile: [ {
                $field: $("#health_contactDetails_contactNumber_mobile"),
                $fieldInput: $("#health_contactDetails_contactNumber_mobileinput"),
                $optInField: contactDetailsOptinField
            }, {
                $field: $("#health_application_mobile"),
                $fieldInput: $("#health_application_mobileinput")
            } ],
            otherPhone: [ {
                $field: $("#health_contactDetails_contactNumber_other"),
                $fieldInput: $("#health_contactDetails_contactNumber_otherinput"),
                $optInField: contactDetailsOptinField
            }, {
                $field: $("#health_application_other"),
                $fieldInput: $("#health_application_otherinput")
            } ],
            postcode: [ {
                $field: $("#health_situation_postcode")
            }, {
                $field: $("#health_application_address_postCode"),
                $fieldInput: $("#health_application_address_postCode")
            } ]
        };
        meerkat.modules.contactDetails.configure(contactDetailsFields);
    }
    function hasPartner() {
        var cover = $(':input[name="health_situation_healthCvr"]').val();
        if (cover == "F" || cover == "C") {
            return true;
        } else {
            return false;
        }
    }
    function getRates() {
        return rates;
    }
    function getRebate() {
        if (rates != null && rates.rebate) {
            return rates.rebate;
        } else {
            return 0;
        }
    }
    function setRates(ratesObject) {
        rates = ratesObject;
        $("#health_rebate").val(rates.rebate || "");
        $("#health_rebateChangeover").val(rates.rebateChangeover || "");
        $("#health_loading").val(rates.loading || "");
        $("#health_primaryCAE").val(rates.primaryCAE || "");
        $("#health_partnerCAE").val(rates.partnerCAE || "");
        meerkat.modules.healthResults.setLhcApplicable(rates.loading);
    }
    function loadRates(callback) {
        $healthCoverDetails = $(".health-cover_details");
        var postData = {
            dependants: $healthCoverDetails.find(':input[name="health_healthCover_dependants"]').val(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val(),
            rebate_choice: $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: $healthCoverDetails.find('input[name="health_healthCover_primary_cover"]:checked').val(),
            primary_loading_manual: $healthCoverDetails.find(".primary-lhc").val(),
            partner_loading: $healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
            partner_current: $healthCoverDetails.find('input[name="health_healthCover_partner_cover"]:checked').val(),
            partner_loading_manual: $healthCoverDetails.find(".partner-lhc").val(),
            cover: $(':input[name="health_situation_healthCvr"]').val()
        };
        if ($("#health_application_provider, #health_application_productId").val() === "") {
            postData.primary_dob = $healthCoverDetails.find('input[name="health_healthCover_primary_dob"]').val();
            postData.partner_dob = $healthCoverDetails.find('input[name="health_healthCover_partner_dob"]').val();
        } else {
            postData.primary_dob = $("#health_application_primary_dob").val();
            postData.partner_dob = $("#health_application_partner_dob").val();
            postData.primary_current = $("#clientFund").find(":selected").val() == "NONE" ? "N" : "Y";
            postData.partner_current = $("#partnerFund").find(":selected").val() == "NONE" ? "N" : "Y";
        }
        var coverTypeHasPartner = hasPartner();
        if (postData.cover === "") return false;
        if (postData.rebate_choice === "") return false;
        if (postData.primary_dob === "") return false;
        if (coverTypeHasPartner && postData.partner_dob === "") return false;
        if (returnAge(postData.primary_dob) < 0) return false;
        if (coverTypeHasPartner && returnAge(postData.partner_dob) < 0) return false;
        if (postData.rebate_choice === "Y" && postData.income === "") return false;
        var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
        if (!postData.primary_dob.match(dateRegex)) return false;
        if (coverTypeHasPartner && !postData.partner_dob.match(dateRegex)) return false;
        meerkat.modules.comms.post({
            url: "ajax/json/health_rebate.jsp",
            data: postData,
            cache: true,
            errorLevel: "warning",
            onSuccess: function onRatesSuccess(data) {
                setRates(data);
                if (callback != null) callback(data);
            }
        });
    }
    function changeStateAndQuote(event) {
        event.preventDefault();
        var suburb = $("#health_application_address_suburbName").val();
        var postcode = $("#health_application_address_postCode").val();
        var state = $("#health_application_address_state").val();
        $("#health_situation_location").val([ suburb, postcode, state ].join(" "));
        $("#health_situation_suburb").val(suburb);
        $("#health_situation_postcode").val(postcode);
        $("#health_situation_state").val(state);
        healthChoices.setState(state);
        window.location = this.href;
        var handler = meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function changeStateAndQuoteStep(step) {
            meerkat.messaging.unsubscribe(meerkatEvents.journeyEngine.STEP_CHANGED, handler);
            meerkat.modules.healthResults.get();
        });
    }
    function getTrackingFieldsObject() {
        try {
            var state = $("#health_situation_state").val();
            var state2 = $("#health_application_address_state").val();
            if (state2.length && state2 != state) {
                state = state2;
            }
            var gender = null;
            var $gender = $("input[name=health_application_primary_gender]:checked");
            if ($gender) {
                if ($gender.val() == "M") {
                    gender = "Male";
                } else if ($gender.val() == "F") {
                    gender = "Female";
                }
            }
            var yob = "";
            var yob_str = $("#health_healthCover_primary_dob").val();
            if (yob_str.length) {
                yob = yob_str.split("/")[2];
            }
            var ok_to_call = $("input[name=health_contactDetails_call]", "#mainform").val() === "Y" ? "Y" : "N";
            var mkt_opt_in = $("input[name=health_application_optInEmail]:checked", "#mainform").val() === "Y" ? "Y" : "N";
            var email = $("#health_contactDetails_email").val();
            var email2 = $("#health_application_email").val();
            if (email2.length > 0) {
                email = email2;
            }
            var transactionId = meerkat.modules.transactionId.get();
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var actionStep = "";
            if (meerkat.modules.splitTest.isActive(99)) {
                switch (current_step) {
                  case 0:
                    actionStep = "health situation";
                    break;

                  case 1:
                    actionStep = "health details";
                    break;

                  case 2:
                    actionStep = "health cover";
                    break;

                  case 3:
                    actionStep = "health cover contact";
                    break;

                  case 5:
                    actionStep = "health application";
                    break;

                  case 6:
                    actionStep = "health payment";
                    break;

                  case 7:
                    actionStep = "health confirmation";
                    break;
                }
            } else {
                switch (current_step) {
                  case 0:
                    actionStep = "health situation";
                    break;

                  case 1:
                    actionStep = "health details";
                    break;

                  case 2:
                    actionStep = "health cover";
                    break;

                  case 4:
                    actionStep = "health application";
                    break;

                  case 5:
                    actionStep = "health payment";
                    break;

                  case 6:
                    actionStep = "health confirmation";
                    break;
                }
            }
            var response = {
                vertical: "Health",
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                postCode: null,
                state: null,
                healthCoverType: null,
                healthSituation: null,
                gender: null,
                yearOfBirth: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null,
                simplesUser: meerkat.site.isCallCentreUser
            };
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                $.extend(response, {
                    postCode: $("#health_application_address_postCode").val(),
                    state: state,
                    healthCoverType: $("#health_situation_healthCvr").val(),
                    healthSituation: $("#health_situation_healthSitu").val()
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("details")) {
                $.extend(response, {
                    yearOfBirth: yob,
                    email: email,
                    marketOptIn: mkt_opt_in,
                    okToCall: ok_to_call
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("apply")) {
                $.extend(response, {
                    gender: gender
                });
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    function enableSubmitApplication() {
        var $button = $("#submit_btn");
        $button.removeClass("disabled");
        meerkat.modules.loadingAnimation.hide($button);
    }
    function disableSubmitApplication(isSameSource) {
        var $button = $("#submit_btn");
        $button.addClass("disabled");
        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($button);
        }
    }
    function submitApplication() {
        if (stateSubmitInProgress === true) {
            alert("Your application is still being submitted. Please wait.");
            return;
        }
        stateSubmitInProgress = true;
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
            source: "submitApplication"
        });
        try {
            var postData = meerkat.modules.journeyEngine.getFormData();
            meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
                source: "submitApplication",
                disableFields: true
            });
            meerkat.modules.comms.post({
                url: "ajax/json/health_application.jsp",
                data: postData,
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "silent",
                timeout: 25e4,
                onSuccess: function onSubmitSuccess(resultData) {
                    meerkat.modules.leavePageWarning.disable();
                    var redirectURL = "health_confirmation.jsp?action=confirmation&transactionId=" + meerkat.modules.transactionId.get() + "&token=";
                    var extraParameters = "";
                    if (meerkat.site.utm_source !== "" && meerkat.site.utm_medium !== "" && meerkat.site.utm_campaign !== "") {
                        extraParameters = "&utm_source=" + meerkat.site.utm_source + "&utm_medium=" + meerkat.site.utm_medium + "&utm_campaign=" + meerkat.site.utm_campaign;
                    }
                    if (resultData.result && resultData.result.success) {
                        window.location.replace(redirectURL + resultData.result.confirmationID + extraParameters);
                    } else if (resultData.result && resultData.result.pendingID && resultData.result.pendingID.length > 0 && (!resultData.result.callcentre || resultData.result.callcentre !== true)) {
                        window.location.replace(redirectURL + resultData.result.pendingID + extraParameters);
                    } else {
                        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
                            source: "submitApplication"
                        });
                        handleSubmittedApplicationErrors(resultData);
                    }
                },
                onError: onSubmitApplicationError,
                onComplete: function onSubmitComplete() {
                    stateSubmitInProgress = false;
                }
            });
        } catch (e) {
            stateSubmitInProgress = false;
            onSubmitApplicationError();
        }
    }
    function onSubmitApplicationError(jqXHR, textStatus, errorThrown, settings, data) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
            source: "submitApplication"
        });
        stateSubmitInProgress = false;
        if (errorThrown == meerkat.modules.comms.getCheckAuthenticatedLabel()) {} else if (textStatus == "Server generated error") {
            handleSubmittedApplicationErrors(errorThrown);
        } else {
            handleSubmittedApplicationErrors(data);
        }
    }
    function handleSubmittedApplicationErrors(resultData) {
        var error = resultData;
        if (resultData.hasOwnProperty("error") && typeof resultData.error == "object") {
            error = resultData.error;
        }
        var msg = "";
        var validationFailure = false;
        try {
            if (resultData.result && resultData.result.errors) {
                var target = resultData.result.errors;
                if ($.isArray(target.error)) {
                    target = target.error;
                }
                $.each(target, function(i, error) {
                    msg += "<p>";
                    msg += "[Code: " + error.code + "] " + error.text;
                    msg += "</p>";
                });
                if (msg === "") {
                    msg = "An unhandled error was received.";
                }
            } else if (error && error.hasOwnProperty("type")) {
                switch (error.type) {
                  case "validation":
                    validationFailure = true;
                    break;

                  case "timeout":
                    msg = "Fund application service timed out.";
                    break;

                  case "parsing":
                    msg = "Error parsing the XML request - report issue to developers.";
                    break;

                  case "confirmed":
                    msg = error.message;
                    break;

                  case "transaction":
                    msg = error.message;
                    break;

                  case "submission":
                    msg = error.message;
                    break;

                  default:
                    msg = "[" + error.code + "] " + error.message + " (Please report to IT before continuing)";
                    break;
                }
            } else {
                msg = "An unhandled error was received.";
            }
        } catch (e) {
            msg = "Application unsuccessful. Failed to handle response: " + e.message;
        }
        if (validationFailure) {
            meerkat.modules.serverSideValidationOutput.outputValidationErrors({
                validationErrors: error.errorDetails.validationErrors,
                startStage: "payment"
            });
            if (typeof error.transactionId != "undefined") {
                meerkat.modules.transactionId.set(error.transactionId);
            }
        } else {
            if (meerkat.site.isCallCentreUser === false) {
                msg = 'Please contact us on <span class="callCentreHelpNumber">' + meerkat.site.content.callCentreHelpNumberApplication + "</span> for assistance.";
            }
            meerkat.modules.errorHandling.error({
                message: "<strong>Application failed:</strong><br/>" + msg,
                page: "health.js",
                errorLevel: "warning",
                description: "handleSubmittedApplicationErrors(). Submit failed: " + msg,
                data: resultData
            });
            if (healthFunds.applicationFailed) {
                healthFunds.applicationFailed();
            }
        }
    }
    function toggleInboundOutbound() {
        if ($("#health_simples_contactType_inbound").is(":checked")) {
            $(".follow-up-call").addClass("hidden");
            $(".simples-privacycheck-statement, .new-quote-only").removeClass("hidden");
            $(".simples-privacycheck-statement input:checkbox").prop("disabled", false);
        } else if ($("#health_simples_contactType_outbound").is(":checked")) {
            $(".simples-privacycheck-statement, .new-quote-only, .follow-up-call").addClass("hidden");
        } else if ($("#health_simples_contactType_followup").is(":checked")) {
            $(".simples-privacycheck-statement, .new-quote-only").addClass("hidden");
            $(".follow-up-call").removeClass("hidden");
            $(".follow-up-call input:checkbox").prop("disabled", false);
        } else if ($("#health_simples_contactType_callback").is(":checked")) {
            $(".simples-privacycheck-statement, .new-quote-only, .follow-up-call").removeClass("hidden");
            toggleDialogueInChatCallback();
        }
    }
    function toggleRebateDialogue() {
        if ($("#health_healthCover_rebate_Y").is(":checked")) {
            $(".simples-dialogue-37").removeClass("hidden");
        } else if ($("#health_healthCover_rebate_N").is(":checked")) {
            $(".simples-dialogue-37").addClass("hidden");
        }
    }
    function toggleDialogueInChatCallback() {
        var $followUpCallField = $(".follow-up-call input:checkbox");
        var $privacyCheckField = $(".simples-privacycheck-statement input:checkbox");
        if ($followUpCallField.is(":checked")) {
            $privacyCheckField.attr("checked", false);
            $privacyCheckField.prop("disabled", true);
            $(".simples-privacycheck-statement .error-field").hide();
        } else if ($privacyCheckField.is(":checked")) {
            $followUpCallField.attr("checked", false);
            $followUpCallField.prop("disabled", true);
            $(".follow-up-call .error-field").hide();
        } else {
            $privacyCheckField.prop("disabled", false);
            $followUpCallField.prop("disabled", false);
            $(".simples-privacycheck-statement .error-field").show();
            $(".follow-up-call .error-field").show();
        }
    }
    function initHealth() {
        var self = this;
        $(document).ready(function() {
            if (meerkat.site.vertical !== "health") return false;
            initJourneyEngine();
            if (meerkat.site.pageAction === "confirmation") return false;
            if (meerkat.site.isCallCentreUser === false) {
                setInterval(function() {
                    var content = $("#chat-health-insurance-sales").html();
                    if (content === "" || content === "<span></span>") {
                        $("#contact-panel").removeClass("hasButton");
                    } else {
                        $("#contact-panel").addClass("hasButton");
                    }
                }, 5e3);
            }
            eventSubscriptions();
            configureContactDetails();
            if (meerkat.site.pageAction === "amend" || meerkat.site.pageAction === "load" || meerkat.site.pageAction === "start-again") {
                if (typeof healthFunds !== "undefined" && healthFunds.checkIfNeedToInjectOnAmend) {
                    healthFunds.checkIfNeedToInjectOnAmend(function onLoadedAmeded() {
                        meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                    });
                } else {
                    meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                }
            }
            $("#health_contactDetails_optin").on("click", function() {
                var optinVal = $(this).is(":checked") ? "Y" : "N";
                $("#health_privacyoptin").val(optinVal);
                $("#health_contactDetails_optInEmail").val(optinVal);
                $("#health_contactDetails_call").val(optinVal);
            });
            if ($('input[name="health_directApplication"]').val() === "Y") {
                $("#health_application_productId").val(meerkat.site.loadProductId);
                $("#health_application_productTitle").val(meerkat.site.loadProductTitle);
            }
            healthDependents.init();
            if (meerkat.site.isCallCentreUser === true) {
                meerkat.modules.simplesSnapshot.initSimplesSnapshot();
            }
        });
    }
    meerkat.modules.register("health", {
        init: initHealth,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getRates: getRates,
        getRebate: getRebate,
        loadRates: loadRates
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {};
    var isActive = false, fromMonth = null, disabledFunds = [];
    function getIsActive() {
        return isActive;
    }
    function getFromMonth() {
        return fromMonth;
    }
    function isFundDisabled(fund) {
        return _.indexOf(disabledFunds, fund) >= 0;
    }
    function init() {
        var self = this;
        $(document).ready(function() {
            var json = meerkat.site.alternatePricing;
            if (!_.isNull(json) && _.isObject(json) && !_.isEmpty(json)) {
                if (json.hasOwnProperty("isActive") && json.hasOwnProperty("fromMonth") && json.hasOwnProperty("disabledFunds")) {
                    isActive = json.isActive;
                    fromMonth = json.fromMonth;
                    disabledFunds = json.disabledFunds;
                }
            }
        });
    }
    meerkat.modules.register("healthAltPricing", {
        init: init,
        events: moduleEvents,
        getIsActive: getIsActive,
        getFromMonth: getFromMonth,
        isFundDisabled: isFundDisabled
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $dropdown, $component, mode, changedByCallCentre = false, isIE8;
    var events = {
        healthBenefits: {
            CHANGED: "HEALTH_BENEFITS_CHANGED"
        }
    }, moduleEvents = events.healthBenefits;
    var MODE_POPOVER = "popover-mode";
    var MODE_JOURNEY = "journey-mode";
    function getProductCategory() {
        var hospital = $("#health_benefits_benefitsExtras_Hospital").is(":checked");
        var extras = $("#health_benefits_benefitsExtras_GeneralHealth").is(":checked");
        if (hospital > 0 && extras) {
            return "Combined";
        } else if (hospital) {
            return "Hospital";
        } else if (extras) {
            return "GeneralHealth";
        } else {
            return "None";
        }
    }
    function getBenefitsForSituation(situation, isReset, callback) {
        if (changedByCallCentre) return;
        if (situation === "") {
            populateHiddenFields([], isReset);
            if (typeof callback === "function") {
                callback();
            }
            return;
        }
        meerkat.modules.comms.post({
            url: "ajax/csv/get_benefits.jsp",
            data: {
                situation: situation
            },
            errorLevel: "silent",
            cache: true,
            onSuccess: function onBenefitSuccess(data) {
                defaultBenefits = data.split(",");
                populateHiddenFields(defaultBenefits, isReset);
                if (typeof callback === "function") {
                    callback();
                }
            }
        });
    }
    function resetHiddenFields() {
        $("#mainform input[type='hidden'].benefit-item").val("");
    }
    function populateHiddenFields(checkedBenefits, isReset) {
        if (isReset) {
            resetHiddenFields();
        }
        for (var i = 0; i < checkedBenefits.length; i++) {
            var path = checkedBenefits[i];
            var element = $("#mainform input[name='health_benefits_benefitsExtras_" + path + "'].benefit-item").val("Y");
        }
    }
    function resetDisplayComponent() {
        $component.find(".benefits-list input[type='checkbox']").prop("checked", false);
        if (isIE8) $component.find(".benefits-list input[type='checkbox']").change();
    }
    function populateDisplayComponent() {
        resetDisplayComponent();
        $("#mainform input.benefit-item").each(function(index, element) {
            var $element = $(element);
            if ($element.val() == "Y") {
                var key = $element.attr("name");
                $component.find(".benefits-list :input[name='" + key + "']").prop("checked", true);
                if (isIE8) $component.find(".benefits-list :input[name='" + key + "']").change();
            }
        });
        $component.find("input.checkbox-switch").bootstrapSwitch("setState");
        $component.find("input.hasChildren").each(function(index, element) {
            updateEnableSectionState(element);
        });
    }
    function onSectionChange(event) {
        if ($component.find(":input.hasChildren:checked").length === 0) {
            $component.find(".btn-save").prop("disabled", true);
            $component.find("a.btn-save").addClass("disabled");
        } else {
            $component.find(".btn-save").prop("disabled", false);
            $component.find("a.btn-save").removeClass("disabled");
        }
        updateEnableSectionState($(this));
    }
    function updateEnableSectionState(element) {
        var $element = $(element), disabled = !$element.is(":checked"), $first = $element.parents(".short-list-item").first(), $childrenInputs = $first.find(".children :input");
        $childrenInputs.prop("disabled", disabled);
        if (disabled === true) {
            $first.addClass("disabled");
            $childrenInputs.prop("checked", false);
        } else {
            $first.removeClass("disabled");
        }
        if (isIE8) $childrenInputs.change();
    }
    function getSelectedBenefits() {
        var benefits = [];
        $("#mainform input.benefit-item").each(function(index, element) {
            var $element = $(element);
            if ($element.val() == "Y") {
                var key = $element.attr("data-skey");
                benefits.push(key);
            }
        });
        return benefits;
    }
    function saveBenefits() {
        resetHiddenFields();
        var selectedBenefits = [];
        $component.find(":input:checked").each(function(index, element) {
            var $element = $("#mainform input[name='" + $(element).attr("name") + "'].benefit-item");
            $element.val("Y");
            selectedBenefits.push($element.attr("data-skey"));
        });
        if (_.contains(selectedBenefits, "Hospital")) {
            $("#filter-tierHospital").removeClass("hidden");
        } else {
            $("#filter-tierHospital").addClass("hidden");
            $("#filters_tierHospital").val("");
            $("#health_filter_tierHospital").val("");
        }
        if (_.contains(selectedBenefits, "GeneralHealth")) {
            $("#filter-tierExtras").removeClass("hidden");
        } else {
            $("#filter-tierExtras").addClass("hidden");
            $("#filters_tierExtras").val("");
            $("#health_filter_tierExtras").val("");
        }
        return selectedBenefits;
    }
    function saveSelection() {
        var navigationId = "";
        if (meerkat.modules.journeyEngine.getCurrentStep()) navigationId = meerkat.modules.journeyEngine.getCurrentStep().navigationId;
        if (navigationId === "results" || meerkat.modules.splitTest.isActive(1) && navigationId === "benefits") {
            meerkat.modules.journeyEngine.loadingShow("getting your quotes", true);
        }
        close();
        _.defer(function() {
            var selectedBenefits = saveBenefits();
            if (mode === MODE_JOURNEY) {
                meerkat.modules.journeyEngine.gotoPath("next");
            } else {
                meerkat.messaging.publish(moduleEvents.CHANGED, selectedBenefits);
            }
            if (meerkat.site.isCallCentreUser === true) {
                changedByCallCentre = true;
            }
        });
    }
    function enableParent(event) {
        $target = $(event.currentTarget);
        if ($target.find("input").prop("disabled") === true) {
            $target.parents(".hasShortlistableChildren").first().find(".title").first().find(":input").prop("checked", true);
            $component.find("input.checkbox-switch").bootstrapSwitch("setState");
        }
    }
    function prefillBenefits() {
        var healthSitu = $("#health_situation_healthSitu").val(), healthSituCvr = getHealthSituCvr();
        if (healthSituCvr === "" || healthSitu === "ATP") {
            getBenefitsForSituation(healthSitu, true);
        } else {
            getBenefitsForSituation(healthSitu, true, function() {
                getBenefitsForSituation(healthSituCvr, false);
            });
        }
    }
    function getHealthSituCvr() {
        var cover = $("#health_situation_healthCvr").val(), primary_dob = $("#health_healthCover_primary_dob").val(), partner_dob = $("#health_healthCover_partner_dob").val(), primary_age = 0, partner_age = 0, ageAverage = 0, healthSituCvr = "";
        if (cover === "F" || cover === "SPF") {
            healthSituCvr = "FAM";
        } else if ((cover === "S" || cover === "SM" || cover === "SF") && primary_dob !== "") {
            ageAverage = returnAge(primary_dob, true);
            healthSituCvr = getAgeBands(ageAverage);
        } else if (cover === "C" && primary_dob !== "" && partner_dob !== "") {
            primary_age = returnAge(primary_dob), partner_age = returnAge(partner_dob);
            if (16 <= primary_age && primary_age <= 120 && 16 <= partner_age && partner_age <= 120) {
                ageAverage = Math.floor((primary_age + partner_age) / 2);
                healthSituCvr = getAgeBands(ageAverage);
            }
        }
        return healthSituCvr;
    }
    function getAgeBands(age) {
        if (16 <= age && age <= 30) {
            return "YOU";
        } else if (31 <= age && age <= 55) {
            return "MID";
        } else if (56 <= age && age <= 120) {
            return "MAT";
        } else {
            return "";
        }
    }
    function open(modeParam) {
        mode = modeParam;
        meerkat.modules.navMenu.open();
        if ($dropdown.hasClass("open") === false) {
            $component.addClass(mode);
            $dropdown.find(".activator").dropdown("toggle");
        }
    }
    function afterOpen() {
        $component.find(":input.hasChildren").on("change.benefits", onSectionChange);
        $component.find(".btn-save").on("click.benefits", saveSelection);
        $component.find(".btn-cancel").on("click.benefits", close);
        $component.find(".categoriesCell .checkbox").on("click.benefits", enableParent);
    }
    function close() {
        if ($dropdown.hasClass("open")) {
            if (isLocked()) {
                unlockBenefits();
                $dropdown.find(".activator").dropdown("toggle");
                lockBenefits();
            } else {
                $dropdown.find(".activator").dropdown("toggle");
            }
            meerkat.modules.navMenu.close();
        }
    }
    function afterClose() {
        $component.find("input.hasChildren").off("change.benefits");
        $component.find(".btn-save").off("click.benefits");
        $component.find(".btn-cancel").off("click.benefits");
        $component.find(".categoriesCell .checkbox").off("click.benefits", enableParent);
        $component.removeClass("journey-mode");
        $component.removeClass("popover-mode");
        mode = null;
    }
    function init() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;
            $dropdown = $("#benefits-dropdown");
            $component = $(".benefits-component");
            isIE8 = meerkat.modules.performanceProfiling.isIE8();
            $dropdown.on("show.bs.dropdown", function() {
                if (mode === null) mode = MODE_POPOVER;
                afterOpen();
                populateDisplayComponent();
            });
            $dropdown.on("hide.bs.dropdown", function(event) {
                if (meerkat.modules.journeyEngine.getCurrentStepIndex() == 2) {
                    event.preventDefault();
                    meerkat.modules.dropdownInteractive.addBackdrop($dropdown);
                }
            });
            $dropdown.on("hidden.bs.dropdown", function() {
                afterClose();
            });
            meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(step) {
                if (step.navigationId === "benefits") {
                    return;
                }
                meerkat.modules.healthBenefits.close();
            });
            $("[data-benefits-control='Y']").click(function(event) {
                event.preventDefault();
                event.stopPropagation();
                open(MODE_POPOVER);
            });
            $("#health_situation_healthSitu").add("#health_healthCover_primary_dob").add("#health_healthCover_partner_dob").add("#health_situation_healthCvr").on("change", function(event) {
                prefillBenefits();
            });
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockBenefits);
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockBenefits);
        });
    }
    function isLocked() {
        return $dropdown.children(".activator").hasClass("disabled");
    }
    function lockBenefits() {
        $dropdown.children(".activator").addClass("inactive").addClass("disabled");
    }
    function unlockBenefits() {
        $dropdown.children(".activator").removeClass("inactive").removeClass("disabled");
    }
    meerkat.modules.register("healthBenefits", {
        init: init,
        events: events,
        open: open,
        close: close,
        getProductCategory: getProductCategory,
        getSelectedBenefits: getSelectedBenefits,
        getBenefitsForSituation: getBenefitsForSituation
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var confirmationProduct = null;
    function init() {
        jQuery(document).ready(function($) {
            if (typeof meerkat.site === "undefined") return;
            if (meerkat.site.pageAction !== "confirmation") return;
            meerkat.modules.health.initProgressBar(true);
            meerkat.modules.journeyProgressBar.setComplete();
            meerkat.modules.journeyProgressBar.disable();
            if (result.hasOwnProperty("data") === false || result.data.status != "OK" || result.data.product === "") {
                meerkat.modules.errorHandling.error({
                    message: result.data.message,
                    page: "healthConfirmation.js module",
                    description: "Trying to load the confirmation page failed",
                    data: null,
                    errorLevel: "warning"
                });
            } else {
                confirmationProduct = $.extend({}, result.data);
                confirmationProduct.mode = "lhcInc";
                if (confirmationProduct.product) {
                    confirmationProduct.pending = false;
                    confirmationProduct.product = $.parseJSON(confirmationProduct.product);
                    if (confirmationProduct.product.price && _.isArray(confirmationProduct.product.price)) {
                        confirmationProduct.product = confirmationProduct.product.price[0];
                    }
                    $.extend(confirmationProduct, confirmationProduct.product);
                    delete confirmationProduct.product;
                } else if (typeof sessionProduct === "object") {
                    if (sessionProduct.price && _.isArray(sessionProduct.price)) {
                        sessionProduct = sessionProduct.price[0];
                    }
                    if (confirmationProduct.transID === sessionProduct.transactionId) {
                        $.extend(confirmationProduct, sessionProduct);
                    } else {
                        sessionProduct = undefined;
                    }
                    confirmationProduct.pending = true;
                } else {
                    confirmationProduct.pending = true;
                }
                meerkat.modules.healthMoreInfo.setProduct(confirmationProduct);
                meerkat.modules.healthMoreInfo.prepareCover();
                if (confirmationProduct.frequency.length == 1) {
                    confirmationProduct.frequency = meerkat.modules.healthResults.getFrequencyInWords(confirmationProduct.frequency);
                }
                confirmationProduct._selectedFrequency = confirmationProduct.frequency;
                fillTemplate();
                if (confirmationProduct.warningAlert === "" || confirmationProduct.warningAlert === undefined) {
                    meerkat.modules.healthMoreInfo.prepareExternalCopy(function confirmationExternalCopySuccess() {
                        if (typeof confirmationProduct.warningAlert !== "undefined" && confirmationProduct.warningAlert !== "") {
                            $("#health_confirmation-warning").find(".fundWarning").show().html(confirmationProduct.warningAlert);
                        } else {
                            $("#health_confirmation-warning").find(".fundWarning").hide().empty();
                        }
                    });
                }
                meerkat.modules.healthMoreInfo.applyEventListeners();
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "completedApplication",
                    object: {
                        productID: confirmationProduct.productId,
                        vertical: meerkat.site.vertical,
                        productBrandCode: confirmationProduct.info.provider,
                        productName: confirmationProduct.info.productTitle,
                        quoteReferenceNumber: confirmationProduct.transactionId,
                        simplesUser: meerkat.site.isCallCentreUser,
                        reedemedCouponID: $(".coupon-confirmation").data("couponId")
                    }
                });
            }
        });
    }
    function fillTemplate() {
        var confirmationTemplate = $("#confirmation-template").html();
        var htmlTemplate = _.template(confirmationTemplate);
        var htmlString = htmlTemplate(confirmationProduct);
        $("#confirmation").html(htmlString);
        meerkat.messaging.subscribe(meerkatEvents.healthPriceComponent.INIT, function(selectedProduct) {
            meerkat.modules.healthPriceComponent.updateProductSummaryHeader(confirmationProduct, confirmationProduct.frequency, true);
            meerkat.modules.healthPriceComponent.updateProductSummaryDetails(confirmationProduct, confirmationProduct.startDate, false);
        });
        if (confirmationProduct.about === "") {
            meerkat.modules.healthMoreInfo.prepareExternalCopy(function confirmationExternalCopySuccess() {
                $(".aboutFund").append(confirmationProduct.aboutFund).parents(".displayNone").first().removeClass("displayNone");
            });
        }
    }
    meerkat.modules.register("healthConfirmation", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $dropdown, $component, $providerFilter, filterValues = {}, joinDelimiter = ",";
    var events = {
        healthFilters: {
            CHANGED: "HEALTH_FILTERS_CHANGED"
        }
    }, moduleEvents = events.healthFilters;
    function updateFilters() {
        readFilterValues("value");
    }
    function readFilterValues(propertyNameToStoreValue, readOnlyFromFilters) {
        var propName = propertyNameToStoreValue || "value";
        $component.find("[data-filter-type]").each(function() {
            var $this = $(this), filterType = $this.attr("data-filter-type"), id = $this.attr("id"), value = "";
            if (typeof id === "undefined") return;
            if ("slider" === filterType) {
                $this.find(".slider-control").trigger("UPDATE");
                value = $this.find(".slider").val();
            }
            if ("radio" === filterType) {
                value = $this.find(":checked").val() || "";
                if (readOnlyFromFilters !== true) {
                    if ("filter-frequency" === id) {
                        try {
                            value = Results.getFrequency();
                        } catch (err) {}
                        value = meerkat.modules.healthResults.getFrequencyInLetters(value) || "A";
                        $this.find('input[value="' + value + '"]').prop("checked", true).change();
                    } else if ("filter-sort" === id) {
                        try {
                            value = Results.getSortBy();
                        } catch (err) {}
                        if (value.indexOf("price") > -1) {
                            value = "L";
                        } else {
                            value = "B";
                        }
                        $this.find('input[value="' + value + '"]').prop("checked", true).change();
                    }
                }
            }
            if ("select" === filterType) {
                value = $this.find(":selected").val() || "";
                if (readOnlyFromFilters !== true) {
                    if ("filter-tierHospital" === id) {
                        value = $("#health_filter_tierHospital").val();
                        $this.find("select").val(value);
                    } else if ("filter-tierExtras" === id) {
                        value = $("#health_filter_tierExtras").val();
                        $this.find("select").val(value);
                    }
                }
            }
            if ("checkbox" === filterType) {
                var values = [];
                if ("filter-provider" === id) {
                    values = $this.find("[type=checkbox]:not(:checked)").map(function() {
                        return this.value;
                    });
                } else {
                    values = $this.find("[type=checkbox]:checked").map(function() {
                        return this.value;
                    });
                }
                value = values.get().join(joinDelimiter);
                if (readOnlyFromFilters !== true) {
                    if ("filter-provider" === id) {
                        value = $("#health_filter_providerExclude").val();
                        values = value.split(joinDelimiter);
                        $this.find(":checkbox").each(function() {
                            var $ele = $(this);
                            if ($.inArray($ele.attr("value"), values) < 0) {
                                $ele.prop("checked", true).change();
                            } else {
                                $ele.prop("checked", false).change();
                            }
                        });
                    }
                }
            }
            if (!filterValues.hasOwnProperty(id)) filterValues[id] = {};
            filterValues[id].type = filterType;
            filterValues[id][propName] = value;
        });
    }
    function revertSelections() {
        var value, filterId;
        for (filterId in filterValues) {
            if (filterValues.hasOwnProperty(filterId)) {
                value = filterValues[filterId].value;
                switch (filterValues[filterId].type) {
                  case "slider":
                    $component.find("#" + filterId + " .slider").val(value);
                    break;

                  case "radio":
                    if (value === "") {
                        $component.find("#" + filterId + " input").prop("checked", false).change();
                    } else {
                        $component.find("#" + filterId + ' input[value="' + value + '"]').prop("checked", true).change();
                    }
                    break;

                  case "select":
                    $component.find("#" + filterId + " select").val(value);
                    break;
                }
            }
        }
    }
    function saveSelection() {
        var numValidProviders = $providerFilter.find("[type=checkbox]:checked").length;
        if (numValidProviders < 1) {
            $providerFilter.find(":checkbox").addClass("has-error");
            if ($providerFilter.find(".alert").length === 0) {
                $providerFilter.prepend('<div id="health-filter-alert" class="alert alert-danger">Please select at least 1 brand to compare results</div>');
            }
            window.location.href = "#health-filter-alert";
            return;
        } else {
            $providerFilter.find(":checkbox").removeClass("has-error");
            $providerFilter.find(".alert").remove();
        }
        $component.addClass("is-saved");
        close();
        if (meerkat.modules.deviceMediaState.get() === "xs") {
            meerkat.modules.navMenu.close();
        } else {
            $dropdown.closest(".navbar-collapse").removeClass("in");
        }
        _.defer(function() {
            var valueOld, valueNew, filterId, needToFetchFromServer = false, filterChanges = {};
            readFilterValues("valueNew", true);
            for (filterId in filterValues) {
                if (filterValues.hasOwnProperty(filterId)) {
                    if (filterValues[filterId].value !== filterValues[filterId].valueNew) {
                        if ($("#" + filterId).attr("data-filter-serverside")) {
                            needToFetchFromServer = true;
                            break;
                        }
                    }
                }
            }
            for (filterId in filterValues) {
                if (filterValues.hasOwnProperty(filterId)) {
                    valueOld = filterValues[filterId].value;
                    valueNew = filterValues[filterId].valueNew;
                    if (valueOld !== valueNew) {
                        if ("filter-frequency" === filterId) {
                            $("#health_filter_frequency").val(valueNew);
                            valueNew = meerkat.modules.healthResults.getFrequencyInWords(valueNew) || "monthly";
                            if (!needToFetchFromServer) {
                                refreshView = true;
                                if (filterValues.hasOwnProperty("filter-sort")) {
                                    if (filterValues["filter-sort"].value === "L" && filterValues["filter-sort"].value === filterValues["filter-sort"].valueNew) {
                                        refreshSort = true;
                                    }
                                }
                                filterChanges["filter-frequency-change"] = valueNew;
                            }
                            Results.setFrequency(valueNew, false);
                        } else if ("filter-sort" === filterId) {
                            var sortDir = "asc";
                            switch (valueNew) {
                              case "L":
                                if (filterValues.hasOwnProperty("filter-frequency")) {
                                    valueNew = meerkat.modules.healthResults.getFrequencyInWords(filterValues["filter-frequency"].valueNew) || "monthly";
                                    valueNew = "price." + valueNew;
                                    break;
                                }
                                valueNew = "price.monthly";
                                break;

                              default:
                                valueNew = "benefitsSort";
                            }
                            Results.setSortBy(valueNew);
                            Results.setSortDir(sortDir);
                        } else if ("filter-tierHospital" === filterId) {
                            $("#health_filter_tierHospital").val(valueNew);
                        } else if ("filter-tierExtras" === filterId) {
                            $("#health_filter_tierExtras").val(valueNew);
                        } else if ("filter-provider" === filterId) {
                            $("#health_filter_providerExclude").val(valueNew);
                        }
                    }
                }
            }
            meerkat.messaging.publish(moduleEvents.CHANGED, filterChanges);
            if (needToFetchFromServer) {
                _.defer(function() {
                    meerkat.modules.journeyEngine.loadingShow("...updating your quotes...", true);
                    _.delay(function() {
                        meerkat.modules.healthResults.get();
                    }, 100);
                });
            } else {
                Results.applyFiltersAndSorts();
            }
        });
    }
    function open() {
        if ($dropdown.hasClass("open") === false) {
            $dropdown.find(".activator").dropdown("toggle");
        }
    }
    function afterOpen() {
        $component.find(".btn-save").on("click.filters", saveSelection);
        $component.find(".btn-cancel").on("click.filters", close);
    }
    function close() {
        if ($dropdown.hasClass("open")) {
            $dropdown.find(".activator").dropdown("toggle");
        }
    }
    function afterClose() {
        if ($component.hasClass("is-saved")) {
            $component.removeClass("is-saved");
        } else {
            revertSelections();
        }
        $component.find(".btn-save").off("click.filters");
        $component.find(".btn-cancel").off("click.filters");
        $component.find(":checkbox").removeClass("has-error");
        $component.find(".alert").remove();
    }
    function setBrandFilterActions() {
        $(".selectNotRestrictedBrands").on("click", function selectNotRestrictedBrands() {
            $(".notRestrictedBrands [type=checkbox]:not(:checked)").prop("checked", true).change();
        });
        $(".unselectNotRestrictedBrands").on("click", function unselectNotRestrictedBrands() {
            $(".notRestrictedBrands [type=checkbox]:checked").prop("checked", false).change();
        });
        $(".selectRestrictedBrands").on("click", function selectRestrictedBrands() {
            $(".restrictedBrands [type=checkbox]:not(:checked)").prop("checked", true).change();
        });
        $(".unselectRestrictedBrands").on("click", function unselectRestrictedBrands() {
            $(".restrictedBrands [type=checkbox]:checked").prop("checked", false).change();
        });
    }
    function setUpFequency() {
        var frequencyValue = $("#health_filter_frequency").val();
        if (frequencyValue.length > 0) {
            $("#filter-fequency").find('input[value="' + frequencyValue + '"]').prop("checked", true);
            meerkat.modules.healthPriceRangeFilter.setUp();
        }
    }
    function initModule() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;
            $dropdown = $("#filters-dropdown");
            $component = $(".filters-component");
            $providerFilter = $("#filter-provider");
            $dropdown.on("show.bs.dropdown", function() {
                afterOpen();
                updateFilters();
            });
            $dropdown.on("hidden.bs.dropdown", function() {
                afterClose();
            });
            $providerFilter.find(":checkbox").on("change", function() {
                $(this).removeClass("has-error");
                $providerFilter.find(".alert").remove();
            });
            setBrandFilterActions();
            setUpFequency();
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockFilters(obj) {
                close();
                $dropdown.children(".activator").addClass("inactive").addClass("disabled");
            });
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockFilters(obj) {
                $dropdown.children(".activator").removeClass("inactive").removeClass("disabled");
            });
        });
    }
    meerkat.modules.register("healthFilters", {
        init: initModule,
        events: events,
        open: open,
        close: close
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var events = {
        healthMoreInfo: {
            bridgingPage: {
                CHANGE: "BRIDGINGPAGE_CHANGE",
                SHOW: "BRIDGINGPAGE_SHOW",
                HIDE: "BRIDGINGPAGE_HIDE"
            }
        }
    }, moduleEvents = events.healthMoreInfo;
    var template, htmlTemplate, product, modalId, isModalOpen = false, isBridgingPageOpen = false, $moreInfoElement, headerBarHeight;
    var topPosition;
    function updatePosition() {
        topPosition = $(".resultsHeadersBg").height();
    }
    function initMoreInfo() {
        $moreInfoElement = $(".moreInfoDropdown");
        jQuery(document).ready(function($) {
            if (meerkat.site.vertical != "health" || meerkat.site.pageAction == "confirmation") return false;
            template = $("#more-info-template").html();
            if (typeof template != "undefined") {
                htmlTemplate = _.template(template);
                applyEventListeners();
                eventSubscriptions();
            }
        });
    }
    function applyEventListeners() {
        if (typeof Results.settings !== "undefined") {
            if (meerkat.modules.deviceMediaState.get() != "xs") {
                $(Results.settings.elements.page).on("click", ".btn-more-info", openbridgingPageDropdown);
            } else {
                $(Results.settings.elements.page).on("click", ".btn-more-info", openModalClick);
            }
            $(Results.settings.elements.page).on("click", ".btn-close-more-info", closeBridgingPageDropdown);
        }
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.healthMoreInfo.close();
        });
        $(document.body).on("click", ".btn-more-info-apply", function applyClick() {
            var $this = $(this);
            $this.addClass("inactive").addClass("disabled");
            meerkat.modules.loadingAnimation.showInside($this, true);
            _.defer(function deferApplyNow() {
                if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().productId != $this.attr("data-productId")) {
                    $("#health_declaration:checked").prop("checked", false).change();
                }
                Results.setSelectedProduct($this.attr("data-productId"));
                var product = Results.getSelectedProduct();
                if (product) {
                    meerkat.modules.healthResults.setSelectedProduct(product);
                    healthFunds.load(product.info.provider, applyCallback);
                    var transaction_id = meerkat.modules.transactionId.get();
                    var handoverType;
                    if (meerkat.site.isCallCentreUser) {
                        handoverType = "Simples";
                    } else {
                        handoverType = "Online";
                    }
                    meerkat.modules.partnerTransfer.trackHandoverEvent({
                        product: product,
                        type: handoverType,
                        quoteReferenceNumber: transaction_id,
                        transactionID: transaction_id,
                        productID: product.productId.replace("PHIO-HEALTH-", ""),
                        productName: product.info.name,
                        productBrandCode: product.info.FundCode,
                        simplesUser: meerkat.site.isCallCentreUser
                    }, false);
                } else {
                    applyCallback(false);
                }
            });
        });
        $(document.body).on("click", ".dialogPop", function promoConditionsLinksClick() {
            meerkat.modules.dialogs.show({
                title: $(this).attr("title"),
                htmlContent: $(this).attr("data-content")
            });
        });
        $(document.body).on("click", ".more-info", function moreInfoLinkClick(event) {
            setProduct(meerkat.modules.healthResults.getSelectedProduct());
            openModal();
        });
    }
    function applyCallback(success) {
        _.delay(function deferApplyCallback() {
            $(".btn-more-info-apply").removeClass("inactive").removeClass("disabled");
            meerkat.modules.loadingAnimation.hide($(".btn-more-info-apply"));
        }, 1e3);
        if (success === true) {
            meerkat.modules.address.setHash("apply");
        }
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function breakPointChange(data) {
            updatePosition();
        });
        $(document).on("resultPageChange", function() {
            if (isBridgingPageOpen) {
                closeBridgingPageDropdown();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (isBridgingPageOpen) {
                closeBridgingPageDropdown();
            }
            $(Results.settings.elements.page).off("click", ".btn-more-info");
            $(Results.settings.elements.page).on("click", ".btn-more-info", openModalClick);
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (isModalOpen) {
                closeModal();
            }
            $(Results.settings.elements.page).off("click", ".btn-more-info");
            $(Results.settings.elements.page).on("click", ".btn-more-info", openbridgingPageDropdown);
        });
        meerkat.messaging.subscribe(moduleEvents.bridgingPage.SHOW, function(state) {
            adaptResultsPageHeight(state.isOpen);
        });
        meerkat.messaging.subscribe(moduleEvents.bridgingPage.HIDE, function(state) {
            adaptResultsPageHeight(state.isOpen);
        });
    }
    function show(target) {
        target.html(meerkat.modules.loadingAnimation.getTemplate()).show();
        prepareProduct(function moreInfoShowSuccess() {
            var htmlString = htmlTemplate(product);
            target.find(".spinner").fadeOut();
            target.html(htmlString);
            if (meerkat.site.emailBrochures.enabled) {
                initialiseBrochureEmailForm(product, target, $("#resultsForm"));
                populateBrochureEmail();
            }
            $(".more-info-content .next-info-all").html($(".more-info-content .next-steps-all-funds-source").html());
            var animDuration = 400;
            var scrollToTopDuration = 250;
            var totalDuration = 0;
            if (isBridgingPageOpen) {
                target.find(".more-info-content").fadeIn(animDuration);
                totalDuration = animDuration;
            } else {
                meerkat.modules.utils.scrollPageTo(".resultsHeadersBg", scrollToTopDuration, -$("#navbar-main").height(), function() {
                    target.find(".more-info-content").slideDown(animDuration);
                });
                totalDuration = animDuration + scrollToTopDuration;
            }
            isBridgingPageOpen = true;
            _.delay(function() {
                meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {
                    isOpen: isBridgingPageOpen
                });
                if (!isBridgingPageOpen) {
                    updatePosition();
                    target.css({
                        top: topPosition
                    });
                }
            }, totalDuration);
            meerkat.modules.healthPhoneNumber.changePhoneNumber();
            meerkat.modules.healthSegment.hideBySegment();
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: {
                    productID: product.productId,
                    productBrandCode: product.info.providerName,
                    productName: product.info.productTitle,
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });
            $("#health_fundData_hospitalPDF").val(product.promo.hospitalPDF !== undefined ? meerkat.site.urls.base + product.promo.hospitalPDF : "");
            $("#health_fundData_extrasPDF").val(product.promo.extrasPDF !== undefined ? meerkat.site.urls.base + product.promo.extrasPDF : "");
            $("#health_fundData_providerPhoneNumber").val(product.promo.providerPhoneNumber !== undefined ? product.promo.providerPhoneNumber : "");
        });
    }
    function adaptResultsPageHeight(isOpen) {
        if (isOpen) {
            $(Results.settings.elements.page).css("overflow", "hidden").height($moreInfoElement.outerHeight());
        } else {
            $(Results.settings.elements.page).css("overflow", "visible").height("");
        }
    }
    function hide(target) {
        $(Results.settings.elements.page).find(".result").removeClass("faded");
        $(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");
        target.slideUp(400, function hideMoreInfo() {
            target.html("").hide();
            isBridgingPageOpen = false;
            meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {
                isOpen: isBridgingPageOpen
            });
            meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {
                isOpen: isBridgingPageOpen
            });
        });
    }
    function openModalClick(event) {
        var $this = $(this), productId = $this.attr("data-productId"), showApply = $this.hasClass("more-info-showapply");
        setProduct(Results.getResult("productId", productId), showApply);
        openModal();
    }
    function openModal() {
        prepareProduct(function moreInfoOpenModalSuccess() {
            var htmlString = "<form class='healthMoreInfoModel'>" + htmlTemplate(product) + "</form>";
            modalId = meerkat.modules.dialogs.show({
                htmlContent: htmlString,
                className: "modal-breakpoint-wide modal-tight",
                onOpen: function onOpen(id) {
                    if (meerkat.site.emailBrochures.enabled) {
                        initialiseBrochureEmailForm(product, $("#" + id), $("#" + id).find(".healthMoreInfoModel"));
                    }
                }
            });
            $(".more-info-content .next-info .next-info-all").html($(".more-info-content .next-steps-all-funds-source").html());
            $(".more-info-content .moreInfoRightColumn > .dualPricing").insertAfter($(".more-info-content .moreInfoMainDetails"));
            isModalOpen = true;
            $(".more-info-content").show();
            meerkat.modules.healthPhoneNumber.changePhoneNumber(true);
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: {
                    productID: product.productId,
                    productBrandCode: product.info.providerName,
                    productName: product.info.productTitle,
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });
        });
    }
    function initialiseBrochureEmailForm(product, parent, form) {
        var emailBrochuresElement = parent.find(".moreInfoEmailBrochures");
        emailBrochuresElement.show();
        meerkat.modules.emailBrochures.setup({
            emailInput: emailBrochuresElement.find(".sendBrochureEmailAddress"),
            submitButton: emailBrochuresElement.find(".btn-email-brochure"),
            form: form,
            marketing: emailBrochuresElement.find(".optInMarketing"),
            productData: [ {
                name: "hospitalPDSUrl",
                value: product.promo.hospitalPDF
            }, {
                name: "extrasPDSUrl",
                value: product.promo.extrasPDF
            }, {
                name: "provider",
                value: product.info.provider
            }, {
                name: "providerName",
                value: product.info.providerName
            }, {
                name: "productName",
                value: product.info.productTitle
            }, {
                name: "productId",
                value: product.productId
            }, {
                name: "productCode",
                value: product.info.productCode
            }, {
                name: "premium",
                value: product.premium[Results.settings.frequency].lhcfreetext
            }, {
                name: "premiumText",
                value: product.premium[Results.settings.frequency].lhcfreepricing
            } ],
            product: product,
            identifier: "SEND_BROCHURES" + product.productId,
            emailResultsSuccessCallback: function onSendBrochuresCallback(result, settings) {
                if (result.success) {
                    parent.find(".formInput").hide();
                    parent.find(".moreInfoEmailBrochuresSuccess").show();
                    meerkat.modules.emailBrochures.tearDown(settings);
                    meerkat.modules.healthResults.setSelectedProduct(product);
                } else {
                    meerkat.modules.errorHandling.error({
                        errorLevel: "warning",
                        message: "Oops! Something seems to have gone wrong. Please try again by re-entering your email address or " + 'alternatively contact our call centre on <span class="callCentreHelpNumber">' + meerkat.site.content.callCentreHelpNumber + "</span> and they'll be able to assist you further.",
                        page: "healthMoreInfo.js:onSendBrochuresCallback",
                        description: result.message,
                        data: product
                    });
                }
            }
        });
    }
    function closeModal() {
        $("#" + modalId).modal("hide");
        isModalOpen = false;
    }
    function openbridgingPageDropdown(event) {
        var $this = $(this);
        $(Results.settings.elements.page).find(".result").addClass("faded");
        $(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");
        $this.parents(".result").removeClass("faded");
        $this.removeClass("btn-more-info").addClass("btn-close-more-info");
        var productId = $this.attr("data-productId"), showApply = $this.hasClass("more-info-showapply");
        setProduct(Results.getResult("productId", productId), showApply);
        meerkat.modules.resultsHeaderBar.disableAffixMode();
        show($moreInfoElement);
    }
    function closeBridgingPageDropdown(event) {
        hide($moreInfoElement);
        meerkat.modules.resultsHeaderBar.enableAffixMode();
        if (isModalOpen) {
            closeModal();
        }
    }
    function setProduct(productToParse, showApply) {
        product = productToParse;
        if (product !== false) {
            if (showApply === true) {
                product.showApply = true;
            } else {
                product.showApply = false;
            }
        }
        return product;
    }
    function getOpenProduct() {
        if (isBridgingPageOpen === false) return null;
        return product;
    }
    function prepareProduct(successCallback) {
        prepareCover();
        prepareExternalCopy(successCallback);
    }
    function prepareCover() {
        if (typeof product.hospitalCover === "undefined") {
            if (typeof product.hospital !== "undefined" && typeof product.hospital.benefits !== "undefined") {
                prepareCoverFeatures("hospital.benefits", "hospitalCover");
                coverSwitch(product.hospital.inclusions.publicHospital, "hospitalCover", "Public Hospital");
                coverSwitch(product.hospital.inclusions.privateHospital, "hospitalCover", "Private Hospital");
            }
        }
        if (typeof product.extrasCover === "undefined") {
            if (typeof product.extras !== "undefined" && typeof product.extras === "object") {
                prepareCoverFeatures("extras", "extrasCover");
            }
        }
    }
    function prepareExternalCopy(successCallback) {
        product.aboutFund = "<p>Apologies. This information did not download successfully.</p>";
        product.whatHappensNext = "<p>Apologies. This information did not download successfully.</p>";
        product.warningAlert = "";
        $.when(meerkat.modules.comms.get({
            url: "health_fund_info/" + product.info.provider + "/about.html",
            cache: true,
            errorLevel: "silent",
            onSuccess: function aboutFundSuccess(result) {
                product.aboutFund = result;
            }
        }), meerkat.modules.comms.get({
            url: "health_fund_info/" + product.info.provider + "/next_info.html",
            cache: true,
            errorLevel: "silent",
            onSuccess: function whatHappensNextSuccess(result) {
                product.whatHappensNext = result;
            }
        }), meerkat.modules.comms.get({
            url: "health/quote/dualPrising/getFundWarning.json",
            data: {
                providerId: product.info.providerId
            },
            cache: true,
            errorLevel: "silent",
            onSuccess: function warningAlertSuccess(result) {
                product.warningAlert = result.warningMessage;
            }
        })).then(successCallback, successCallback);
    }
    function prepareCoverFeatures(searchPath, target) {
        product[target] = {
            inclusions: [],
            restrictions: [],
            exclusions: []
        };
        var lookupKey;
        var name;
        _.each(Object.byString(product, searchPath), function eachBenefit(benefit, key) {
            lookupKey = searchPath + "." + key + ".covered";
            foundObject = _.findWhere(resultLabels, {
                p: lookupKey
            });
            if (typeof foundObject !== "undefined") {
                name = foundObject.n;
                coverSwitch(benefit.covered, target, name);
            }
        });
    }
    function coverSwitch(cover, target, name) {
        switch (cover) {
          case "Y":
            product[target].inclusions.push(name);
            break;

          case "R":
            product[target].restrictions.push(name);
            break;

          case "N":
            product[target].exclusions.push(name);
            break;
        }
    }
    function populateBrochureEmail() {
        var emailAddress = $("#health_contactDetails_email").val();
        if (emailAddress !== "") {
            $("#emailAddress").val(emailAddress).trigger("blur");
        }
    }
    meerkat.modules.register("healthMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        setProduct: setProduct,
        prepareProduct: prepareProduct,
        prepareCover: prepareCover,
        prepareExternalCopy: prepareExternalCopy,
        getOpenProduct: getOpenProduct,
        close: closeBridgingPageDropdown,
        applyEventListeners: applyEventListeners
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var moduleEvents = {
        POLICY_DATE_CHANGE: "POLICY_DATE_CHANGE"
    };
    var $paymentDay, $policyDateHiddenField;
    function init() {
        $(document).ready(function() {
            $paymentDay = $(".health_payment_day");
            $policyDateHiddenField = $(".health_details-policyDate");
            $paymentDay.on("change", function paymentDayChange() {
                meerkat.messaging.publish(moduleEvents.POLICY_DATE_CHANGE, $(this).val());
            });
        });
    }
    function paymentDaysRenderEarliestDay($message, euroDate, daysMatch, exclusion) {
        if (typeof exclusion === "undefined") exclusion = 7;
        if (typeof daysMatch === "undefined" || daysMatch.length < 1) daysMatch = [ 1 ];
        var earliestDate = null;
        if (typeof euroDate === "undefined" || euroDate === "") {
            earliestDate = new Date();
        } else {
            earliestDate = meerkat.modules.utils.returnDate(euroDate);
        }
        earliestDate = new Date(earliestDate.getTime() + exclusion * 24 * 60 * 60 * 1e3);
        var i = 0;
        var foundMatch = false;
        while (i < 31 && !foundMatch) {
            earliestDate = new Date(earliestDate.getTime() + 1 * 24 * 60 * 60 * 1e3);
            foundMatch = _.contains(daysMatch, earliestDate.getDate());
            i++;
        }
        $policyDateHiddenField.val(meerkat.modules.utils.returnDateValue(earliestDate));
        $message.text("Your payment will be deducted on: " + healthFunds._getNiceDate(earliestDate));
    }
    function populateFuturePaymentDays(euroDate, exclusion, excludeWeekend, isBank) {
        var startDate, minimumDate, childDateOriginal, childDateNew, $paymentDays;
        if (typeof euroDate === "undefined" || euroDate === "") {
            startDate = new Date();
        } else {
            startDate = meerkat.modules.utils.returnDate(euroDate);
        }
        if (typeof exclusion === "undefined") exclusion = 7;
        if (typeof excludeWeekend === "undefined") excludeWeekend = false;
        if (typeof isBank === "undefined") isBank = true;
        if (isBank) {
            $paymentDays = $("#health_payment_bank_paymentDay");
        } else {
            $paymentDays = $("#health_payment_credit_paymentDay");
        }
        minimumDate = new Date(startDate);
        if (excludeWeekend) {
            minimumDate = meerkat.modules.utils.calcWorkingDays(minimumDate, exclusion);
        } else {
            minimumDate.setDate(minimumDate.getDate() + exclusion);
        }
        $paymentDays.children().each(function playWithChildren() {
            if ($(this).val() !== "") {
                childDateOriginal = new Date($(this).val());
                childDateNew = compareAndAddMonth(childDateOriginal, minimumDate);
                $(this).val(meerkat.modules.utils.returnDateValue(childDateNew));
            }
        });
    }
    function compareAndAddMonth(oldDate, minDate) {
        if (oldDate < minDate) {
            var newDate = new Date(oldDate.setMonth(oldDate.getMonth() + 1));
            return compareAndAddMonth(newDate, minDate);
        } else {
            return oldDate;
        }
    }
    meerkat.modules.register("healthPaymentDate", {
        init: init,
        events: moduleEvents,
        paymentDaysRenderEarliestDay: paymentDaysRenderEarliestDay,
        populateFuturePaymentDays: populateFuturePaymentDays
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        healthPaymentGatewayNAB: {}
    }, moduleEvents = events.healthPaymentGatewayNAB;
    var $cardNumber;
    var $cardName;
    var $crn;
    var $rescode;
    var $restext;
    var $expiryMonth;
    var $expiryYear;
    var $cardType;
    var timeout = false;
    var settings;
    function onMessage(e) {
        if (e.origin !== settings.origin) {
            console.error("domain name mismatch");
            return;
        } else {
            if (typeof e.data === "string" && e.data === "page loaded") {
                clearTimeout(timeout);
            } else {
                onPaymentResponse(e.data);
            }
        }
    }
    function init() {}
    function setup(instanceSettings) {
        settings = instanceSettings;
        $cardNumber = $("#" + settings.name + "_nab_cardNumber");
        $cardName = $("#" + settings.name + "_nab_cardName");
        $crn = $("#" + settings.name + "_nab_crn");
        $rescode = $("#" + settings.name + "_nab_rescode");
        $restext = $("#" + settings.name + "_nab_restext");
        $expiryMonth = $("#" + settings.name + "_nab_expiryMonth");
        $expiryYear = $("#" + settings.name + "_nab_expiryYear");
        $cardType = $("#" + settings.name + "_nab_cardType");
        $(".gatewayProvider").text("NAB");
    }
    function onPaymentResponse(data) {
        var json = JSON.parse(data);
        if (validatePaymentResponse(json)) {
            meerkat.messaging.publish(meerkat.modules.events.paymentGateway.SUCCESS, json);
        } else {
            meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL, json);
        }
    }
    function validatePaymentResponse(response) {
        var valid = response && response.CRN && response.CRN !== "";
        valid = valid && response.rescode == "00";
        return valid;
    }
    function success(params) {
        $cardNumber.val(params.pan);
        $cardName.val(params.cardName);
        $crn.val(params.CRN);
        $rescode.val(params.rescode);
        $restext.val(params.restext);
        $expiryMonth.val(params.expMonth);
        $expiryYear.val(params.expYear);
        $cardType.val(params.cardType);
        return true;
    }
    function fail(params) {
        if (typeof params !== "undefined") {
            $rescode.val(params.rescode);
            $restext.val(params.restext);
        }
        $cardNumber.val("");
        $cardName.val("");
        $crn.val("");
        $rescode.val("");
        $restext.val("");
        $expiryMonth.val("");
        $expiryYear.val("");
        $cardType.val("");
    }
    function onOpen(id) {
        clearTimeout(timeout);
        timeout = _.delay(function onOpenTimout() {
            meerkat.messaging.publish(meerkatEvents.paymentGateway.FAIL);
        }, 45e3);
        var iframe = '<iframe width="100%" height="390" frameBorder="0" src="' + settings.src + "external/hambs/nab_ctm_iframe.jsp?providerCode=" + settings.providerCode + "&b=" + settings.brandCode + '"></iframe>';
        meerkat.modules.dialogs.changeContent(id, iframe);
        if (window.addEventListener) {
            window.addEventListener("message", onMessage, false);
        } else if (window.attachEvent) {
            window.attachEvent("onmessage", onMessage);
        }
    }
    meerkat.modules.register("healthPaymentGatewayNAB", {
        init: init,
        success: success,
        fail: fail,
        onOpen: onOpen,
        setup: setup
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var $registered;
    var $number;
    var $type;
    var $expiry;
    var $name;
    var _type;
    var settings;
    var timeout = false;
    function init() {}
    function setup(instanceSettings) {
        settings = instanceSettings;
        $registered = $("#" + settings.name + "-registered");
        $number = $("#" + settings.name + "_number");
        $type = $("#" + settings.name + "_type");
        $expiry = $("#" + settings.name + "_expiry");
        $name = $("#" + settings.name + "_name");
        $(".gatewayProvider").text("Westpac");
    }
    function success(params) {
        if (!params || !params.number || !params.type || !params.expiry || !params.name) {
            meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL, "Registration response parameters invalid");
            return false;
        }
        $number.val(params.number);
        $type.val(params.type);
        $expiry.val(params.expiry);
        $name.val(params.name);
    }
    function fail(_msg) {
        $registered.val("");
        $number.val("");
        $type.val("");
        $expiry.val("");
        $name.val("");
    }
    function onOpen(id) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            meerkat.modules.dialogs.changeContent(id, '<iframe width="100%" height="340" frameBorder="0" src="' + settings.src + "?transactionId=" + meerkat.modules.transactionId.get() + '"></iframe>');
        }, 1e3);
    }
    meerkat.modules.register("healthPaymentGatewayWestpac", {
        success: success,
        fail: fail,
        onOpen: onOpen,
        init: init,
        setup: setup
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, $maskedNumber = [], $token = [], $cardtype = [], modalId, modalContent = "", ajaxInProgress = false, launchTime = 0;
    function init() {
        $(document).ready(function initHealthPaymentIPP() {
            $('[data-provide="payment-ipp"]').each(function eachPaymentIPP() {
                var $this = $(this);
                $token = $this.find(".payment-ipp-tokenisation");
                $cardtype = $("#health_payment_credit_type");
                $maskedNumber = $this.find(".payment-ipp-maskedNumber");
                $maskedNumber.prop("readonly", true);
                $maskedNumber.css("cursor", "pointer");
                $maskedNumber.on("click", function clickMaskedNumber() {
                    launch();
                });
            });
        });
    }
    function show() {
        $('[data-provide="payment-ipp"]').removeClass("hidden");
    }
    function hide() {
        $('[data-provide="payment-ipp"]').addClass("hidden");
    }
    function launch() {
        if ($maskedNumber.is(":visible") && isValid()) {
            openModal(modalContent);
            if (!isModalCreated()) {
                authorise();
            }
        }
    }
    function authorise() {
        if (ajaxInProgress === true || isModalCreated()) {
            return false;
        }
        ajaxInProgress = true;
        $maskedNumber.val("Loading...");
        reset();
        meerkat.modules.comms.post({
            url: "ajax/json/ipp/ipp_payment.jsp?ts=" + new Date().getTime(),
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: meerkat.modules.transactionId.get()
            },
            onSuccess: createModalContent,
            onError: function onIPPAuthError(obj, txt, errorThrown) {
                fail("IPP Token Session Request http");
            },
            onComplete: function onIPPAuthComplete() {
                ajaxInProgress = false;
            }
        });
    }
    function createModalContent(data) {
        if (isModalCreated()) {
            return false;
        }
        if (!data || !data.result || data.result.success !== true) {
            fail("IPP Token Session Request fail");
            return;
        }
        var _url = data.result.url + "?SessionId=" + data.result.refId + "&sst=" + data.result.sst + "&cardType=" + cardType() + "&registerError=false" + "&resultPage=0";
        var _message = '<p class="message"></p>';
        htmlContent = _message + '<iframe width="100%" height="110" frameBorder="0" src="' + _url + '" tabindex="" id="cc-frame"></iframe>';
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    function openModal(htmlContent) {
        launchTime = new Date().getTime();
        if (typeof htmlContent === "undefined" || htmlContent.length === 0) {
            htmlContent = meerkat.modules.loadingAnimation.getTemplate();
        }
        modalId = meerkat.modules.dialogs.show({
            htmlContent: htmlContent,
            title: "Credit Card Number",
            buttons: [ {
                label: "Cancel",
                className: "btn-default",
                closeWindow: true
            } ],
            onOpen: function(id) {
                meerkat.modules.tracking.recordSupertag("trackCustomPage", "Payment gateway popup");
            },
            onClose: function() {
                fail("User closed process");
            }
        });
    }
    function isValid() {
        return $cardtype.valid();
    }
    function fail(reason) {
        if ($token.val() === "") {
            meerkat.modules.dialogs.changeContent(modalId, "<p>We're sorry but our system is down and we are unable to process your credit card details right now.</p><p>Continue with your application and we can collect your details after you join.</p>");
            var failTime = ", " + Math.round((new Date().getTime() - launchTime) / 1e3) + " seconds";
            $token.val("fail, " + reason + failTime);
            $maskedNumber.val("Try again or continue");
            modalContent = "";
        }
    }
    function isModalCreated() {
        if (modalContent === "") {
            return false;
        } else {
            return true;
        }
    }
    function reset() {
        $token.val("");
        $maskedNumber.val("");
        modalContent = "";
    }
    function cardType() {
        switch ($cardtype.find("option:selected").val()) {
          case "v":
            return "Visa";

          case "a":
            return "Amex";

          case "m":
            return "Mastercard";

          case "d":
            return "Diners";

          default:
            return "Unknown";
        }
    }
    function register(jsonData) {
        jsonData.transactionId = meerkat.modules.transactionId.get();
        meerkat.modules.comms.post({
            url: "ajax/json/ipp/ipp_log.jsp?ts=" + new Date().getTime(),
            data: jsonData,
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            onSuccess: function onRegisterSuccess(data) {
                if (!data || !data.result || data.result.success !== true) {
                    fail("IPP Token Log false");
                    return;
                }
                $token.val(jsonData.sessionid);
                $maskedNumber.val(jsonData.maskedcardno);
                modalContent = "";
                meerkat.modules.dialogs.close(modalId);
            },
            onError: function onRegisterError(obj, txt, errorThrown) {
                fail("IPP Token Log http");
            }
        });
    }
    meerkat.modules.register("healthPaymentIPP", {
        init: init,
        show: show,
        hide: hide,
        fail: fail,
        register: register
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var modalId;
    var $coverStartDate;
    var $paymentRadioGroup;
    var $premiumContainer;
    var $updatePremiumButtonContainer;
    var $paymentContainer;
    var $frequencySelect;
    var $priceCell;
    var $frequncyCell;
    var $lhcCell;
    var settings = {
        bank: [],
        credit: [],
        frequency: [],
        creditBankSupply: false,
        creditBankQuestions: false,
        minStartDateOffset: 0,
        maxStartDateOffset: 90,
        minStartDate: "",
        maxStartDate: ""
    };
    function init() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;
            $coverStateDate = $("#health_payment_details_start");
            $coverStateDateCalendar = $("#health_payment_details_start_calendar");
            $paymentRadioGroup = $("#health_payment_details_type");
            $frequencySelect = $("#health_payment_details_frequency");
            $bankAccountDetailsRadioGroup = $("#health_payment_details_claims");
            $sameBankAccountRadioGroup = $("#health_payment_bank_claims");
            $updatePremiumButtonContainer = $(".health-payment-details_update");
            $paymentContainer = $("#update-content");
            $premiumContainer = $(".health-payment-details_premium");
            $priceCell = $premiumContainer.find(".amount");
            $frequncyCell = $premiumContainer.find(".frequencyText");
            $lhcCell = $premiumContainer.find(".lhcText");
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockPaymentStep(obj) {
                var isSameSource = typeof obj !== "undefined" && obj.source && obj.source === "healthPaymentStep";
                var disableFields = typeof obj !== "undefined" && obj.disableFields && obj.disableFields === true;
                disableUpdatePremium(isSameSource, disableFields);
            });
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockPaymentStep(obj) {
                enableUpdatePremium();
            });
            meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, resetState);
            meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_RESET, function jeStepChange(step) {
                resetState();
                resetSettings();
            });
            $paymentRadioGroup.find("input").on("change", updateFrequencySelectOptions);
            $("#update-premium").on("click", function() {
                meerkat.modules.coupon.validateCouponCode($(".coupon-code-field").val());
            });
            $(".coupon-code-field").on("change", resetState);
            $("#update-premium").on("click", updatePremium);
            $("#health_payment_credit_type").on("change", creditCardDetails.set);
            creditCardDetails.set();
            $bankAccountDetailsRadioGroup.find("input").on("click", toggleClaimsBankAccountQuestion);
            $sameBankAccountRadioGroup.find("input").on("click", toggleClaimsBankAccountQuestion);
            resetSettings();
            $premiumContainer.hide();
            $updatePremiumButtonContainer.show();
            $paymentContainer.hide();
        });
    }
    function resetState() {
        $premiumContainer.hide();
        $updatePremiumButtonContainer.show();
        $paymentContainer.hide();
        $("#health_declaration-selection").hide();
        $("#confirm-step").hide();
        $("#update-premium").removeClass("hasAltPremium");
    }
    function resetSettings() {
        settings.bank = {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        };
        settings.credit = {
            weekly: false,
            fortnightly: false,
            monthly: true,
            quarterly: false,
            halfyearly: false,
            annually: true
        };
        settings.frequency = {
            weekly: 27,
            fortnightly: 31,
            monthly: 27,
            quarterly: 27,
            halfyearly: 27,
            annually: 27
        };
        settings.creditBankSupply = false;
        settings.creditBankQuestions = false;
        creditCardDetails.resetConfig();
        $("#health_payment_details_start").val("");
        $paymentRadioGroup.find("input").prop("checked", false).change();
        $paymentRadioGroup.find("label").removeClass("active");
        $frequencySelect.val("");
        $("#health_payment_details_claims input").prop("checked", false).change();
        $("#health_payment_details_claims input").find("label").removeClass("active");
        setCoverStartRange(0, 90);
    }
    function overrideSettings(property, value) {
        settings[property] = value;
    }
    function getSetting(property) {
        return settings[property];
    }
    function getSelectedPaymentMethod() {
        return $paymentRadioGroup.find("input:checked").val();
    }
    function getSelectedFrequency() {
        return $frequencySelect.val();
    }
    function setCoverStartRange(min, max) {
        settings.minStartDateOffset = min;
        settings.maxStartDateOffset = max;
        var today = meerkat.modules.utils.getUTCToday(), start = 0, end = 0, hourAsMs = 60 * 60 * 1e3;
        today += 10 * hourAsMs;
        start = today;
        if (min > 0) {
            start += min * 24 * hourAsMs;
        }
        end = today + max * 24 * hourAsMs;
        today = new Date(start);
        settings.minStartDate = today.getUTCDate() + "/" + (today.getUTCMonth() + 1) + "/" + today.getUTCFullYear();
        today = new Date(end);
        settings.maxStartDate = today.getUTCDate() + "/" + (today.getUTCMonth() + 1) + "/" + today.getUTCFullYear();
    }
    function updateFrequencySelectOptions() {
        var paymentMethod = getSelectedPaymentMethod();
        var selectedFrequency = getSelectedFrequency();
        var product = meerkat.modules.healthResults.getSelectedProduct();
        var _html = '<option id="health_payment_details_frequency_" value="">Please choose...</option>';
        if (paymentMethod === "" || product === null) {
            return false;
        }
        var method;
        if (paymentMethod === "cc") {
            method = settings.credit;
        } else if (paymentMethod === "ba") {
            method = settings.bank;
        } else {
            return false;
        }
        var premium = product.premium;
        if (method.weekly === true && premium.weekly.value > 0) {
            _html += '<option id="health_payment_details_frequency_W" value="weekly">Weekly</option>';
        }
        if (method.fortnightly === true && premium.fortnightly.value > 0) {
            _html += '<option id="health_payment_details_frequency_F" value="fortnightly">Fortnightly</option>';
        }
        if (method.monthly === true && premium.monthly.value > 0) {
            _html += '<option id="health_payment_details_frequency_M" value="monthly">Monthly</option>';
        }
        if (method.quarterly === true && premium.quarterly.value > 0) {
            _html += '<option id="health_payment_details_frequency_Q" value="quarterly">Quarterly</option>';
        }
        if (method.halfyearly === true && premium.halfyearly.value > 0) {
            _html += '<option id="health_payment_details_frequency_H" value="halfyearly">Half-yearly</option>';
        }
        if (method.annually === true && premium.annually.value > 0) {
            _html += '<option id="health_payment_details_frequency_A" value="annually">Annually</option>';
        }
        $frequencySelect.html(_html).find("option[value=" + selectedFrequency + "]").attr("selected", "SELECTED");
    }
    function enableUpdatePremium() {
        var $button = $("#update-premium");
        $button.removeClass("disabled");
        var $paymentSection = $("#health_payment_details-selection");
        $paymentSection.find(":input").not(".disabled-by-fund").prop("disabled", false);
        $paymentSection.find(".select").not(".disabled-by-fund").removeClass("disabled");
        $paymentSection.find(".btn-group label").not(".disabled-by-fund").removeClass("disabled");
        $("#health_payment_details_start").parent().find(".datepicker").children().css("visibility", "visible");
        meerkat.modules.loadingAnimation.hide($button);
    }
    function disableUpdatePremium(isSameSource, disableFields) {
        var $button = $("#update-premium");
        $button.addClass("disabled");
        if (disableFields === true) {
            var $paymentSection = $("#health_payment_details-selection");
            $paymentSection.find(":input").prop("disabled", true);
            $paymentSection.find(".select").addClass("disabled");
            $paymentSection.find(".btn-group label").addClass("disabled");
            $("#health_payment_details_start").parent().find(".datepicker").children().css("visibility", "hidden");
        }
        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($button);
        }
    }
    function updatePremium() {
        if (meerkat.modules.journeyEngine.isCurrentStepValid() === false) {
            return false;
        }
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
            source: "healthPaymentStep",
            disableFields: true
        });
        _.defer(function() {
            meerkat.modules.healthResults.getProductData(function(data) {
                if (data === null) {
                    var notAvailableHtml = '<p>Unfortunately this policy is not currently available. Please select another policy or call our Health Insurance Specialists on <span class="callCentreHelpNumber">' + meerkat.site.content.callCentreHelpNumber + "</span> for assistance.</p>" + '<div class="col-sm-offset-4 col-xs-12 col-sm-4">' + '<a class="btn btn-next btn-block" id="select-another-product" href="javascript:;">Select Another Product</a>' + '<a class="btn btn-cta btn-block visible-xs" href="tel:' + meerkat.site.content.callCentreHelpNumber + '">Call Us Now</a>' + "</div>";
                    modalId = meerkat.modules.dialogs.show({
                        title: "Policy not available",
                        htmlContent: notAvailableHtml
                    });
                    $("#select-another-product").on("click", function() {
                        meerkat.modules.dialogs.close(modalId);
                        meerkat.modules.journeyEngine.gotoPath("results");
                    });
                } else {
                    if (_.isArray(data)) data = data[0];
                    meerkat.modules.healthResults.setSelectedProduct(data, true);
                    $premiumContainer.slideDown();
                    $updatePremiumButtonContainer.hide();
                    $paymentContainer.show();
                    if (getSelectedPaymentMethod() === "cc") {
                        $("#health_payment_credit-selection").slideDown();
                        $("#health_payment_bank-selection").hide();
                    } else {
                        $("#health_payment_bank-selection").slideDown();
                        $("#health_payment_credit-selection").hide();
                    }
                    $("#health_declaration-selection").slideDown();
                    toggleClaimsBankAccountQuestion();
                    updatePaymentDayOptions();
                    $("#confirm-step").show();
                }
                meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
                    source: "healthPaymentStep"
                });
            });
        });
    }
    function toggleClaimsBankAccountQuestion() {
        var _type = getSelectedPaymentMethod();
        if (_type == "ba") {
            if ($bankAccountDetailsRadioGroup.find("input:checked").val() == "Y" || settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(":visible") === false) {
                toggleClaimsBankSubQuestion(true);
            } else {
                toggleClaimsBankSubQuestion(false);
            }
            if ($sameBankAccountRadioGroup.find("input:checked").val() == "N") {
                toggleClaimsBankAccountForm(true);
            } else {
                toggleClaimsBankAccountForm(false);
            }
        } else if (_type == "cc") {
            toggleClaimsBankSubQuestion(false);
            if ($bankAccountDetailsRadioGroup.find("input:checked").val() == "Y" || settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(":visible") === false) {
                toggleClaimsBankAccountForm(true);
            } else {
                toggleClaimsBankAccountForm(false);
            }
        }
    }
    function updatePaymentDayOptions() {
        var selected_bank_day = $("#health_payment_bank_day").val();
        var selected_credit_day = $("#health_payment_credit_day").val();
        $("#health_payment_bank_day").empty().append("<option id='health_payment_bank_day_' value='' >Please choose...</option>");
        $("#health_payment_credit_day").empty().append("<option id='health_payment_credit_day_' value='' >Please choose...</option>");
        var option_count;
        var selectedFrequency = getSelectedFrequency();
        if (selectedFrequency !== "") {
            option_count = settings.frequency[getSelectedFrequency()];
        } else {
            option_count = 27;
        }
        for (var i = 1; i <= option_count; i++) {
            $("#health_payment_bank_day").append("<option id='health_payment_bank_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
            $("#health_payment_credit_day").append("<option id='health_payment_credit_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
        }
        if (selected_bank_day) {
            $("#health_payment_bank_day").val(selected_bank_day);
        }
        if (selected_credit_day) {
            $("#health_payment_credit_day").val(selected_credit_day);
        }
    }
    function toggleClaimsBankSubQuestion(show) {
        if (show) {
            $(".health_bank-details_claims_group").slideDown();
        } else {
            $(".health_bank-details_claims_group").slideUp();
        }
    }
    function toggleClaimsBankAccountForm(show) {
        if (show) {
            $(".health-bank_claim_details").slideDown();
        } else {
            $(".health-bank_claim_details").slideUp();
        }
    }
    meerkat.modules.register("healthPaymentStep", {
        init: init,
        events: moduleEvents,
        getSetting: getSetting,
        overrideSettings: overrideSettings,
        setCoverStartRange: setCoverStartRange,
        getSelectedFrequency: getSelectedFrequency,
        getSelectedPaymentMethod: getSelectedPaymentMethod
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, moduleEvents = {}, callCentreNumber = ".callCentreNumber", applicationSteps = [ "apply", "payment" ];
    function init() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChangeChangePhone(step) {
            _.defer(function() {
                changePhoneNumber(false);
            });
        });
    }
    function changePhoneNumber(isModal) {
        var $callCentreFields = $(callCentreNumber), $callCentreHelpFields = $(".callCentreHelpNumber");
        var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];
        if (isModal === true) {
            $callCentreFields = $(".more-info-content").find(callCentreNumber);
        }
        if (applicationSteps.indexOf(navigationId) > -1) {
            $callCentreFields.text(meerkat.site.content.callCentreNumberApplication);
            $callCentreFields.closest(".callCentreNumberClick").attr("href", "tel:" + meerkat.site.content.callCentreNumberApplication);
            $callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumberApplication);
        } else {
            $callCentreFields.text(meerkat.site.content.callCentreNumber);
            $callCentreFields.closest(".callCentreNumberClick").attr("href", "tel:" + meerkat.site.content.callCentreNumber);
            $callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumber);
        }
    }
    meerkat.modules.register("healthPhoneNumber", {
        init: init,
        events: moduleEvents,
        changePhoneNumber: changePhoneNumber
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        healthPriceComponent: {
            INIT: "PRICE_COMPONENT_INITED"
        }
    }, moduleEvents = events.healthPriceComponent;
    var logoPriceTemplate;
    var $policySummaryContainer;
    var $policySummaryTemplateHolder;
    var $policySummaryDetailsComponents;
    var $policySummaryDualPricing = [];
    var $displayedFrequency;
    var $startDateInput;
    function init() {
        jQuery(document).ready(function($) {
            if (meerkat.site.vertical !== "health") return false;
            logoPriceTemplate = $("#logo-price-template").html();
            $policySummaryContainer = $(".policySummaryContainer");
            $policySummaryTemplateHolder = $(".policySummaryTemplateHolder");
            $policySummaryDetailsComponents = $(".productSummaryDetails");
            $policySummaryDualPricing = $(".policySummary.dualPricing");
            if (meerkat.site.pageAction != "confirmation") {
                $displayedFrequency = $("#health_payment_details_frequency");
                $startDateInput = $("#health_payment_details_start");
                meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_CHANGED, function(selectedProduct) {
                    onProductPremiumChange(selectedProduct, false);
                });
                meerkat.messaging.subscribe(meerkatEvents.healthResults.PREMIUM_UPDATED, function(selectedProduct) {
                    onProductPremiumChange(selectedProduct, true);
                });
                meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, function(selectedProduct) {
                    $policySummaryContainer.find(".policyPriceWarning").show();
                });
            }
            applyEventListeners();
            meerkat.messaging.publish(moduleEvents.INIT);
        });
    }
    function onProductPremiumChange(selectedProduct, showIncPrice) {
        var displayedFrequency = $displayedFrequency.val();
        if (displayedFrequency === "") displayedFrequency = Results.getFrequency();
        updateProductSummaryHeader(selectedProduct, displayedFrequency, showIncPrice);
        var startDateString = "Please confirm";
        if ($startDateInput.val() !== "") {
            startDateString = $startDateInput.val();
        }
        updateProductSummaryDetails(selectedProduct, startDateString);
    }
    function updateProductSummaryHeader(product, frequency, showIncPrice) {
        product._selectedFrequency = frequency;
        if (showIncPrice) {
            product.mode = "lhcInc";
        } else {
            product.mode = "";
        }
        product.showAltPremium = false;
        var htmlTemplate = _.template(logoPriceTemplate);
        var htmlString = htmlTemplate(product);
        $policySummaryTemplateHolder.html(htmlString);
        $policySummaryDualPricing.find(".Premium").html(htmlString);
        $policySummaryContainer.find(".policyPriceWarning").hide();
        if ($policySummaryDualPricing.length > 0) {
            product.showAltPremium = true;
            htmlString = htmlTemplate(product);
            $policySummaryDualPricing.find(".altPremium").html(htmlString);
        }
    }
    function updateProductSummaryDetails(product, startDateString, displayMoreInfoLink) {
        $policySummaryDetailsComponents.find(".name").text(product.info.providerName + " " + product.info.name);
        $policySummaryDetailsComponents.find(".startDate").text(startDateString);
        if (typeof product.hospital.inclusions !== "undefined") {
            $policySummaryDetailsComponents.find(".excess").html(product.hospital.inclusions.excess);
            $policySummaryDetailsComponents.find(".excessWaivers").html(product.hospital.inclusions.waivers);
            $policySummaryDetailsComponents.find(".copayment").html(product.hospital.inclusions.copayment);
        }
        $policySummaryDetailsComponents.find(".footer").removeClass("hidden");
        $policySummaryDetailsComponents.find(".excess").parent().removeClass("hidden");
        $policySummaryDetailsComponents.find(".excessWaivers").parent().removeClass("hidden");
        $policySummaryDetailsComponents.find(".copayment").parent().removeClass("hidden");
        if (typeof displayMoreInfoLink != "undefined" && displayMoreInfoLink === false) {
            $policySummaryDetailsComponents.find(".footer").addClass("hidden");
        }
        if (typeof product.hospital.inclusions === "undefined" || product.hospital.inclusions.excess === "") {
            $policySummaryDetailsComponents.find(".excess").parent().addClass("hidden");
        }
        if (typeof product.hospital.inclusions === "undefined" || product.hospital.inclusions.waivers === "") {
            $policySummaryDetailsComponents.find(".excessWaivers").parent().addClass("hidden");
        }
        if (typeof product.hospital.inclusions === "undefined" || product.hospital.inclusions.copayment === "") {
            $policySummaryDetailsComponents.find(".copayment").parent().addClass("hidden");
        }
    }
    function applyEventListeners() {
        $(".btn-show-how-calculated").on("click", function() {
            meerkat.modules.dialogs.show({
                title: "Here is how your premium is calculated:",
                htmlContent: '<p>The BASE PREMIUM is the cost of a policy set by the health fund. This cost excludes any discounts or additional charges that are applied to the policy due to your age or income.</p><p>LHC LOADING is an initiative designed by the Federal Government to encourage people to take out private hospital cover earlier in life. If you&rsquo;re over the age of 31 and don&rsquo;t already have cover, you&rsquo;ll be required to pay a 2% Lifetime Health Cover loading for every year over the age of 30 that you were without hospital cover. The loading is applied to the BASE PREMIUM of the hospital component of your cover if applicable.<br/>For full information please go to: <a href="http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm" target="_blank">http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm</a></p><p>The AUSTRALIAN GOVERNMENT REBATE exists to provide financial assistance to those who need help with the cost of their health insurance premium. It is currently income-tested and tiered according to total income and the age of the oldest person covered by the policy. If you claim a rebate and find at the end of the financial year that it was incorrect for whatever reason, the Australian Tax Office will simply correct the amount either overpaid or owing to you after your tax return has been completed. There is no penalty for making a rebate claim that turns out to have been incorrect. The rebate is calculated against the BASE PREMIUM for both the hospital &amp; extras components of your cover.<br/>For full information please go to: <a href="https://www.ato.gov.au/Calculators-and-tools/Private-health-insurance-rebate-calculator/" target="_blank">https://www.ato.gov.au/Calculators-and-tools/Private-health-insurance-rebate-calculator/</a></p><p>PAYMENT DISCOUNTS can be offered by health funds for people who choose to pay by certain payment methods or pay their premiums upfront. These are applied to the total premium costs.</p>'
            });
        });
    }
    meerkat.modules.register("healthPriceComponent", {
        init: init,
        events: events,
        updateProductSummaryHeader: updateProductSummaryHeader,
        updateProductSummaryDetails: updateProductSummaryDetails
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, defaultPremiumsRange = {
        fortnightly: {
            min: 1,
            max: 300
        },
        monthly: {
            min: 1,
            max: 560
        },
        yearly: {
            min: 1,
            max: 4e3
        }
    };
    function init() {
        $("#filter-frequency input").on("change", onUpdateFrequency);
        $(document).on("resultsDataReady", onUpdatePriceFilterRange);
    }
    function setUp() {
        var frequency = meerkat.modules.healthResults.getFrequencyInWords($("#health_filter_frequency").val());
        $(".health-filter-price .slider-control").trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(frequency, false));
    }
    function onUpdateFrequency() {
        $(".health-filter-price .slider-control").trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(getFrequency(), true));
    }
    function onUpdatePriceFilterRange() {
        $(".health-filter-price .slider-control").trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(getFrequency(), false));
    }
    function getFrequency() {
        var frequency = meerkat.modules.healthResults.getFrequencyInWords($("#filter-frequency input:checked").val());
        if (!frequency) {
            frequency = Results.getFrequency();
        }
        return frequency;
    }
    function getPremiumRange(frequency, isUpdateFrequency) {
        var generalInfo = Results.getReturnedGeneral();
        if (!generalInfo || !generalInfo.premiumRange) {
            premiumsRange = defaultPremiumsRange;
        } else {
            premiumsRange = generalInfo.premiumRange;
        }
        var range = {};
        switch (frequency) {
          case "fortnightly":
            if (premiumsRange.fortnightly.max <= 0) {
                premiumsRange.fortnightly.max = defaultPremiumsRange.fortnightly.max;
            }
            range = premiumsRange.fortnightly;
            break;

          case "monthly":
            if (premiumsRange.monthly.max <= 0) {
                premiumsRange.monthly.max = defaultPremiumsRange.monthly.max;
            }
            range = premiumsRange.monthly;
            break;

          case "annually":
            if (premiumsRange.yearly.max <= 0) {
                premiumsRange.yearly.max = defaultPremiumsRange.yearly.max;
            }
            range = premiumsRange.yearly;
            break;

          default:
            range = premiumsRange.monthly;
        }
        return [ Number(range.min), Number(range.max), isUpdateFrequency ];
    }
    meerkat.modules.register("healthPriceRangeFilter", {
        init: init,
        setUp: setUp
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $resultsLowNumberMessage, $component, selectedProduct = null, previousBreakpoint, best_price_count = 5, isLhcApplicable = "N", premiumIncreaseContent = $(".healthPremiumIncreaseContent"), templates = {
        premiumsPopOver: "{{ if(product.premium.hasOwnProperty(frequency)) { }}" + '<strong>Total Price including rebate and LHC: </strong><span class="highlighted">{{= product.premium[frequency].text }}</span><br/> ' + "<strong>Price including rebate but no LHC: </strong>{{=product.premium[frequency].lhcfreetext}}<br/> " + "<strong>Price including LHC but no rebate: </strong>{{= product.premium[frequency].baseAndLHC }}<br/> " + "<strong>Base price: </strong>{{= product.premium[frequency].base }}<br/> " + "{{ } }}" + "<hr/> " + "{{ if(product.premium.hasOwnProperty('fortnightly')) { }}" + "<strong>Fortnightly (ex LHC): </strong>{{=product.premium.fortnightly.lhcfreetext}}<br/> " + "{{ } }}" + "{{ if(product.premium.hasOwnProperty('monthly')) { }}" + "<strong>Monthly (ex LHC): </strong>{{=product.premium.monthly.lhcfreetext}}<br/> " + "{{ } }}" + "{{ if(product.premium.hasOwnProperty('annually')) { }}" + "<strong>Annually (ex LHC): </strong>{{= product.premium.annually.lhcfreetext}}<br/> " + "{{ } }}" + "<hr/> " + "{{ if(product.hasOwnProperty('info')) { }}" + "<strong>Name: </strong>{{=product.info.productTitle}}<br/> " + "<strong>Product Code: </strong>{{=product.info.productCode}}<br/> " + "<strong>Product ID: </strong>{{=product.productId}}<br/>" + "<strong>State: </strong>{{=product.info.State}}<br/> " + "<strong>Membership Type: </strong>{{=product.info.Category}}" + "{{ } }}"
    }, moduleEvents = {
        healthResults: {
            SELECTED_PRODUCT_CHANGED: "SELECTED_PRODUCT_CHANGED",
            SELECTED_PRODUCT_RESET: "SELECTED_PRODUCT_RESET",
            PREMIUM_UPDATED: "PREMIUM_UPDATED"
        },
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK",
        RESULTS_ERROR: "RESULTS_ERROR"
    };
    function initPage() {
        initResults();
        initCompare();
        Features.init();
        eventSubscriptions();
        breakpointTracking();
    }
    function onReturnToPage() {
        breakpointTracking();
        if (previousBreakpoint !== meerkat.modules.deviceMediaState.get()) {
            Results.view.calculateResultsContainerWidth();
            Features.clearSetHeights();
            Features.balanceVisibleRowsHeight();
        }
        Results.pagination.refresh();
    }
    function initResults() {
        $(".adjustFilters").on("click", function displayFiltersClicked(event) {
            event.preventDefault();
            event.stopPropagation();
            meerkat.modules.healthFilters.open();
        });
        $resultsLowNumberMessage = $(".resultsLowNumberMessage, .resultsMarketingMessages");
        var frequencyValue = $("#health_filter_frequency").val();
        frequencyValue = meerkat.modules.healthResults.getFrequencyInWords(frequencyValue) || "monthly";
        try {
            Results.init({
                url: "ajax/json/health_quote_results.jsp",
                runShowResultsPage: false,
                paths: {
                    results: {
                        list: "results.price",
                        info: "results.info"
                    },
                    brand: "info.Name",
                    productBrandCode: "info.providerName",
                    productId: "productId",
                    productTitle: "info.productTitle",
                    productName: "info.productTitle",
                    price: {
                        annually: "premium.annually.lhcfreevalue",
                        monthly: "premium.monthly.lhcfreevalue",
                        fortnightly: "premium.fortnightly.lhcfreevalue"
                    },
                    availability: {
                        product: "available",
                        price: {
                            annually: "premium.annual.lhcfreevalue",
                            monthly: "premium.monthly.lhcfreevalue",
                            fortnightly: "premium.fortnightly.lhcfreevalue"
                        }
                    },
                    benefitsSort: "info.rank"
                },
                show: {
                    nonAvailablePrices: false
                },
                availability: {
                    price: [ "notEquals", 0 ]
                },
                render: {
                    templateEngine: "_",
                    features: {
                        mode: "populate",
                        headers: false,
                        numberOfXSColumns: 2
                    },
                    dockCompareBar: false
                },
                displayMode: "features",
                pagination: {
                    mode: "page",
                    touchEnabled: Modernizr.touch
                },
                sort: {
                    sortBy: "benefitsSort"
                },
                frequency: frequencyValue,
                animation: {
                    results: {
                        individual: {
                            active: false
                        },
                        delay: 500,
                        options: {
                            easing: "swing",
                            duration: 1e3
                        }
                    },
                    shuffle: {
                        active: false,
                        options: {
                            easing: "swing"
                        }
                    },
                    filter: {
                        reposition: {
                            options: {
                                easing: "swing"
                            }
                        }
                    }
                },
                elements: {
                    features: {
                        values: ".content",
                        extras: ".children"
                    }
                },
                dictionary: {
                    valueMap: [ {
                        key: "Y",
                        value: "<span class='icon-tick'></span>"
                    }, {
                        key: "N",
                        value: "<span class='icon-cross'></span>"
                    }, {
                        key: "R",
                        value: "Restricted"
                    }, {
                        key: "-",
                        value: "&nbsp;"
                    } ]
                },
                rankings: {
                    triggers: [ "RESULTS_DATA_READY" ],
                    callback: meerkat.modules.healthResults.rankingCallback,
                    forceIdNumeric: true
                }
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.healthResults.initResults(); " + e.message, e);
        }
    }
    function initCompare() {
        var compareSettings = {
            compareBarRenderer: ListModeCompareBarRenderer,
            elements: {
                button: ".compareBtn",
                bar: ".compareBar",
                boxes: ".compareBox"
            },
            dictionary: {
                compareLabel: 'Compare <span class="icon icon-arrow-right"></span>',
                clearBasketLabel: 'Clear Shortlist <span class="icon icon-arrow-right"></span>'
            }
        };
        Compare.init(compareSettings);
        $compareBasket = $(Compare.settings.elements.bar);
        $compareBasket.on("compareAdded", function(event, productId) {
            if (meerkat.modules.healthMoreInfo.getOpenProduct() !== null && meerkat.modules.healthMoreInfo.getOpenProduct().productId !== productId) {
                meerkat.modules.healthMoreInfo.close();
            }
            $compareBasket.addClass("active");
            $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]").addClass("compared");
            if (Compare.view.resultsFiltered === false && Compare.model.products.length === Compare.settings.maximum) {
                $(".compareBtn").addClass("compareInActive");
                _.delay(function() {
                    compareResults();
                }, 250);
            }
        });
        $compareBasket.on("compareRemoved", function(event, productId) {
            if (Compare.view.resultsFiltered && Compare.model.products.length >= Compare.settings.minimum) {
                compareResults();
            }
            $element = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]");
            $element.removeClass("compared");
            $element.find(".compareCheckbox input").prop("checked", false);
            if (Compare.model.products.length === 0) {
                $(".compareBar").removeClass("active");
                toggleMarketingMessage(false);
                toggleResultsLowNumberMessage(true);
            }
        });
        $compareBasket.on("compareNonAvailable", function(event) {
            if (Compare.view.resultsFiltered) {
                resetCompare();
            }
        });
        $compareBasket.on("compareBucketFull", function(event) {
            $(".result .compareCheckbox :input").not(":checked").prop("disabled", true);
        });
        $compareBasket.on("compareBucketAvailable", function(event) {
            $(".result .compareCheckbox :input").prop("disabled", false);
        });
        $compareBasket.on("compareClick", function(event) {
            if (!Compare.view.resultsFiltered) {
                compareResults();
            } else {
                resetCompare();
            }
        });
    }
    function resetCompare() {
        $container = $(Results.settings.elements.container);
        if (Results.settings.animation.filter.active) {
            $container.find(".compared").removeClass("compared");
        } else {
            $container.find(".compared").removeClass("compared notfiltered").addClass("filtered");
        }
        $container.find(".compareCheckbox input").prop("checked", false);
        $(".compareBtn").addClass("compareInActive");
        _.defer(function() {
            Compare.unfilterResults();
            _.defer(function() {
                Compare.reset();
            });
        });
    }
    function compareResults() {
        _.defer(function() {
            Compare.filterResults();
            _.defer(function() {
                toggleMarketingMessage(true, 5 - Results.getFilteredResults().length);
                toggleResultsLowNumberMessage(false);
                _.delay(function() {
                    if (Results.settings.render.features.expandRowsOnComparison) {
                        $(".featuresHeaders .featuresList > .section.expandable.collapsed > .content").trigger("click");
                        $(".featuresHeaders .featuresList > .selectionHolder > .children > .category.expandable.collapsed > .content").trigger("click");
                    }
                    if (meerkat.modules.healthMoreInfo.getOpenProduct() !== null) {
                        meerkat.modules.healthMoreInfo.close();
                    }
                    meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                        touchType: "H",
                        touchComment: "ResCompare",
                        simplesUser: meerkat.site.isCallCentreUser
                    });
                    var compareArray = [];
                    var items = Results.getFilteredResults();
                    for (var i = 0; i < items.length; i++) {
                        var product = items[i];
                        compareArray.push({
                            productID: product.productId
                        });
                    }
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackQuoteComparison",
                        object: {
                            products: compareArray,
                            simplesUser: meerkat.site.isCallCentreUser
                        }
                    });
                }, Results.settings.animation.features.scroll.duration + 100);
            });
        });
    }
    function updateBasketCount() {
        var items = Results.getFilteredResults().length;
        var label = items + " product";
        if (items != 1) label = label + "s";
        $(".compareBar .productCount").text(label);
    }
    function eventSubscriptions() {
        $(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function() {
            Features.buildHtml();
        });
        $(document).on("generalReturned", function() {
            var generalInfo = Results.getReturnedGeneral();
            if (generalInfo.pricesHaveChanged) {
                meerkat.modules.dialogs.show({
                    title: "Just a quick note",
                    htmlContent: $("#quick-note").html(),
                    buttons: [ {
                        label: "Show latest results",
                        className: "btn btn-next",
                        closeWindow: true
                    } ]
                });
                $("input[name='health_retrieve_savedResults']").val("N");
            }
        });
        $(document).on("resultsLoaded", onResultsLoaded);
        $(document).on("resultsReturned", function() {
            Compare.reset();
            meerkat.modules.utils.scrollPageTo($("header"));
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");
            if (premiumIncreaseContent.length > 0) {
                _.defer(function() {
                    premiumIncreaseContent.click();
                });
            }
            meerkat.modules.coupon.loadCoupon("filter", null, function successCallBack() {
                meerkat.modules.coupon.renderCouponBanner();
            });
        });
        $(document).on("resultsDataReady", function() {
            updateBasketCount();
            if (meerkat.site.isCallCentreUser) {
                createPremiumsPopOver();
            }
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            toggleMarketingMessage(false);
            toggleResultsLowNumberMessage(false);
            meerkat.modules.journeyEngine.loadingShow("getting your quotes");
            $("header .slide-feature-pagination, header a[data-results-pagination-control]").addClass("hidden");
        });
        meerkat.messaging.subscribe(moduleEvents.RESULTS_ERROR, function resultsError() {
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath("previous");
            }, 1e3);
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            toggleResultsLowNumberMessage(true);
            _.defer(function() {
                $("header .slide-feature-pagination, header a[data-results-pagination-control]").removeClass("hidden");
                Results.pagination.setupNativeScroll();
            });
            meerkat.modules.journeyEngine.loadingHide();
            if (!meerkat.site.isNewQuote && !Results.getSelectedProduct() && meerkat.site.isCallCentreUser) {
                Results.setSelectedProduct($(".health_application_details_productId").val());
                var product = Results.getSelectedProduct();
                if (product) {
                    meerkat.modules.healthResults.setSelectedProduct(product);
                }
            }
            if ($('input[name="health_directApplication"]').val() === "Y") {
                Results.setSelectedProduct(meerkat.site.loadProductId);
                var productMatched = Results.getSelectedProduct();
                if (productMatched) {
                    meerkat.modules.healthResults.setSelectedProduct(productMatched);
                    meerkat.modules.journeyEngine.gotoPath("next");
                } else {
                    var productUpdated = Results.getResult("productTitle", meerkat.site.loadProductTitle);
                    var htmlContent = "";
                    if (productUpdated) {
                        meerkat.modules.healthResults.setSelectedProduct(productUpdated);
                        htmlContent = "Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Please note that for this particular product, " + "the price and/or features have changed since the last time you were comparing. If you need further assistance, " + 'you can chat to one of our Health Insurance Specialists on <span class="callCentreHelpNumber">' + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
                    } else {
                        $("#health_application_productId").val("");
                        $("#health_application_productTitle").val("");
                        htmlContent = "Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Unfortunately the product you're looking for is no longer available. " + "Please head to your results page to compare available policies or alternatively, " + 'chat to one of our Health Insurance Specialists on <span class="callCentreHelpNumber">' + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
                    }
                    meerkat.modules.dialogs.show({
                        title: "Just a quick note",
                        htmlContent: htmlContent,
                        buttons: [ {
                            label: "Show latest results",
                            className: "btn btn-next",
                            closeWindow: true
                        } ]
                    });
                }
                meerkat.site.loadProductId = "";
                meerkat.site.loadProductTitle = "";
                $('input[name="health_directApplication"]').val("");
            }
            $(Results.settings.elements.page).show();
        });
        $(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
            meerkat.modules.performanceProfiling.startTest("results");
        });
        $(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {
            var time = meerkat.modules.performanceProfiling.endTest("results");
            var score;
            if (time < 800) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
            } else if (time < 8e3 && meerkat.modules.performanceProfiling.isIE8() === false) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
            } else {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
            }
            Results.setPerformanceMode(score);
        });
        $(document).on("resultPageChange", function(event) {
            var pageData = event.pageData;
            if (pageData.measurements === null) return false;
            var numberOfPages = pageData.measurements.numberOfPages;
            var items = Results.getFilteredResults().length;
            var columnsPerPage = pageData.measurements.columnsPerPage;
            var freeColumns = columnsPerPage * numberOfPages - items;
            if (freeColumns > 1 && numberOfPages === 1) {
                toggleResultsLowNumberMessage(true);
                toggleMarketingMessage(false);
            } else {
                toggleResultsLowNumberMessage(false);
                if (Compare.view.resultsFiltered === false) {
                    if (pageData.pageNumber === pageData.measurements.numberOfPages && freeColumns > 2) {
                        toggleMarketingMessage(true, freeColumns);
                        return true;
                    }
                    toggleMarketingMessage(false);
                }
            }
        });
        $(document).on("FeaturesRendered", function() {
            $(Features.target + " .expandable > " + Results.settings.elements.features.values).on("mouseenter", function() {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');
                $hoverRow.addClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ""));
            }).on("mouseleave", function() {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');
                $hoverRow.removeClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ""));
            });
        });
        meerkat.messaging.subscribe(meerkatEvents.healthFilters.CHANGED, function onFilterChange(obj) {
            resetCompare();
            if (obj && obj.hasOwnProperty("filter-frequency-change")) {
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function onHealthResultsXsEnterChange() {
            resetCompare();
        });
    }
    function breakpointTracking() {
        if (meerkat.modules.deviceMediaState.get() == "xs") {
            startColumnWidthTracking();
        }
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results") {
                startColumnWidthTracking();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave() {
            stopColumnWidthTracking();
        });
    }
    function startColumnWidthTracking() {
        Results.view.startColumnWidthTracking($(window), Results.settings.render.features.numberOfXSColumns, false);
    }
    function stopColumnWidthTracking() {
        Results.view.stopColumnWidthTracking();
    }
    function recordPreviousBreakpoint() {
        previousBreakpoint = meerkat.modules.deviceMediaState.get();
    }
    function get() {
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
            source: "healthLoadRates"
        });
        meerkat.modules.health.loadRates(function afterFetchRates() {
            meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
                source: "healthLoadRates"
            });
            Results.get();
        });
    }
    function getSelectedProduct() {
        return selectedProduct;
    }
    function getSelectedProductPremium(frequency) {
        var selectedProduct = getSelectedProduct();
        return selectedProduct.premium[frequency];
    }
    function getFrequencyInLetters(frequency) {
        switch (frequency) {
          case "weekly":
            return "W";

          case "fortnightly":
            return "F";

          case "monthly":
            return "M";

          case "quarterly":
            return "Q";

          case "halfyearly":
            return "H";

          case "annually":
            return "A";

          default:
            return false;
        }
    }
    function getFrequencyInWords(frequency) {
        switch (frequency) {
          case "W":
            return "weekly";

          case "F":
            return "fortnightly";

          case "M":
            return "monthly";

          case "Q":
            return "quarterly";

          case "H":
            return "halfyearly";

          case "A":
            return "annually";

          default:
            return false;
        }
    }
    function getNumberOfPeriodsForFrequency(frequency) {
        switch (frequency) {
          case "weekly":
            return 52;

          case "fortnightly":
            return 26;

          case "quarterly":
            return 4;

          case "halfyearly":
            return 2;

          case "annually":
            return 1;

          default:
            return 12;
        }
    }
    function setSelectedProduct(product, premiumChangeEvent) {
        selectedProduct = product;
        var $_main = $("#mainform");
        if (product === null) {
            $_main.find(".health_application_details_provider").val("");
            $_main.find(".health_application_details_productId").val("");
            $_main.find(".health_application_details_productNumber").val("");
            $_main.find(".health_application_details_productTitle").val("");
            $_main.find(".health_application_details_providerName").val("");
        } else {
            $_main.find(".health_application_details_provider").val(selectedProduct.info.provider);
            $_main.find(".health_application_details_productId").val(selectedProduct.productId);
            $_main.find(".health_application_details_productNumber").val(selectedProduct.info.productCode);
            $_main.find(".health_application_details_productTitle").val(selectedProduct.info.productTitle);
            $_main.find(".health_application_details_providerName").val(selectedProduct.info.providerName);
            if (premiumChangeEvent === true) {
                meerkat.messaging.publish(moduleEvents.healthResults.PREMIUM_UPDATED, selectedProduct);
            } else {
                meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_CHANGED, selectedProduct);
                $(Results.settings.elements.rows).removeClass("active");
                var $targetProduct = $(Results.settings.elements.rows + "[data-productid=" + selectedProduct.productId + "]");
                var targetPosition = $targetProduct.data("position") + 1;
                $targetProduct.addClass("active");
                Results.pagination.gotoPosition(targetPosition, true, false);
            }
            meerkat.modules.writeQuote.write({
                health_application_provider: selectedProduct.info.provider,
                health_application_productId: selectedProduct.productId,
                health_application_productName: selectedProduct.info.productCode,
                health_application_productTitle: selectedProduct.info.productTitle
            }, false);
        }
    }
    function resetSelectedProduct() {
        healthFunds.unload();
        setSelectedProduct(null);
        meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_RESET);
    }
    function getProductData(callback) {
        meerkat.modules.health.loadRates(function afterFetchRates(data) {
            if (data === null) {
                callback(null);
            } else {
                var postData = meerkat.modules.journeyEngine.getFormData();
                _.findWhere(postData, {
                    name: "health_showAll"
                }).value = "N";
                _.findWhere(postData, {
                    name: "health_onResultsPage"
                }).value = "N";
                _.findWhere(postData, {
                    name: "health_incrementTransactionId"
                }).value = "N";
                postData.push({
                    name: "health_payment_details_start",
                    value: $("#health_payment_details_start").val()
                });
                postData.push({
                    name: "health_payment_details_type",
                    value: meerkat.modules.healthPaymentStep.getSelectedPaymentMethod()
                });
                postData.push({
                    name: "health_payment_details_frequency",
                    value: meerkat.modules.healthPaymentStep.getSelectedFrequency()
                });
                meerkat.modules.comms.post({
                    url: "ajax/json/health_quote_results.jsp",
                    data: postData,
                    cache: false,
                    errorLevel: "warning",
                    onSuccess: function onGetProductSuccess(data) {
                        Results.model.updateTransactionIdFromResult(data);
                        if (!data.results || !data.results.price || data.results.price.available === "N") {
                            callback(null);
                        } else {
                            callback(data.results.price);
                        }
                    },
                    onError: function onGetProductError(data) {
                        callback(null);
                    }
                });
            }
        });
    }
    function onBenefitsSelectionChange(selectedBenefits, callback) {
        $component.find(".featuresTemplateComponent .selectionHolder [data-skey]").each(function(index, elementA) {
            var $element = $(elementA);
            var key = $element.attr("data-skey");
            var parentKey = $element.attr("data-par-skey");
            var elementIndex = Number($element.attr("data-index"));
            $parentFeatureList = $element.parents(".featuresTemplateComponent").first();
            if (elementIndex === 0) {
                var $item = $parentFeatureList.find('div[data-skey="' + parentKey + '"].hasShortlistableChildren .children').first();
                if ($item.attr("data-skey") === key) {
                    $item.after($element);
                } else {
                    $item.prepend($element);
                }
            } else {
                var beforeIndex = elementIndex - 1;
                $parentFeatureList.find('.hasShortlistableChildren div[data-par-skey="' + parentKey + '"][data-index="' + beforeIndex + '"]').first().after($element);
            }
        });
        for (var i = 0; i < selectedBenefits.length; i++) {
            var key = selectedBenefits[i];
            $component.find('.featuresTemplateComponent div[data-skey="' + key + '"]').each(function(index, elementA) {
                var $element = $(elementA);
                var parentKey = $element.attr("data-par-skey");
                if (parentKey != null) {
                    $parentFeatureList = $element.parents(".featuresTemplateComponent").first();
                    $parentFeatureList.find(".selection_" + parentKey + " .children").first().append($element);
                }
            });
        }
        $component.find(".featuresTemplateComponent > .section.hasShortlistableChildren").each(function(index, elementA) {
            var $element = $(elementA);
            var key = $element.attr("data-skey");
            var $selectionElement = $component.find(".cell.selection_" + key);
            if (selectedBenefits.indexOf(key) === -1) {
                $element.hide();
                $selectionElement.hide();
            } else {
                $element.show();
                var selectedCount = $component.find(".featuresHeaders .selection_" + key + "> .children > .cell").length;
                if (selectedCount === 0) {
                    $selectionElement.hide();
                } else {
                    $selectionElement.show();
                    var $linkedElement = $component.find('.featuresHeaders div[data-skey="' + key + '"]');
                    var availableCount = selectedCount + $linkedElement.find("> .children > .cell").length;
                    $selectionElement.find(".content .extraText .selectedCount").text(selectedCount);
                    $selectionElement.find(".content .extraText .availableCount").text(availableCount);
                }
            }
        });
        if (typeof callback === "undefined") {
            if (meerkat.modules.journeyEngine.getCurrentStepIndex() === 3) {
                get();
            }
        } else {
            callback();
        }
    }
    function onResultsLoaded() {
        if (meerkat.modules.deviceMediaState.get() == "xs") {
            startColumnWidthTracking();
        }
        updateBasketCount();
        try {
            $("#resultsPage .compare").unbind().on("click", function() {
                var $checkbox = $(this);
                var productId = $checkbox.parents(Results.settings.elements.rows).attr("data-productId");
                var productObject = Results.getResult("productId", productId);
                var product = {
                    id: productId,
                    object: productObject
                };
                if ($checkbox.is(":checked")) {
                    Compare.add(product);
                } else {
                    Compare.remove(productId);
                }
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred processing results", "results.tag", "FeaturesResults.setResultsActions(); " + e.message, e);
        }
        if (meerkat.site.isCallCentreUser) {
            createPremiumsPopOver();
        }
    }
    function createPremiumsPopOver() {
        $("#resultsPage .price").each(function() {
            var $this = $(this);
            var productId = $this.parents(Results.settings.elements.rows).attr("data-productId");
            var product = Results.getResultByProductId(productId);
            if (product.hasOwnProperty("premium")) {
                var htmlTemplate = _.template(templates.premiumsPopOver);
                var text = htmlTemplate({
                    product: product,
                    frequency: Results.getFrequency()
                });
                meerkat.modules.popovers.create({
                    element: $this,
                    contentValue: text,
                    contentType: "content",
                    showEvent: "mouseenter click",
                    position: {
                        my: "top center",
                        at: "bottom center"
                    },
                    style: {
                        classes: "priceTooltips"
                    }
                });
            } else {
                meerkat.modules.errorHandling.error({
                    message: "product does not have property premium",
                    page: "healthResults.js",
                    description: "createPremiumsPopOver()",
                    errorLevel: "silent",
                    data: product
                });
            }
        });
    }
    function toggleMarketingMessage(show, columns) {
        var $marketingMessage = $(".resultsMarketingMessage");
        if (show) {
            $marketingMessage.addClass("show").attr("data-columns", columns);
        } else {
            $marketingMessage.removeClass("show");
        }
    }
    function toggleResultsLowNumberMessage(show) {
        var freeColumns;
        if (show) {
            var pageMeasurements = Results.pagination.calculatePageMeasurements();
            if (pageMeasurements == null) {
                show = false;
            } else {
                var items = Results.getFilteredResults().length;
                freeColumns = pageMeasurements.columnsPerPage - items;
                if (freeColumns < 2 || pageMeasurements.numberOfPages !== 1) {
                    show = false;
                }
            }
        }
        if (show) {
            $resultsLowNumberMessage.addClass("show");
            $resultsLowNumberMessage.attr("data-columns", freeColumns);
        } else {
            $resultsLowNumberMessage.removeClass("show");
        }
        return show;
    }
    function rankingCallback(product, position) {
        var data = {};
        var frequency = Results.getFrequency();
        var prodId = product.productId.replace("PHIO-HEALTH-", "");
        data["rank_productId" + position] = prodId;
        data["rank_price_actual" + position] = product.premium[frequency].value.toFixed(2);
        data["rank_price_shown" + position] = product.premium[frequency].lhcfreevalue.toFixed(2);
        data["rank_frequency" + position] = frequency;
        data["rank_lhc" + position] = product.premium[frequency].lhc;
        data["rank_rebate" + position] = product.premium[frequency].rebate;
        data["rank_discounted" + position] = product.premium[frequency].discounted;
        if (_.isNumber(best_price_count) && position < best_price_count) {
            data["rank_provider" + position] = product.info.provider;
            data["rank_providerName" + position] = product.info.providerName;
            data["rank_productName" + position] = product.info.productTitle;
            data["rank_productCode" + position] = product.info.productCode;
            data["rank_premium" + position] = product.premium[Results.settings.frequency].lhcfreetext;
            data["rank_premiumText" + position] = product.premium[Results.settings.frequency].lhcfreepricing;
        }
        return data;
    }
    function publishExtraSuperTagEvents() {
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {
                preferredExcess: getPreferredExcess(),
                paymentPlan: Results.getFrequency(),
                sortBy: Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price",
                simplesUser: meerkat.site.isCallCentreUser,
                isLhcApplicable: isLhcApplicable
            },
            onAfterEventMode: "Load"
        });
    }
    function getPreferredExcess() {
        var excess = null;
        switch ($("#health_excess").val()) {
          case "1":
            excess = "0";
            break;

          case "2":
            excess = "1-250";
            break;

          case "3":
            excess = "251-500";
            break;

          default:
            excess = "ALL";
            break;
        }
        return excess;
    }
    function setLhcApplicable(lhcLoading) {
        isLhcApplicable = lhcLoading > 0 ? "Y" : "N";
    }
    function init() {
        $component = $("#resultsPage");
        meerkat.messaging.subscribe(meerkatEvents.healthBenefits.CHANGED, onBenefitsSelectionChange);
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
    }
    meerkat.modules.register("healthResults", {
        init: init,
        events: moduleEvents,
        initPage: initPage,
        onReturnToPage: onReturnToPage,
        get: get,
        getSelectedProduct: getSelectedProduct,
        setSelectedProduct: setSelectedProduct,
        resetSelectedProduct: resetSelectedProduct,
        getProductData: getProductData,
        getSelectedProductPremium: getSelectedProductPremium,
        getNumberOfPeriodsForFrequency: getNumberOfPeriodsForFrequency,
        getFrequencyInLetters: getFrequencyInLetters,
        getFrequencyInWords: getFrequencyInWords,
        stopColumnWidthTracking: stopColumnWidthTracking,
        toggleMarketingMessage: toggleMarketingMessage,
        toggleResultsLowNumberMessage: toggleResultsLowNumberMessage,
        onBenefitsSelectionChange: onBenefitsSelectionChange,
        recordPreviousBreakpoint: recordPreviousBreakpoint,
        rankingCallback: rankingCallback,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        setLhcApplicable: setLhcApplicable
    });
})(jQuery);

(function($, undefined) {
    function init() {
        jQuery(document).ready(function($) {
            if (meerkat.modules.performanceProfiling.isSafariAffectedByColumnCountBug()) {
                $(".benefits-component .benefits-list .children").css("-webkit-column-count", "1");
            }
        });
    }
    meerkat.modules.register("healthSafariColumnCountFix", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, debug = meerkat.logging.debug, exception = meerkat.logging.exception;
    var currentSegments = false;
    function filterSegments() {
        meerkat.modules.comms.get({
            url: "segment/filter.json",
            cache: false,
            errorLevel: "silent",
            dataType: "json",
            useDefaultErrorHandling: false
        }).done(function onSuccess(json) {
            setCurrentSegments(json);
            hideBySegment();
        }).fail(function onError(obj, txt, errorThrown) {
            exception(txt + ": " + errorThrown);
        });
    }
    function hideBySegment() {
        if (currentSegments.hasOwnProperty("segments") && currentSegments.segments.length > 0) {
            _.each(currentSegments.segments, function(segment) {
                if (canHide(segment) === true) {
                    $("." + segment.classToHide).css("visibility", "hidden");
                }
            });
        }
    }
    function isSegmentsValid(segment) {
        if (!segment.hasOwnProperty("segmentId") || isNaN(segment.segmentId) || segment.segmentId <= 0) {
            debug("Segment is not valid");
            return false;
        }
        if (segment.hasOwnProperty("errors") && segment.errors.length > 0) {
            debug(segment.errors[0].message);
            return false;
        }
        return true;
    }
    function canHide(segment) {
        if (isSegmentsValid(segment) !== true) return false;
        if (!segment.hasOwnProperty("canHide") || segment.canHide !== true) return false;
        if (!segment.hasOwnProperty("classToHide") || segment.classToHide.length === 0 || !segment.classToHide.trim()) return false;
        return true;
    }
    function getCurrentSegments() {
        return currentSegments;
    }
    function setCurrentSegments(segments) {
        currentSegments = segments;
    }
    meerkat.modules.register("healthSegment", {
        filterSegments: filterSegments,
        hideBySegment: hideBySegment
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, rebateTiers = {
        single: {
            incomeBaseTier: 9e4,
            incomeTier1: {
                from: 90001,
                to: 105e3
            },
            incomeTier2: {
                from: 105001,
                to: 14e4
            },
            incomeTier3: 140001
        },
        familyOrCouple: {
            incomeBaseTier: 18e4,
            incomeTier1: {
                from: 180001,
                to: 21e4
            },
            incomeTier2: {
                from: 210001,
                to: 28e4
            },
            incomeTier3: 280001
        }
    }, $dependants, $incomeMessage, $incomeBase, $income, $tier, $medicare;
    init = function() {
        $dependants = $("#health_healthCover_dependants");
        $incomeMessage = $("#health_healthCover_incomeMessage");
        $incomeBase = $("#health_healthCover_incomeBase");
        $income = $("#health_healthCover_income");
        $tier = $("#health_healthCover_tier");
        $medicare = $(".health-medicare_details");
    };
    setTiers = function(initMode) {
        var _allowance = $dependants.val() - 1;
        if (_allowance > 0) {
            _allowance = _allowance * 1500;
            $incomeMessage.text("this includes an adjustment for your dependants");
        } else {
            _allowance = 0;
            $incomeMessage.text("");
        }
        var _cover;
        if ($incomeBase.is(":visible") && $("#health_healthCover_incomeBase").find(":checked").length > 0) {
            _cover = $incomeBase.find(":checked").val();
        } else {
            _cover = healthChoices.returnCoverCode();
        }
        $income.find("option").each(function() {
            var $this = $(this);
            var _value = $this.val();
            var _text = "";
            if (meerkat.modules.health.getRates() === null) {
                _ageBonus = 0;
            } else {
                _ageBonus = parseInt(meerkat.modules.health.getRates().ageBonus);
            }
            if (_cover === "S" || _cover === "SM" || _cover === "SF" || _cover === "") {
                switch (_value) {
                  case "0":
                    _text = "$" + formatMoney(rebateTiers.single.incomeBaseTier + _allowance) + " or less";
                    break;

                  case "1":
                    _text = "$" + formatMoney(rebateTiers.single.incomeTier1.from + _allowance) + " - $" + formatMoney(rebateTiers.single.incomeTier1.to + _allowance);
                    break;

                  case "2":
                    _text = "$" + formatMoney(rebateTiers.single.incomeTier2.from + _allowance) + " - $" + formatMoney(rebateTiers.single.incomeTier2.to + _allowance);
                    break;

                  case "3":
                    _text = "$" + formatMoney(rebateTiers.single.incomeTier3 + _allowance) + "+ (no rebate)";
                    break;
                }
            } else {
                switch (_value) {
                  case "0":
                    _text = "$" + formatMoney(rebateTiers.familyOrCouple.incomeBaseTier + _allowance) + " or less";
                    break;

                  case "1":
                    _text = "$" + formatMoney(rebateTiers.familyOrCouple.incomeTier1.from + _allowance) + " - $" + formatMoney(rebateTiers.familyOrCouple.incomeTier1.to + _allowance);
                    break;

                  case "2":
                    _text = "$" + formatMoney(rebateTiers.familyOrCouple.incomeTier2.from + _allowance) + " - $" + formatMoney(rebateTiers.familyOrCouple.incomeTier2.to + _allowance);
                    break;

                  case "3":
                    _text = "$" + formatMoney(rebateTiers.familyOrCouple.incomeTier3 + _allowance) + "+ (no rebate)";
                    break;
                }
            }
            if (_text !== "") {
                $this.text(_text);
            }
            if (healthCoverDetails.getRebateChoice() == "N" || !healthCoverDetails.getRebateChoice()) {
                if (initMode) {
                    $tier.hide();
                } else {
                    $tier.slideUp();
                }
                $medicare.hide();
                meerkat.modules.form.clearInitialFieldsAttribute($medicare);
            } else {
                if (initMode) {
                    $tier.show();
                } else {
                    $tier.slideDown();
                }
                $medicare.show();
            }
        });
    };
    meerkat.modules.register("healthTiers", {
        init: init,
        setTiers: setTiers
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {
        simplesSnapshot: {}
    }, $simplesSnapshot = $(".simplesSnapshot");
    var elements = {
        journeyName: "#health_contactDetails_name",
        journeySituation: "#health_situation_healthCvr",
        journeyState: "#health_situation_state",
        applicationState: "#health_application_address_state",
        journeyPostCode: "#health_situation_postcode",
        applicationPostCode: "#health_application_address_postCode",
        applicationFirstName: "#health_application_primary_firstname",
        applicationSurame: "#health_application_primary_surname"
    };
    function applyEventListeners() {
        $(document).ready(function() {
            renderSnapshot();
            $(elements.journeyName + ", " + elements.journeySituation + ", " + elements.journeyState + ", " + elements.applicationState + ", " + elements.journeyPostCode + ", " + elements.applicationPostCode + ", " + elements.applicationFirstName + ", " + elements.applicationSurame).on("change", function() {
                setTimeout(function() {
                    renderSnapshot();
                }, 50);
            });
        });
    }
    function initSimplesSnapshot() {
        console.log("[Simples Snapshot] Initiated.");
        applyEventListeners();
    }
    function renderSnapshot() {
        if ($(elements.journeySituation + " option:selected").val() !== "" || $(elements.journeyState).val() !== "" || $(elements.journeyPostCode).val() !== "") {
            $simplesSnapshot.removeClass("hidden");
        }
        if ($(elements.applicationFirstName).val() === "" && $(elements.applicationSurame).val() === "") {
            $(".snapshotApplicationFirstName, .snapshotApplicationSurname").hide();
            $(".snapshotJourneyName").show();
        } else {
            $(".snapshotApplicationFirstName, .snapshotApplicationSurname").show();
            $(".snapshotJourneyName").hide();
        }
        if ($(elements.applicationState).val() === "") {
            $(".snapshotApplicationState").hide();
            $(".snapshotJourneyState").show();
        } else {
            $(".snapshotApplicationState").show();
            $(".snapshotJourneyState").hide();
        }
        if ($(elements.applicationPostcode).val() === "") {
            $(".snapshotApplicationPostcode").hide();
            $(".snapshotJourneyPostcode").show();
        } else {
            $(".snapshotApplicationPostcode").show();
            $(".snapshotJourneyPostcode").hide();
        }
        meerkat.modules.contentPopulation.render("#navbar-main .transactionIdContainer .simplesSnapshot");
    }
    meerkat.modules.register("simplesSnapshot", {
        initSimplesSnapshot: initSimplesSnapshot,
        events: events
    });
})(jQuery);