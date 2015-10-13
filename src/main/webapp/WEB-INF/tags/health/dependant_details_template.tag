<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="dependant details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}{{= obj.dependantId }}"/>
<div id="health-dependants-wrapper"></div>
<core:js_template id="health-dependants-template">

    {{ var dependantsConfig = meerkat.modules.healthDependants.getConfig(); }}
    {{ var usesSchoolDropdown = dependantsConfig.useSchoolDropdownMenu === true; }}
    <%-- HTML --%>
    <div id="${name}" class="health_dependant_details dependant{{= obj.dependantId }}" data-id="{{= obj.dependantId }}">

        <form_new:row>
            <div class="inlineHeadingWithButton">
                <h5>Dependant {{= obj.dependantId }}</h5>{{ if(obj.dependantId != 1) { }}
                <a href="javascript:void(0);" class="remove-dependent btn btn-danger" title="Remove last dependent"
                                                                                            data-id="{{= obj.dependantId }}">Remove Dependant</a>
                {{ } }}
            </div>
        </form_new:row>

        <div class="items">

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/title"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Title">
                <field_new:import_select xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s title" required="true" url="/WEB-INF/option_data/titles_pithy.html"/>
            </form_new:row>

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/firstName"/>
            <form_new:row fieldXpath="${fieldXpath}" label="First Name">
                <field_new:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s first name" required="true" className="sessioncamexclude"
                                 additionalAttributes=" data-rule-personName='true' "/>
            </form_new:row>

            {{ if(dependantsConfig.showMiddleName === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/middleName"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_dependant_details_middleName">
                <field_new:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s middle name" required="false" className="sessioncamexclude"
                                 additionalAttributes=" data-rule-personName='true' "/>
            </form_new:row>
            {{ } }}

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/lastname"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Last Name">
                <field_new:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s last name" required="true" className="sessioncamexclude"
                                 additionalAttributes=" data-rule-personName='true' "/>
            </form_new:row>

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/dob"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Date of Birth">
                <field_new:person_dob xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s date of birth" required="true" ageMin="0"
                                      additionalAttributes=" data-rule-limitDependentAgeToUnder25='true' " outputJS="${false}"/>
            </form_new:row>
            <%-- Only shows if showFullTimeField is true, AND the school age is between schoolMinAge and schoolMaxAge --%>
            {{ if(dependantsConfig.showFullTimeField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/fulltime"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Full-time student" id="${name}_fulltimeGroup"
                          className="health_dependant_details_fulltimeGroup hidden">
                <field_new:array_radio xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="dependant {{= obj.dependantId }}'s full-time status" className="sessioncamexclude"/>
            </form_new:row>
            {{ } }}

            {{ if(dependantsConfig.showSchoolFields === true) { }}

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/school"/>
            <form_new:row fieldXpath="${fieldXpath}" label="{{= (usesSchoolDropdown ? 'Educational institute this dependant is attending' : 'Name of school your child is attending') }}" id="${name}_schoolGroup"
                          className="health_dependant_details_schoolGroup hidden" helpId="{{= usesSchoolDropdown ? '' : 290 }}">
                {{ if(usesSchoolDropdown === true) { }}
                <c:set var="storeGroupName" value="${go:nameFromXpath(fieldXpath)}" />
                <div class="select">
                    <span class="input-group-addon"><i class="icon-sort"></i></span>
                    <select name="${storeGroupName}" id="${storeGroupName}" class="form-control" required title="dependant {{= obj.dependantId }}'s educational institute">
                        {{= meerkat.modules.healthDependants.getEducationalInstitutionsOptions() }}
                    </select>
                </div>
                {{ } else { }}
                <field_new:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s school" required="true" className="sessioncamexclude"/>
                {{ } }}
            </form_new:row>

            {{ if(dependantsConfig.showSchoolIdField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolID"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Student ID Number" id="${name}_schoolIDGroup"
                          className="health_dependant_details_schoolIDGroup hidden">
                <field_new:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s student ID number" required="{{= dependantsConfig.schoolIdRequired }}" className="sessioncamexclude" maxlength="{{= (schoolIdMaxLength || '') }} "/>
            </form_new:row>
            {{ } }}

            {{ if(dependantsConfig.showSchoolCommencementField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolDate"/>
            <form_new:row fieldXpath="${fieldXpath}" label="Date Study Commenced" id="${name}_schoolDateGroup"
                          className="health_dependant_details_schoolDateGroup hidden">
                <field_new:basic_date xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s study commencement date" required="{{= dependantsConfig.schoolDateRequired }}" />
            </form_new:row>
            {{ } }}

            {{ } }}
                <%-- Only  exists in GMF which has been turned off. --%>
            {{ if(dependantsConfig.showMaritalStatusField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/maritalincomestatus"/>
            <form_new:row fieldXpath="${fieldXpath}"
                          label="Is this dependant not married or living in a defacto relationship and earning less than $20,500 p/annum?"
                          id="${name}_maritalincomestatusGroup" className="health_dependant_details_maritalincomestatus hidden">
                <field_new:array_radio id="${name}_maritalincomestatus" xpath="${fieldXpath}" required="true"
                                       items="Y=Yes,N=No" additionalAttributes=" data-rule-defactoConfirmation='true' "
                                       title="if dependant {{= obj.dependantId }} is not married or living in a defacto relationship and earning less than $20,500 p/annum?"
                                       className="health-person-details"/>
            </form_new:row>
            {{ } }}


            {{ if(dependantsConfig.showApprenticeField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/apprentice"/>
            <form_new:row fieldXpath="${fieldXpath}"
                          label="Apprentice earning less than $30,000pa?"
                          id="${name}_apprenticeGroup" className="health_dependant_details_apprenticeGroup hidden">
                <field_new:array_radio id="${name}_apprentice" xpath="${fieldXpath}" required="true"
                                       items="Y=Yes,N=No"
                                       title="if dependant {{= obj.dependantId }} is an apprentice earning less than $30,000pa?"
                                       className="health-person-details"/>
            </form_new:row>
            {{ } }}

        </div>
    </div>
</core:js_template>