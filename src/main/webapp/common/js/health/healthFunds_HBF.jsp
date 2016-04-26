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
        var productType = meerkat.modules.healthResults.getSelectedProduct().info.ProductType;
        if (productType === 'GeneralHealth' || productType === 'Combined') {
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


        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
    },
    unset: function(){
        var $hbf_flexi_extras = $('#hbf_flexi_extras');
        $hbf_flexi_extras.find('.flexi-extras-icons a').off('click.HBF');
        $hbf_flexi_extras.hide();

    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />