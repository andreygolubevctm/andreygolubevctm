<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="dependant details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}{{= obj.dependantId }}"/>
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

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/title"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Title">
                <field_v2:import_select xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s title" required="true" url="/WEB-INF/option_data/titles_pithy.html"/>
            </form_v2:row>

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/firstName"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="First Name">
                <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s first name" required="true" className="sessioncamexclude"
                                additionalAttributes=" data-rule-personName='true' " defaultValue="{{= obj.firstName }}" />
            </form_v2:row>

            {{ if(providerConfig.showMiddleName === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/middleName"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_dependant_details_middleName">
                <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s middle name" required="false" className="sessioncamexclude"
                                additionalAttributes=" data-rule-personName='true'" defaultValue="{{= obj.middleName }}" />
            </form_v2:row>
            {{ } }}

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/lastname"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Last Name">
                <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s last name" required="true" className="sessioncamexclude"
                                additionalAttributes=" data-rule-personName='true'" defaultValue="{{= obj.lastname }}" />
            </form_v2:row>

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/dob"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Date of Birth">
                <field_v2:person_dob xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s date of birth" required="true" ageMin="0"
                                     additionalAttributes=" data-rule-limitDependentAgeToUnder25='true' " outputJS="${false}"/>
            </form_v2:row>
                <%-- Only shows if showFullTimeField is true, AND the school age is between schoolMinAge and schoolMaxAge --%>
            {{ if(providerConfig.showFullTimeField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/fulltime"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Full-time student" id="${name}_fulltimeGroup"
                         className="health_dependant_details_fulltimeGroup hidden">
                <field_v2:array_radio xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="dependant {{= obj.dependantId }}'s full-time status" className="sessioncamexclude"/>
            </form_v2:row>
            {{ } }}

            {{ if(providerConfig.showSchoolFields === true) { }}

            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/school"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="{{= (usesSchoolDropdown ? 'Educational institute this dependant is attending' : 'Name of school your child is attending') }}" id="${name}_schoolGroup"
                         className="health_dependant_details_schoolGroup hidden {{= usesSchoolDropdown ? 'hide-help-icon' : '' }}" helpId="{{= isNibOrQts ? '653' : '290' }}">
                {{ if(isNibOrQts === true) { }}
                <c:set var="storeGroupName" value="${go:nameFromXpath(fieldXpath)}" />
                <div class="select">
                    <span class="input-group-addon"><i class="icon-angle-down"></i></span>
                    <field_v2:import_select xpath="${storeGroupName}" className="form-control" url="/WEB-INF/option_data/nib_qantas_educational_institutions.html" title="dependant {{= obj.dependantId }}'s educational institute" required="false" />
                    </select>
                </div>
                {{ } else if(usesSchoolDropdown === true) { }}
                <c:set var="storeGroupName" value="${go:nameFromXpath(fieldXpath)}" />
                <div class="select">
                    <span class="input-group-addon"><i class="icon-angle-down"></i></span>
                    <select name="${storeGroupName}" id="${storeGroupName}" class="form-control" required title="dependant {{= obj.dependantId }}'s educational institute">
                        {{= meerkat.modules.healthDependants.getEducationalInstitutionsOptions() }}
                    </select>
                </div>
                {{ } else { }}
                <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s school" required="true" className="sessioncamexclude" defaultValue="{{= obj.school }}"/>
                {{ } }}
            </form_v2:row>

            {{ if(providerConfig.showSchoolIdField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolID"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Student ID Number" id="${name}_schoolIDGroup"
                         className="health_dependant_details_schoolIDGroup hidden">
                <field_v2:input xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s student ID number" required="{{= providerConfig.schoolIdRequired }}" className="sessioncamexclude" maxlength="{{= providerConfig.schoolIdMaxLength }}" defaultValue="{{= obj.schoolID }}"/>
            </form_v2:row>
            {{ } }}

            {{ if(providerConfig.showSchoolCommencementField === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/schoolDate"/>
            <form_v2:row fieldXpath="${fieldXpath}" label="Date Study Commenced" id="${name}_schoolDateGroup"
                         className="health_dependant_details_schoolDateGroup hidden">
                <field_v2:basic_date xpath="${fieldXpath}" title="dependant {{= obj.dependantId }}'s study commencement" required="{{= providerConfig.schoolDateRequired }}" />
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
                                      className="health-person-details"/>
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
                                      className="health-person-details"/>
            </form_v2:row>
            {{ } }}

                <%-- used by navy --%>
            {{ if(providerConfig.showRelationship === true) { }}
            <c:set var="fieldXpath" value="${xpath}{{= obj.dependantId }}/relationship"/>
            <form_v2:row fieldXpath="${fieldXpath}"
                         label="Relationship"
                         id="${name}_relationshipGroup" className="health_dependant_details_relationshipGroup">
                <field_v2:general_select type="healthNavQuestion_relationship" xpath="${fieldXpath}" title="Relationship to you" required="true" initialText="Please select" />
            </form_v2:row>
            {{ } }}


        </div>
    </div>
</core_v1:js_template>