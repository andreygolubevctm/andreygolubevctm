<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.*,java.util.*,java.text.*,java.math.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Upload Health Rates</title>
<style type="text/css">
	body {
		font-family:sans-serif; 
		font-size:11px;
	}
</style>
</head>
<body>
<sql:setDataSource dataSource="jdbc/ctm"/>

<c:import var="prodPropsXSL" url="product_properties.xsl" />
<c:import var="prodPropsExtXSL" url="product_properties_ext.xsl" />

<c:choose>
<c:when test="${param.fundCode == ''}">
	fundCode parameter not supplied<br /> 
	Query String params are as follows:<br />
	<table>
		<tr>
			<th>Parameter</th><th>Description</th>
			<td>fundCode</td><td>3 Character Fund Code (e.g. HCF)</td>
			<td>addNew</td><td>if Y passed - Force all products to be added (make sure they don't exist)</td>
		</tr>
	</table>
</c:when>
<c:otherwise>
<%
	String fundCode = request.getParameter("fundCode");
	File d = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode);	
	for (File f : d.listFiles()){
		//System.out.println(f.getName());
		if (f.getName().endsWith(".xml") && !f.getName().endsWith("out.xml")){

			
			%>
			<c:set var="fundCode"><%=fundCode%></c:set>
			<c:set var="filename"><%=f.getName()%></c:set>
			<p>Processing <b>"${filename}"</b></p>
			
			<c:import url="file:///_NEWROOTDIR_/PHIO-Data/${fundCode}/${filename}" var="xmlData" />
			<x:parse xml="${xmlData}" var="xmlDoc"/>

			<%-- Get the product code from the xml --%>
			<c:set var="prodCode"><x:out select="$xmlDoc//@ProductCode"/></c:set>
			<p>...Product: ${prodCode}</p>
			
			<%-- Get the product description from the xml --%>
			<c:set var="prodDes"><x:out select="$xmlDoc//*[name()='Name']"/></c:set>
			<p>...Product: ${prodDes}</p>
			
			<c:set var="prodDesTC" value="${go:TitleCase(prodDes)}" />
			<p>...Product (TitleCase): ${prodDesTC}</p>
			
			<go:log>${prodDesTC}</go:log>
			
			<%-- Get the provider Id - based on the fundcode --%>
			<c:set var="fundCode"><x:out select="$xmlDoc//*[name()='FundCode']"/></c:set>
			<sql:query var="providerRes">
				SELECT providerId from provider_properties 
				WHERE propertyId = 'FundCode' 
				AND text = ?
				LIMIT 1
				<sql:param value="${fundCode}" />
			</sql:query>
			<c:set var="providerId" value="${providerRes.rows[0].providerId}" />

			<c:set var="productId">			
				<c:choose>
					<c:when test="${param.addNew=='Y'}">
						<sql:transaction>
							<sql:update>
								INSERT INTO ctm.product_master (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`) 
								VALUES ('HEALTH', ?, ?, ?, ?);
								<sql:param value="${prodCode}" />
								<sql:param value="${providerId}" />
								<sql:param value="${fn:substring(prodDesTC,0,50)}" />
								<sql:param value="${prodDesTC}" />
							</sql:update>
							
							<sql:query var="res">
								select last_insert_id() as lastId from ctm.product_master; 			
							</sql:query>							
						</sql:transaction>
						<c:out value="${res.rows[0].lastId}" />						
					</c:when>
					<c:otherwise>
						<sql:query var="productIdRes">
							SELECT ProductId FROM ctm.product_master 
								WHERE ProviderId=? 
								AND ProductCode=?
								<sql:param value="${providerId}" />
								<sql:param value="${prodCode}" />
						</sql:query>
						<c:if test="${productIdRes.rowCount != 0 }">
							<c:out value="${productIdRes.rows[0].productId}" />
						</c:if>						
					</c:otherwise>
				</c:choose>
			</c:set>
			
			<p>...Master Record for "${prodDesTC}" has Id: ${productId}
			
			<c:choose>
			<c:when test="${productId != ''}">
				<sql:transaction>
					<p>...Deleting existing properties</p>
					<sql:update>
						DELETE FROM ctm.product_properties WHERE ProductId = ?
						<sql:param value="${productId}"/>
					</sql:update>
					
					<sql:update>
						DELETE FROM ctm.product_properties_ext WHERE ProductId = ?
						AND type='E'
						<sql:param value="${productId}"/>
					</sql:update>
					
					<p>...Updating properties</p>
					<c:set var="sqls">
						<x:transform xml="${xmlData}" xslt="${prodPropsXSL}">
							<x:param name="providerId" value="${providerId}" />
							<x:param name="productId" value="${productId}" />
						</x:transform>
					</c:set>
				
					<c:set var="sqlLen">${fn:length(sqls)-1}</c:set>
					<c:set var="finalSQL">${fn:substring(sqls,0,sqlLen)};</c:set>
					<sql:update sql="${finalSQL}" />				 

					<p>...Updating properties_ext</p>
					<c:set var="info">
						<x:transform xml="${xmlData}" xslt="${prodPropsExtXSL}" />
					</c:set>
					<go:log>${info}</go:log>
					<sql:update>
						INSERT IGNORE INTO ctm.product_properties_ext(`ProductId`,`Text`,`Type`) 
						VALUES (?, ?,'E');
						<sql:param value="${productId}" />
						<sql:param value="${info}" />
					</sql:update>
				</sql:transaction>
				<p>...Operation Complete</p>	
			</c:when>
	 		<c:otherwise>
	 			<p>...Nothing to Do (either product is not in the MySQL DB already or addNew!=Y)</p>
	 			<c:if test="${param.deleteIfNotFound=='Y'}">
	 				<p>deleteIfNotFound='Y', so deleting <%=f.getName()%>...</p>
	 				<% f.deleteOnExit(); %>
	 			</c:if>
	 			<% System.out.println("del "+f.getName()); %>
	 		</c:otherwise>
	 		</c:choose>
			<hr>
			<%
		
		}
	
	}
							
%>
</c:otherwise>
</c:choose>
</body>
</html>
