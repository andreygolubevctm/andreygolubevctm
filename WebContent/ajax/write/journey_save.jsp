<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:update>
 	insert into aggregator.layout_master 
 </sql:update>

<sql:query var="master">
 	select LAST_INSERT_ID() as layoutId from aggregator.journey_master; 
</sql:query>

<c:forEach var="item" items="${param}" varStatus="status">

	<c:if test="${fn:startsWith(item.name,'journey_')}">
		<c:set var="parentName" value="${fn:substringAfter(item.name,'parent_')}" />
		<c:set var="orderParm">order_${parentName}</c:set>
		<c:set var="order" value="${param[orderParm]}" />
		
		<sql:update>
			insert into aggregator.journey_details (journeyId, parent, order)
			values(${master.journeyId},'${parentName}','${order}')
		</sql:update>
	</c:if>
</c:forEach>
${master.journeyId}