<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<sql:query var="results">
 	select  * from aggregator.rating_table
</sql:query>

<c:forEach var="row" items="${results.rows}" varStatus="status">
	
	<c:set var="seq" value="${status.count}" />
	<c:choose>
		<c:when test="${row.Provider=='Budget Direct' && row.Product=='Gold'}">
			<c:set var="Prodid" value="1" />
		</c:when>
		<c:when test="${row.Provider=='Budget Direct' && row.Product=='Silver'}">
			<c:set var="Prodid" value="2" />
		</c:when>
		<c:otherwise>
			<c:set var="Prodid" value="3" />		
		</c:otherwise>
	</c:choose>
	
	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','DurMin','${seq}','${row.DurMin}','${row.DurMin}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','DurMax','${seq}','${row.DurMax}','${row.DurMax}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','AgeMin','${seq}','${row.AgeMin}','${row.AgeMin}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','AgeMax','${seq}','${row.AgeMax}','${row.AgeMax}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','WW-SIN','${seq}','${row.WW-Single}','${row.WW-Single}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','WW-DUO','${seq}','${row.WW-Duo}','${row.WW-Duo}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','WW-FAM','${seq}','${row.WW-Family}','${row.WW-Family}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','EU-SIN','${seq}','${row.EU-Single}','${row.EU-Single}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','EU-DUO','${seq}','${row.EU-Duo}','${row.EU-Duo}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','EU-FAM','${seq}','${row.EU-Family}','${row.EU-Family}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','AS-SIN','${seq}','${row.AS-Single}','${row.AS-Single}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','AS-DUO','${seq}','${row.AS-Duo}','${row.AS-Duo}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','AS-FAM','${seq}','${row.AS-Family}','${row.AS-Family}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','PA-SIN','${seq}','${row.PA-Single}','${row.PA-Single}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','PA-DUO','${seq}','${row.PA-Duo}','${row.PA-Duo}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','PA-FAM','${seq}','${row.PA-Family}','${row.PA-Family}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','DO-SIN','${seq}','${row.DO-Single}','${row.DO-Single}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','DO-DUO','${seq}','${row.DO-Duo}','${row.DO-Duo}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
 	<sql:update>
 		insert into aggregator.product_properties (ProductId,PropertyId,SequenceNo,Value,Text,Date,EffectiveStart,EffectiveEnd,Status) 
 		values 
 		('${Prodid}','DO-FAM','${seq}','${row.DO-Family}','${row.DO-Family}',CURRENT_DATE,CURRENT_DATE,'2040-12-31',' '); 
 	</sql:update>
</c:forEach>