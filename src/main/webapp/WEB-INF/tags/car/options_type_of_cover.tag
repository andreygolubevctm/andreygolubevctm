<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for type of cover options"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="typeOfCoverOptions">
    <c:choose>
        <c:when test="${pageSettings.getBrandCode() eq 'ctm'}">
            COMPREHENSIVE=Comprehensive,TPFT=Third party property&#44; fire and theft,TPPD=Third party property,CTP=Compulsory third party (Greenslip)
        </c:when>
        <c:otherwise>
            COMPREHENSIVE=Comprehensive,CTP=Compulsory third party (Greenslip)
        </c:otherwise>
    </c:choose>
</c:set>

<%-- HTML --%>

<form_v2:row label="What level of car insurance cover are you looking for?" id="${name}FieldRow" helpId="565">
    <field_v2:array_select xpath="${xpath}"
                           items="${typeOfCoverOptions}"
                           required="true"
                           title="what level of car insurance cover are you looking for"
                           className="type_of_cover" />
</form_v2:row>

