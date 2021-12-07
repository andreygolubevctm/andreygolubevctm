<%@ tag description="Australian Government Rebate form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />

<%-- Get content text from db --%>
<c:set var="applicantCovered"><content:get key="applicantCovered" /></c:set>
<c:set var="entitledToMedicare"><content:get key="entitledToMedicare" /></c:set>
<c:set var="entitledToMedicareInfo"><content:get key="entitledToMedicareInfo" /></c:set>
<c:set var="entitledToMedicareMoreInfo"><content:get key="entitledToMedicareMoreInfo" /></c:set>
<c:set var="declaration"><content:get key="declaration" /></c:set>
<c:set var="privacyPolicy"><content:get key="privacyPolicy" /></c:set>
<fmt:formatDate var="declarationDate" value="${now}" pattern="dd/MM/yyyy" />

<form id="agr-form" class="form-horizontal">
    <h3>Application to receive the Australian Government Rebate on Private Health Insurance as a reduced premium</h3>
    <health_v4_contact:required_text />

    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/agr/applicantCovered" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Are you covered by this policy?" id=""
                 className="required_input">
        <field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="" required="true" id="" />

        <c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
        <div class="${name}-no-help no-help hidden">
            <div class="help-text">${applicantCovered}</div>
            <health_v4_agr:continue_without_rebate_link />
        </div>
    </form_v4:row>


    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/agr/entitledToMedicare" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Are all the people on the policy eligible for Medicare?" id=""
                 className="required_input">
        <field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="" required="true" id="" />

        <c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
        <div class="${name}-no-help no-help hidden">
            <div class="help-text">${entitledToMedicare}</div>
            <health_v4_agr:continue_without_rebate_link />
        </div>
    </form_v4:row>

    <div class="row">
        <div class="col-sm-8 col-sm-push-4">
            <div class="entitled-medicare-text">
                <c:set var="entitledMeidcareText">${entitledToMedicareInfo}</c:set>

                <c:out value="${entitledMeidcareText}" escapeXml="false" />
            </div>
            <div class="entitled-medicare-more-info-text">${entitledToMedicareMoreInfo}</div>
        </div>
    </div>

    <hr />

    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/agr/declaration" />
    <c:set var="title">${declaration}&nbsp;<span class='declaration-date'>${declarationDate}</span></c:set>

    <form_v4:row fieldXpath="${fieldXpath}" label="Declaration" className="required_input">
        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="${title}" label="${true}" required="true" errorMsg="Please tick" customAttribute=" data-attach='true' " />
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

    <div class="privacy-text">${privacyPolicy}</div>
</form>