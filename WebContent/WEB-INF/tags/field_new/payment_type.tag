<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Payment Type (Annual/Instalment)"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>

<%-- HTML --%>
<field:array_select xpath="${xpath}" className="paymentType ${className}" title="${title}" items="A=Annual,I=Monthly" required="false" />
