<%@ page language="java" pageEncoding="UTF-8"%>
        <%@ include file="/WEB-INF/tags/taglib.tagf" %>
        <session:get settings="true" />
        <% response.setHeader("Content-type", "text/javascript"); %>
        <% pageContext.setAttribute("newLineChar", "\n"); %>
        <% pageContext.setAttribute("newLineChar2", "\r"); %>
        <% pageContext.setAttribute("aposChar", "'"); %>
        <% pageContext.setAttribute("aposChar2", "\\\\'"); %>
        <% pageContext.setAttribute("slashChar", "\\\\"); %>
        <% pageContext.setAttribute("slashChar2", "\\\\\\\\"); %>
        <%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand). --%>
        <c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
        <c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
        <c:if test="${fn:endsWith(hostOrigin, '/')}">
        <c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
        </c:if>
        <%--
        =======================
        NHB
        =======================
        --%>
        var healthFunds_NHB = {
          processOnAmendQuote: true,
          ajaxJoinDec: false,

          set: function() {
            $(".health_application-details_contact-group").removeClass('hidden');
            $(".health_previous_fund_authority").removeClass("hidden");
            $("label[for='health_application_contactPoint'] span").text('Navy Health');
            $("label[for='health_previousfund_primary_authority'] span").text("Navy Health");
            $("label[for='health_previousfund_partner_authority'] span").text("Navy Health");
            <%--  not cumpolsary --%>
            $("#health_application_email").prop('required', false);


            <%-- Custom questions: Eligibility --%>
            if ($('#nhb_eligibility').length > 0) {
              <%-- HTML was already injected so unhide it --%>
              $('#nhb_eligibility').show();
            }
            else {

              <c:set var="html">
                <c:set var="fieldXpath" value="health/application/nhb" />
                <form_v2:fieldset id="nhb_eligibility" legend="How are you eligible to join Navy Health?" className="primary">
                  <div id="nhb_currentemployee">
                      <form_v2:row fieldXpath="${fieldXpath}/eligibility" label="Eligibility reason"  className="cbhmain">
                        <field_v2:general_select type="healthNavQuestion_eligibility" xpath="${fieldXpath}/eligibility" title="Eligibility reason" required="true" initialText="Please select" />
                      </form_v2:row>

                      <form_v2:row label="Sub Reason" id="subreasonId">
                        <field_v2:general_select xpath="${fieldXpath}/subreason" title="Sub reason" required="true" initialText="&nbsp;" />
                      </form_v2:row>
                  </div>
                  <div id="nhb_ineligible" class="alert alert-danger">
                       <span></span>
                  </div>
                </form_v2:fieldset>
              </c:set>

              <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
              $('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');
              $("#subreasonId, #nhb_ineligible").hide();
              $.validator.addMethod("validateNAVEligibility", function(value, element) {
                          return !$("#nhb_ineligible").is(":visible");
                        }
                );
              <%-- lets make ajax call to get the other values for the sub eligibility field --%>
              $('#health_application_nhb_eligibility').on('change',function() {
                $('#subreasonId').slideDown(200);
                var $dropDown = $("#health_application_nhb_subreason");
                switch($(this).val()) {
                  case 'CS':
                    populateDropdownOnKey('healthNavQuestion_subCS',$dropDown);
                    break;
                  case 'ES':
                    populateDropdownOnKey('healthNavQuestion_subES',$dropDown);
                    break;
                  case 'CO':
                    populateDropdownOnKey('healthNavQuestion_subCO',$dropDown);
                    break;
                  case 'CR':
                    populateDropdownOnKey('healthNavQuestion_subCR',$dropDown);
                    break;
                  case 'FO':
                    populateDropdownOnKey('healthNavQuestion_subFO',$dropDown);
                    break;
                  case 'F':
                    populateDropdownOnKey('healthNavQuestion_subF',$dropDown);
                    break;
                  case 'O':
                    populateDropdownOnKey('healthNavQuestion_subO',$dropDown);
                    break;
                  case 'CF':
                    populateDropdownOnKey('healthNavQuestion_subCF',$dropDown);
                    break;
                  case 'DOD':
                    populateDropdownOnKey('healthNavQuestion_subDOD',$dropDown);
                    break;
                  default:
                    $dropDown.empty();
                    $("#subreasonId").slideUp(200);
                }
              });


              function populateDropdownOnKey(key,$dropDown,originalKey) {
                _.defer(function() {
                  ajaxRequest = meerkat.modules.comms.get({
                    url: "rest/health/dropdown/list.json",
                    data: {
                      type:key
                    },
                    cache: true,
                    useDefaultErrorHandling: false,
                    numberOfAttempts: 3,
                    errorLevel: "fatal",
                    onSuccess: function onSubmitSuccess(resultData) {
                      $dropDown.empty();
                      $.each(resultData,function(k,v) {
                        $dropDown.append($("<option />").val(k).text(v));
                      });

                      return true;
                    },
                    onComplete: function onSubmitComplete() {
                      return true;
                    }
                  });
                  if(! _.isUndefined(originalKey)) {
                    $dropDown.val(originalKey).change();
                  }
                });
              }
            }<%-- /injection --%>

            <%-- Title replacement --%>
            if($('#nhb_title_prim').length) {
              $('#nhb_title_prim').show();
            }
            else {
                <c:set var="html">
                  <c:set var="fieldXpath" value="health/application/primary/title" />
                    <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_primary_titleRow" >
                      <field_v2:general_select xpath="${fieldXpath}" title="Title" type="healthNavQuestion_title" required="true"  className="person-title"/>
                    </form_v2:row>
                  </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                var originalTitle = $("#health_application_primary_title").val();
                $('#health_application_primary_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
                <%-- lets get the previous original title and apply to the replaced one --%>
                $("#health_application_primary_title").val(originalTitle);
            }
            <%-- Partner Title replacement --%>
            if($('#nhb_title_partner').length) {
              $('#nhb_title_partner').show();
            }
            else {
              <c:set var="html">
                <c:set var="fieldXpath" value="health/application/partner/title" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_partner_titleRow" >
                  <field_v2:general_select xpath="${fieldXpath}" title="Title" type="healthNavQuestion_title" required="true"  className="person-title"/>
                </form_v2:row>
              </c:set>
              <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
              var originalTitle = $("#health_application_partner_title").val();
              $('#health_application_partner_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
              <%-- lets get the previous partner title and apply to the replaced one. --%>
              $("#health_application_partner_title").val(originalTitle);
            }

            <%-- Custom question: Partner relationship --%>
            if ($('#nhb_partnerrel').length > 0) {
              $('#nhb_partnerrel').show();
            }
            else {
              <c:set var="html">
              <c:set var="fieldXpath" value="health/application/nhb/partnerrel" />
              <form_v2:row id="nhb_partnerrel" fieldXpath="${fieldXpath}" label="Relationship to you">
              <field_v2:array_select xpath="${fieldXpath}"
                      required="true"
                      title="Relationship to you" items="=Please choose...,Ptnr=Partner,Sps=Spouse" />
              </form_v2:row>
              </c:set>
              <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
              $('#health_application_partner_genderRow').after('<c:out value="${html}" escapeXml="false" />');
            }



            <%-- Run these if not loading a quote --%>
            if (!$('body').hasClass('injectingFund')) {

              <%-- Dependants --%>
              healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

              meerkat.modules.healthDependants.updateConfig({showFullTimeField :true, showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':25, showSchoolIdField:false,showRelationshipForNavy:true,showPreferredMethodOfContact:true });

              <%-- Partner authority --%>
              healthFunds._partner_authority(true);

              <%-- Calendar for start cover --%>
              meerkat.modules.healthPaymentStep.setCoverStartRange(0, 28);

              <%-- Payments --%>
              meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
              meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
              meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });
              <%--credit card options--%>
              //meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
             // meerkat.modules.healthCreditCard.render();

              <%-- Claims account --%>
              //meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
              //meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

              $("#update-premium").on("click.NHB",function() {
                if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'ba') {
                  $('.health_bank-details_policyDay-message').html('Your first premium payment will be deducted from your nominated bank account on receipt of your application by us, or from the actual start date of your policy');
                  $('#health_payment_bank_policyDay').attr('type','hidden').attr('data-attach', 'true');
                }
                else if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc') {
                  $('.health_credit-card-details_policyDay-message').html('Your first premium payment will be deducted from your credit card on receipt of your application by us, or from the actual start date of your policy');
                  $('#health_payment_credit_policyDay').attr('type','hidden').attr('data-attach', 'true');
                }

              });

            }<%-- /not loading quote --%>
            meerkat.modules.paymentGateway.setup({
              "paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
              "name" : 'health_payment_gateway',
              "src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
              "origin": '${hostOrigin}', <%-- the CTM host origin --%>
              "providerCode": 'nhb',
              "brandCode": '${pageSettings.getBrandCode()}',
              "handledType" :  {
                "credit" : true,
                "bank" : false
              },
              "paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
              "clearValidationSelectors" : $('#health_payment_details_frequency, #health_payment_details_start ,#health_payment_details_type'),
              "getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
            });
          },
          unset: function() {
            <%-- Custom questions - hide in case user comes back --%>
            $('#nhb_eligibility, #nhb_ineligible, #nhb_partnerrel').hide();
            $("#health_application_contactPoint-group").addClass('hidden');
            $("label[for='health_application_contactPoint'] span").text("the fund");
            $(".health_previous_fund_authority").addClass("hidden");
            $("label[for='health_previousfund_primary_authority'] span").text("the fund");
            $("label[for='health_previousfund_partner_authority'] span").text("the fund");
            <%-- let set this back to its original state --%>
            $("#health_application_email").prop("required","true");

            <%-- Run these if not loading a quote --%>
            if (!$('body').hasClass('injectingFund')) {
              <%-- Dependants --%>
              healthFunds._dependants(false);
              meerkat.modules.healthDependants.resetConfig();
              healthFunds._reset();
              $("#update-premium").off("click.NHB");
              meerkat.modules.paymentGateway.reset();

              <%-- Payments --%>
              $('.health-payment_details-type').off('change.NAV');
              $('#health_payment_details-selection p.NAV').remove();

              $('#health_payment_details_frequency').off('change.NAV');
              $('.health_bank-details_policyDay-message').html('');

              <%-- lets undo the title massive values from nav --%>
              <c:set var="html">
                <c:set var="fieldXpath" value="health/application/primary/title" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_primary_titleRow" >
                  <field_v2:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' "/>
                </form_v2:row>
              </c:set>
              <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
              var originalTitle = $("#health_application_primary_title").val();
              $('#health_application_primary_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
              $("#health_application_primary_title").val(originalTitle);

              <%-- lets undo the partner title massive values from nav --%>
              <c:set var="html">
                <c:set var="fieldXpath" value="health/application/partner/title" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_partner_titleRow" >
                  <field_v2:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' "/>
                </form_v2:row>
                </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                var originalTitle = $("#health_application_partner_title").val();
                $('#health_application_partner_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
                $("#health_application_partner_title").val(originalTitle);
            }
          }
        };