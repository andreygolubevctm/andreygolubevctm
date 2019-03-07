<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for factory/sealer options"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
	<c:set var="analAttribute"><field_v1:analytics_attr analVal="Factory Options Fitted - Tool Tip" quoteChar="\"" /></c:set>
	<form_v2:row label="Does the car have any factory/dealer options fitted?" id="${name}FieldRow" className="initial" helpId="13" tooltipAttributes="${analAttribute}">
		<c:set var="analAttribute"><field_v1:analytics_attr analVal="Factory Options Fitted" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${xpath}RadioBtns" required="true"
			className="" items="Y=Yes,N=No"
			id="${name}RadioBtns" title="if the car has any factory/dealer options fitted" additionalLabelAttributes="${analAttribute}" />
		<c:set var="analAttribute"><field_v1:analytics_attr analVal="Factory options - Edit Selections" quoteChar="\"" /></c:set>
		<a href="javascript:;" class="btn btn-edit" id="${name}Button" title="Edit Selections" ${analAttribute}>Edit Selections</a>
	</form_v2:row>

	<div id="${name}Selections">
		<label class="col-sm-4 col-xs-10"><!-- empty --></label>
		<div class="col-md-6 col-sm-8 col-xs-12 added-items">
			<ul><!-- empty --></ul>
		</div>
	</div>

	<field_v1:hidden xpath="${xpath}" defaultValue="${data[xpath]}" />

<car:options_factory_dialog xpath="${xpath}"/>
