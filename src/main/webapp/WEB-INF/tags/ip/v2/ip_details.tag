<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<form_v3:row label="Your gross annual income" helpId="411">
    <c:set var="fieldXPath" value="${xpath}/term" />
    <div class="input-group">
        <div class="input-group-addon">$</div>
        <field_v2:input xpath="${fieldXPath}" title="Gross Annual Income" required="true" type="text" className="currency" placeHolder="0" />
    </div>
</form_v3:row>

<form_v3:row label="Benefit amount" helpId="411">
    <c:set var="fieldXPath" value="${xpath}/amount" />
    <div class="input-group">
        <div class="input-group-addon">$</div>
        <field_v2:input xpath="${fieldXPath}" title="Gross Annual Income" required="true" type="text" className="currency" placeHolder="0" />
    </div>
</form_v3:row>

<form_v3:row label="Indemnity or Agreed" helpId="405">
    <field_v2:array_select xpath="${xpath}/value" required="true" title="Indemnity or Agreed" items="=Please choose...,I=Indemnity,A=Agreed" />
</form_v3:row>

<form_v3:row label="Waiting period" helpId="406">
    <field_v2:array_select xpath="${xpath}/waiting" required="true" title="waiting period" items="=Please choose...,14=14 days,30=30 days,60=60 days,90=90 days,1=1 year,2=2 years" />
</form_v3:row>

<form_v3:row label="Benefit period" helpId="407">
    <field_v2:array_select xpath="${xpath}/benefit" required="true" title="benefit period" items="=Please choose...,2=2 years,5=5 years,60=to Age 60,65=to Age 65,70=to Age 70" />
</form_v3:row>

<field_v1:hidden xpath="${xpath}/frequency" defaultValue="M" constantValue="M" />
<field_v1:hidden xpath="${xpath}/type" defaultValue="S" constantValue="S" />
<field_v1:hidden xpath="${xpath}/partner" defaultValue="N" constantValue="N" />