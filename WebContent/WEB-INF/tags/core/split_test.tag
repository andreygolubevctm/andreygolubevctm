<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Split test ninja turtle fight techniques or whatever you want really.."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="dataVar" 		required="true"		rtexprvalue="true"	description="The variable that needs to be set to databucket as an xpath"%>
<%@ attribute name="forceNew" 		required="false"	rtexprvalue="true"	description="true/false to force a new code even if it exists in the databucket. Defaults to true"%>
<%@ attribute name="codes" 			required="false"	rtexprvalue="true" 	description="Comma deliminated list of possible values. Defaults to true/false" %>
<%@ attribute name="supertagName" 	required="false"	rtexprvalue="true" 	description="The testname of the supertag object. If ommitted then its not invoked" %>
<%@ attribute name="paramName" 		required="false"	rtexprvalue="true" 	description="Short version of the name for param usage" %>

<%@ attribute name="var" required="true" rtexprvalue="false"%>
<%@ variable alias="variableName" name-from-attribute="var"  scope="AT_BEGIN" %>

<c:if test="${empty codes}">
	<c:set var="codes">true,false</c:set>
</c:if>
<c:if test="${empty forceNew}">
	<c:set var="forceNew">true</c:set>
</c:if>
<c:set var="splitTestNode">splitTest/${dataVar}</c:set>

<c:if test="${not empty data[splitTestNode] && empty data[dataVar]}">
	<go:setData dataVar="data" value="${data[splitTestNode]}" xpath="${dataVar}" />
</c:if>
<c:set var="usingParam" value="false"/>

	<c:if test="${fn:contains(param.splittest, supertagName) || (not empty paramName && fn:contains(param.splittest, paramName))}">
		<go:log source="core:split_test">PARAM FOUND: ${param}</go:log>
		<c:set var="splitTestArray" value="${fn:split(param.splittest, ',')}" />
		<c:set var="splitTestLength" value="${fn:length(splitTestArray)}" />
		<c:forEach var="i" begin="0" end="${splitTestLength-1}">
			<c:if test="${fn:contains(splitTestArray[i], supertagName) || fn:contains(splitTestArray[i], paramName)}">
				<c:set var="splitTest" value="${fn:split(splitTestArray[i], '-')}" />
				<!-- Check if the param is a valid code (from $codes) -->
				<c:set var="contains" value="false" />
				<c:forEach var="item" items="${codes}">
				<c:if test="${splitTest[1] eq item}">
					<c:set var="contains" value="true" />
				</c:if>
				</c:forEach>
				<go:log source="core:split_test">LEGIT CODE = ${contains }</go:log>
				<c:choose>
					<c:when test="${contains}">
						<go:log source="core:split_test" >NAME = ${splitTest[0]}  VALUE = ${splitTest[1]}</go:log>
						<c:set var="result">${splitTest[1]}</c:set>
						<go:setData dataVar="data" value="${result}" xpath="${dataVar}" />
						<go:setData dataVar="data" value="${result}" xpath="splitTest/${dataVar}" />
						<c:set var="usingParam" value="true"/>
					</c:when>
					<c:otherwise>
						<go:log source="core:split_test">DODGY SPLIT TEST PARAM FOUND: ${splitTest[1]} : FORCING RANDOM CODE.</go:log>
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${data.current.transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="split_test" />
							<c:param name="description" value="Dodgy split test Param detected" />
							<c:param name="data" value="name:${splitTest[0]}  value:${splitTest[1]}" />
						</c:import>
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
	</c:if>
<c:if test="${usingParam == false }">
	<c:choose>
		<c:when test="${forceNew == true || empty data[dataVar]}">
			<go:log source="core:split_test" >RANDOM GENERATION BEGINNING</go:log>
			<c:set var="codesArray" value="${fn:split(codes, ',')}" />
			<c:set var="codesLength" value="${fn:length(codesArray)}" />
				<c:set var="randomNum">
					<%= java.lang.Math.round(java.lang.Math.random() * 100) %> <%-- Between 0 and 99 (100 possible options)--%>
				</c:set>
				<c:forEach var="i" begin="1" end="${codesLength}">
					<c:if test="${randomNum <= 100/codesLength*i && randomNum >= 100/codesLength*(i-1)}">
						<c:set var="result">${codesArray[i-1]}</c:set>
						<go:setData dataVar="data" value="${result}" xpath="${dataVar}" />
						<go:setData dataVar="data" value="${result}" xpath="splitTest/${dataVar}" />

					</c:if>
				</c:forEach>
		</c:when>
		<c:otherwise>
			<go:log source="core:split_test" >POPULATING FROM DATA BUCKET</go:log>
			<c:set var="result">${data[splitTestNode]}</c:set>
		</c:otherwise>
	</c:choose>
</c:if>
<go:log source="core:split_test" >RESULT is ${result}</go:log>
<c:set var="variableName" value="${result}" />
<field:hidden xpath="${dataVar}" constantValue="${result}" /> <%-- This is to ensure that the split test is inserted into the database --%>

<c:if test="${not empty supertagName}">
	<go:script marker="onready">
		Track.splitTest('${result}', '${supertagName}');
	</go:script>
</c:if>