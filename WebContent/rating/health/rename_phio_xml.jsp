<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.*,java.util.*,java.text.*,java.math.*,au.com.bytecode.opencsv.CSVParser,com.disc_au.web.go.xml.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %> 
<sql:setDataSource dataSource="jdbc/ctm"/>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Rename PHIO files to the productCode</title>
<style type="text/css">
	body {
		font-family:sans-serif; 
		font-size:11px;
	}
</style>
</head>
<body>
<%
	String fundCode = request.getParameter("fundCode");
	File d = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode);
	File[] files = d.listFiles();
	for (File f : files){
		//System.out.println(f.getName());
		if (f.getName().endsWith(".xml") && !f.getName().endsWith("out.xml")){
			%>
			<c:set var="fundCode"><%=fundCode%></c:set>
			<c:set var="filename"><%=f.getName()%></c:set>
			<p>Processing <b>"${filename}"</b></p>
			<%
			byte[] buffer = new byte[(int)f.length()];
			BufferedInputStream in = new BufferedInputStream(new FileInputStream(f)); 
			in.read(buffer); 
			String phioXML = new String(buffer);
			in.close();
			
			int prodStart = phioXML.indexOf("ProductCode=\"");
			int prodEnd = phioXML.indexOf("\"",prodStart+13);
			
			if (prodStart > -1 && prodEnd > -1){
				String productCode = phioXML.substring(prodStart + 13,prodEnd);
				
				String newFilename = productCode.replaceAll("/", "_");
				
				File newFile = new File( f.getParent()+"/"+newFilename+".xml");
				
				System.err.println(newFile.getAbsolutePath());
				if (!newFile.exists()){
					System.err.println(f.renameTo(newFile));
				} else {
					System.err.println("Failed - file already exists");
				}
				
			}
		}
	}
	%>
	DONE
</body>
</html>
