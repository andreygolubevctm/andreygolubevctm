<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Places dialogue markers for call center staff"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="date" class="java.util.Date" />

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 			required="true"	 	rtexprvalue="true" 	description="The database id for the dialogue message e.g. 12" %>
<%@ attribute name="vertical"		required="true"	 	rtexprvalue="true" 	description="Vertical to associate this dialogue with e.g. health" %>
<%@ attribute name="className" 		required="false"	rtexprvalue="true" 	description="Additional css class (colour variations are green/red/purple)" %>
<%@ attribute name="mandatory" 		required="false"	rtexprvalue="true" 	description="Flag for whether the prompt is a mandatory tickbox" %>

<%-- VARIABLES --%>
<c:set var="month"><fmt:formatDate value="${date}" pattern="M" /></c:set>
<c:set var="year"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>
<c:set var="mandatory">
	<c:if test="${mandatory=='true'}">${true}</c:if>
</c:set>

<%-- Calculate the year for continuous cover - changes on 1st July each year --%>
<c:set var="continuousCoverYear">
	<c:choose>
		<c:when test="${month < 7}">${year - 11}</c:when>
		<c:otherwise>${year - 10}</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${callCentre}">
	<c:catch var="error">
		<sql:query var="result" dataSource="jdbc/test" maxRows="1">
			SELECT text FROM `ctm`.`dialogue`
			WHERE dialogueID = ?
			<sql:param value="${id}" />
		</sql:query>
		<c:set var="dialogueText" value="${result.rows[0]['text']}" />
		<c:set var="dialogueText" value="${fn:replace(dialogueText, '%10YEARSAGO%', continuousCoverYear)}" />
	</c:catch>

		<%-- OUTPUT: display and test for additional flags --%>	
	<div class="simples-dialogue-${id} simples-dialogue ${className}<c:if test="${not empty mandatory && mandatory == true}"> mandatory</c:if>">
			<c:choose>
				<c:when test="${not empty mandatory && mandatory == true}">
				<div class="wrapper">
					<input type="checkbox" class="simples_dialogue-checkbox-${id} customCheckbox greyCheckbox"  id="${vertical}_simples_dialogue-checkbox-${id}" name="${vertical}_simples_dialogue-checkbox-${id}" value="Y" />
					<label for="${vertical}_simples_dialogue-checkbox-${id}" id="simples-dialogue-${id}">
						${dialogueText}
			</label>
				</div>
				</c:when>
				<c:otherwise>
				${dialogueText}
				</c:otherwise>
			</c:choose>

		<jsp:doBody />
		</div>

<c:if test="${not empty mandatory && mandatory == true}">
		<go:validate selector="${vertical}_simples_dialogue-checkbox-${id}" rule="required" parm="true" message="Please confirm each mandatory dialog has been read to the client"/>
</c:if>
</c:if>

<%-- SCRIPT --%>
<c:if test="${empty mandatory}">
<go:script marker="onready"> 
		<%-- If dialogue text contains an <h3 class=toggle> then hook it up to a click event that will hide/show the panel contents. --%>
		$('.simples-dialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function() {
			$(this).find('h3 + div').slideToggle(200, function() {
				<%-- Update scroll toggle position if on results page --%>
				if ($('body').hasClass('stage-2')) {
					FixedResults.updateTop();
				}
			});
		});
</go:script>
</c:if>

<%-- CSS --%>
<go:style marker="css-head">
.simples-dialogue {
	clear: both;
	font-size: 1.1em;
	line-height: 1.2;
	padding: 12px;
	margin: 1em 0;
	color: #fff;
	min-height: 15px;
	background-color: #1C3F94;
	border-radius: 10px;
}

.simples-dialogue.green {
	background: #0CB24E;
}
.simples-dialogue.red, .simples-dialogue.mandatory {
	background: #fcc;
	color: #f00;
	border: 1px solid #f00;
}
.simples-dialogue.purple {
	background: rgb(112, 48, 160);
}

.simples-dialogue h3 {
	color: #fff;
	font-size: 19px;
}
.simples-dialogue.red h3, .simples-dialogue.mandatory h3 {
	color: #f00;
}

.simples-dialogue .wrapper {
	position: relative;
}
.simples-dialogue.toggle {
	cursor: pointer;
}
.simples-dialogue h3.toggle + div {
	display: none;
}

.simples-dialogue label {
	cursor: pointer;
	margin-right: 10px;
	font-size: 1em;
	line-height: 1.2;
}
.simples-dialogue.mandatory label {
	display: block;
	margin: -18px 0 0 25px;
}

.simples-dialogue select {
	background: #fff;
}
</go:style>