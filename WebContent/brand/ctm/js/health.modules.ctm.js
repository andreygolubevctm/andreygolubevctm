/*!
 * CTM-Platform v0.8.1
 * Copyright 2014 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

var healthFunds_HCF = {
    set: function() {},
    unset: function() {}
};

var healthFunds_AHM = {
    set: function() {
        healthFunds._dependants("ahm Health Insurance provides cover for your children up to the age of 21 plus students who are single and studying full time aged between 21 and 25. Adult dependants outside this criteria can be covered by an additional premium on certain covers so please call Compare the Market on 1800777712 or chat to our consultants online to discuss your health cover needs.");
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
            quarterly: false,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: true,
            fortnightly: true,
            monthly: true,
            quarterly: false,
            halfyearly: false,
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
            var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
            if (freq == "weekly" || freq == "fortnightly") {
                healthFunds._payments = {
                    min: 3,
                    max: 8,
                    weekends: false
                };
            } else {
                healthFunds._payments = {
                    min: 3,
                    max: 32,
                    weekends: true
                };
            }
            var _html = healthFunds._paymentDays($("#health_payment_details_start").val());
            healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), _html);
            healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), _html);
            if (freq == "monthly" || freq == "annually") {
                $(".health-bank_details-policyDay option, .health-credit-card_details-policyDay option").each(function(index) {
                    if (this.value.length >= 3) {
                        var end = this.value.substring(this.value.length - 3);
                        if (end == "-29" || end == "-30" || end == "-31") {
                            $(this).remove();
                        }
                    }
                });
            }
        });
        $("#health_payment_details_frequency, #health_payment_details_start ,#health_payment_details_type").on("change.AHM", function() {
            healthFunds.paymentGateway.clearValidation();
        });
        meerkat.modules.healthPaymentStep.setCoverStartRange(1, 28);
        healthFunds.paymentGateway = paymentGateway;
        healthFunds.paymentGateway.src = "ajax/html/health_paymentgateway.jsp";
        healthFunds.paymentGateway.init("health_payment_gateway");
        healthFunds.paymentGateway.handledType.credit = true;
        healthFunds.paymentGateway.handledType.bank = false;
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
        healthFunds.paymentGateway.reset();
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
            amex: true,
            diners: false
        };
        creditCardDetails.render();
        healthFunds.applicationFailed = function() {
            referenceNo.generateNewTransactionID(3);
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
    set: function() {
        healthFunds._dependants("This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.");
        healthFunds._previousfund_authority(true);
        healthFunds.$_optionDR = $(".person-title").find("option[value=DR]").first();
        $(".person-title").find("option[value=DR]").remove();
        $("#update-premium").on("click.FRA", function() {
            var _html = healthFunds._earliestDays($("#health_payment_details_start").val(), new Array(1, 15), 7);
            healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), _html);
            healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), _html);
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

var healthFunds_GMF = {
    set: function() {
        healthFunds._dependants("This policy provides cover for your children up to their 21st birthday. Dependants aged under 25 may also be added to the policy provided they are not married or in a defacto relationship and earn less than $20,500 p/annum. Adult dependants outside these criteria can still be covered by applying for a separate policy.");
        healthDependents.config = {
            school: false,
            defacto: true,
            defactoMin: 21,
            defactoMax: 24
        };
        $("#clientMemberID input").rules("remove", "required");
        $("#partnerMemberID input").rules("remove", "required");
        healthFunds_GMF.$_medicareMessage = $("#health_medicareDetails_message");
        healthFunds_GMF.$_medicareMessage.text("GMF will send you an email shortly so that your rebate can be applied to the premium");
        if (healthFunds_GMF.$_medicareMessage.siblings("input").val() !== "") {
            healthFunds_GMF.$_medicareMessage.fadeIn();
        } else {
            healthFunds_GMF.$_medicareMessage.hide();
            healthFunds_GMF.$_medicareMessage.siblings("input").on("change.GMF", function() {
                if ($(this).val() !== "") {
                    healthFunds_GMF.$_medicareMessage.fadeIn();
                }
            });
        }
        meerkat.modules.healthPaymentStep.overrideSettings("bank", {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: true,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("credit", {
            weekly: false,
            fortnightly: true,
            monthly: true,
            quarterly: true,
            halfyearly: false,
            annually: true
        });
        meerkat.modules.healthPaymentStep.overrideSettings("frequency", {
            weekly: 28,
            fortnightly: 28,
            monthly: 28,
            quarterly: 28,
            halfyearly: 28,
            annually: 28
        });
        meerkat.modules.healthPaymentStep.overrideSettings("creditBankQuestions", true);
        creditCardDetails.config = {
            visa: true,
            mc: true,
            amex: false,
            diners: false
        };
        creditCardDetails.render();
    },
    unset: function() {
        healthFunds._reset();
        healthFunds._dependants(false);
        healthFunds_GMF.$_medicareMessage.text("").hide();
        healthFunds_GMF.$_medicareMessage.siblings("input").unbind("change.GMF");
        delete healthFunds_GMF.$_medicareMessage;
        creditCardDetails.resetConfig();
        creditCardDetails.render();
    }
};

var healthFunds_GMH = {
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
        $("#update-premium").on("click.GMH", function() {
            var _html = healthFunds._earliestDays($("#health_payment_details_start").val(), [ 1 ], 7);
            healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), _html);
        });
    },
    unset: function() {
        healthFunds._reset();
        healthFunds._previousfund_authority(false);
        healthFunds._dependants(false);
        $("#mainform").find(".health_dependant_details_schoolGroup").find(".control-label").text(healthFunds._schoolLabel);
        creditCardDetails.resetConfig();
        creditCardDetails.render();
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        $("#update-premium").off("click.GMH");
    }
};

var healthFunds_NIB = {
    set: function() {
        healthApplicationDetails.showHowToSendInfo("NIB", true);
        healthFunds._partner_authority(true);
        healthFunds._dependants("This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 24 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.");
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
    set: function() {
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
        healthFunds._dependants("As a member of Westfund, your children aged between 18-24 are entitled to stay on your cover at no extra charge if they are a full time or part-time student at School, college or University TAFE institution or serving an Apprenticeship or Traineeship.");
        healthDependents.config = {
            school: true,
            defacto: false,
            schoolMin: 18,
            schoolMax: 24,
            schoolID: true
        };
        healthFunds_WFD.$_declaration = $("#health_declaration-selection");
        healthFunds_WFD.$_declaration.addClass("hidden");
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
            if (distance < 1) {
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
        healthFunds_WFD.defaultAgeMin = dob_health_application_primary_dob.ageMin;
        dob_health_application_primary_dob.ageMin = 18;
        healthFunds_WFD.$_dobPrimary.rules("add", {
            messages: {
                min_DateOfBirth: healthFunds_WFD.$_dobPrimary.attr("title") + " age cannot be under " + dob_health_application_primary_dob.ageMin
            }
        });
        healthFunds_WFD.$_dobPartner = $("#health_application_partner_dob");
        dob_health_application_partner_dob.ageMin = 18;
        healthFunds_WFD.$_dobPartner.rules("add", {
            messages: {
                min_DateOfBirth: healthFunds_WFD.$_dobPartner.attr("title") + " age cannot be under " + dob_health_application_partner_dob.ageMin
            }
        });
    },
    unset: function() {
        $("#update-premium").off("click.WFD");
        healthFunds._paymentDaysRender($(".health-credit-card_details-policyDay"), false);
        healthFunds._paymentDaysRender($(".health-bank_details-policyDay"), false);
        healthFunds._reset();
        healthFunds._dependants(false);
        healthFunds_WFD.$_declaration.removeClass("hidden");
        healthFunds_WFD.$_declaration = undefined;
        $(".health-payment-details_premium .statement").remove();
        $("#health_previousfund_primary_fundName").attr("required", "required");
        $("#health_previousfund_partner_fundName").attr("required", "required");
        healthFunds._previousfund_authority(false);
        dob_health_application_primary_dob.ageMin = healthFunds_WFD.defaultAgeMin;
        healthFunds_WFD.$_dobPrimary.rules("add", {
            messages: {
                min_DateOfBirth: healthFunds_WFD.$_dobPrimary.attr("title") + " age cannot be under " + dob_health_application_primary_dob.ageMin
            }
        });
        dob_health_application_partner_dob.ageMin = healthFunds_WFD.defaultAgeMin;
        healthFunds_WFD.$_dobPrimary.rules("add", {
            messages: {
                min_DateOfBirth: healthFunds_WFD.$_dobPartner.attr("title") + " age cannot be under " + dob_health_application_partner_dob.ageMin
            }
        });
        delete healthFunds_WFD.defaultAgeMin;
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

$(document).ready(function() {
    $("#health_contactDetails_optin").on("click", function() {
        $("#health_contactDetails_optInEmail").val($(this).is(":checked") ? "Y" : "N");
    });
    $("input.phone").on("blur", function(event) {
        var id = $(this).attr("id");
        var hiddenFieldName = id.substr(0, id.indexOf("input"));
        var hiddenField = $("#" + hiddenFieldName);
    });
    var applicationEmailElement;
    var emailOptinElement;
    var optIn;
    if ($("#health_altContactFormRendered")) {
        applicationEmailElement = $("#health_application_email");
        emailOptinElement = $("#health_application_optInEmail");
        applicationEmailElement.on("blur", function() {
            optIn = false;
            var email = $(this).val();
            if (isValidEmailAddress(email)) {
                optIn = true;
            }
        });
        $(document).on(meerkat.modules.events.saveQuote.EMAIL_CHANGE, function(event, optIn, emailAddress) {
            if (!isValidEmailAddress(applicationEmailElement.val()) && isValidEmailAddress(emailAddress) && optIn) {
                applicationEmailElement.val(emailAddress).trigger("blur");
            }
        });
    } else {
        applicationEmailElement = $("#health_application_email");
        emailOptInElement = $("#health_application_optInEmail");
        emailOptInElement.change(function() {
            optIn = $(this).is(":checked");
        });
        applicationEmailElement.change(function() {
            optIn = emailOptInElement.is(":checked");
            emailOptInElement.show();
            $("label[for='health_application_optInEmail']").show();
        });
        $(document).on(meerkat.modules.events.saveQuote.EMAIL_CHANGE, function(event, optIn, emailAddress) {
            if (!isValidEmailAddress(applicationEmailElement.val())) {
                applicationEmailElement.val(emailAddress);
            }
            if (applicationEmailElement.val() == emailAddress) {
                if (optIn) {
                    emailOptInElement.prop("checked", true);
                    emailOptInElement.hide();
                    $("label[for='health_application_optInEmail']").hide();
                } else {
                    emailOptInElement.prop("checked", null);
                    emailOptInElement.show();
                    $("label[for='health_application_optInEmail']").show();
                }
            }
        });
    }
    healthDependents.init();
});

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
        healthCoverDetails.setTiers(initMode);
        if (typeof priceMinSlider !== "undefined") {
            priceMinSlider.reset();
        }
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
        healthCoverDetails.setTiers();
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
        if (healthChoices._cover == "S" && healthCoverDetails.getRebateChoice() == "Y") {
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
    getRebateAmount: function(base, age_bonus) {
        age_bonus = age_bonus || 0;
        return ((base + age_bonus) * HealthSettings.rebate_multiplier_current).toFixed(HealthSettings.rebate_multiplier_current !== 1 ? 3 : 0);
    },
    setTiers: function(initMode) {
        var _allowance = $("#health_healthCover_dependants").val() - 1;
        if (_allowance > 0) {
            _allowance = _allowance * 1500;
            $("#health_healthCover_incomeMessage").text("this includes an adjustment for your dependants");
        } else {
            _allowance = 0;
            $("#health_healthCover_incomeMessage").text("");
        }
        var _cover;
        if ($("#health_healthCover_incomeBase").is(":visible") && $("#health_healthCover_incomeBase").find(":checked").length > 0) {
            _cover = $("#health_healthCover_incomeBase").find(":checked").val();
        } else {
            _cover = healthChoices.returnCoverCode();
        }
        $("#health_healthCover_income").find("option").each(function() {
            var $this = $(this);
            var _value = $this.val();
            var _text = "";
            if (meerkat.modules.health.getRates() === null) {
                _ageBonus = 0;
            } else {
                _ageBonus = parseInt(meerkat.modules.health.getRates().ageBonus);
            }
            if (_cover == "S" || _cover == "") {
                switch (_value) {
                  case "0":
                    _text = "$" + (88e3 + _allowance) + " or less";
                    break;

                  case "1":
                    _text = "$" + (88001 + _allowance) + " - $" + (102e3 + _allowance);
                    break;

                  case "2":
                    _text = "$" + (102001 + _allowance) + " - $" + (136e3 + _allowance);
                    break;

                  case "3":
                    _text = "$" + (136001 + _allowance) + "+ (no rebate)";
                    break;
                }
            } else {
                switch (_value) {
                  case "0":
                    _text = "$" + (176e3 + _allowance) + " or less";
                    break;

                  case "1":
                    _text = "$" + (176001 + _allowance) + " - $" + (204e3 + _allowance);
                    break;

                  case "2":
                    _text = "$" + (204001 + _allowance) + " - $" + (272e3 + _allowance);
                    break;

                  case "3":
                    _text = "$" + (272e3 + _allowance) + "+ (no rebate)";
                    break;
                }
            }
            if (_text != "") {
                $this.text(_text);
            }
            if (healthCoverDetails.getRebateChoice() == "N" || !healthCoverDetails.getRebateChoice()) {
                if (initMode) {
                    $("#health_healthCover_tier").hide();
                } else {
                    $("#health_healthCover_tier").slideUp();
                }
                $(".health-medicare_details").hide();
            } else {
                if (initMode) {
                    $("#health_healthCover_tier").show();
                } else {
                    $("#health_healthCover_tier").slideDown();
                }
                $(".health-medicare_details").show();
            }
        });
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

Number.prototype.formatMoney = function(c, d, t) {
    c = isNaN(c = Math.abs(c)) ? 2 : c;
    d = d == undefined ? "." : d;
    t = t == undefined ? "," : t;
    var n = this, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return "$" + s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

isValidEmailAddress = function(emailAddress) {
    var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    return pattern.test(emailAddress);
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
            $.ajax({
                url: "common/js/health/healthFunds_" + fund + ".jsp",
                dataType: "script",
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
        el.append('<label class="btn btn-default"><input id="health_application_contactPoint_' + formValue + '" type="radio" data-msg-required="Please choose " value="' + formValue + '" name="health_application_contactPoint">' + labelText + "</label>");
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

var paymentGateway = {
    name: "",
    handledType: {},
    _hasRegistered: false,
    _type: "",
    _calledBack: false,
    _timeout: false,
    modalId: "",
    hasRegistered: function() {
        return this._hasRegistered;
    },
    success: function(params) {
        if (!params || !params.number || !params.type || !params.expiry || !params.name) {
            this.fail("Registration response parameters invalid");
            return false;
        }
        this._hasRegistered = true;
        this._outcome(true);
        $("#" + paymentGateway.name + "-registered").val("1").valid();
        $("#" + paymentGateway.name + "_number").val(params.number);
        $("#" + paymentGateway.name + "_type").val(params.type);
        $("#" + paymentGateway.name + "_expiry").val(params.expiry);
        $("#" + paymentGateway.name + "_name").val(params.name);
        $("." + paymentGateway.name + " .launcher").slideUp();
        $("." + paymentGateway.name + " .success").slideDown();
        $("." + paymentGateway.name + " .fail").slideUp();
    },
    fail: function(_msg) {
        this._outcome(false);
        $("#" + paymentGateway.name + "-registered").val("");
        $("#" + paymentGateway.name + "_number").val("");
        $("#" + paymentGateway.name + "_type").val("");
        $("#" + paymentGateway.name + "_expiry").val("");
        $("#" + paymentGateway.name + "_name").val("");
        $("." + paymentGateway.name + " .launcher").slideDown();
        $("." + paymentGateway.name + " .success").slideUp();
        $("." + paymentGateway.name + " .fail").slideDown();
        if (_msg && _msg.length > 0) {
            meerkat.modules.errorHandling.error({
                message: _msg,
                page: "health_quote.jsp",
                description: "paymentGateway.fail()",
                silent: true
            });
        }
    },
    _outcome: function(success) {
        this._calledBack = true;
        meerkat.modules.dialogs.destroyDialog(paymentGateway.modalId);
    },
    setType: function(type) {
        if (this._type != type) {
            this._hasRegistered = false;
        }
        if (type == "cc" && this.handledType.credit || type == "ba" && this.handledType.bank) {
            this._type = type;
        } else {
            this._type = "";
        }
        this.togglePanels();
        return this._type != "";
    },
    setTypeFromControl: function() {
        this.setType(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod());
        this.setType($("input[name='health_payment_details_type']:checked").val());
    },
    togglePanels: function() {
        if (this.hasRegistered()) {
            $("." + paymentGateway.name + " .launcher").slideUp();
            $("." + paymentGateway.name + " .success").slideDown();
            $("." + paymentGateway.name + " .fail").slideUp();
        } else {
            $("#" + paymentGateway.name + "-registered").val("");
            $("." + paymentGateway.name + " .launcher").slideDown();
            $("." + paymentGateway.name + " .success").slideUp();
            $("." + paymentGateway.name + " .fail").slideUp();
        }
        switch (this._type) {
          case "cc":
            $("." + paymentGateway.name + "-credit").slideDown();
            $("#" + paymentGateway.name + "-registered").rules("add", {
                required: true,
                messages: {
                    required: "Please register your credit card details"
                }
            });
            break;

          default:
            $("." + paymentGateway.name + "-credit").slideUp("", "", function() {
                $(this).hide();
            });
            $("#" + paymentGateway.name + "-registered").rules("remove", "required");
        }
    },
    reset: function() {
        this.handledType = {
            credit: false,
            bank: false
        };
        this._type = "";
        this._hasRegistered = false;
        this.togglePanels();
        $("body").removeClass(paymentGateway.name + "-active");
        this.clearValidation();
        $("#" + paymentGateway.name + "-registered").val("");
        $("#health_payment_details_claims").find("input").off("change." + paymentGateway.name);
        $("#update-premium").off("click." + paymentGateway.name);
        $("#health_payment_details_type").trigger("change");
    },
    clearValidation: function() {
        $("#" + paymentGateway.name + "-registered").rules("remove", "required");
    },
    init: function(name) {
        paymentGateway.name = name;
        this.reset();
        $("body").addClass(paymentGateway.name + "-active");
        $("#update-premium").on("click." + paymentGateway.name, function() {
            paymentGateway.setTypeFromControl();
        });
    },
    launch: function() {
        paymentGateway._calledBack = false;
        meerkat.modules.tracking.recordSupertag("trackCustomPage", "Payment gateway popup");
        paymentGateway.modalId = meerkat.modules.dialogs.show({
            htmlContent: meerkat.modules.loadingAnimation.getTemplate(),
            onOpen: function(id) {
                clearTimeout(paymentGateway._timeout);
                paymentGateway._timeout = setTimeout(function() {
                    var type = "";
                    if (paymentGateway._type == "ba") {
                        type = "DD";
                    }
                    meerkat.modules.dialogs.changeContent(id, '<iframe width="100%" height="340" frameBorder="0" src="ajax/html/health_paymentgateway.jsp?type=' + type + '"></iframe>');
                }, 1e3);
            },
            onClose: function() {
                clearTimeout(paymentGateway._timeout);
                if (!paymentGateway._calledBack) {
                    paymentGateway.fail();
                }
            }
        });
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
    addSchool: function(index, age) {
        if (healthDependents.config.school === false) {
            $("#health_application_dependants-selection").find(".health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup").hide();
            return false;
        }
        if (age >= healthDependents.config.schoolMin && age <= healthDependents.config.schoolMax) {
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {
        health: {
            CHANGE_MAY_AFFECT_PREMIUM: "CHANGE_MAY_AFFECT_PREMIUM"
        },
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var hasSeenResultsScreen = false;
    var rates = null;
    var steps = null;
    function initJourneyEngine() {
        if (HealthSettings.pageAction === "confirmation") {
            meerkat.modules.journeyEngine.configure(null);
        } else {
            initProgressBar(false);
            var startStepId = null;
            if (HealthSettings.isFromBrochureSite === true) {
                startStepId = steps.detailsStep.navigationId;
            } else if (HealthSettings.journeyStage.length > 0 && HealthSettings.pageAction === "amend") {
                if (HealthSettings.journeyStage === "apply" || HealthSettings.journeyStage === "payment") {
                    startStepId = "results";
                } else {
                    startStepId = HealthSettings.journeyStage;
                }
            }
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
            var transaction_id = referenceNo.getTransactionID(false);
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackQuoteEvent",
                object: {
                    action: "Start",
                    transactionID: parseInt(transaction_id, 10)
                }
            });
            if (HealthSettings.isNewQuote === false) {
                if (HealthSettings.isCallCentreUser === true) {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "contactCentreUser",
                        object: {
                            contactCentreID: HealthSettings.userId,
                            quoteReferenceNumber: transaction_id,
                            transactionID: transaction_id,
                            productID: HealthSettings.productId
                        }
                    });
                } else {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackQuoteEvent",
                        object: {
                            action: "Retrieve",
                            transactionID: transaction_id
                        }
                    });
                }
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
                if ($("#health_privacyoptin[type=hidden]").length === 1) {
                    $(".slide-feature-emailquote").addClass("privacyOptinChecked");
                }
                $(".health-situation-healthSitu").on("change", function(event) {
                    meerkat.modules.healthBenefits.getBenefitsForSituation($(this).val());
                });
                if ($(".health-situation-healthSitu").val() !== "") {
                    $(".health-situation-healthSitu").change();
                }
                var emailQuoteBtn = $(".slide-feature-emailquote");
                $("#health_privacyoptin").on("change", function(event) {
                    var $this = $(this);
                    if ($this.is(":checked") || $this.attr("type") === "hidden" && $this.val === "Y") {
                        emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });
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
                    healthCoverDetails.setTiers();
                });
                $("#health_healthCover-selection").find(".health_cover_details_rebate").on("change", function() {
                    healthCoverDetails.setIncomeBase();
                    healthChoices.dependants();
                    healthCoverDetails.setTiers();
                });
                if (meerkat.site.isCallCentreUser === true) {
                    $("#health_healthCover_incomeBase").find("input").on("change", function() {
                        $("#health_healthCover_income").prop("selectedIndex", 0);
                        healthCoverDetails.setTiers();
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
                            healthCoverDetails.setTiers();
                        });
                    }
                });
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
            },
            onAfterEnter: function(event) {
                if (meerkat.modules.deviceMediaState.get() === "xs") {
                    meerkat.modules.utilities.scrollPageTo("html", 0, 1);
                }
                if (meerkat.site.isCallCentreUser === true) {
                    $("#journeyEngineSlidesContainer .journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find(".simples-dialogue").hide();
                }
                if (event.isStartMode === false) {
                    _.defer(function() {
                        meerkat.modules.healthBenefits.open("journey-mode");
                    });
                }
            },
            onAfterLeave: function(event) {
                var selectedBenefits = meerkat.modules.healthBenefits.getSelectedBenefits();
                meerkat.modules.healthResults.onBenefitsSelectionChange(selectedBenefits);
            }
        };
        var resultsStep = {
            title: "Your Results",
            navigationId: "results",
            slideIndex: 2,
            validation: {
                validate: false,
                customValidation: function validateSelection(callback) {
                    if (meerkat.site.isCallCentreUser === true) {
                        var $_exacts = $(".resultsSlide").find(".simples-dialogue.mandatory");
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
                meerkat.modules.healthResults.resetSelectedProduct();
                if (event.isForward === true) {
                    if (meerkat.site.isCallCentreUser === true) {
                        $("#journeyEngineSlidesContainer .journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find(".simples-dialogue").show();
                    }
                }
            },
            onAfterEnter: function(event) {
                _.defer(function() {
                    meerkat.modules.kampyle.setFormId("85252");
                });
                if (event.isBackward === true) {
                    meerkat.modules.healthResults.onReturnToPage();
                }
                if (event.isForward === true) {
                    meerkat.modules.healthResults.get();
                }
                meerkat.modules.resultsHeaderbar.registerEventListeners();
            },
            onAfterLeave: function(event) {
                meerkat.modules.healthResults.stopColumnWidthTracking();
                meerkat.modules.healthResults.recordPreviousBreakpoint();
                meerkat.modules.healthResults.toggleMarketingMessage(false);
                meerkat.modules.healthMoreInfo.close();
                _.defer(function() {
                    meerkat.modules.kampyle.setFormId("85272");
                });
                meerkat.modules.resultsHeaderbar.removeEventListeners();
            }
        };
        var applyStep = {
            title: "Your Application",
            navigationId: "apply",
            slideIndex: 3,
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
            slideIndex: 4,
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
                $("#jointDeclarationDialog_link").on("click", function() {
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
                    $("#mainform").find(".health_declaration span").text(selectedProduct.info.providerName);
                    var $firstnameField = $("#health_payment_medicare_firstName");
                    var $surnameField = $("#health_payment_medicare_surname");
                    if ($firstnameField.val() === "") $firstnameField.val($("#health_application_primary_firstname").val());
                    if ($surnameField.val() === "") $surnameField.val($("#health_application_primary_surname").val());
                    var product = meerkat.modules.healthResults.getSelectedProduct();
                    var mustShowList = [ "GMHBA", "Frank", "Bupa" ];
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
    }
    function configureContactDetails() {
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
                $optInField: $("#health_contactDetails_optin")
            }, {
                $field: $("#health_application_email"),
                $optInField: $("#health_application_optInEmail")
            } ],
            mobile: [ {
                $field: $("#health_contactDetails_contactNumber_mobile"),
                $fieldInput: $("#health_contactDetails_contactNumber_mobileinput")
            }, {
                $field: $("#health_application_mobile"),
                $fieldInput: $("#health_application_mobileinput")
            } ],
            otherPhone: [ {
                $field: $("#health_contactDetails_contactNumber_other"),
                $fieldInput: $("#health_contactDetails_contactNumber_otherinput")
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
        $("#health_loading").val(rates.loading || "");
        $("#health_primaryCAE").val(rates.primaryCAE || "");
        $("#health_partnerCAE").val(rates.partnerCAE || "");
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
        if (postData.cover === "") return false;
        if (postData.rebate_choice === "") return false;
        if (postData.primary_dob === "") return false;
        if (hasPartner() && postData.partner_dob === "") return false;
        if (returnAge(postData.primary_dob) < 0) return false;
        if (hasPartner() && returnAge(postData.partner_dob) < 0) return false;
        if (postData.rebate_choice === "Y" && postData.income === "") return false;
        meerkat.modules.comms.post({
            url: "ajax/json/health_rebate.jsp",
            data: postData,
            cache: true,
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
            var gender = "";
            if ($("input[name=health_application_primary_gender]:checked", "#mainform")) {
                if ($("input[name=health_application_primary_gender]:checked", "#mainform").val() == "M") {
                    gender = "Male";
                } else {
                    gender = "Female";
                }
            }
            var yob = "";
            if ($("#health_healthCover_primary_dob").val().length) {
                yob = $("#health_healthCover_primary_dob").val().split("/")[2];
            }
            var ok_to_call = $("input[name=health_contactDetails_call]", "#mainform").val() === "Y" ? "Y" : "N";
            var mkt_opt_in = $("input[name=health_application_optInEmail]:checked", "#mainform").val() === "Y" ? "Y" : "N";
            var email = $("#health_contactDetails_email").val();
            var email2 = $("#health_application_email").val();
            if (email2.length > 0) {
                email = email2;
            }
            var transactionId = referenceNo.getTransactionID(false);
            var actionStep = "";
            switch (meerkat.modules.journeyEngine.getCurrentStepIndex()) {
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
            return {
                vertical: "Health",
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                yearOfBirth: yob,
                gender: gender,
                postCode: $("#health_application_address_postCode").val(),
                state: state,
                email: email,
                emailID: null,
                marketOptIn: mkt_opt_in === false ? "" : mkt_opt_in,
                okToCall: ok_to_call === false ? "" : ok_to_call,
                healthCoverType: $("#health_situation_healthCvr").val(),
                healthSituation: $("#health_situation_healthSitu").val()
            };
        } catch (e) {
            console.log("getTrackingFieldsObject failed for supertag");
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
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
            source: "submitApplication"
        });
        var frequency = $("#health_payment_details_frequency").val();
        var selectedProductPremium = meerkat.modules.healthResults.getSelectedProductPremium(frequency);
        var periods = meerkat.modules.healthResults.getNumberOfPeriodsForFrequency(frequency);
        $("#health_application_paymentAmt").val(selectedProductPremium.value * periods);
        $("#health_application_paymentFreq").val(selectedProductPremium.value);
        $("#health_application_paymentHospital").val(selectedProductPremium.hospitalValue * periods);
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
            onSuccess: function onSubmitSuccess(resultData) {
                var redirectURL = "health_confirmation.jsp?action=confirmation&token=";
                if (resultData.result && resultData.result.success) {
                    window.location.replace(redirectURL + resultData.result.confirmationID);
                } else if (resultData.result && resultData.result.pendingID && resultData.result.pendingID.length > 0 && (!resultData.result.callcentre || resultData.result.callcentre !== true)) {
                    window.location.replace(redirectURL + resultData.result.pendingID);
                } else {
                    meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
                        source: "submitApplication"
                    });
                    handleSubmittedApplicationErrors(resultData);
                }
            },
            onError: function onError(jqXHR, textStatus, errorThrown, settings, resultData) {
                meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
                    source: "submitApplication"
                });
                handleSubmittedApplicationErrors(resultData);
            }
        });
    }
    function handleSubmittedApplicationErrors(resultData) {
        var msg = "";
        var validationFailure = false;
        try {
            if (resultData.result && resultData.result.errors) {
                var target = resultData.result.errors;
                if ($.isArray(target.error)) {
                    target = target.error;
                }
                $.each(target, function(i, error) {
                    msg += "[code " + error.code + "] " + error.original;
                    if (target.length > 1 && i < target.length - 1) {
                        msg += "<br />";
                    }
                });
                if (msg === "") {
                    msg = "An unhandled error was received.";
                }
            } else if (resultData.hasOwnProperty("error") && typeof resultData.error == "object" && resultData.error.hasOwnProperty("type")) {
                switch (resultData.error.type) {
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
                    msg = resultData.error.message;
                    break;

                  case "transaction":
                    msg = resultData.error.message;
                    break;

                  default:
                    msg = "[" + resultData.error.code + "] " + resultData.error.message + " (Please report to IT before continuing)";
                    break;
                }
            } else {
                msg = "An unhandled error was received.";
            }
        } catch (e) {
            msg = "Application unsuccessful. Failed to handle response: " + e.message;
        }
        if (validationFailure) {
            ServerSideValidation.outputValidationErrors({
                validationErrors: resultData.error.errorDetails.validationErrors,
                startStage: 3
            });
            if (typeof resultData.error.transactionId != "undefined") {
                referenceNo.setTransactionId(resultData.error.transactionId);
            }
        } else {
            if (HealthSettings.isCallCentreUser === false) {
                msg = "Please contact us on 1800 77 77 12 for assistance.";
            }
            meerkat.modules.errorHandling.error({
                message: "<strong>Application failed:</strong><br/>" + msg,
                page: "health.js",
                description: "handleSubmittedApplicationErrors(). Submit failed: " + msg,
                data: resultData
            });
            if (healthFunds.applicationFailed) {
                healthFunds.applicationFailed();
            }
        }
    }
    function initHealth() {
        var self = this;
        $(document).ready(function() {
            $(document).on("click", ".blah", function() {
                meerkat.modules.dialogs.show({
                    title: "Blah title",
                    htmlContent: "Content",
                    buttons: [ {
                        label: "Cancel",
                        className: "btn-default modal-call-me-back-close",
                        closeWindow: true
                    }, {
                        label: "Call me",
                        className: "btn-primary disabled modal-call-me-back-submit" + (isRequested ? " displayNone" : "")
                    } ],
                    onClose: function() {
                        $openButton.fadeIn();
                    }
                });
            });
            if (meerkat.site.vertical !== "health") return false;
            initJourneyEngine();
            if (HealthSettings.pageAction === "confirmation") return false;
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
            if (HealthSettings.pageAction === "amend" || HealthSettings.pageAction === "start-again") {
                if (typeof healthFunds !== "undefined" && healthFunds.checkIfNeedToInjectOnAmend) {
                    healthFunds.checkIfNeedToInjectOnAmend(function onLoadedAmeded() {
                        meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                    });
                } else {
                    meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                }
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

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $dropdown, $component, mode, isIE8;
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
    function getBenefitsForSituation(situation) {
        if (situation === "") {
            populateHiddenFields([]);
            return;
        }
        meerkat.modules.comms.post({
            url: "ajax/csv/get_benefits.jsp",
            data: {
                situation: situation
            },
            cache: true,
            onSuccess: function onBenefitSuccess(data) {
                defaultBenefits = data.split(",");
                populateHiddenFields(defaultBenefits);
            }
        });
    }
    function resetHiddenFields() {
        $("#mainform input[type='hidden'].benefit-item").val("");
    }
    function populateHiddenFields(checkedBenefits) {
        resetHiddenFields();
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
        return selectedBenefits;
    }
    function saveSelection() {
        var navigationId = "";
        if (meerkat.modules.journeyEngine.getCurrentStep()) navigationId = meerkat.modules.journeyEngine.getCurrentStep().navigationId;
        if (navigationId === "benefits" || navigationId === "results") {
            meerkat.modules.journeyEngine.loadingShow("...getting your quotes...", true);
        }
        close();
        _.defer(function() {
            var selectedBenefits = saveBenefits();
            if (mode === MODE_JOURNEY) {
                meerkat.modules.journeyEngine.goto("next");
            } else {
                meerkat.messaging.publish(moduleEvents.CHANGED, selectedBenefits);
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
    function open(modeParam) {
        mode = modeParam;
        if ($dropdown.hasClass("open") === false) {
            $component.addClass(mode);
            if (meerkat.modules.deviceMediaState.get() === "xs") {
                $dropdown.closest(".navbar-collapse").collapse("show");
            } else {
                $dropdown.closest(".navbar-collapse").addClass("in");
            }
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
            if (meerkat.modules.deviceMediaState.get() === "xs") {
                $dropdown.closest(".navbar-collapse").collapse("hide");
            } else {
                $dropdown.closest(".navbar-collapse").removeClass("in");
            }
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
            if (meerkat.site.vertical !== "health" || HealthSettings.pageAction === "confirmation") return false;
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
                close();
            });
            $("[data-benefits-control='Y']").click(function(event) {
                event.preventDefault();
                event.stopPropagation();
                open(MODE_POPOVER);
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
            if (typeof HealthSettings === "undefined") return;
            if (HealthSettings.pageAction !== "confirmation") return;
            meerkat.modules.health.initProgressBar(true);
            meerkat.messaging.subscribe(meerkatEvents.journeyProgressBar.INIT, function disableProgressBar() {
                meerkat.modules.journeyProgressBar.setComplete();
                meerkat.modules.journeyProgressBar.disable();
            });
            if (result.data.status != "OK" || result.data.product === "") {
                meerkat.modules.errorHandling.error({
                    message: result.data.message,
                    page: "healthConfirmation.js module",
                    description: "Trying to load the confirmation page failed",
                    data: null
                });
            } else {
                confirmationProduct = _.extend({}, result.data);
                confirmationProduct.mode = "lhcInc";
                if (confirmationProduct.product) {
                    confirmationProduct.pending = false;
                    confirmationProduct.product = $.parseJSON(confirmationProduct.product);
                    if (confirmationProduct.product.price && _.isArray(confirmationProduct.product.price)) {
                        confirmationProduct.product = confirmationProduct.product.price[0];
                    }
                    _.extend(confirmationProduct, confirmationProduct.product);
                    delete confirmationProduct.product;
                } else if (typeof sessionProduct === "object") {
                    if (sessionProduct.price && _.isArray(sessionProduct.price)) {
                        sessionProduct = sessionProduct.price[0];
                    }
                    if (confirmationProduct.transID === sessionProduct.transactionId) {
                        _.extend(confirmationProduct, sessionProduct);
                    } else {
                        sessionProduct = undefined;
                    }
                    confirmationProduct.pending = true;
                } else {
                    confirmationProduct.pending = true;
                }
                meerkat.modules.healthMoreInfo.setProduct(confirmationProduct);
                if (typeof meerkat.modules.LiveChat !== "undefined") {
                    if (!(typeof window.referenceNo == "object" && window.referenceNo.hasOwnProperty("getTransactionID"))) {
                        window.referenceNo = {};
                        window.referenceNo.getTransactionID = function() {
                            return confirmationProduct.transID;
                        };
                    }
                    meerkat.modules.liveChat.fire(7, true, "confirmation");
                }
                meerkat.modules.healthMoreInfo.prepareCover();
                if (confirmationProduct.frequency.length == 1) {
                    confirmationProduct.frequency = meerkat.modules.healthResults.getFrequencyInWords(confirmationProduct.frequency);
                }
                confirmationProduct._selectedFrequency = confirmationProduct.frequency;
                fillTemplate();
                meerkat.modules.healthMoreInfo.applyEventListeners();
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "completedApplication",
                    object: {
                        productID: confirmationProduct.productId
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $dropdown, $component, filterValues = {}, joinDelimiter = ",";
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
                        switch (value) {
                          case "fortnightly":
                            value = "F";
                            break;

                          case "monthly":
                            value = "M";
                            break;

                          default:
                            value = "A";
                            break;
                        }
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
                        $this.val(value);
                    } else if ("filter-tierExtras" === id) {
                        value = $("#health_filter_tierExtras").val();
                        $this.val(value);
                    }
                }
            }
            if ("checkbox" === filterType) {
                var values = [];
                if ("filter-provider" === id) {
                    values = $this.find(":not(:checked)").map(function() {
                        return this.value;
                    });
                } else {
                    values = $this.find(":checked").map(function() {
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
        $component.addClass("is-saved");
        close();
        if (meerkat.modules.deviceMediaState.get() === "xs") {
            $dropdown.closest(".navbar-collapse").collapse("hide");
        } else {
            $dropdown.closest(".navbar-collapse").removeClass("in");
        }
        _.defer(function() {
            var valueOld, valueNew, filterId, needToFetchFromServer = false;
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
                            valueNew = meerkat.modules.healthResults.getFrequencyInWords(valueNew) || "monthly";
                            if (!needToFetchFromServer) {
                                refreshView = true;
                                if (filterValues.hasOwnProperty("filter-sort")) {
                                    if (filterValues["filter-sort"].value === "L" && filterValues["filter-sort"].value === filterValues["filter-sort"].valueNew) {
                                        refreshSort = true;
                                    }
                                }
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
            meerkat.messaging.publish(moduleEvents.CHANGED);
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
    }
    function initModule() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "health" || HealthSettings.pageAction === "confirmation") return false;
            $dropdown = $("#filters-dropdown");
            $component = $(".filters-component");
            $dropdown.on("show.bs.dropdown", function() {
                afterOpen();
                updateFilters();
            });
            $dropdown.on("hidden.bs.dropdown", function() {
                afterClose();
            });
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
            BRIDGINGPAGE_STATE: "BRIDGINGPAGE_STATE"
        }
    }, moduleEvents = events.healthMoreInfo;
    var template = null;
    var htmlTemplate = null;
    var product = null;
    var modalId = null;
    var isModalOpen = false;
    var isBridgingPageOpen = false;
    var $moreInfoElement;
    var overlap = -2;
    var POSITION;
    function positionFunction() {
        POSITION = -$("#pageContent").offset().top + $(".featuresList").offset().top + overlap;
    }
    function initMoreInfo() {
        $moreInfoElement = $(".moreInfoDropdown");
        jQuery(document).ready(function($) {
            if (meerkat.site.vertical != "health" || HealthSettings.pageAction == "confirmation") return false;
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
                    var transaction_id = referenceNo.getTransactionID(false);
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackHandoverType",
                        object: {
                            type: "Online_R",
                            quoteReferenceNumber: transaction_id,
                            transactionID: transaction_id,
                            productID: "productID"
                        }
                    });
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
            positionFunction();
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
        meerkat.messaging.subscribe(moduleEvents.BRIDGINGPAGE_SHOW, function(state) {
            adaptResultsPageHeight(state.isOpen);
        });
        meerkat.messaging.subscribe(moduleEvents.BRIDGINGPAGE_HIDE, function(state) {
            adaptResultsPageHeight(state.isOpen);
        });
    }
    function show(target) {
        positionFunction();
        target.html(meerkat.modules.loadingAnimation.getTemplate()).show();
        prepareProduct(function moreInfoShowSuccess() {
            var htmlString = htmlTemplate(product);
            target.find(".spinner").fadeOut();
            target.html(htmlString);
            $(".more-info-content .next-info-all").html($(".more-info-content .next-steps-all-funds-source").html());
            target.css({
                top: POSITION
            });
            var animDuration = 400;
            if (isBridgingPageOpen) {
                target.find(".more-info-content").fadeIn(animDuration);
            } else {
                target.find(".more-info-content").slideDown(animDuration, function showMoreInfo() {
                    meerkat.messaging.publish(moduleEvents.BRIDGINGPAGE_STATE, {
                        isOpen: true
                    });
                });
            }
            isBridgingPageOpen = true;
            _.delay(function() {
                meerkat.messaging.publish(moduleEvents.BRIDGINGPAGE_SHOW, {
                    isOpen: isBridgingPageOpen
                });
            }, animDuration);
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: {
                    productID: product.productId
                }
            });
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
            meerkat.messaging.publish(moduleEvents.BRIDGINGPAGE_STATE, {
                isOpen: isBridgingPageOpen
            });
            meerkat.messaging.publish(moduleEvents.BRIDGINGPAGE_HIDE, {
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
            modalId = meerkat.modules.dialogs.show({
                htmlContent: htmlTemplate(product),
                className: "modal-breakpoint-wide modal-tight"
            });
            $(".more-info-content .next-info .next-info-all").html($(".more-info-content .next-steps-all-funds-source").html());
            $(".more-info-content .moreInfoRightColumn > .dualPricing").insertAfter($(".more-info-content .moreInfoMainDetails"));
            isModalOpen = true;
            $(".more-info-content").show();
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
        show($moreInfoElement);
    }
    function closeBridgingPageDropdown(event) {
        hide($moreInfoElement);
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
        var aboutFund = null;
        var whatHappensNext = null;
        $.when(meerkat.modules.comms.get({
            url: "health_fund_info/" + product.info.provider + "/about.html",
            cache: true,
            onSuccess: function aboutFundSuccess(result) {
                product.aboutFund = result;
            }
        }), meerkat.modules.comms.get({
            url: "health_fund_info/" + product.info.provider + "/next_info.html",
            cache: true,
            onSuccess: function whatHappensNextSuccess(result) {
                product.whatHappensNext = result;
            }
        })).then(successCallback, function moreInfoAjaxFailure() {
            product.aboutFund = "<p>Apologies. This information did not download successfully.</p>";
        });
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
    var meerkat = window.meerkat, $maskedNumber = [], $token = [], $cardtype = [], modalId, modalContent = "", ajaxInProgress = false;
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
            onSuccess: createModalContent,
            onError: function onIPPAuthError(obj, txt, errorThrown) {
                fail();
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
            fail();
            return;
        }
        var _url = data.result.url + "?SessionId=" + data.result.refId + "&sst=" + data.result.sst + "&cardType=" + cardType() + "&registerError=false" + "&resultPage=0";
        var _message = '<p class="message"></p>';
        htmlContent = _message + '<iframe width="100%" height="110" frameBorder="0" src="' + _url + '" tabindex="" id="cc-frame"></iframe>';
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    function openModal(htmlContent) {
        if (typeof htmlContent === "undefined" || htmlContent.length === 0) {
            htmlContent = meerkat.modules.loadingAnimation.getTemplate();
        }
        modalId = meerkat.modules.dialogs.show({
            htmlContent: htmlContent,
            title: "Credit Card Number",
            onOpen: function(id) {
                meerkat.modules.tracking.recordSupertag("trackCustomPage", "Payment gateway popup");
            },
            onClose: function() {
                fail();
            }
        });
    }
    function isValid() {
        return $cardtype.valid();
    }
    function fail() {
        if ($token.val() === "") {
            meerkat.modules.dialogs.changeContent(modalId, "<p>We're sorry but our system is down and we are unable to process your credit card details right now.</p><p>Continue with your application and we can collect your details after you join.</p>");
            $token.val("fail");
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
        meerkat.modules.comms.post({
            url: "ajax/json/ipp/ipp_log.jsp?ts=" + new Date().getTime(),
            data: jsonData,
            dataType: "json",
            cache: false,
            onSuccess: function onRegisterSuccess(data) {
                if (!data || !data.result || data.result.success !== true) {
                    fail();
                    return;
                }
                $token.val(jsonData.sessionid);
                $maskedNumber.val(jsonData.maskedcardno);
                modalContent = "";
                meerkat.modules.dialogs.destroyDialog(modalId);
            },
            onError: function onRegisterError(obj, txt, errorThrown) {
                fail();
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
            if (meerkat.site.vertical !== "health" || HealthSettings.pageAction === "confirmation") return false;
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
            $("#update-premium").on("click", updatePremium);
            $("#health_payment_credit_type").on("change", creditCardDetails.set);
            creditCardDetails.set();
            $('[data-provide="paymentGateway"]').on("click", '[data-gateway="launcher"]', paymentGateway.launch);
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
        var today = meerkat.modules.utilities.getUTCToday(), start = 0, end = 0, hourAsMs = 60 * 60 * 1e3;
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
        $paymentSection.find(":input").prop("disabled", false);
        $paymentSection.find(".select").removeClass("disabled");
        $paymentSection.find(".btn-group label").removeClass("disabled");
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
                    meerkat.modules.dialogs.show({
                        title: "Policy not available",
                        htmlContent: "Unfortunately, no pricing is available for this fund. Click the button below to return to your application and try again or alternatively save your quote and call us on 1800 77 77 12."
                    });
                } else {
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
            $policySummaryDualPricing = $(".policySummary.dualPricing .productSummary");
            if (HealthSettings.pageAction != "confirmation") {
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
        $policySummaryContainer.find(".policyPriceWarning").hide();
        if ($policySummaryDualPricing.length > 0) {
            product.showAltPremium = true;
            htmlString = htmlTemplate(product);
            $policySummaryDualPricing.html(htmlString);
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
    meerkat.modules.register("healthPriceComponent", {
        init: init,
        events: events,
        updateProductSummaryHeader: updateProductSummaryHeader,
        updateProductSummaryDetails: updateProductSummaryDetails
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, supertagEventMode = "Load";
    var moduleEvents = {
        healthResults: {
            SELECTED_PRODUCT_CHANGED: "SELECTED_PRODUCT_CHANGED",
            SELECTED_PRODUCT_RESET: "SELECTED_PRODUCT_RESET",
            PREMIUM_UPDATED: "PREMIUM_UPDATED"
        },
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var $component;
    var selectedProduct = null;
    var previousBreakpoint;
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
            Features.balanceVisibleRowsHeight();
        }
        Results.pagination.refresh();
    }
    function initResults() {
        try {
            Results.init({
                url: "ajax/json/health_quote_results.jsp",
                runShowResultsPage: false,
                paths: {
                    results: {
                        list: "results.price"
                    },
                    brand: "info.Name",
                    productId: "productId",
                    price: {
                        annually: "premium.annually.lhcfreevalue",
                        monthly: "premium.monthly.lhcfreevalue",
                        fortnightly: "premium.fortnightly.lhcfreevalue"
                    },
                    availability: {
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
                        headers: false
                    },
                    dockCompareBar: false
                },
                displayMode: "features",
                paginationMode: "page",
                sort: {
                    sortBy: "benefitsSort"
                },
                frequency: "monthly",
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
                }
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.healthResults.init(); " + e.message, e);
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
        meerkat.messaging.subscribe(meerkatEvents.healthFilters.CHANGED, function onFilterChange() {
            resetCompare();
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
            Compare.reset();
        });
    }
    function compareResults() {
        _.defer(function() {
            Compare.filterResults();
            _.defer(function() {
                toggleMarketingMessage(true, 5 - Results.getFilteredResults().length);
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
                        touchComment: "ResCompare"
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
                            products: compareArray
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
        $(document).on("resultsLoaded", onResultsLoaded);
        $(document).on("resultsReturned", function() {
            Compare.reset();
            meerkat.modules.utilities.scrollPageTo($("header"));
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");
        });
        $(document).on("resultsDataReady", function() {
            writeRanking();
            updateBasketCount();
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
                source: "healthResults"
            });
            toggleMarketingMessage(false);
            meerkat.modules.journeyEngine.loadingShow("...getting your quotes...");
            $("header .slide-feature-pagination, header a[data-results-pagination-control]").addClass("hidden");
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            _.defer(function() {
                meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
                    source: "healthResults"
                });
                $("header .slide-feature-pagination, header a[data-results-pagination-control]").removeClass("hidden");
            });
            meerkat.modules.journeyEngine.loadingHide();
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
            if (Compare.view.resultsFiltered === false) {
                var pageData = event.pageData;
                if (pageData.measurements === null) return false;
                if (pageData.pageNumber === pageData.measurements.numberOfPages) {
                    var freeColumns = pageData.measurements.columnsPerPage * pageData.measurements.numberOfPages - Results.getFilteredResults().length;
                    if (freeColumns > 2) {
                        toggleMarketingMessage(true, freeColumns);
                        return true;
                    }
                }
                toggleMarketingMessage(false);
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
        Results.view.startColumnWidthTracking($(window), 2, false);
    }
    function stopColumnWidthTracking() {
        Results.view.stopColumnWidthTracking();
    }
    function recordPreviousBreakpoint() {
        previousBreakpoint = meerkat.modules.deviceMediaState.get();
    }
    function get() {
        meerkat.modules.health.loadRates(function afterFetchRates() {
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
        } else {
            $_main.find(".health_application_details_provider").val(selectedProduct.info.provider);
            $_main.find(".health_application_details_productId").val(selectedProduct.productId);
            $_main.find(".health_application_details_productNumber").val(selectedProduct.info.productCode);
            $_main.find(".health_application_details_productTitle").val(selectedProduct.info.productTitle);
            if (premiumChangeEvent === true) {
                meerkat.messaging.publish(moduleEvents.healthResults.PREMIUM_UPDATED, selectedProduct);
            } else {
                meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_CHANGED, selectedProduct);
                $(Results.settings.elements.rows).removeClass("active");
                $(Results.settings.elements.rows + "[data-productid=" + selectedProduct.productId + "]").addClass("active");
            }
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
                    onSuccess: function onGetProductSuccess(data) {
                        if (!data.results || !data.results.price || data.results.price.available === "N") {
                            callback(null);
                        } else {
                            callback(data.results.price);
                        }
                    },
                    onError: function onGetProductError() {
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
            $("#resultsPage .price").each(function() {
                var $this = $(this);
                var productId = $this.parents(Results.settings.elements.rows).attr("data-productId");
                var product = Results.getResultByProductId(productId);
                text = "<strong>Premium:</strong> " + product.premium[Results.getFrequency()].text + "<br/>";
                text += "<strong>Premium LHC Excluded:</strong> " + product.premium[Results.getFrequency()].lhcfreetext + "<br/>";
                text += "<hr/>";
                text += "<strong>Fortnightly (ex LHC):</strong> " + product.premium.fortnightly.lhcfreetext + "<br/>";
                text += "<strong>Monthly (ex LHC):</strong> " + product.premium.monthly.lhcfreetext + "<br/>";
                text += "<strong>Annually (ex LHC):</strong> " + product.premium.annually.lhcfreetext + "<br/>";
                text += "<hr/>";
                text += "<strong>Product Code:</strong> " + product.info.productCode + "<br/>";
                text += "<strong>Product ID:</strong> " + product.productId;
                meerkat.modules.popovers.create({
                    element: $this,
                    contentValue: text,
                    contentType: "content",
                    showEvent: "mouseenter click",
                    position: {
                        my: "bottom center",
                        at: "top center"
                    },
                    style: {
                        classes: "priceTooltips"
                    }
                });
            });
        }
    }
    function toggleMarketingMessage(show, columns) {
        if (show) {
            $(".resultsMarketingMessage").addClass("show");
            $(".resultsMarketingMessage").attr("data-columns", columns);
        } else {
            $(".resultsMarketingMessage").removeClass("show");
        }
    }
    function writeRanking() {
        var frequency = Results.getFrequency();
        var sortBy = Results.getSortBy();
        var sortDir = Results.getSortDir();
        var sortedPrices = Results.getFilteredResults();
        var data = {
            rootPath: "health",
            rankBy: sortBy + "-" + sortDir,
            rank_count: sortedPrices.length
        };
        var externalTrackingData = [];
        for (var i = 0; i < sortedPrices.length; i++) {
            var price = sortedPrices[i];
            var prodId = price.productId.replace("PHIO-HEALTH-", "");
            data["rank_productId" + i] = prodId;
            data["rank_price_actual" + i] = price.premium[frequency].value.toFixed(2);
            data["rank_price_shown" + i] = price.premium[frequency].lhcfreevalue.toFixed(2);
            data["rank_frequency" + i] = frequency;
            data["rank_lhc" + i] = price.premium[frequency].lhc;
            data["rank_rebate" + i] = price.premium[frequency].rebate;
            data["rank_discounted" + i] = price.premium[frequency].discounted;
            var rank = i + 1;
            externalTrackingData.push({
                productID: price.productId,
                ranking: rank
            });
        }
        meerkat.modules.comms.post({
            url: "ajax/write/quote_ranking.jsp",
            data: data
        });
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteProductList",
            object: {
                products: externalTrackingData
            }
        });
        var excess = "ALL";
        switch ($("#health_excess").val()) {
          case 1:
            excess = "0";
            break;

          case 2:
            excess = "1-250";
            break;

          case 3:
            excess = "251-500";
            break;

          default:
            excess = "ALL";
            break;
        }
        var sortHealthRanking = Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price";
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteList",
            object: {
                preferredExcess: excess,
                sortPaymentFrequency: frequency,
                sortHealthRanking: sortHealthRanking,
                event: supertagEventMode
            }
        });
        supertagEventMode = "Refresh";
    }
    function init() {
        $component = $("#resultsPage");
        meerkat.messaging.subscribe(meerkatEvents.healthBenefits.CHANGED, onBenefitsSelectionChange);
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
        onBenefitsSelectionChange: onBenefitsSelectionChange,
        recordPreviousBreakpoint: recordPreviousBreakpoint
    });
})(jQuery);