<%@page import="org.jsoup.helper.StringUtil"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.ctm.connectivity.SimpleDatabaseConnection"%>
<%@page import="com.ctm.exceptions.DaoException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.io.*,java.util.*,java.text.*,java.math.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
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
            int LINE_TYPE_COLUMN_NUMBER = 0;

            int PROVIDER_ID_COLUMN_NUMBER = 1;
            int PROVIDER_NAME_COLUMN_NUMBER = 2;
            int PROVIDER_SHORT_NAME_COLUMN_NUMBER = 3;

            int PRODUCT_ID_COLUMN_NUMBER = 1;
            int PRODUCT_NAME_COLUMN_NUMBER = 2;
            int PRODUCT_IS_ACTIVE_ACTION_COLUMN_NUMBER = 3;
            int PRODUCT_ADD_ACTION_COLUMN_NUMBER = 4;
            int PRODUCT_RENAME_ACTION_COLUMN_NUMBER = 5;
            int PRODUCT_INCLUDE_ACTION_COLUMN_NUMBER = 6;

            int PROPERTY_PRODUCT_ID_COLUMN_NUMBER = 1;
            int PROPERTY_PROPERTY_ID_COLUMN_NUMBER = 2;
            int PROPERTY_VALUE_COLUMN_NUMBER = 3;
            int PROPERTY_TEXT_COLUMN_NUMBER = 4;
            int PROPERTY_ORDER_COLUMN_NUMBER = 5;

            String fileName = request.getParameter("file");
            System.out.println("the fileName is:"+fileName);
            String providerName = "NOT_SET";
            String providerId = "NOT_SET";
            String providerShortName = "NOT_SET";
            long initialResultCount = 0;
            long newResultCount = 0;

            // Get data from meta file
            String metaFileLocation = "C:/dev/web_ctm/WebContent/rating/travel_rates_generator/travel_rates_"+fileName+"_meta.csv";
            String metaFileLocation2 = "C:/Dev/web_ctm/WebContent/rating/travel_rates_generator/travel_rates_"+fileName+"_meta.csv";


            System.out.println("the metaFileLocation is:"+metaFileLocation);
            BufferedReader metaDoc = null;
            FileReader fr = null;
            try {
                fr = new FileReader(metaFileLocation);
            } catch (FileNotFoundException fe) {
                fe.printStackTrace();
                System.out.println("exception.. "+fe.getMessage()+" lets try again ");
                fr = new FileReader(metaFileLocation2);
            }
            try {
                metaDoc = new BufferedReader(fr);
            } catch(Exception ioe) {
                System.out.println("failed.. "+ioe);
            }

            String metaLine;
            System.out.println("we have a metaDoc***"+metaDoc.ready());

            int metaLineNo = 0;

            ArrayList<HashMap<String,String>> productsArray = new ArrayList<HashMap<String,String>>();
            ArrayList<String> productIds = new ArrayList<String>();

            ArrayList<HashMap<String,String>> propertiesArray = new ArrayList<HashMap<String,String>>();

            while((metaLine = metaDoc.readLine()) != null) {
                metaLine= metaLine.replace("&", "&amp;");
                //System.out.println("reading line:"+metaLine);
                String[] part = metaLine.split(",(?=(?:(?:[^\"]*\"){2})*[^\"]*$)");
                for(int i=0;i<part.length;i++){
                    part[i] = part[i].replace("\"", "");
                }

                if (part.length > 0){

                    if(part[LINE_TYPE_COLUMN_NUMBER].equals("provider")){
                       // System.out.println("we have provider");

                        providerName = part[PROVIDER_NAME_COLUMN_NUMBER];
                        providerId = part[PROVIDER_ID_COLUMN_NUMBER];
                        providerShortName = part[PROVIDER_SHORT_NAME_COLUMN_NUMBER];
                        //System.out.println("providername:"+providerName+" providerId:"+providerId);

                    }else if(part[LINE_TYPE_COLUMN_NUMBER].equals("product")){

                        HashMap<String, String> product = new HashMap<String, String>();
                        //Include in data import?

                        if(part[PRODUCT_INCLUDE_ACTION_COLUMN_NUMBER].equals("1")){

                            product.put("productId",part[PRODUCT_ID_COLUMN_NUMBER]);
                            product.put("name",part[PRODUCT_NAME_COLUMN_NUMBER]);
                            product.put("active",part[PRODUCT_IS_ACTIVE_ACTION_COLUMN_NUMBER]);

                            productsArray.add(product);
                            productIds.add(product.get("productId"));

                            // Rename product?
                            if(part[PRODUCT_RENAME_ACTION_COLUMN_NUMBER].equals("1")){
        %>
        /* Rename product */<br/>
        UPDATE ctm.product_master SET longTitle = '<%=providerName %>&nbsp;<%=product.get("name") %>' WHERE ProductId = <%=product.get("productId") %>;<br/>
        UPDATE ctm.product_master SET shortTitle = '<%=providerShortName %>&nbsp;<%=product.get("name") %>' WHERE ProductId = <%=product.get("productId") %>;<br/>
        <br/>
        <%
            }

            // Delete product?
            if(part[PRODUCT_IS_ACTIVE_ACTION_COLUMN_NUMBER].equals("1")==false){
        %>
        /* Delete existing product master */<br/>
        DELETE FROM ctm.product_master WHERE ProductId = <%=product.get("productId") %>;<br/>
        <br/>
        <%
            }

            // Add product?
            if(part[PRODUCT_ADD_ACTION_COLUMN_NUMBER].equals("1")){
        %>
        /* Add new product master */<br/>
        INSERT INTO ctm.product_master (ProductId, ProductCat, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd) VALUES (<%=product.get("productId") %>, 'TRAVEL',<%=providerId %>,'<%=providerShortName %>&nbsp;<%=product.get("name") %>','<%=providerName %>&nbsp;<%=product.get("name") %>',curdate(),'2040-12-31');
        <br/>
        <br/>
        <%
                            }

                        }

                    }else if(part[LINE_TYPE_COLUMN_NUMBER].equals("product_properties")){
                                //System.out.println("-- we have product properties");

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
                                propertiesArray.add(property);
                            }
                        }else{
                            HashMap<String, String> property = new HashMap<String, String>();

                            property.put("propertyId",part[PROPERTY_PROPERTY_ID_COLUMN_NUMBER]);
                            property.put("value",part[PROPERTY_VALUE_COLUMN_NUMBER]);
                            property.put("text",part[PROPERTY_TEXT_COLUMN_NUMBER]);
                            property.put("order",part[PROPERTY_ORDER_COLUMN_NUMBER]);

                            property.put("productId",part[PROPERTY_PRODUCT_ID_COLUMN_NUMBER]);
                            propertiesArray.add(property);
                        }


                    }

                }

                metaLineNo++;

            }
           // System.out.println("about to close metaDoc");
            metaDoc.close();
           // System.out.println("metaDoc closed size of propertiesArray:" + propertiesArray.size());


            if(propertiesArray.size() > 0){
        %>
        /* Delete existing product properties (including SEQUENCE 0)) */<br/>
        DELETE FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIds, ",")%>);<br/><br/>
        <br/><br/>/* Insert product properties */<br/><br/>
        <%

            for (HashMap<String, String> property : propertiesArray){

        %>
        INSERT INTO ctm.product_properties VALUES(
        <%=property.get("productId")%>,
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
            System.out.println("attemtpting to open a connection to the DB");
            SimpleDatabaseConnection dbSource = null;
            try {
                PreparedStatement stmt;

                dbSource = new SimpleDatabaseConnection();
                String sql  = "SELECT count(*) as count FROM ctm.product_properties WHERE ProductId IN("+StringUtil.join(productIds, ",")+") AND SequenceNo > 0 LIMIT 999999";
                System.out.println(sql);
                stmt = dbSource.getConnection().prepareStatement(sql);
                System.out.println("the statement is :"+stmt.toString());

                ResultSet results = stmt.executeQuery();
                while (results.next()) {
                    initialResultCount = (Long) results.getObject("count");
                }

            } catch (SQLException e) {
                initialResultCount = 0;
                System.out.println("exception is :"+e);
                //throw new DaoException(e.getMessage(), e);

            }
            finally {
                System.out.println("attempting to close the connection");
                dbSource.closeConnection();
            }
        %>
        -- ================ TESTS =====================<br />
        -- ========= BEFORE INSERT TESTS ==============<br />
        -- When this is run before anything else on the ctm.product_properties table, query should return <%= initialResultCount %> rows<br />
        SELECT * FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIds, ",")%>) AND SequenceNo > 0 LIMIT 999999;<br/><br/>

        /* Delete existing prices in product properties */<br/>
        DELETE FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIds, ",")%>) AND SequenceNo > 0 LIMIT <%= initialResultCount %>;<br/><br/>
        /* Insert product properties pricing*/<br/>
        <%
            }

            String fileLocation = "C:/dev/web_ctm/WebContent/rating/travel_rates_generator/travel_rates_"+fileName+".csv";
            String fileLocation2 = "C:/Dev/web_ctm/WebContent/rating/travel_rates_generator/travel_rates_"+fileName+".csv";
            BufferedReader in = null;
            FileReader freader = null;
            try {
                freader = new FileReader(fileLocation);
            } catch(FileNotFoundException fe) {
                fe.printStackTrace();
                System.out.println("exception " + fe.getMessage() + " lets try again");
                freader = new FileReader(fileLocation2);
            }
            in = new BufferedReader(freader);
            // Open the rates csv

            String line;

            DecimalFormat formatter = new DecimalFormat("#,###,##0.00");
            formatter.setRoundingMode(RoundingMode.HALF_UP);

            HashMap<String, Integer> map = new HashMap<String, Integer>();

            int prevProductId = 0;
            int sequenceNo = 1;
            int lineNo = 0;

            while((line = in.readLine()) != null) {

                lineNo++;
                //System.out.println(lineNo);

                int productId = -1;

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
                           // System.out.println(product.get("name"));
                            if(product.get("name").equals(productNameFromPrice)){
                                productId = Integer.parseInt(product.get("productId"));
                                break;
                            }
                        }


                        if (productId > -1){

                            // Reset the sequence number on change of product
                            if (productId != prevProductId){
                                sequenceNo = 1;
                                prevProductId = productId;
                            } else {
                                sequenceNo++;
                            }

                            map.clear();
                            map.put("durMin",2);
                            map.put("durMax",4);
                            map.put("ageMin",6);
                            map.put("ageMax",7);

                            map.put("R1_SIN",8);
                            map.put("R1_DUO",9);
                            map.put("R1_FAM",10);

                            map.put("R2_SIN",11);
                            map.put("R2_DUO",12);
                            map.put("R2_FAM",13);

                            map.put("R3_SIN",14);
                            map.put("R3_DUO",15);
                            map.put("R3_FAM",16);

                            map.put("R4_SIN",17);
                            map.put("R4_DUO",18);
                            map.put("R4_FAM",19);

                            map.put("R5_SIN",20);
                            map.put("R5_DUO",21);
                            map.put("R5_FAM",22);

								/*map.put("R6_SIN",23);
								map.put("R6_DUO",24);
								map.put("R6_FAM",25);

								// remove if necessary
								/*map.put("R7_SIN",26);
								map.put("R7_DUO",27);
								map.put("R7_FAM",28);

								// remove if necessary
								map.put("R8_SIN",29);
								map.put("R8_DUO",30);
								map.put("R8_FAM",31);*/
                            int sizeOfMap = map.size();
                            System.out.println("the size of the map is:"+sizeOfMap);

                            for (String key : map.keySet()){
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
        <%=productId%>,
        '<%=key%>',
        <%=sequenceNo%>,
        <%=part[idx]%>,
        '<%=currency%>',
        NULL,
        CURDATE(),
        '2040-12-31',
        '',
        0
        )
        <% if(newResultCount <= initialResultCount - 1) { System.out.println(newResultCount+" "+initialResultCount); %>
        , <!--  put a semi colon or comma here if last one. -->
        <!--  also report on the nubmer of inserts per product id -->
        <% } else { %>
        ,
        <% } %>
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
        SELECT * FROM ctm.product_properties WHERE ProductId IN(<%=StringUtil.join(productIds, ",")%>) AND SequenceNo > 0 LIMIT 999999;<br />
        -- ================ =====================<br /><br />
    </c:otherwise>
</c:choose>

</body>
</html>