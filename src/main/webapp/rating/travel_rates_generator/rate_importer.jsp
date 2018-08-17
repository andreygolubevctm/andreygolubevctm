<%@page import="com.ctm.web.core.connectivity.SimpleDatabaseConnection"%>
<%@page import="com.ctm.web.travel.utils.RatesImporter"%>
<%@page import="org.jsoup.helper.StringUtil"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.FileReader"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.math.BigDecimal,java.math.RoundingMode,java.sql.PreparedStatement,java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('jsp.unsubscribe')}" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Upload Travel Rates</title>
    <style type="text/css">
        body {
            font-family:monospace;
            font-size:13px;
            color:#333;
        }
    </style>
</head>
<body>

<c:choose>
    <c:when test="${param.file == null}">
        <h1> :-( Please set ?file= parameter</h1>
    </c:when>
    <c:otherwise>

        <h1>Import: ${param.file}</h1>
        <br/>
        <%
            RatesImporter ratesImporter = new RatesImporter();
            int LINE_TYPE_COLUMN_NUMBER = 0;

            int PROVIDER_ID_COLUMN_NUMBER = 1;
            int PROVIDER_NAME_COLUMN_NUMBER = 2;
            int PROVIDER_SHORT_NAME_COLUMN_NUMBER = 3;

            int PRODUCT_ID_COLUMN_NUMBER = 1;
            int PRODUCT_CODE_COLUMN_NUMBER = 2;
            int PRODUCT_NAME_COLUMN_NUMBER = 3;
            int PRODUCT_IS_ACTIVE_ACTION_COLUMN_NUMBER = 4;
            int PRODUCT_ADD_ACTION_COLUMN_NUMBER = 5;
            int PRODUCT_RENAME_ACTION_COLUMN_NUMBER = 6;
            int PRODUCT_INCLUDE_ACTION_COLUMN_NUMBER = 7;

            int PROPERTY_PRODUCT_ID_COLUMN_NUMBER = 1;
            int PROPERTY_PRODUCT_CODE_COLUMN_NUMBER = 2;
            int PROPERTY_PROPERTY_ID_COLUMN_NUMBER = 3;
            int PROPERTY_VALUE_COLUMN_NUMBER = 4;
            int PROPERTY_TEXT_COLUMN_NUMBER = 5;
            int PROPERTY_ORDER_COLUMN_NUMBER = 6;

            ratesImporter.init(request);
            String providerName = "NOT_SET";
            String providerId = "NOT_SET";
            String providerShortName = "NOT_SET";
            long initialResultCount = 0;
            long newResultCount = 0;

            BufferedReader metaDoc = ratesImporter.getMetaDoc();

            String metaLine;

            int metaLineNo = 0;

            ArrayList<HashMap<String,String>> productsArray = new ArrayList<HashMap<String,String>>();
            ArrayList<String> productIds = new ArrayList<String>();
            ArrayList<String> productCodes = new ArrayList<String>();
            ArrayList<String> productIdSets = new ArrayList<String>();

            ArrayList<HashMap<String,String>> propertiesArray = new ArrayList<HashMap<String,String>>();

            while((metaLine = metaDoc.readLine()) != null) {
                metaLine= metaLine.replace("&", "&amp;");
                String[] part = metaLine.split(",(?=(?:(?:[^\"]*\"){2})*[^\"]*$)");
                for(int i=0;i<part.length;i++){
                    part[i] = part[i].replace("\"", "");
                }

                if (part.length > 0){

                    if(part[LINE_TYPE_COLUMN_NUMBER].equals("provider")){

                        providerName = part[PROVIDER_NAME_COLUMN_NUMBER];
                        providerId = part[PROVIDER_ID_COLUMN_NUMBER];
                        providerShortName = part[PROVIDER_SHORT_NAME_COLUMN_NUMBER];

                    }else if(part[LINE_TYPE_COLUMN_NUMBER].equals("product")){

                        HashMap<String, String> product = new HashMap<String, String>();
                        //Include in data import?

                        if(part[PRODUCT_INCLUDE_ACTION_COLUMN_NUMBER].equals("1")){

                            product.put("productId",part[PRODUCT_ID_COLUMN_NUMBER]);
                            product.put("productCode", part[PRODUCT_CODE_COLUMN_NUMBER]);
                            product.put("name",part[PRODUCT_NAME_COLUMN_NUMBER]);
                            product.put("active",part[PRODUCT_IS_ACTIVE_ACTION_COLUMN_NUMBER]);

                            productsArray.add(product);
                            productIds.add(product.get("productId"));
                            productCodes.add(product.get("productCode"));
                            // Rename product?
                            if(part[PRODUCT_RENAME_ACTION_COLUMN_NUMBER].equals("1")) {
        %>
        /* Rename product */<br/>
        SET @product_id = (SELECT ProductId FROM ctm.product_master WHERE ProductCode='<%=product.get("productCode") %>');<br/>
        UPDATE ctm.product_master SET longTitle = '<%=providerName %>&nbsp;<%=product.get("name") %>' WHERE ProductId = @product_id;<br/>
        UPDATE ctm.product_master SET shortTitle = '<%=providerShortName %>&nbsp;<%=product.get("name") %>' WHERE ProductId = @product_id;<br/>
        <br/>
        <%
            }

            // Delete product?
            if(part[PRODUCT_IS_ACTIVE_ACTION_COLUMN_NUMBER].equals("1") == false) {
        %>
        /* Delete existing product master */<br/>
        SET @product_id = (SELECT ProductId FROM ctm.product_master WHERE ProductCode='<%=product.get("productCode") %>');<br/>
        DELETE FROM ctm.product_master WHERE ProductId = @product_id;<br/>
        <br/>
        <%
            }

            // Add product?
            if(part[PRODUCT_ADD_ACTION_COLUMN_NUMBER].equals("1")) {
        %>
        /* Add new product master */<br/>
        INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd) VALUES ('TRAVEL', '<%=product.get("productCode") %>', <%=providerId %>, '<%=providerShortName %>&nbsp;<%=product.get("name") %>', '<%=providerName %>&nbsp;<%=product.get("name") %>', curdate(), '2040-12-31');
        <br/>
        <br/>
        <%
                            }

                        }

                    }else if(part[LINE_TYPE_COLUMN_NUMBER].equals("product_properties")){

                        // Get the data for sequence 0 product properties.
                        if(part[PROPERTY_PRODUCT_ID_COLUMN_NUMBER].equals("*")){
                            // Create an instance of this property for each product.
                            for(HashMap<String, String> product : productsArray){
                                HashMap<String, String> property = new HashMap<String, String>();

                                property.put("propertyId",part[PROPERTY_PROPERTY_ID_COLUMN_NUMBER]);
                                property.put("value",part[PROPERTY_VALUE_COLUMN_NUMBER]);
                                property.put("text",part[PROPERTY_TEXT_COLUMN_NUMBER]);
                                property.put("order",part[PROPERTY_ORDER_COLUMN_NUMBER]);
                                property.put("productId",product.get("productId"));
                                property.put("productCode", product.get("productCode"));
                                propertiesArray.add(property);
                            }
                        }else{
                            HashMap<String, String> property = new HashMap<String, String>();

                            property.put("propertyId",part[PROPERTY_PROPERTY_ID_COLUMN_NUMBER]);
                            property.put("value",part[PROPERTY_VALUE_COLUMN_NUMBER]);
                            property.put("text",part[PROPERTY_TEXT_COLUMN_NUMBER]);
                            property.put("order",part[PROPERTY_ORDER_COLUMN_NUMBER]);
                            property.put("productId",part[PROPERTY_PRODUCT_ID_COLUMN_NUMBER]);
                            property.put("productCode", part[PROPERTY_PRODUCT_CODE_COLUMN_NUMBER]);
                            propertiesArray.add(property);
                        }


                    }

                }

                metaLineNo++;

            }
            metaDoc.close();

            if(propertiesArray.size() > 0){
        %>
        /* Delete existing product properties (including SEQUENCE 0)) */<br/>
        <%
            productIdSets.clear();
            for(String code : productCodes) { %>
        SET @<%= code.replaceAll("-", "_") %>_property_product_id = (SELECT ProductId FROM ctm.product_master WHERE ProductCode='<%= code %>'); <br/>
        <%  productIdSets.add("@" + code.replaceAll("-", "_") + "_property_product_id");
        }
        %>

        DELETE FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIdSets, ",")%>);<br/><br/>
        <br/><br/>/* Insert product properties */<br/><br/>
        <%

            for (HashMap<String, String> property : propertiesArray){
            String propertyProductIdSet = "@" + property.get("productCode").replaceAll("-", "_") + "_property_product_id";

        %>
        INSERT INTO ctm.product_properties VALUES(
        <%=propertyProductIdSet%>,
        '<%=property.get("propertyId")%>',
        0,
        <%=property.get("value")%>,
        '<%=property.get("text")%>',
        NULL,
        curdate(),
        '2040-12-31',
        '',
        <%=property.get("order")%>
        );
        <br/>
        <%

            }

        %>
        <br/><br/>/* Insert product properties pricing*/<br/><br/>
        <%
        }else{
            initialResultCount = ratesImporter.getToProductPropertiesCount(productIds);
        %>
        -- ================ TESTS =====================<br />
        -- ========= BEFORE INSERT TESTS ==============<br />
        <br />
        /* When this is run before anything else on the ctm.product_properties table, query should return <%= initialResultCount %> rows */<br /><br />
        <%
        productIdSets.clear();
        for(String code : productCodes) { %>
            SET @<%= code.replaceAll("-", "_") %>_product_id = (SELECT ProductId FROM ctm.product_master WHERE ProductCode='<%= code %>'); <br/>
        <%  productIdSets.add("@" + code.replaceAll("-", "_") + "_product_id");
         }
        %>

        <br />
        SELECT * FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIdSets, ",")%>) AND SequenceNo > 0 LIMIT 999999;<br/><br/>

        /* Delete existing prices in product properties */<br/>
        DELETE FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIdSets, ",")%>) AND SequenceNo > 0 LIMIT 999999;<br/><br/>
        /* Insert product properties pricing*/<br/>
        <%
            }
            BufferedReader in = ratesImporter.getReader();
            // Open the rates csv

            String line;

            DecimalFormat formatter = new DecimalFormat("#,###,##0.00");
            formatter.setRoundingMode(RoundingMode.HALF_UP);

            HashMap<String, Integer> map = new HashMap<String, Integer>();

            int prevProductId = 0;
            int lineNo = 0;

            while((line = in.readLine()) != null) {
                %>
                <%--Enable this logger when you want to see it printing lines that it's processing--%>
                <%--logger.debug("Processing line " + <%=line %>);--%>
                <%
                lineNo++;
                int productId = -1;
                String productIdSet = "";

                // Remove " chars
                String[] part = line.split(",(?=(?:(?:[^\"]*\"){2})*[^\"]*$)");
                for(int i=0;i<part.length; i++){
                    part[i]= part[i].replaceAll("\"", "");
                }

                if(part.length > 0){

                    if (part[0].equals(providerName)){

                        // Get productId from Name
                        for(HashMap<String,String> product : productsArray){
                            String productNameFromPrice = part[1];
                            if(product.get("name").equals(productNameFromPrice)){
                                productId = Integer.parseInt(product.get("productId"));
                                productIdSet = "@" + product.get("productCode").replaceAll("-", "_") + "_product_id";
                                break;
                            }
                        }


                        if (productId > -1) {

                            prevProductId = ratesImporter.map(productId,prevProductId, map);

                            for (String key : map.keySet()) {
                                int index = 0;
                                index++;

                                int idx = map.get(key);
                                key = key.replaceAll("_", "-");


                                if (idx < part.length && !(part[idx].equals(""))) {

                                    //see if the variable actually needs a currency format
                                    String currency = "";

                                    if(idx >= 8){
                                        // Convert to BigDecimal
                                        BigDecimal d = new BigDecimal(part[idx]);
                                        formatter.setRoundingMode(RoundingMode.HALF_UP);
                                        currency = "$" + formatter.format(d);
                                    } else {
                                        currency = part[idx];
                                    }

                                    // If currency value is blank, don't import it.
                                    if(currency.equals("") == false){
                                        newResultCount++;
                                        if(newResultCount == 1) {
        %>
        INSERT INTO ctm.product_properties VALUES
        <% } %>
        (
        <%=productIdSet%>,
        '<%=key%>',
        <%=ratesImporter.getSequenceNo()%>,
        <%=part[idx]%>,
        '<%=currency%>',
        NULL,
        CURDATE(),
        '2040-12-31',
        '',
        0
        ),
        <% ratesImporter.handleCount(newResultCount,initialResultCount);%>
        <br />
        <%

                                    } // end if currency equals false
                                }
                            } // end for each number of days
                        }
                    }
                }
            }

            in.close();

        %>
        <br /><br />
        -- ========= AFTER INSERT TESTS ==============<br />
        -- When this is run after the insert statements on the ctm.product_properties table, query should return <%= (newResultCount) %> rows<br />
        SELECT * FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIdSets, ",")%>) AND SequenceNo > 0 LIMIT 999999;<br />
        -- ================ =====================<br /><br />
    </c:otherwise>
</c:choose>

</body>
</html>