<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="dependant details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}{{= obj.dependantId }}"/>
<fmt:formatDate var="todayDate" value="${now}" pattern="yyyy-MM-dd" />
<div id="health-dependants-wrapper"></div>
<core_v1:js_template id="health-dependants-template">

    {{ var providerConfig = meerkat.modules.healthDependants.getConfig(); }}
    {{ var usesSchoolDropdown = providerConfig.useSchoolDropdownMenu === true; }}
    {{ var isNibOrQts = providerConfig.isNibOrQts === true; }}
    <%-- HTML --%>
    <div id="${name}" class="health_dependant_details dependant{{= obj.dependantId }}" data-id="{{= obj.dependantId }}">

        <form_v2:row>
            <div class="inlineHeadingWithButton">
                <h5>Dependant {{= obj.dependantId }}</h5>{{ if(obj.dependantId != 1) { }}
                <a href="javascript:void(0);" class="remove-dependent btn btn-danger" title="Remove last dependant"
                   data-id="{{= obj.dependantId }}">Remove Dependant</a>
                {{ } }}
            </div>
        </form_v2:row>

        <div class="items">

            <form_v2:row label="Name" hideHelpIconCol="true" className="row" isNestedStyleGroup="${true}">
                <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/title"/>
                <form_v2:row fieldXpath="${fieldXpath}" label="Title" smRowOverride="3" isNestedField="${true}" hideHelpIconCol="${true}" className="selectContainerTitle">
                    <field_v2:import_select xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s title" required="true" url="/WEB-INF/option_data/titles_pithy.html" placeHolder="Title" disableErrorContainer="${false}" additionalAttributes=" data-rule-genderTitle='dependant{{= obj.dependantId }}-gender' "/>
                </form_v2:row>


                <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/firstName"/>
                <form_v2:row fieldXpath="${fieldXpath}" label="First Name" smRowOverride="3" isNestedField="${true}" hideHelpIconCol="${true}">
                    <health_v3:check_name_capitalisation />
                    <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s first name" required="true" className="sessioncamexclude check-capitalisation expect-sentence-case"
                                    additionalAttributes=" data-rule-personName='true' " defaultValue="{{= obj.firstName }}" placeHolder="First name" disableErrorContainer="${true}" maxlength="24" />
                </form_v2:row>

                {{ if(providerConfig.showMiddleName === true) { }}
                <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/middleName"/>
                <form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_dependant_details_middleName" smRowOverride="3" isNestedField="${true}" hideHelpIconCol="${true}">
                    <health_v3:check_name_capitalisation />
                    <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s middle name" required="false" className="sessioncamexclude check-capitalisation expect-sentence-case"
                                    additionalAttributes=" data-rule-personName='true'" defaultValue="{{= obj.middleName }}" disableErrorContainer="${true}" />
                </form_v2:row>
                {{ } }}


                <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/lastname"/>
                <form_v2:row fieldXpath="${fieldXpath}" label="Last Name" smRowOverride="3" isNestedField="${true}" hideHelpIconCol="${true}">
                    <health_v3:check_name_capitalisation />
                    <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s last name" required="true" className="sessioncamexclude check-capitalisation expect-sentence-case"
                                    additionalAttributes=" data-rule-personName='true'" defaultValue="{{= obj.lastname }}" placeHolder="Last name" disableErrorContainer="${true}" maxlength="20" />
                </form_v2:row>

            </form_v2:row>

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/dob"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Date of Birth">
                <field_v2:person_dob xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s date of birth" required="true" ageMin="0"
                                     additionalAttributes=" data-rule-limitDependentAgeToUnder25='true' " outputJS="${false}" disableErrorContainer="${true}"/>
            </form_v2:row>

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/gender" />
            <form_v2:row fieldXpath="${fieldXpath}" label="Gender" id="${name}_genderRow">
                <field_v2:array_radio id="${name}_gender" xpath="${fieldXpath}" required="true" items="M=Male,F=Female" title="dependant {{= obj.dependantId }}'s gender" className="health-person-details dependant{{= obj.dependantId }}-gender" disableErrorContainer="${true}" />
            </form_v2:row>

                <%-- Only shows if showFullTimeField is true, AND the school age is between schoolMinAge and schoolMaxAge --%>
            {{ if(providerConfig.showFullTimeField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/fulltime"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Full-time student" id="${name}_fulltimeGroup"
                         className="health_dependant_details_fulltimeGroup hidden">
                <field_v2:array_radio xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="dependant {{= obj.dependantId }}'s full-time status" className="sessioncamexclude"  disableErrorContainer="${true}" />
            </form_v2:row>
            {{ } }}

            {{ if(providerConfig.showSchoolFields === true) { }}

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/school"/>
            <c:set var="storeGroupName" value="${go:nameFromXpath(fieldXpath)}" />
            <form_v2:row fieldXpath="${fieldXpath}" label="{{= (usesSchoolDropdown ? 'Educational institute this dependant is attending' : 'Name of school your child is attending') }}" id="${name}_schoolGroup"
                         className="health_dependant_details_schoolGroup hidden {{= usesSchoolDropdown ? 'hide-help-icon' : '' }}" helpId="290">
                {{ if (isNibOrQts) { }}
                    <field_v2:import_select xpath="${storeGroupName}" url="/WEB-INF/option_data/nib_qantas_educational_institutions.html" title="dependant {{= obj.dependantId }}'s educational institute" required="true" additionalAttributes="data-visible='true'"
                                        disableErrorContainer="${false}" className="combobox" placeHolder="Start typing to search or select from list" requiredErrorMessage="No Educational institute selected."/>
                {{ } else if(providerConfig.isAUF === true) { }}
                    <field_v2:import_select xpath="${storeGroupName}" url="/WEB-INF/option_data/auf_educational_institutions.html" title="dependant {{= obj.dependantId }}'s educational institute" required="true" additionalAttributes="data-visible='true'"
                                        disableErrorContainer="${false}" className="combobox" placeHolder="Start typing to search or select from list" requiredErrorMessage="No Educational institute selected."/>
                {{ } else { }}
                    <field_v2:import_select xpath="${storeGroupName}" url="/WEB-INF/option_data/other_providers_educational_institutions.html" title="dependant {{= obj.dependantId }}'s educational institute" required="true" additionalAttributes="data-visible='true'"
                                        disableErrorContainer="${false}" className="combobox" placeHolder="Start typing to search or select from list" requiredErrorMessage="No Educational institute selected."/>
                {{ } }}
            </form_v2:row>
            {{ if(providerConfig.showSchoolCommencementField === true && providerConfig.isAUF === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolDate"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Date Study Commenced" id="${name}_schoolDateGroup"
                         className="health_dependant_details_schoolDateGroup hidden">
                <field_v2:basic_date xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s study commencement" required="{{= providerConfig.schoolDateRequired }}" />
            </form_v2:row>
            {{ } }}
            {{ if(providerConfig.isNibOrQts === true || providerConfig.isAUF === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/gradDate"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Expected Graduation Date" id="${name}_schoolGraduationDate" className="health_dependant_details_schoolGraduationDate hidden" helpId="654">
                {{ if (providerConfig.isNibOrQts === true) { }}
                <field_v2:basic_date_mm_yyyy xpath="${fieldXpath}" minDate="${todayDate}" title="dependant {{= obj.dependantId }}'s graduation date " required="true" className="sessioncamexclude data-hj-suppress" mode="separated" defaultDay="31"/>
                {{ } else if(providerConfig.isAUF === true) { }}
                <field_v2:basic_date_mm_yyyy xpath="${fieldXpath}" minDate="${todayDate}" title="dependant {{= obj.dependantId }}'s graduation date " required="true" className="sessioncamexclude data-hj-suppress" mode="separated" defaultDay="1"/>
                {{ } }}
            </form_v2:row>
            {{ } }}
            {{ if(providerConfig.showSchoolIdField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolID"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Student ID Number" id="${name}_schoolIDGroup"
                         className="health_dependant_details_schoolIDGroup hidden">
                <field_v2:input xpath="${fieldXpath}" required="false" className="sessioncamexclude" maxlength="{{= providerConfig.schoolIdMaxLength }}" defaultValue="{{= obj.schoolID }}"  disableErrorContainer="${true}"/>
            </form_v2:row>
            {{ } }}

            {{ if(providerConfig.showSchoolCommencementField === true && providerConfig.isAUF === false) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolDate"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Date Study Commenced" id="${name}_schoolDateGroup"
                         className="health_dependant_details_schoolDateGroup hidden">
                <field_v2:basic_date xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s study commencement" required="{{= providerConfig.schoolDateRequired }}"  disableErrorContainer="${true}" />
            </form_v2:row>
            {{ } }}

            {{ } }}
                <%-- Only  exists in GMF which has been turned off. --%>
            {{ if(providerConfig.showMaritalStatusField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/maritalincomestatus"/>
            <form_v2:row fieldXpath="${fieldXpath}"
                         label="Is this dependant not married or living in a defacto relationship and earning less than $20,500 p/annum?"
                         id="${name}_maritalincomestatusGroup" className="health_dependant_details_maritalincomestatus hidden">
                <field_v2:array_radio id="${name}_maritalincomestatus" xpath="${fieldXpath}" required="true"
                                      items="Y=Yes,N=No" additionalAttributes=" data-rule-defactoConfirmation='true' "
                                      title="if dependant {{= obj.dependantId }} is not married or living in a defacto relationship and earning less than $20,500 p/annum?"
                                      className="health-person-details" disableErrorContainer="${true}"/>
            </form_v2:row>
            {{ } }}


            {{ if(providerConfig.showApprenticeField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/apprentice"/>
            <form_v2:row fieldXpath="${fieldXpath}"
                         label="Apprentice earning less than $30,000pa?"
                         id="${name}_apprenticeGroup" className="health_dependant_details_apprenticeGroup hidden">
                <field_v2:array_radio id="${name}_apprentice" xpath="${fieldXpath}" required="true"
                                      items="Y=Yes,N=No"
                                      title="if dependant {{= obj.dependantId }} is an apprentice earning less than $30,000pa?"
                                      className="health-person-details" disableErrorContainer="${true}"/>
            </form_v2:row>
            {{ } }}

                <%-- used by navy --%>
            {{ if(providerConfig.showRelationship === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/relationship"/>
            <form_v2:row fieldXpath="${fieldXpath}"
                         label="Relationship"
                         id="${name}_relationshipGroup" className="health_dependant_details_relationshipGroup">
                <field_v2:general_select type="healthNavQuestion_relationship" xpath="${fieldXpath}" title="Relationship to you" required="true" initialText="Please select" disableErrorContainer="${true}" />
            </form_v2:row>
            {{ } }}

            <div id="simples-dialogue-dependant{{= obj.dependantId }}" class="simples-dialogue-dependant{{= obj.dependantId }} simples-dialogue row-content simplesDynamicElements mandatory hidden"  data-scripting-template="%DEPENDANTS_SCRIPT_TEMPLATE%. Is that right?">
                <div class="wrapper">
                    <div class="checkbox-custom simples_dialogue-checkbox-dependant{{= obj.dependantId }} checkbox">
                        <input type="checkbox" name="health_simples_dialogue-checkbox-dependant{{= obj.dependantId }}" id="health_simples_dialogue-checkbox-dependant{{= obj.dependantId }}" class="checkbox-custom  checkbox" value="Y" required="" data-msg-required="Please confirm each mandatory dialog has been read to the client" aria-required="true">
                        <label for="health_simples_dialogue-checkbox-dependant{{= obj.dependantId }}">
                            <p class="red">default copy to be replaced</p><p class="black"><i>Customer must answer with a clear yes or no response</i></p>
                        </label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</core_v1:js_template>
