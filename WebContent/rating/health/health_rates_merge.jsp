<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.*,java.util.*,java.text.*,java.math.*,au.com.bytecode.opencsv.CSVParser,com.disc_au.web.go.xml.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %> 
<sql:setDataSource dataSource="jdbc/ctm"/>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Merge Extended and Ancillary Health Rates</title>
<style type="text/css">
	body {
		font-family:sans-serif; 
		font-size:11px;
	}
</style>
</head>
<body>
<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="eRes">
SELECT * FROM ctm.product_properties_ext
WHERE type = 'E'
</sql:query>

<c:import var="mergeXSL" url="product_properties_merge_ext.xsl" /> 

<c:forEach items="${eRes.rows}" var="eRec">

	<sql:query var="aRes">
		SELECT * FROM ctm.product_properties_ext
		WHERE type = 'A' 
		AND productid=${eRec.ProductId}
		LIMIT 1
	</sql:query>
	
	<c:forEach items="${aRes.rows}" var="aRec">		
		<c:set var="masterXML">
			<merge>
				${eRec.text}
				${aRec.text}
			</merge>
		</c:set>
		<%--<go:log>${masterXML}</go:log>--%>
		
		<c:set var="finalXML">
			<x:transform xml="${masterXML}" xslt="${mergeXSL}" />
		</c:set>
		<%--go:log>${finalXML}</go:log --%>
		<c:set var="productId" value="${aRec.ProductId}"/>
		Merging ${productId}...<br />
		<c:if test="${productId != ''}" >
			<sql:update>
				REPLACE INTO ctm.product_properties_ext 
				VALUES('${productId}', ?, 'M');
				<sql:param><c:out value="${finalXML}" escapeXml="false"/></sql:param>
			</sql:update>
		</c:if>
				
	</c:forEach>

</c:forEach>

DONE


</body>
</html>