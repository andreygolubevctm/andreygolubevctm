<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		 required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required"  	 required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className"   required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		 required="true"  rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="size" 		 required="false" rtexprvalue="true"	 description="the size attribute of this input"%>
<%@ attribute name="placeholder" required="false" rtexprvalue="true"  description="HTML5 placeholder" %>
<%@ attribute name="maxlength" required="false" rtexprvalue="true"
			  description="The maximum length for the input field" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required"' />
</c:if>

<c:set var="sizeAttribute" value=' size="18"' />
<c:if test="${not empty size}">
	<c:set var="sizeAttribute" value=' size="${size}"' />
</c:if>

<c:if test="${not empty placeholder}">
	<c:set var="placeHolderAttribute" value=' placeholder="${placeholder}"' />
</c:if>

<c:if test="${not empty maxlength}">
	<c:set var="maxlengthAttribute" value=' maxlength="${maxlength}"'/>
</c:if>

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="form-control person_name sessioncamexclude ${className}"
	   value="${value}" ${sizeAttribute}${requiredAttribute}${placeHolderAttribute} ${maxlengthAttribute}
					data-msg-required="Please enter ${title}" data-rule-personName="true">