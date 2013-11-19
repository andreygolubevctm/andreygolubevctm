<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from imported option."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="url" 		required="true"	 rtexprvalue="true"	 description="url of import file containing options" %>
<%@ attribute name="omitPleaseChoose" required="false"	rtexprvalue="true"	 description="should 'please choose' be omitted?" %>
<%@ attribute name="validateRule" required="false"	rtexprvalue="true"	 description="specify your own validation rule" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<%-- HTML --%>
<%-- Import the file into a variable --%>
<c:import url="${url}" var="optionData" />
<%-- Substitute the value="X" --%>
<c:set var="findVal" 	value="value=\"${value}\"" />
<c:set var="replaceVal" value="value='${value}' selected='selected'" />

<div>
	<div class="floatLeft">

		<jsp:element name="select">
			<jsp:attribute name="name">${name}</jsp:attribute>
			<jsp:attribute name="id">${name}</jsp:attribute>
			<jsp:attribute name="class">${className}</jsp:attribute>
			<jsp:body>
				<%-- Write the initial "please choose" option --%>
				<c:choose>
					<c:when test="${omitPleaseChoose == 'Y'}"></c:when>
					<c:when test="${value == ''}">
						<option value="" selected="selected">Please choose..</option>
					</c:when>
					<c:otherwise>
						<option value="">Please choose..</option>
					</c:otherwise>
				</c:choose>
				${fn:replace(optionData,findVal,replaceVal)}
			</jsp:body>
		</jsp:element>

	</div>
	<div class="floatLeft">
		<c:if test="${helpId != null && helpId != ''}">
			<span class="help_icon floatLeft" id="help_${helpId}"></span>
		</c:if>
	</div>
</div>


<%-- VALIDATION --%>
<c:if test="${validateRule == null}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose ${title}"/>
</c:if>
<c:if test="${validateRule == 'ccExp'}">
	<go:validate selector="${name}" rule="ccExp" parm="${required}" message="Please choose a valid ${title}"/>
</c:if>
<c:if test="${validateRule == 'mcExp'}">
	<go:validate selector="${name}" rule="mcExp" parm="${required}" message="Please choose a valid ${title}"/>
</c:if>

