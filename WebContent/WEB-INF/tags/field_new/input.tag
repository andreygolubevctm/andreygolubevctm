<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form input field."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		            required="true"  rtexprvalue="true"   description="variable's xpath" %>
<%@ attribute name="required" 	            required="true"  rtexprvalue="true"   description="is this field required?" %>
<%@ attribute name="requiredMessage"        required="false"  rtexprvalue="true"  description="Validation message when field is required" %>
<%@ attribute name="className" 	            required="false" rtexprvalue="true"   description="additional css class attribute" %>
<%@ attribute name="title" 		            required="false"  rtexprvalue="true"  description="The input field's title"%>
<%@ attribute name="maxlength" 	            required="false" rtexprvalue="true"   description="The maximum length for the input field"%>
<%@ attribute name="size" 	                required="false" rtexprvalue="true"   description="The maximum size for the input field"%>
<%@ attribute name="readOnly" 	            required="false" rtexprvalue="true"   description="readOnly true or otherwise" %>
<%@ attribute name="tabIndex"	            required="false" rtexprvalue="true"   description="TabIndex of the field" %>
<%@ attribute name="type"                   required="false" rtexprvalue="true"   description="Type attribute of the input e.g. HTML5 types like 'email'" %>
<%@ attribute name="placeHolder"            required="false" rtexprvalue="true"   description="HTML5 placeholder" %>
<%@ attribute name="pattern"                required="false" rtexprvalue="true"   description="HTML5 pattern attribute" %>
<%@ attribute name="integerKeyPressLimit"   required="false" rtexprvalue="true"   description="Limit kepresses to integer numeric keys" %>
<%@ attribute name="decimalKeyPressLimit"   required="false" rtexprvalue="true"   description="Limit kepresses to decimal numeric keys" %>
<%@ attribute name="formattedDecimal"       required="false" rtexprvalue="true"   description="Live number formatting applied to field (2 decimal places) - use true/false or the number of decimal places to use." %>
<%@ attribute name="formattedInteger"       required="false" rtexprvalue="true"   description="Live number formatting applied to field (NO decimal places) - use true/false" %>
<%@ attribute name="includeInForm"          required="false" rtexprvalue="true"   description="Force attribute to include value in data bucket - use true/false" %>

<%-- VARIABLES --%>
<c:if test="${readOnly}">
	<go:setData dataVar="data" xpath="readonly/${xpath}" value="${data[xpath]}" />
</c:if>

<c:if test="${includeInForm eq true}">
	<c:set var="includeAttribute" value=' data-attach="true" ' />
</c:if>

<c:choose>
	<c:when test="${not empty size}">
		<c:set var="size" value="${size}" />
	</c:when>
	<c:otherwise>
		<c:set var="size" value="20" />
	</c:otherwise>
</c:choose>

<c:if test="${not empty maxlength}">
	<c:set var="maxlength" value=" maxlength='${maxlength}'" />
</c:if>

<c:if test="${not empty tabIndex}">
	<c:set var="tabIndexValue">tabindex=${tabIndex}</c:set>
</c:if>

<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderAttribute" value=' placeholder="${placeHolder}"' />
	<c:set var="className">${className} placeholder</c:set>
</c:if>

<c:if test="${not empty pattern}">
	<c:set var="patternAttribute" value=' pattern="${pattern}" ' />
</c:if>

<c:if test="${empty type}">
	<c:set var="type" value="text" />
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=" required" />

	<c:if test="${not empty requiredMessage}">
		<c:set var="requiredAttribute" value='${requiredAttribute} data-msg-required="${requiredMessage}"' />
	</c:if>
</c:if>

<c:set var="keyPressLimit">
	<c:choose>
		<c:when test="${not empty integerKeyPressLimit}"> onKeyPress="return meerkat.modules.utilities.isValidNumericKeypressEvent(event, false)"</c:when>
		<c:when test="${not empty decimalKeyPressLimit}"> onKeyPress="return meerkat.modules.utilities.isValidNumericKeypressEvent(event, true)"</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="className">
	<c:choose>
		<c:when test="${not empty formattedDecimal and formattedDecimal ne 'false'}">
			<c:choose>
				<c:when test="${formattedDecimal eq 'true'}">${className} liveFormatNumber formattedDecimal formattedDecimal_2</c:when>
				<c:otherwise>${className} formattedDecimal_${formattedDecimal}</c:otherwise>
			</c:choose>
		</c:when>
		<c:when test="${not empty formattedInteger}">${className} liveFormatNumber formattedInteger</c:when>
		<c:otherwise>${className}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:choose>
	<c:when test="${!readOnly}">
		<%-- HTML --%>
		<input type="${type}" name="${name}" id="${name}" class="form-control ${className}" value="${value}" ${maxlength}${requiredAttribute}${tabIndexValue}${placeHolderAttribute}${patternAttribute}${keyPressLimit}${includeAttribute}>
	</c:when>
	<c:otherwise>
		<input type="hidden" name="${name}" id="${name}" class="${className}" value="${value}">
		<div class="field readonly" id="${name}-readonly">${data[xpath]}</div>
	</c:otherwise>
</c:choose>