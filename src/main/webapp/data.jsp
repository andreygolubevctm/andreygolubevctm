<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<c:set var="logger" value="${log:getLogger('jsp.data')}"/>

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="buildIdentifier"><core_v1:buildIdentifier></core_v1:buildIdentifier></c:set>
<c:set var="remoteAddr" value="${ipAddressHandler.getIPAddress(pageContext.request)}"/>

<jsp:useBean id="sessionDataService" class="com.ctm.web.core.services.SessionDataService" scope="application"/>
<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page"/>


<core_v1:doctype/>
<html>
<head>
    <link rel='stylesheet' type='text/css' href='common/data.css'/>
</head>
<body>
<p id="buildIdentifierRow"><strong>Build Identifier: </strong><span id="buildIdentifier"><c:out
        value="${buildIdentifier}"/></span></p>

<%-- SECURITY  FEATURE --%>
<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or fn:startsWith(remoteAddr, '10.4') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">

    <%-- APPLICATION DATE OVERRIDE --%>
    <p>

    <form method="POST" action="data.jsp">
        <strong>Set application date:</strong>
        <input type="hidden" name="applicationDateOverride" value="yes"/>
        <input type="text" name="applicationDateOverrideValue" placeholder="yyyy-MM-dd HH:mm:ss"/>
        <input type="submit" value="Set"/>

        <c:if test="${not empty param.applicationDateOverride && param.applicationDateOverride == 'yes'}">
            <c:set var="outcome"
                   value="${applicationService.setApplicationDateOnSession(pageContext.getRequest(), param.applicationDateOverrideValue)}"/>
            <br><strong style="color:red">DATE SET (check "Application date" below)</strong>
        </c:if>
    </form>
    </p>
    <%-- /APPLICATION DATE OVERRIDE --%>


    <%-- DEBUG INFO --%>
    <c:set var="serverIp">
        <% String ip = request.getLocalAddr();
            try {
                java.net.InetAddress address = java.net.InetAddress.getLocalHost();
                ip = address.getHostAddress();
            } catch (Exception e) {
            }
        %>
        <%= ip %>
    </c:set>

    <h1>Debug information</h1>
    <table>
        <tr>
            <th>Field</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Tomcat Version</td>
            <td><%= application.getServerInfo() %>
            </td>
        </tr>
        <tr>
            <td>Servlet Specification Version</td>
            <td><%= application.getMajorVersion() %>.<%= application.getMinorVersion() %>
            </td>
        </tr>
        <tr>
            <td>JSP version</td>
            <td><%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %>
            </td>
        </tr>
        <tr>
            <td>java.io.tmpdir</td>
            <td><%= System.getProperty("java.io.tmpdir") %>
            </td>
        </tr>
        <tr>
            <td>Application date</td>
            <td>${applicationService.getApplicationDate(pageContext.getRequest())}
                (<%= org.apache.commons.lang3.time.DateFormatUtils.format(applicationService.getApplicationDate(request), "yyyy-MM-dd HH:mm:ss") %>
                )
            </td>
        </tr>
        <tr>
            <td>Session ID</td>
            <td><%=session.getId()%>
            </td>
        </tr>
        <tr>
            <td>Server IP</td>
            <td>${serverIp}</td>
        </tr>
        <tr>
            <td>Is New</td>
            <td><%=session.isNew()%>
            </td>
        </tr>
        <tr>
            <td>Last Session Touch Timestamp</td>
            <td>${sessionData.getLastSessionTouch()}</td>
        </tr>
        <tr>
            <td>Session Created</td>
            <td><%=new Date(session.getCreationTime())%>
            </td>
        </tr>
        <tr>
            <td>Session Last Accessed</td>
            <td><%=new Date(session.getLastAccessedTime())%>
            </td>
        </tr>
        <tr>
            <td>Application IP Address</td>
            <td>${ipAddressHandler.getIPAddress(pageContext.request)}</td>
        </tr>
        <tr>
            <td>Client remoteAddr</td>
            <td>${pageContext.request.remoteAddr}</td>
        </tr>
        <tr>
            <td>Client remoteHost</td>
            <td>${pageContext.request.remoteHost}</td>
        </tr>
        <tr>
            <td>Header: HTTP_CLIENT_IP</td>
            <td><%=request.getHeader("HTTP_CLIENT_IP")%>
            </td>
        </tr>
        <tr>
            <td>Header: Proxy-Client-IP</td>
            <td><%=request.getHeader("Proxy-Client-IP")%>
            </td>
        </tr>
        <tr>
            <td>Header: X-FORWARDED-FOR</td>
            <td><%=request.getHeader("X-FORWARDED-FOR")%>
            </td>
        </tr>
        <tr>
            <td>SessionData session scoped variable?</td>
            <td><c:if
                    test="${not empty sessionData}">YES, with ${sessionData.transactionSessionData.size()} buckets.</c:if><c:if
                    test="${empty sessionData}">NO</c:if></td>
        </tr>
    </table>
    <%-- /DEBUG INFO --%>


    <%-- SESSION DATA --%>

    <c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>

    <c:if test="${not empty data}">
        <div style="background-color:#FFD7D7">
            <h1 style="color:red">OLD BUCKET IN SESSION FYI THIS SHOULD NOT EXIST </h1>
            <x:transform xml="${data.getXML()}" xslt="${prettyXml}"/>
        </div>
    </c:if>

    <c:if test="${not empty sessionData}">
        <h1>Session data</h1>

        ${sessionDataService.cleanUpSessions(sessionData)}

        <c:if test="${not empty sessionData.authenticatedSessionData}">
            <div style="background-color:#FEFAD8;padding:10px;border-bottom:1px solid #ccc;">
                <h1>Authenticated Session Data </h1>
                <x:transform xml="${sessionData.authenticatedSessionData.getXML()}" xslt="${prettyXml}"/>
            </div>
        </c:if>

        <ol>
            <c:forEach items="${sessionData.getTransactionSessionData()}" var="data">
                <li><a href="#${data['current/transactionId']}">${data['current/verticalCode']}
                    / ${data['current/transactionId']}</a></li>
            </c:forEach>
        </ol>
        <c:forEach items="${sessionData.getTransactionSessionData()}" var="data">
            <div style="background-color:#fff;padding:10px;border-bottom:1px solid #ccc;">

                <div style="background-color:#eee;padding:10px;margin-bottom:10px;">
                    <a name="${data['current/transactionId']}"></a>

                    <h1>${data['current/verticalCode']} / ${data['current/transactionId']}</h1>
                    <em>Last accessed by session data service on ${data.getLastSessionTouch()}</em>
                </div>

                <c:catch var="catchException">
                    <c:forEach items="${data['*']}" var="node">
                        <c:set var="tempXml" value="${go:getEscapedXml(node)}"/>
                        <x:transform xml="${tempXml}" xslt="${prettyXml}"/>
                    </c:forEach>
                </c:catch>

                <c:choose>
                    <c:when test="${catchException != null}">
                        <x:transform xml="${data.getXML()}" xslt="${prettyXml}"/>
                    </c:when>
                    <c:otherwise>
                        ${logger.warn('Exception thrown transforming xml. {}', log:kv('node', node) , catchException)}
                    </c:otherwise>
                </c:choose>

            </div>
        </c:forEach>
    </c:if>
    <%-- /SESSION DATA --%>

    <%-- ENV DATA --%>
    <%
        Map<String, String> systemProperties = new TreeMap<String, String>();
        for (Map.Entry<Object,Object> o : System.getProperties().entrySet()) {
            systemProperties.put(String.valueOf(o.getKey()), String.valueOf(o.getValue()));
        }
        pageContext.setAttribute("systemProperties", systemProperties, PageContext.PAGE_SCOPE);
    %>
    <h1>Environment information</h1>
    <table>
        <tr>
            <th>Field</th>
            <th>Value</th>
        </tr>
        <c:forEach var="entry" items="${systemProperties}">
            <tr>
                <td>${entry.key}</td>
                <td>${entry.value}</td>
            </tr>
        </c:forEach>
    </table>
    <%-- /ENV DATA --%>
</c:if>

</body>
</html>