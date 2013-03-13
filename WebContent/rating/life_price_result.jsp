<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- 
	Data takes form in a service call from Life-broker
--%>

<results>
	<products>
		<premium>
			<company>AIA Australia</company>
			<name>Priority Protection</name>
			<description>Life Cover Plan w Crisis Recovery</description>
			<stars>4.5</stars>
			<product_id>c1db310c5f8396ac8b8cb352b8a6250471d6002d</product_id>
			<value>8.79</value>
			<below_min>Y</below_min>
		</premium>
		<premium>
			<company>Asteron</company>
			<name>Asteron Lifeguard</name>
			<description>Recovery
				Package</description>
			<stars>4</stars>
			<product_id>ba688348691b5f73c06a91ab363b62533aecb33b</product_id>
			<value>9.39</value>
			<below_min>Y</below_min>
		</premium>
		<premium>
			<company>Asteron</company>
			<name>Asteron Lifeguard</name>
			<description>Recovery
				Package w Recovery Plus</description>
			<stars>5</stars>
			<product_id>163b8e8d878cfdaef08cc0491b72ceb7aa456851</product_id>
			<value>9.46</value>
			<below_min>Y</below_min>
		</premium>
	</products>
	<client>
		<reference>8wHVDUCzWfXk9U6SfgiXZA</reference>
	</client>
</results>