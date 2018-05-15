<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<jsp:useBean id="serviceConfigurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="session"/>

<core_v1:doctype/>
<html>
<head>
    <link rel='stylesheet' type='text/css' href='common/data.css'/>
</head>
<body class="dataConfig">

<%-- SECURITY FEATURE --%>
<c:if test="${ipAddressHandler.isLocalRequest(pageContext.request)}">
    <c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>

    <session:core/>

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

    <%-- Menu --%>

    <div style="margin:10px;padding:10px 20px; border:1px solid #ccc;">
        <h1>${serverIp} (${environmentService.getEnvironmentAsString()})</h1>
        <ul>
            <c:forEach items="${applicationService.getBrands()}" var="brand">
                <li>${brand.getName()}</li>
                <ul>
                    <c:forEach items="${brand.getVerticals()}" var="vertical">
                        <c:if test="${vertical.isEnabled()}">
                            <li>${vertical.getName()}</li>
                            <ul>
                                <c:forEach items="${serviceConfigurationService.getServiceConfigurations()}" var="configItem">
                                    <c:if test="${configItem.getVerticalId() == vertical.getId()}">
                                        <li>
                                            <a href="#${brand.getId()}-${vertical.getId()}-${configItem.getId()}">
                                                    ${configItem.getCode()} ${configItem.getDescription()}
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:forEach>
                </ul>
            </c:forEach>
        </ul>
    </div>

    <%-- Combinations --%>

    <c:forEach items="${applicationService.getBrands()}" var="brand">
        <c:forEach items="${brand.getVerticals()}" var="vertical">
            <c:if test="${vertical.isEnabled()}">
                <c:forEach items="${serviceConfigurationService.getServiceConfigurations()}" var="configItem">
                    <c:if test="${configItem.getVerticalId() == vertical.getId()}">
                        <div id="${brand.getId()}-${vertical.getId()}-${configItem.getId()}" style="padding:20px;background-color:#f5f5f5;margin:10px;">
                            <h2>${configItem.getCode()} [${configItem.getId()}]</h2>

                            <p>Brand: ${brand.getName()} <br/>Vertical: ${vertical.getName()}</p>


                            <c:forEach items="${configItem.getAllProviderIds()}" var="providerId">

                                <c:if test="${providerId != 0}">
                                    <div style="margin:10px 0;padding:10px 20px; border:1px solid #ccc;background-color:#eee">

                                    <h3>Provider ID: ${providerId}</h3>
                                </c:if>
                                <table>
                                    <tr>
                                        <th>key</th>
                                        <th>value</th>
                                        <th>service</th>
                                        <th>provider</th>
                                        <th>scope</th>
                                        <th>environment</th>
                                        <th>comments</th>
                                    </tr>
                                    <c:forEach items="${configItem.getProperties()}" var="configProperty">

                                        <c:if test="${configProperty.getStyleCodeId() == 0 || configProperty.getStyleCodeId() == brand.getId()}">

                                            <c:if test="${configProperty.getProviderId() == 0 || configProperty.getProviderId() == providerId}">
                                                <tr>

                                                    <td align="right" width="30%">${configProperty.getKey()}</td>
                                                    <td>${configProperty.getValue()}</td>


                                                    <td>${configProperty.getServiceId()}</td>
                                                    <td>${configProperty.getProviderId()}</td>
                                                    <td>${configProperty.getScope()}</td>
                                                    <td>${configProperty.getEnvironmentCode()}</td>

                                                    <td align="right" width="20%">
                                                        <c:if test="${configProperty.getStyleCodeId() != 0}">
                                                            Brand specific
                                                        </c:if>
                                                            ${configProperty.getStyleCodeId()}
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:if>


                                    </c:forEach>
                                </table>
                                <c:if test="${providerId != 0}">
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>
    </c:forEach>
</c:if>

</body>
</html>
