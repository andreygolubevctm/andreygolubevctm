<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
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
		  $paymentType : $('#health_payment_details_type input'),
			$paymentFrequency : $('#health_payment_details_frequency'),
			$paymentStartDate: $("#health_payment_details_start"),
			$paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
			$claimsAccountOptin: $('#health_payment_bank_claims'),

          set: function() {
            $(".health_previous_fund_authority").removeClass("hidden");
            $("label[for='health_previousfund_primary_authority'] span").text("Navy Health");
            $("label[for='health_previousfund_partner_authority'] span").text("Navy Health");

            <%-- Email not compulsory, but when you select email as how to sent you, then it is required --%>
              var $emailField = $("#health_application_email");
              $emailField.setRequired(false);

              $('input[name="health_application_contactPoint"]').on('change.NHB', function onHowToSendChange(){
                  $emailField.setRequired($('#health_application_contactPoint_E').is(':checked'));
              });

              <%-- Increase minimum age requirement for applicants from 16 to 18 --%>
              healthFunds_NHB.$_dobPrimary = $('#health_application_primary_dob');
              healthFunds_NHB.$_dobPartner = $('#health_application_partner_dob');
              healthFunds_NHB.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under 18");
              healthFunds_NHB.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under 18");


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
                        <field_v2:general_select type="healthNavQuestion_eligibility" xpath="${fieldXpath}/eligibility" title="Eligibility reason" required="true" initialText="Please select" disableErrorContainer="${true}" />
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
                    url: "spring/rest/health/dropdown/list.json",
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
                      <%-- Set subreason if set --%>
                      <c:set var="subreasonxpath" value="${fieldXpath}/subreason"/>
                      <c:set var="subreasonval"><c:out value="${data[subreasonxpath]}" escapeXml="true"/></c:set>
                      <c:if test="${fn:length(subreasonval) > 0}">
                        $("#health_application_nhb_subreason").val('<c:out value="${subreasonval}" escapeXml="true"/>');
                      </c:if>
                      return true;
                    }
                  });
                  if(! _.isUndefined(originalKey)) {
                    $dropDown.val(originalKey).change();
                  }
                });
              }

              var $eligibility = $('#health_application_nhb_eligibility');
              if($eligibility.val() !== '') {
                $eligibility.trigger('change');
              }
            }<%-- /injection --%>

            <%-- Title replacement --%>
            if($('#nhb_title_prim').length) {
              $('#nhb_title_prim').show();
            }
            else {
                var originalTitle = $("#health_application_primary_title").val();
                <c:set var="html">
                  <c:set var="fieldXpath" value="health/application/primary/title" />
                    <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_primary_titleRow" className="selectContainerTitle" hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
                      <field_v2:general_select xpath="${fieldXpath}" title="Title" type="healthNavQuestion_title" required="true"  className="person-title" additionalAttributes=" data-rule-genderTitle='true' " disableErrorContainer="${true}" />
                    </form_v2:row>
                  </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                $('#health_application_primary_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
                <%-- lets get the previous original title and apply to the replaced one --%>
                $("#health_application_primary_title").val(healthFunds_NHB.primaryTitleValue || originalTitle);
            }
            <%-- Partner Title replacement --%>
            if($('#nhb_title_partner').length) {
              $('#nhb_title_partner').show();
            }
            else {
                var originalTitle = $("#health_application_partner_title").val();
                <c:set var="html">
                    <c:set var="fieldXpath" value="health/application/partner/title" />
                    <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_partner_titleRow" className="selectContainerTitle" hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
                        <field_v2:general_select xpath="${fieldXpath}" title="Title" type="healthNavQuestion_title" required="true"  className="person-title" additionalAttributes=" data-rule-genderTitle='true' "  disableErrorContainer="${true}"/>
                    </form_v2:row>
                </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                $('#health_application_partner_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
                <%-- lets get the previous partner title and apply to the replaced one. --%>
                $("#health_application_partner_title").val(healthFunds_NHB.partnerTitleValue || originalTitle);
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
                      title="Relationship to you" items="=Please choose...,Ptnr=Partner,Sps=Spouse" placeHolder="Relationship" disableErrorContainer="${true}" />
              </form_v2:row>
              </c:set>
              <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
              $('#health_application_partner_genderRow').after('<c:out value="${html}" escapeXml="false" />');
            }



            <%-- Run these if not loading a quote --%>
            if (!$('body').hasClass('injectingFund')) {

              <%-- Dependants --%>
                meerkat.modules.healthFunds._dependants('This policy provides cover for your children up to their 22nd birthday and dependants aged between 22 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

              meerkat.modules.healthDependants.updateConfig({showFullTimeField :true, showSchoolFields:true, 'schoolMinAge':22, 'schoolMaxAge':25, showSchoolIdField:false,showRelationship:true,showPreferredMethodOfContact:true });

              <%-- Partner authority --%>
                meerkat.modules.healthFunds._partner_authority(false);

              <%-- How to send information. Second argument = validation required --%>
              meerkat.modules.healthFunds.showHowToSendInfo('Navy Health', true);

              <%--fund offset check--%>
              meerkat.modules.healthFundTimeOffset.onInitialise({
                weekends: false,
                coverStartRange: {
                  min: 0,
                  max: 28
                },
                renderPaymentDaysCb: healthFunds_NHB.renderPaymentDays
              });

              <%-- Payments --%>
              meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
              meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
              meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });
              <%--credit card options--%>
              //meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
             // meerkat.modules.healthCreditCard.render();

              <%-- Claims account --%>
              //meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
              meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',false);

			  healthFunds_NHB.$paymentType.on('change.NHB', function renderPaymentDaysPaymentType(){
				healthFunds_NHB.renderPaymentDays();
			});

			healthFunds_NHB.$paymentFrequency.on('change.NHB', function renderPaymentDaysFrequency(){
				healthFunds_NHB.renderPaymentDays();
			});

			healthFunds_NHB.$paymentStartDate.on("changeDate.NHB", function renderPaymentDaysCalendar(e) {
				healthFunds_NHB.renderPaymentDays();
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
			  "updateValidationSelectors" : meerkat.modules.healthPaymentStep.updateValidationSelectorsPaymentGateway,
			  "resetValidationSelectors" : meerkat.modules.healthPaymentStep.resetValidationSelectorsPaymentGateway,
              "paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
              "getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
            });

			<%-- Unset the refund optin radio buttons --%>
			healthFunds_NHB.$claimsAccountOptin.find("input:checked").each(function(){
			  $(this).prop("checked",null).trigger("change");
			});
          },
		  renderPaymentDays: function() {
			healthFunds_NHB.$paymentTypeContainer.text('*Navy Health offers a 2% discount on Half Yearly or a 4% discount on Annual payments').slideDown();
			meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':14, 'weekends':false, 'countFrom' : meerkat.modules.healthPaymentDay.EFFECTIVE_DATE, 'maxDay' : 28});
			
            var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
            meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
            meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);
		  },
          unset: function() {
            <%-- Custom questions - hide in case user comes back --%>
            $('#nhb_eligibility, #nhb_ineligible, #nhb_partnerrel').hide();
            $(".health_previous_fund_authority").addClass("hidden");
            $("label[for='health_previousfund_primary_authority'] span").text("the fund");
            $("label[for='health_previousfund_partner_authority'] span").text("the fund");

              <%-- let set this back to its original state --%>
              $('input[name="health_application_contactPoint"]').off('change.NHB');
              $("#health_application_email").setRequired(true);

              <%-- Age requirements for applicants (back to default) --%>
              healthFunds_NHB.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
              healthFunds_NHB.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

              delete healthFunds_NHB.$_dobPrimary;
              delete healthFunds_NHB.$_dobPartner;

            <%-- Run these if not loading a quote --%>
            if (!$('body').hasClass('injectingFund')) {
              <%-- Dependants --%>
                meerkat.modules.healthFunds._dependants(false);
              meerkat.modules.healthDependants.resetConfig();
                meerkat.modules.healthFunds._reset();
			  healthFunds_NHB.$paymentType.off('change.NHB');
				healthFunds_NHB.$paymentFrequency.off('change.NHB');
				healthFunds_NHB.$paymentStartDate.off("changeDate.NHB");
              meerkat.modules.paymentGateway.reset();

              <%-- Payments --%>
              $('.health-payment_details-type').off('change.NHB');
              $('#health_payment_details-selection p.NHB').remove();

              $('#health_payment_details_frequency').off('change.NHB');
              $('.health_payment_bank_details-policyDay-message').html('');

              <%-- How to send information --%>
              meerkat.modules.healthFunds.hideHowToSendInfo();

              <%-- Remember the selections--%>
              healthFunds_NHB.primaryTitleValue = $('#health_application_primary_title').val();
              healthFunds_NHB.partnerTitleValue = $('#health_application_partner_title').val();

              <%-- lets undo the title massive values from nav --%>
              <c:set var="html">
                <c:set var="fieldXpath" value="health/application/primary/title" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_primary_titleRow" className="selectContainerTitle"  hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
                  <field_v2:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' " disableErrorContainer="${true}"/>
                </form_v2:row>
              </c:set>
              <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                $('#health_application_primary_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />')
                $('#health_application_primary_title').val(healthFunds_NHB.primaryTitleValue);

              <%-- lets undo the partner title massive values from nav --%>
              <c:set var="html">
                <c:set var="fieldXpath" value="health/application/partner/title" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Title" id="health_application_partner_titleRow"  hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
                  <field_v2:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' " disableErrorContainer="${true}" />
                </form_v2:row>
                </c:set>
                <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
                $('#health_application_partner_titleRow').replaceWith('<c:out value="${html}" escapeXml="false" />');
                $('#health_application_partner_title').val(healthFunds_NHB.partnerTitleValue);
            }
			healthFunds_NHB.$paymentTypeContainer.text('').slideUp();
          }
        };