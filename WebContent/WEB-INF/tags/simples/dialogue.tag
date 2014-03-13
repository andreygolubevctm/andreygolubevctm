<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Places dialogue markers for call center staff"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="date" class="java.util.Date" />

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 			required="true"	 	rtexprvalue="true" 	description="The database id for the dialogue message e.g. 12" %>
<%@ attribute name="vertical"		required="true"	 	rtexprvalue="true" 	description="Vertical to associate this dialogue with e.g. health" %>
<%@ attribute name="className" 		required="false"	rtexprvalue="true" 	description="Additional css class (colour variations are green/red/purple)" %>
<%@ attribute name="mandatory" 		required="false"	rtexprvalue="true" 	description="Flag for whether the prompt is a mandatory tickbox" %>

<%@ attribute fragment="true" required="false" name="body_start" %>

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
	<div class="simples-dialogue-${id} simples-dialogue row-content ${className}<c:if test="${not empty mandatory && mandatory == true}"> mandatory</c:if>">
		<jsp:invoke fragment="body_start" />

			<c:choose>
				<c:when test="${not empty mandatory && mandatory == true}">
				<div class="wrapper">

					<div class="checkbox">
						<input type="checkbox" name="${vertical}_simples_dialogue-checkbox-${id}" id="${vertical}_simples_dialogue-checkbox-${id}" class="checkbox-custom simples_dialogue-checkbox-${id}" value="Y" required data-msg-required="Please confirm each mandatory dialog has been read to the client">

						<label for="${vertical}_simples_dialogue-checkbox-${id}" id="simples-dialogue-${id}">
							${dialogueText}
						</label>
					</div>

				</div>
				</c:when>
				<c:otherwise>
				${dialogueText}
				</c:otherwise>
			</c:choose>

		<jsp:doBody />
		</div>
</c:if>
</c:if>

<%-- SCRIPT --%>
<%-- Only allow hide/show if the dialogue is not mandatory --%>
<c:if test="${empty mandatory}">
<go:script marker="onready"> 
		<%-- If dialogue text contains an <h3 class=toggle> then hook it up to a click event that will hide/show the panel contents. --%>
		$('.simples-dialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function() {
			$(this).find('h3 + div').slideToggle(200);
		});
</go:script>
</c:if>