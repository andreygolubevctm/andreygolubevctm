<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Places dialogue markers for call center staff"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 				required="true"	 	rtexprvalue="true" 	description="The database id for the dialogue message" %>
<%@ attribute name="className" 			required="false"	rtexprvalue="true" 	description="Additional css class" %>
<%@ attribute name="mandatory" 			required="false"	rtexprvalue="true" 	description="Flag for whether the prompt is mandatory" %>

<c:if test="${callCentre}">
	<c:catch var="error">
		<sql:query var="result" dataSource="jdbc/test" maxRows="1">
			SELECT text FROM `ctm`.`dialogue`
			WHERE dialogueID = ?
			<sql:param value="${id}" />
		</sql:query>
		<%-- OUTPUT: display and test for additional flags --%>	
		<div class="simples-dialogue-${id} ${className} simples-dialogue <c:if test="${not empty mandatory && mandatory == true}">exact</c:if>">
		<c:if test="${not empty mandatory && mandatory == true}">
			<label for="simples-dialogue-checkbox-${id}" id="simples-dialogue-${id}">
				<input type="checkbox" class="simples-dialogue-checkbox-${id}"  id="simples-dialogue-checkbox-${id}" name="simples-dialogue-checkbox-${id}" value="check-dialog" />
		</c:if>
		${result.rows[0]['text']}
		<c:if test="${not empty mandatory && mandatory == true}">
			</label>
		</c:if>
		</div>
	</c:catch>
</c:if>
<c:if test="${not empty mandatory && mandatory == true}">
<go:validate selector="simples-dialogue-checkbox-${id}" rule="required" parm="true" message="Please confirm each mandatory dialog has been read to the client"/>
</c:if>

<%-- SCRIPT --%>
<go:script marker="onready"> 
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
.simples-dialogue label {
	line-height: 150%;
}
.simples-dialogue label div {
	line-height: 100%;
	margin:	10px 0;
	padding: 5px;
	border: 1px solid
}
.simples-dialogue label div.em {
	font-size: 125%;
}
.simples-dialogue label div.sub {
	font-style: italic;
	font-size: 90%;
}
</go:style>