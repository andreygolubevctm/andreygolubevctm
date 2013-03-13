<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Group for Vehicle Selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="commsId" 		required="true"  rtexprvalue="true"	 description="Id of the item" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="Additional css class attribute" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="Title of the item" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="productPath" value="${xpath}/product" />
<c:set var="leadPath" value="${xpath}/lead" />
<c:set var="supervisor"><simples:security key="supervisor" /></c:set>

<%--
NOTE:
1. supervisor = extended capabilities and views (othewise a normal operator)
2. edit = in edit mode, i.e. it's not a new form
--%>

<%-- Add Class Names --%>
<c:if test="${commsId > 0}">
	<c:set var="edit" value="${true}" />
	<c:set var="className" value="edit ${className}" />
</c:if>
<c:if test="${supervisor}">
	<c:set var="className" value="supervisor ${className}" />
</c:if>

<%-- HTML --%>
<div id="message-form${commsId}" class="message-form ${className}" title="${title}">
	
	<field:hidden xpath="${xpath}/commsId" defaultValue="${data[xpath].commsId}" constantValue="${commsId}"/>	
	<field:hidden xpath="${xpath}/parentId" defaultValue="0" />
	<field:hidden xpath="${xpath}/author" defaultValue="${data.login.user.uid}" />
					
	<form:row label="Owner" className="usersRow">
		<c:if test="${!edit}"><%-- Preset the value to the current user --%>
			<go:setData dataVar="data" xpath="${xpath}/owner" value="${data.login.user.uid}" />
		</c:if>
		<core:readonly xpath="${xpath}/owner" value="${data[xpath].owner}" readOnly="${!supervisor}"><field:user_select xpath="${xpath}/owner" required="true" className="users" title="the owner" /></core:readonly>
	</form:row>
	
	<form:row label="Product" className="productRow simples-message_form_product_group" readonly="${fn:length(data.array[productPath]) > 0}">		
		<core:readonly xpath="${xpath}/product" value="${data[xpath].product}" readOnly="${fn:length(data.array[productPath]) > 0}"><field:array_select items="H=Health,C=Car,T=Travel,R=Roadside,CT=CTP,O=Other" xpath="${xpath}/products" title="product" required="true" /></core:readonly>
	</form:row>
	
	<form:row label="State" className="stateRow simples-message_form_product_group">		
		<field:array_select items="=Please select...,ACT=ACT,NSW=NSW,NT=NT,QLD=QLD,SA=SA,VIC=VIC,WA=WA" xpath="${xpath}/state" className="state" required="true" title="state" />
	</form:row>	
	
	<form:row label="Lead Number" readonly="${edit}" className="leadRow">
		<field:input xpath="${xpath}/lead" required="true" title="lead number" className="digits" readOnly="${edit}" />
	</form:row>
	
	<form:row label="Reason for Call">
		<field:array_select xpath="${xpath}/reason" required="true" title="reason for call" items="=Please select...,A=Application follow up,B=Banking Details,C=Call back request,CL=Call back request - link,I=Information required,L=LHC Query,M=Medicare card details,Q=Quote follow up,T=Technical issue,O=Other" />
	</form:row>
	
	<h5>Customer details</h5>
	
	<form:row label="First name" className="simples-message_form_name_group first_nameRow">
		<field:input xpath="${xpath}/firstName" title="first name" required="true" />
	</form:row>
	
	<form:row label="Surname" className="simples-message_form_name_group surnameRow">
		<field:input xpath="${xpath}/surname" title="surname" required="true" />
	</form:row>
	
	<form:row label="Best contact number" className="simples-message_form_number_group numberRow">
		<field:contact_telno xpath="${xpath}/number" required="true" />		 
	</form:row>
	
	<form:row label="Other number" className="simples-message_form_number_group number_otherRow">
		<field:contact_telno xpath="${xpath}/numberOther" required="false" />
	</form:row>	
	
	<form:row label="Callback Time" className="callbackRow" readonly="${edit}">	
		<c:if test="${edit}">
		
			<go:setData dataVar="data" xpath="${xpath}/date" value="DD/MM/YYYY" />
			<go:setData dataVar="data" xpath="${xpath}/time" value="Afternoon" />
			
			<div class="lastItems">		
				<div class="dateLast field readonly">${data[xpath].date}</div>
				<div class="timeLast field readonly">${data[xpath].time}</div>
				<field:hidden xpath="${xpath}/originalDate" />
				<div class="rescheduleRow">
					<field:checkbox xpath="${xpath}/reschedule" value="" title="reschedule" required="false" label="reschedule" className="reschedule" />
				</div>	
			</div>
		</c:if>
	
		<field:basic_date xpath="${xpath}/date" required="true" className="datePicker" title="select the date" />
		<field:array_select xpath="${xpath}/time" items="=Please select...,1=Morning,2=Afternoon,3=Evening" title="the time" className="time" required="true" />
		
	</form:row>
				
	<form:row label="Notes" className="messageRow">
		<field:textarea xpath="${xpath}/message" title="message" required="true" className="text"/>
	</form:row>		
	
	<c:if test="${edit}">
		<button class="complete" id="${xpath}/complete">Mark As Complete</button>
	</c:if>
	
	<button class="save" id="${xpath}/save">Save Changes</button>
	
	<div class="dialog_footer"></div>
</div>