<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Registration Lookup Form Component"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>

<jsp:useBean id="regoLookupService" class="com.ctm.services.car.RegoLookupService" />
<jsp:useBean id="ipCheckService" class="com.ctm.services.IPCheckService" />
<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="showRegoLookupForm">
    <c:choose>
        <c:when test="${regoLookupService.isAvailable(pageContext.getRequest())}">
            <c:choose>
                <c:when test="${ipCheckService.isPermittedAccess(pageContext.getRequest(), pageSettings)}">
                    <c:choose>
                        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 13)}">${true}</c:when>
                        <c:otherwise>${false}</c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>${false}</c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>

<c:if test="${showRegoLookupForm eq true}">
    <div id="rego-lookup-form">
        <form_new:row label="State">
            <field_new:array_select xpath="${xpath}/searchState" includeInForm="false" items="=Please choose...,ACT=Canberra,NT=Northern Territory,NSW=New South Wales,QLD=Queensland,SA=South Australia,TAS=Tasmania,VIC=Victoria,WA=Western Australia" title="state vehicle registered" required="false" className="rego-lookup-state sessioncamexclude" />
        </form_new:row>
        <form_new:row label="Enter your car's registration no.">
            <div class="col-xs-12 col-sm-6 rego-lookup-number-col">
                <field_new:input xpath="${xpath}/searchRego" includeInForm="false" required="false" title="vehicle registration number" className="rego-lookup-number" placeHolder="eg. 123ABC" />
            </div>
            <div class="col-xs-12 col-sm-6 rego-lookup-btn-col">
                <a href="#lookuprego" class="btn btn-default rego-lookup-button">Find Car<span class="icon icon-arrow-right"><!-- empty --></span></a>
            </div>
        </form_new:row>
        <div class="rego-lookup-feedback"><!-- populate by module --></div>
        <div class="rego-lookup-divider">
            <div class="line"><!-- empty --></div>
            <span>Or find you car by make and model</span>
        </div>
    </div>
</c:if>