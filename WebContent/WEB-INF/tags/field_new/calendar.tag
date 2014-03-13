<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's date of birth."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 					required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 				required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 				required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 					required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="minDate" 				required="false" rtexprvalue="true"	 description="Minimum Date Value (DD/MM/YYYY) or 'today'"%>
<%@ attribute name="maxDate" 				required="false" rtexprvalue="true"	 description="Maximum Date Value (DD/MM/YYYY) or 'today'"%>
<%@ attribute name="startView" 				required="false" rtexprvalue="true"	 description="The view either 0:Month|1:Year|2:Decade|"%>
<%@ attribute name="mode"	 				required="false" rtexprvalue="true"	 description="Display as input or inline calendar (with hidden field)"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty mode}">
	<c:set var="mode">input</c:set>
</c:if>

<c:if test="${not empty maxDate}">
	<c:set var="maxDate"> data-date-end-date="${maxDate}" </c:set>
</c:if>

<c:if test="${not empty minDate}">
	<c:set var="minDate"> data-date-start-date="${minDate}" </c:set>
</c:if>

<c:if test="${empty startView}">
	<c:set var="startView" value="0" />
</c:if>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>


<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required" data-msg-required="Please enter the ${title}"' />
</c:if>

<%-- HTML --%>
<%--
	Datepicker useful links for devs:
		http://bootstrap-datepicker.readthedocs.org/
		http://eternicode.github.io/bootstrap-datepicker/
--%>

<c:choose>
	<c:when test="${mode eq 'inline'}">

		<%-- inline calendar needs to be inited on the below ID via JS somewhere else --%>
		<div id="${name}_calendar"></div>
		<field_new:validatedHiddenField xpath="${xpath}" className="${className}" title="Please enter the ${title}" validationErrorPlacementSelector="#${name}_calendar" />
	</c:when>
	<c:otherwise>

		<div class="input-group date">

			<input type="text"
				data-provide="datepicker"
				${maxDate}
				${minDate}
				data-date-start-view="${startView}"
				data-date-keyboard-navigation="false"
				placeholder="DD/MM/YYYY"
				name="${name}"
				id="${name}"
				class="form-control ${className}"
				value="${value}"
				title="${title}" ${requiredAttribute}>

			<span class="input-group-addon">
				<i class="icon-calendar"></i>
			</span>

		</div>

	</c:otherwise>
</c:choose>

<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>