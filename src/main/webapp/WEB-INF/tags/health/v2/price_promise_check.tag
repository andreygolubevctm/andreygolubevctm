<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price Promise simples questions and dialogue" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="fieldXpath" value="${xpath}/mentioned" />

<c:if test="${brand eq 'ctm'}">
    <form_v3:row label="&nbsp;" fieldXpath="${fieldXpath}">
        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="Tick here if customer mentions an external offer which relates to price promise." required="false" label="Tick here if customer mentions an external offer which relates to price promise." />
    </form_v3:row>


    <c:set var="fieldXpath" value="${xpath}/promotion" />

    <form_v3:row label="What was the promotion you saw?" fieldXpath="${fieldXpath}" className="healthPricePromisePromotionRow">
        <field_v2:array_select items="lower_headline_price=Lower headline price,discounts_off_headline_price=Discounts off headline price,offers_of_free_periods=Offers of 'free periods',cashback_offers='Casback' offers" xpath="${fieldXpath}" title="What was the promotion you saw?" required="true" />
    </form_v3:row>

    <simples:dialogue id="101" vertical="health" className="pricePromisePromotionDialogue" />
</c:if>