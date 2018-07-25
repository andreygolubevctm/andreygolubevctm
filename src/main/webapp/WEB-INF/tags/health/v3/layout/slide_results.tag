<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

    <layout_v3:slide_content>
        <simples:dialogue id="83" className="" vertical="health" />
        <simples:dialogue id="96" className="" vertical="health" />
        <simples:dialogue id="109" className="hidden" vertical="health" mandatory="true" />

        <field_v1:hidden xpath="health/simples/notifyInclusionsExclusionsVia" />
        <div class="simples-dialogue-76 simples-dialogue row-content mandatory hidden" mandatory="true">
            <div class="wrapper">
                <p>This policy also gives additional coverage for a wide range of other services but like most policies there are some things that are restricted and excluded, but <strong>none</strong> of which you mentioned as being important,</p>
                <div data-toggle="radio" id="health_simples_dialogue-radio-76">
                    <div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-76" id="health_simples_dialogue-radio-76-READNOW" class="checkbox-custom checkbox" value="READNOW" data-msg-required="Please choose the method that the client would like to be informed of the inclusions and exclusions" required="required"><label for="health_simples_dialogue-radio-76-READNOW">would you like me to read through them now?</label></div>
                    <div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-76" id="health_simples_dialogue-radio-76-WELCOMEPACK" class="checkbox-custom checkbox" value="WELCOMEPACK" data-msg-required="Please choose the method that the client would like to be informed of the inclusions and exclusions" required="required"><label for="health_simples_dialogue-radio-76-WELCOMEPACK">or are you happy to read them in your welcome pack?</label></div>
                </div>
            </div>
        </div>

        <simples:dialogue id="24" className="" vertical="health" />
        <simples:dialogue id="74" className="extendedFamilyRules hidden" vertical="health"/>
        <health_v3:results />
        <health_v3:more_info/>
        <health_v1:prices_have_changed_notification/>
        <health_v1:dual_pricing_modal />
        <c:if test="${callCentre}">
            <core_v1:js_template id="simples-dialogue-popup-template">
                <competition:africaCompSettings />
                <c:if test="${africaComp}">
                    <simples:dialogue id="106" vertical="health" />
                </c:if>
                <simples:dialogue id="62" vertical="health" className="hidden" />
                <c:if test="${pageSettings.getBrandCode() eq 'wfdd'}">
                    <field_v2:general_select xpath="health/application/wfd/heardAboutSelect" type="wimplesHeardAbout" required="false" initialText="How did you hear about Westfund?" />
                </c:if>
            </core_v1:js_template>
            <field_v1:hidden xpath="health/simples/dialogue-checkbox-62" />
            <c:if test="${pageSettings.getBrandCode() eq 'wfdd'}">
                <field_v1:hidden xpath="health/application/wfd/heardAbout" />
            </c:if>
        </c:if>
    </layout_v3:slide_content>

</layout_v3:slide>
