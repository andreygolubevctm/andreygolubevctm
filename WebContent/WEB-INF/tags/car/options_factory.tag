<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for factory/sealer options"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset legend="Factory / Dealer Options" id="${name}FieldSet">

	<form_new:row label="Does the car have any factory/dealer options fitted?" id="${name}FieldRow" className="initial" helpId="13">
		<field_new:array_radio xpath="${xpath}RadioBtns" required="true"
			className="" items="Y=Yes,N=No"
			id="${name}RadioBtns" title="if the car has any factory/dealer options fitted" />
		<a href="javascript:;" class="btn btn-edit" id="${name}Button" title="Edit Selections">Edit Selections</a>
	</form_new:row>

	<div id="${name}Selections">
		<label class="col-lg-3 col-sm-4 col-xs-10"><!-- empty --></label>
		<div class="col-lg-9 col-sm-8 col-xs-12 added-items">
			<ul><!-- empty --></ul>
		</div>
	</div>

	<field:hidden xpath="${xpath}" defaultValue="${data[xpath]}" />

</form_new:fieldset>

<car:options_factory_dialog xpath="${xpath}"/>
