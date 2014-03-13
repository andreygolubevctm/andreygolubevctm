<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a mobile phone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true" rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 		required="true" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="size"			required="true" rtexprvalue="true"	 description="size of the input" %>
<%@ attribute name="title"			required="true" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="placeHolder"	required="false" rtexprvalue="true"	 description="HTML5 placeholder" %>
<%@ attribute name="placeHolderUnfocused"	required="false" rtexprvalue="true"	 description="HTML5 placeholder when input not in focus" %>
<%@ attribute name="allowLandline"	required="true" rtexprvalue="true"	 description="?" %>
<%@ attribute name="allowMobile"	required="true" rtexprvalue="true"	 description="?" %>
<%@ attribute name="labelName"		required="false" rtexprvalue="true"	 description="the label to display for validation" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="nameInput" value="${name}input" />
<c:set var="xpathInput">${xpath}input</c:set>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="valueInput"><c:out value="${data[xpathInput]}" escapeXml="true"/></c:set>

<c:if test="${empty valueInput && not empty value}">
	<c:set var="valueInput" value="${value}" />
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required"' />
</c:if>

<c:if test="${not empty size}">
	<c:set var="sizeAttribute" value=' size="${size}"' />
</c:if>

<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderAttribute" value=' placeholder="${placeHolder}"' />
	<c:set var="className" value="${className} placeholder" />
</c:if>

<c:if test="${not empty placeHolderUnfocused}">
	<c:set var="placeHolderAttribute" value='${placeHolderAttribute} data-placeholder-unfocused="${placeHolderUnfocused}"' />
</c:if>

<c:choose>
	<c:when test="${allowLandline && allowMobile}">
		<c:set var="phoneTypeClassName" value=" anyPhoneType" />
	</c:when>
	<c:when test="${allowMobile}">
		<c:set var="phoneTypeClassName" value=" mobile" />
	</c:when>
	<c:otherwise>
		<c:set var="phoneTypeClassName" value=" landline" />
	</c:otherwise>
</c:choose>

<c:set var="labelName">
	<c:choose>
		<c:when test="${not empty labelName}">${labelName}</c:when>
		<c:when test="${not empty title}">${title}</c:when>
		<c:otherwise>phone number</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" class="" value="${value}" >
<input type="text" name="${nameInput}" id="${nameInput}" title="${title}"
		class="form-control contact_telno phone ${className} ${phoneTypeClassName} ${name}"
		value="${valueInput}" pattern="[0-9]*" ${sizeAttribute}${placeHolderAttribute}${requiredAttribute}
		data-msg-required="Please enter the ${labelName}."
		maxlength="14">


<go:script marker="onready">
		$("#${nameInput}").on("focusout", function(){
			$("#${name}").val( $(this).val().replace(/[^0-9]+/g, '') );
		});
		<%-- remove fake placeholders (for IE8/9) if preloaded data --%>
		if( typeof meerkat !== "undefined" && $("#${nameInput}").val() !== "" ){
			meerkat.modules.placeholder.invalidatePlaceholder( $("#${nameInput}") );
		}
</go:script>