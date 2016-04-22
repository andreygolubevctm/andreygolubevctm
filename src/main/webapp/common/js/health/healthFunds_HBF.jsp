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
        <%-- Custom question: HBF flexi extras --%>
        if ($('#hbf_fexi_extras').length > 0) {
            $('#hbf_fexi_extras').show();
        }
        <c:set var="html">
            <form_v2:fieldset id="hbf_fexi_extras" legend="" className="primary">
                <div class="col-sm-8 col-md-4 col-lg-3 hidden-xs no-padding"><img src="assets/graphics/logos/health/HBF.png" /></div>
                <div class="col-sm-7 col-md-8 col-lg-9 no-padding">
                    <h2>HBF <span class="saver-flexi">Saver </span>Flexi Extras</h2>
                    <p><strong>HBF <span class="saver-flexi">Saver </span>Flexi Extras</strong> allows you to chosse your extras cover for your needs, pick any <strong><span class="flexi-available">4</span> extras</strong> from the selection below to build the right cover for your needs.</p>
                </div>
                <div class="flexi-message">You have selected <span class="flexi-selected text-tertiary"></span> of your <span class="flexi-available text-tertiary">4</span> <span class="text-tertiary">available</span> extras cover inclusions, <strong class="text-warning"><span class="felxi-remaining"></span> more selections remaining</strong></div>
                <div class="flexi-message-complete hidden">You have selected all of your <span class="flexi-available">4</span> available extras cover inclusions.</div>

                <div class="felxi-extras-icons benefitsIcons">
                    <a href="javascript:;" class="HLTicon-general-dental saver">General Dental</a>
                    <a href="javascript:;" class="HLTicon-major-dental saver">Major Dental</a>
                    <a href="javascript:;" class="HLTicon-optical saver">Optical</a>
                    <a href="javascript:;" class="HLTicon-eye-therapy">Eye Therapy</a>
                    <a href="javascript:;" class="HLTicon-podiatry">Podiatry</a>
                    <a href="javascript:;" class="HLTicon-physiotherapy">Physiotherapy</a>
                    <a href="javascript:;" class="HLTicon-chiropractor">Chiropractic</a>
                    <a href="javascript:;" class="HLTicon-osteopathy">Osteopathy</a>
                    <a href="javascript:;" class="HLTicon-non-pbs-pharm">Pharmacy</a>
                    <a href="javascript:;" class="HLTicon-speech-therapy">Speech Therapy</a>
                    <a href="javascript:;" class="HLTicon-occupational-therapy">Occupational Therapy</a>
                    <a href="javascript:;" class="HLTicon-psychology">Psychology</a>
                    <a href="javascript:;" class="HLTicon-naturopathy">Naturopathy</a>
                    <a href="javascript:;" class="HLTicon-dietetics">Dietetics</a>
                    <a href="javascript:;" class="HLTicon-hearing-aids">Appliances</a>
                    <a href="javascript:;" class="HLTicon-lifestyle-products">Lifestyle Products</a>
                    <a href="javascript:;" class="HLTicon-urgent-ambulance">Urgent Ambulance</a>
                </div>
            </form_v2:fieldset>
        </c:set>
        <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

        $('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
    },
    unset: function(){
        $('#hbf_fexi_extras').hide();
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />