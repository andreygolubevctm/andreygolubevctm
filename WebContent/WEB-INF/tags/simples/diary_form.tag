<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Group for Vehicle Selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="commsId" 		required="true"  rtexprvalue="true"	 description="Id of the item" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="Additional css class attribute" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="Title of the item" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="titlePath" value="${xpath}/title" />

<c:choose>
	<c:when test="${data[xpath].allDay == 'Y'}">
		<c:set var="allDay" value="hidden" />
	</c:when>
	<c:otherwise>
		<c:set var="allDay" value="" />
	</c:otherwise>
</c:choose>

<div id="diary-form${commsId}" class="message-form diary-form ${className}" title="${title}">

	<go:log>
	XPAT: ${xpath}
	THE FORM ID: ${data[xpath].commsId}</go:log>

	<field:hidden xpath="${xpath}/commsId" defaultValue="0" />
	<field:hidden xpath="${xpath}/parentId" defaultValue="0" />
	<field:hidden xpath="${xpath}/author" defaultValue="${data.login.user.uid}" />
	
	<form:row label="Title" className="titleRow" readonly="${not empty data[xpath].title }">
		<core:readonly xpath="${xpath}/title" value="${data[xpath].title}" readOnly="${not empty data[xpath].title }"><field:input required="false" title="the time" xpath="${xpath}/title" className="title" maxlength="64" /></core:readonly>
	</form:row>
	
	<form:row label="Owner" className="usersRow">
		<c:if test="${empty data[xpath].owner}">
			<go:setData dataVar="data" value="${data.login.user.uid}" xpath="${xpath}/owner" />
		</c:if>	
		<core:readonly xpath="${xpath}/owner" value="${data[xpath].owner}" readOnly="false"><field:user_select xpath="${xpath}/owner" required="false" className="users" title="the owner" /></core:readonly>
	</form:row>
	
	<form:row label="All Day" className="startTimeRow">
		<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/allDay" title="All Day" required="false" className="all-day"/>
	</form:row>
	
	<form:row label="Start Time (24h)" className="startTimeRow">		
		<%--<simples:diary_date xpath="${xpath}/dateStart" required="false" className="datePicker" title="select the date"/>--%>
		<field:input xpath="${xpath}/dateStart" required="false" size="10" className="datePicker" title="select the date"/>
		<field:input required="false" title="the time" xpath="${xpath}/timeStart" className="time timeStart ${allDay}" maxlength="5" size="5"/>
	</form:row>	
	
	<form:row label="End Time (24h)" className="endTimeRow">
		<field:input xpath="${xpath}/dateEnd" required="false" size="10" className="datePicker" title="select the date"/>
		<field:input required="false" title="the time" xpath="${xpath}/timeEnd" className="time timeEnd ${allDay}" maxlength="5" size="5"/>
	</form:row>		
		
	<form:row label="URL" className="urlRow">
		<c:if test="${not empty data[xpath].url}">
			<a href="${data[xpath].url}">${data[xpath].url}</a><br />
		</c:if>
		<field:input xpath="${xpath}/url" required="false" className="url" title="url link path"/>
	</form:row>			
		
	<form:row label="Message" className="messageRow">
		<field:textarea xpath="${xpath}/message" title="message" required="false" className="text"/>
	</form:row>
	<br clear="all" />
	<c:if test="${commsId > 0}">
		<button class="complete" id="${xpath}/complete">Mark As Complete</button>
	</c:if>
	<button class="save" id="${xpath}/save">Save Changes</button>
</div>