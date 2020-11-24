<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>

<%-- HTML --%>
<form_v2:row label="Position you appear on your medicare card" hideHelpIconCol="true" className="row card_pos" isNestedStyleGroup="${true}" id="medicare_group" renderLabelAsSimplesDialog="true">
	<c:set var="fieldXpath" value="${xpath}/cardPosition" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card"  className="health_payment_medicare_cardPosition-group"  isNestedField="${true}" smRowOverride="2" hideHelpIconCol="${true}">
		<field_v2:count_select xpath="${fieldXpath}" min="1" max="9" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition" placeHolder="#" disableErrorContainer="${true}"/>
	</form_v2:row>
</form_v2:row>

<c:set var="fieldXpath" value="${xpath}/firstName" />
<field_v1:hidden  xpath="${fieldXpath}" required="true" />

<c:if test="${showInitial eq true}">
    <c:set var="fieldXpath" value="${xpath}/middleName" />
    <field_v1:hidden  xpath="${fieldXpath}" required="false" />
</c:if>


<c:set var="fieldXpath" value="${xpath}/surname" />
<field_v1:hidden  xpath="${fieldXpath}" required="true" />
