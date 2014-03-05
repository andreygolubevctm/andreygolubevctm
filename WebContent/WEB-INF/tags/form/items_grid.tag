<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true" description="variable's xpath" %>
<%@ attribute name="className" 		required="false" 	rtexprvalue="true" description="additional css class attribute"%>
<%@ attribute name="labelClassName" required="false" 	rtexprvalue="true" description="additional css class attribute"%>
<%@ attribute name="title"			 	required="false" 	rtexprvalue="true" description="title for validation"%>
<%@ attribute name="id" 			required="false" 	rtexprvalue="true" description="optional id for this row"%>
<%@ attribute name="helpId" 		required="false" 	rtexprvalue="true" description="The rows help id (if non provided, help is not shown)"%>
<%@ attribute name="legend"			required="false" 	rtexprvalue="true" description="optional ledgend for this row"%>
<%@ attribute name="readonly" 		required="false" 	rtexprvalue="true" description="optional ledgend for this row"%>
<%@ attribute name="columns" 		required="false" 	rtexprvalue="true" description="number of columns defaults to 2"%>
<%@ attribute name="items" 			required="true" 	rtexprvalue="true" description="comma seperated list of values in value=description format"%>
<%@ attribute name="label" 			required="false" 	rtexprvalue="true" description="label for the field"%>
<%@ attribute name="validationValue" 	required="false" 	rtexprvalue="true" description="Validation value for total group"%>
<%@ attribute name="validationField" 	required="false" 	rtexprvalue="true" description="The field to check the validation against"%>


<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${not empty validationField}">
	<c:set var="validationField" value="${go:nameFromXpath(validationField)}" />
</c:if>
<c:set var="readonlyClass" value="" />
<c:if test="${readonly}">
	<c:set var="readonlyClass" value="readonly" />
</c:if>

<c:if test="${empty columns}">
	<c:set var="columns" value="2" />
</c:if>
<c:if test="${ empty(id) }">
	<c:set var="id">xfr_<%=java.lang.Math.round(java.lang.Math.random() * 32768)%></c:set>
</c:if>

<c:set var="id" value="${go:nameFromXpath(id)}" />

<go:style marker="css-head">
	.firstColumnLabel {
		line-height: 15px;
		margin-left: -10px;
		width: 186px;
	}
	.gridColumn${columns}Label {
		line-height: 15px;
		margin-left: 0.2em !important;
		margin-right: 0.2em !important;
		max-width: 15em !important;
		width: <fmt:formatNumber type="number" maxFractionDigits="0"
		value="${25 div columns}" />em !important;
	}
	.columnFirst {
		line-height: 15px;
		max-width: 10em;
	}
	.column {
		line-height: 15px;
		max-width: 10em;
	}
	.floatLeft {
		float:left;
	}
</go:style>

<%-- HTML --%>
<div class="${readonlyClass} fieldrow ${className}" id="${id}">
	<c:set var="begin" value="0" />
	<c:choose>
		<c:when test="${empty label}">
			<div class="floatLeft">
				<c:set var="i" value="0" />
				<c:forTokens items="${items}" delims="," var="radio" step="1">
					<c:set var="label" value="${fn:substringBefore(radio,'=')}" />
					<c:set var="element" value="${fn:substringAfter(radio,'=')}" />
					<c:set var="id" value="${name}_${val}" />
					<c:if test="${i mod columns == 0}">
						<div class="fieldrow_label firstColumnLabel ${labelClassName}">
							${label}</div>
						<div class="fieldrow_value columnFirst">${element}</div>
					</c:if>
					<c:set var="i" value="${i + 1}" />
				</c:forTokens>
			</div>
			<c:set var="begin" value="1" />
		</c:when>
		<c:otherwise>
			<div class="fieldrow_label ${labelClassName}">
				${label}
			</div>
		</c:otherwise>
	</c:choose>

	<c:forEach var="num" begin="${begin}" end="${columns-1}">
		<div class="floatLeft">
			<c:set var="i" value="0" />
			<c:forTokens items="${items}" delims="," var="radio" step="1">
				<c:set var="label" value="${fn:substringBefore(radio,'=')}" />
				<c:set var="element" value="${fn:substringAfter(radio,'=')}" />
				<c:set var="elementId">${fn:substringBefore( fn:substringAfter(element,'id="'), "\"" )}</c:set>

				<c:if test="${i mod columns == num}">
					<div class="fieldrow_label gridColumn${columns}Label ${labelClassName}">
						<c:choose>
							<c:when test="${not empty elementId}">
								<label for="${elementId}">
									${label}
								</label>
							</c:when>
							<c:otherwise>
								${label}
							</c:otherwise>
						</c:choose>
					</div>
					<div class="fieldrow_value column">${element}</div>
				</c:if>
				<c:set var="i" value="${i + 1}" />
			</c:forTokens>
		</div>
	</c:forEach>

	<c:if test="${helpId != null && helpId != ''}">
		<div class="help_icon" id="help_${helpId}"></div>
	</c:if>
	<c:if test="${readonly != true}">
		<div class="fieldrow_legend" id="${id}_row_legend">${legend}</div>
	</c:if>
	<core:clear />
</div>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">
$.validator.addMethod("${name}_checkTotal",
	function(value, elem, parm) {

		var parmsArray = parm.split(",");
		var validationValue = parmsArray[0];
		var validationField = parmsArray[1];

		var validationFieldValue = $('#'+validationField).val();

		if (parseInt(validationFieldValue, 10) <= parseInt(validationValue, 10) ) {
			$('.specifiedValues').removeClass('error');
			return true;
		}
		else {
			$('.specifiedValues').addClass('error');
			return false;
		}

	},
	"Custom message"
);
</go:script>
<%-- VALIDATION --%>
<c:if test="${not empty validationValue }">
	<c:set var="parms">"${validationValue},${validationField}"</c:set>
	<go:validate selector="${validationField}" rule="${name}_checkTotal" parm="${parms}" message="The Total sum of the ${title } cannot be more than $${validationValue }"/>
</c:if>
