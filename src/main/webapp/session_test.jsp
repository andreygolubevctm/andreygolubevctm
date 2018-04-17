<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.net.*"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
</head>
<body>
<span COLOR="#0000FF" style="font-size: large; ">
    Instance <%=InetAddress.getLocalHost()%> <br/><br/>
</span>

<hr/>

<span COLOR="#CC0000" style="font-size: large; ">
    <br/>
    Session Id : <%=request.getSession().getId()%> <br/>
    Is it New Session : <%=request.getSession().isNew()%><br/>
    Session Creation Date : <%=new Date(request.getSession().getCreationTime())%><br/>
    Session Access Date : <%=new Date(request.getSession().getLastAccessedTime())%><br/><br/>
</span>
<b>Cart List </b><br/>
<hr/>


<ul>
    <%
        String bookName = request.getParameter("bookName");
        List<String> listOfBooks = (List<String>) request.getSession().getAttribute("Books");
        if (listOfBooks == null) {
            listOfBooks = new ArrayList<String>();
            request.getSession().setAttribute("Books", listOfBooks);
        }
        if (bookName != null) {
            listOfBooks.add(bookName);
            request.getSession().setAttribute("Books", listOfBooks);
        }
        for (String book : listOfBooks) {
            out.println("<li>"+book + "</li><br/>");
        }

    %>
</ul>
<hr/>
<form action="session_test.jsp" method="post">
    Book Name <input type="text" name="bookName" />

    <input type="submit" value="Add to Cart"/>
</form>
<hr/>
</body>
</html>