<%@ tag description="Australian Government Rebate form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<form id="agr-form" class="form-horizontal">
    <h3>Application to receive the Australian Government Rebate on Private Health Insurance as a reduced premium</h3>
    <health_v4_contact:required_text />

    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/govtRebateDeclaration/applicantCovered" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Are you covered by this policy?" id=""
                 className="required_input">
        <field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="" required="true" id="" />

        <c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
        <div class="${name}-no-help no-help hidden">
            <div class="help-text">
                Applicant not covered by the policy cannot claim the Australian Government Rebate on Private Health Insurance (excluding child only polices) and employers and trustees of organisations cannot claim the Australian Government Rebate on Private Health Insurance on policies paid on behalf of employees.
            </div>
            <health_v4_agr:continue_without_rebate_link />
        </div>
    </form_v4:row>


    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/govtRebateDeclaration/entitledToMedicare" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Are all the people on the policy listed on a Medicare card or entitled to a Medicare card?" id=""
                 className="required_input">
        <field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="" required="true" id="" />

        <c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
        <div class="${name}-no-help no-help hidden">
            <div class="help-text">
                All people listed on this policy must be eligible to claim Medicare for you to receive the rebate at a reduced premium.
            </div>
            <health_v4_agr:continue_without_rebate_link />
        </div>
    </form_v4:row>

    <div class="row">
        <div class="col-sm-8 col-sm-push-4">
            <div class="entitled-medicare-text">
                <c:set var="entitledMeidcareText">
                    You may be entitled to a Medicare card if you are:
                    <ul>
                        <li>a person who lives in Australia, and</li>
                        <li>an Australian citizen, or</li>
                        <li>a holder of a permanent resident visa, or</li>
                    </ul>
                    <ul>
                        <li>a New Zealand citizen, or</li>
                        <li>an applicant for a permanent resident visa</li>
                    </ul>
                </c:set>

                <c:out value="${entitledMeidcareText}" escapeXml="false" />
            </div>
        </div>
    </div>

    <hr />

    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/govtRebateDeclaration/declaration" />
    <c:set var="title">
        I declare that:
        <ul>
            <li>the information I have provided in this form is complete and correct.</li>
        </ul>
        I understand that:
        <ul>
            <li>giving false or misleading information is a serious offence.</li>
        </ul>
        I make this declaration on 9/5/2017
    </c:set>
    <form_v4:row fieldXpath="${fieldXpath}" label="Declaration" className="required_input">
        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="${title}" label="${true}" required="true" customAttribute=" data-attach='true' " />
    </form_v4:row>

    <div class="row">
        <div class="col-sm-4 col-sm-push-8">
            <a href="javascript:;" class="btn btn-next btn-continue-to-payment" disabled>
                Continue to payment
                <span class="icon icon-arrow-right"></span>
            </a>
            <health_v4_agr:continue_without_rebate_link />
        </div>
    </div>
</form>