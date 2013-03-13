<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.*,java.util.*,java.text.*,java.math.*,au.com.bytecode.opencsv.CSVParser,com.disc_au.web.go.xml.*"%>
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
	.error {
		font-weight:Bold;
		color:red;
	}
</style>
</head>
<body>
<sql:setDataSource dataSource="jdbc/ctm"/>

<c:import var="prodPropsXSL" url="product_properties.xsl" />
<c:import var="prodPropsExtXSL" url="product_properties_ext.xsl" />
<c:import var="prodPropsMergeXSL" url="product_properties_merge_ext.xsl" />
<c:import var="prodPropsOverridesXSL" url="product_properties_overrides.xsl" />
<c:import var="phioMergeXSL" url="phio_merge.xsl" />

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
	File sheet = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode+".csv");
	if (!sheet.exists()){
		%>
		Failed: Unable to locate rating sheet "_NEWROOTDIR_/PHIO-Data/<%=fundCode%>.csv" 
		<%
	} else {
		// ################################################################
		// # 1. Remove all products info for the fund
		// ################################################################
		%>
		1.1 - Determining providerId...<br/>
		<c:set var="fundCode"><%=fundCode%></c:set>
		<sql:query var="providerRes">
			SELECT providerId from provider_properties 
			WHERE propertyId = 'FundCode' 
			AND text = ?
			LIMIT 1
			<sql:param value="${fundCode}" />
		</sql:query>
		<c:set var="providerId" value="${providerRes.rows[0].providerId}" />		
		
		1.2 - Deleting product_properties_ext <br />
		<sql:update>
			DELETE FROM product_properties_ext
			WHERE productId IN 
			 (SELECT productId from product_master
			  WHERE providerId = ${providerId})
		</sql:update>
		
		1.3 - Deleting product_properties...<br />
		<sql:update>
			DELETE FROM product_properties
			WHERE productId IN 
			 (SELECT productId from product_master
			  WHERE providerId = ${providerId})
		</sql:update>
		
		1.4 - Deleting product_master...<br />
		<sql:update>
			DELETE FROM product_master
			WHERE providerId = ${providerId}
		</sql:update>
		<%
		// ################################################################
		// # 2. Set up the data map   
		// ################################################################		
		out.print("2. Set up data map for CSV<br />");
		
		final int SIS_CODE_COLUMN = 140;
		final int FIRST_OVERRIDE = 144;
		
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		int col=1;		
		map.clear();
		map.put("fundCode",col++);
		map.put("productName",col++);
		map.put("state",col++);
		map.put("membership",col++);
		int excessAmt = col;
		map.put("excess",col++);
		map.put("type",col++);
		int firstPrem = col;
		map.put("discFortnightlyLhc",col++);
		map.put("discMonthlyLhc",col++);
		map.put("discQuarterlyLhc",col++);
		map.put("discAnnualLhc",col++);
		
		map.put("discFortnightlyPremium",col++);
		map.put("discMonthlyPremium",col++);
		map.put("discQuarterlyPremium",col++);
		map.put("discAnnualPremium",col++);
		
		map.put("disc30PcFortnightlyPremium",col++);
		map.put("disc30PcMonthlyPremium",col++);
		map.put("disc30PcQuarterlyPremium",col++);
		map.put("disc30PcAnnualPremium",col++);
		
		map.put("grossFortnightlyLhc",col++);
		map.put("grossMonthlyLhc",col++);
		map.put("grossQuarterlyLhc",col++);
		map.put("grossAnnualLhc",col++);
		
		map.put("grossFortnightlyPremium",col++);
		map.put("grossMonthlyPremium",col++);
		map.put("grossQuarterlyPremium",col++);
		map.put("grossAnnualPremium",col++);
		
		map.put("gross30PcFortnightlyPremium",col++);
		map.put("gross30PcMonthlyPremium",col++);
		map.put("gross30PcQuarterlyPremium",col++);
		map.put("gross30PcAnnualPremium",col++);
		
		int lastPrem = col-1;
		map.put("hospitalCoverName",col++);
		map.put("extrasCoverName",col++);

		int firstNodeItem = col;
		map.put("extras/DentalGeneral/loyaltyBonus/perPerson",col++);
		map.put("extras/DentalMajor/loyaltyBonus/perPerson",col++);
		map.put("extras/Endodontic/loyaltyBonus/perPerson",col++);
		map.put("extras/Orthodontic/loyaltyBonus/perPerson",col++);
		map.put("extras/Optical/loyaltyBonus/perPerson",col++);
		map.put("extras/Physiotherapy/loyaltyBonus/perPerson",col++);
		map.put("extras/Chiropractic/loyaltyBonus/perPerson",col++);
		map.put("extras/Podiatry/loyaltyBonus/perPerson",col++);
		map.put("extras/Acupuncture/loyaltyBonus/perPerson",col++);
		map.put("extras/Naturopathy/loyaltyBonus/perPerson",col++);
		map.put("extras/Massage/loyaltyBonus/perPerson",col++);
		map.put("extras/Psychology/loyaltyBonus/perPerson",col++);
		map.put("extras/GlucoseMonitor/loyaltyBonus/perPerson",col++);
		map.put("extras/HearingAids/loyaltyBonus/perPerson",col++);
		map.put("extras/NonPBS/loyaltyBonus/perPerson",col++);
		map.put("ancillary/Orthotics/loyaltyBonus/perPerson",col++);
		map.put("ancillary/SpeechTherapy/loyaltyBonus/perPerson",col++);
		map.put("ancillary/OccupationalTherapy/loyaltyBonus/perPerson",col++);
		map.put("ancillary/Dietetics/loyaltyBonus/perPerson",col++);
		map.put("ancillary/EyeTherapy/loyaltyBonus/perPerson",col++);
		map.put("ancillary/LifestyleProducts/loyaltyBonus/perPerson",col++);

		map.put("extras/DentalGeneral/loyaltyBonus/perPolicy",col++);
		map.put("extras/DentalMajor/loyaltyBonus/perPolicy",col++);
		map.put("extras/Endodontic/loyaltyBonus/perPolicy",col++);
		map.put("extras/Orthodontic/loyaltyBonus/perPolicy",col++);
		map.put("extras/Optical/loyaltyBonus/perPolicy",col++);
		map.put("extras/Physiotherapy/loyaltyBonus/perPolicy",col++);
		map.put("extras/Chiropractic/loyaltyBonus/perPolicy",col++);
		map.put("extras/Podiatry/loyaltyBonus/perPolicy",col++);
		map.put("extras/Acupuncture/loyaltyBonus/perPolicy",col++);
		map.put("extras/Naturopathy/loyaltyBonus/perPolicy",col++);
		map.put("extras/Massage/loyaltyBonus/perPolicy",col++);
		map.put("extras/Psychology/loyaltyBonus/perPolicy",col++);
		map.put("extras/GlucoseMonitor/loyaltyBonus/perPolicy",col++);
		map.put("extras/HearingAids/loyaltyBonus/perPolicy",col++);
		map.put("extras/NonPBS/loyaltyBonus/perPolicy",col++);
		map.put("ancillary/Orthotics/loyaltyBonus/perPolicy",col++);
		map.put("ancillary/SpeechTherapy/loyaltyBonus/perPolicy",col++);
		map.put("ancillary/OccupationalTherapy/loyaltyBonus/perPolicy",col++);
		map.put("ancillary/Dietetics/loyaltyBonus/perPolicy",col++);
		map.put("ancillary/EyeTherapy/loyaltyBonus/perPolicy",col++);
		map.put("ancillary/LifestyleProducts/loyaltyBonus/perPolicy",col++);

		map.put("ancillary/Orthotics/covered",col++);
		map.put("ancillary/Orthotics/benefitLimits/perPerson",col++);
		map.put("ancillary/Orthotics/benefitLimits/perPolicy",col++);
		map.put("ancillary/Orthotics/groupLimit/perPerson",col++);
		map.put("ancillary/Orthotics/groupLimit/perPolicy",col++);
		map.put("ancillary/Orthotics/groupLimit/codes",col++);
		map.put("ancillary/Orthotics/waitingPeriod",col++);
		map.put("ancillary/Orthotics/listBenefitExample",col++);

		map.put("ancillary/SpeechTherapy/covered",col++);
		map.put("ancillary/SpeechTherapy/benefitLimits/perPerson",col++);
		map.put("ancillary/SpeechTherapy/benefitLimits/perPolicy",col++);
		map.put("ancillary/SpeechTherapy/groupLimit/perPerson",col++);
		map.put("ancillary/SpeechTherapy/groupLimit/perPolicy",col++);
		map.put("ancillary/SpeechTherapy/groupLimit/codes",col++);
		map.put("ancillary/SpeechTherapy/waitingPeriod",col++);
		map.put("ancillary/SpeechTherapy/benefitPayableInitial",col++);
		map.put("ancillary/SpeechTherapy/benefitpayableSubsequent",col++);
		
		map.put("ancillary/OccupationalTherapy/covered",col++);
		map.put("ancillary/OccupationalTherapy/benefitLimits/perPerson",col++);
		map.put("ancillary/OccupationalTherapy/benefitLimits/perPolicy",col++);
		map.put("ancillary/OccupationalTherapy/groupLimit/perPerson",col++);
		map.put("ancillary/OccupationalTherapy/groupLimit/perPolicy",col++);
		map.put("ancillary/OccupationalTherapy/groupLimit/codes",col++);
		map.put("ancillary/OccupationalTherapy/waitingPeriod",col++);
		map.put("ancillary/OccupationalTherapy/benefitPayableInitial",col++);
		map.put("ancillary/OccupationalTherapy/benefitpayableSubsequent",col++);

		map.put("ancillary/Dietetics/covered",col++);
		map.put("ancillary/Dietetics/benefitLimits/perPerson",col++);
		map.put("ancillary/Dietetics/benefitLimits/perPolicy",col++);
		map.put("ancillary/Dietetics/groupLimit/perPerson",col++);
		map.put("ancillary/Dietetics/groupLimit/perPolicy",col++);
		map.put("ancillary/Dietetics/groupLimit/codes",col++);
		map.put("ancillary/Dietetics/waitingPeriod",col++);
		map.put("ancillary/Dietetics/benefitPayableInitial",col++);
		map.put("ancillary/Dietetics/benefitpayableSubsequent",col++);

		map.put("ancillary/EyeTherapy/covered",col++);
		map.put("ancillary/EyeTherapy/benefitLimits/perPerson",col++);
		map.put("ancillary/EyeTherapy/benefitLimits/perPolicy",col++);
		map.put("ancillary/EyeTherapy/groupLimit/perPerson",col++);
		map.put("ancillary/EyeTherapy/groupLimit/perPolicy",col++);
		map.put("ancillary/EyeTherapy/groupLimit/codes",col++);
		map.put("ancillary/EyeTherapy/waitingPeriod",col++);
		map.put("ancillary/EyeTherapy/benefitPayableInitial",col++);
		map.put("ancillary/EyeTherapy/benefitpayableSubsequent",col++);
		
		map.put("ancillary/LifestyleProducts/covered",col++);
		map.put("ancillary/LifestyleProducts/benefitLimits/perPerson",col++);
		map.put("ancillary/LifestyleProducts/benefitLimits/perPolicy",col++);
		map.put("ancillary/LifestyleProducts/groupLimit/perPerson",col++);
		map.put("ancillary/LifestyleProducts/groupLimit/perPolicy",col++);
		map.put("ancillary/LifestyleProducts/groupLimit/codes",col++);
		map.put("ancillary/LifestyleProducts/waitingPeriod",col++);
		map.put("ancillary/LifestyleProducts/listBenefitExample",col++);

		map.put("ambulance/covered",col++);
		map.put("ambulance/nonEmergency/road",col++);
		map.put("ambulance/nonEmergency/air",col++);
		map.put("ambulance/nonEmergency/interstate",col++);
		map.put("ambulance/emergency/road",col++);
		map.put("ambulance/emergency/air",col++);
		map.put("ambulance/emergency/interstate",col++);
		map.put("ambulance/refund",col++);
		map.put("ambulance/waitingPeriod",col++);
		map.put("ambulance/otherInformation",col++);		
		
		//map.put("fundCode",SIS_CODE_COLUMN);
		
		// ################################################################
		// # 3. Read through csv - processing as we go  
		// ################################################################
		out.print("3. Set up CSV Parser<br />");
		CSVParser parser = new CSVParser(',','"');

		// Open the rates csv 
		BufferedReader in = new BufferedReader(new FileReader(sheet));
		String line; 
		DecimalFormat formatter = new DecimalFormat("#,###,##0.00");
		formatter.setRoundingMode(RoundingMode.HALF_UP);
		
		// ################################################################
		// # 4. Ignore the first 4-6 lines of the CSV (they are headings)  
		// ################################################################
		out.print("4.1 Ignore header lines (and/or read overrides)<br />");

		// Line 1 (2ns in the sheet) will contain any overrides (from column 144)
		HashMap<Integer,String> overrides = new HashMap<Integer,String>();
		
		int lineNo=0;
		boolean overridesProcessed = false;
		boolean lastHeaderLine = false;
		while (!lastHeaderLine){
			line = in.readLine();	
			System.out.println(line);			
			// Do we have overrides to process? 
			if (line.contains("/") && !overridesProcessed){
				String[] overridePart = parser.parseLine(line);
				if (overridePart.length > FIRST_OVERRIDE) {
					
					for (int offset = FIRST_OVERRIDE; offset < overridePart.length; offset++) {				
						String currentPart=overridePart[offset];
						if (currentPart.contains("/")){
							overrides.put(offset,currentPart);
						}
					}
					overridesProcessed=true;
				}
			}
			// Last header line will contain the word "BRAND"	
			if (overridesProcessed){// && line.contains("SIS Product Code")){
				lastHeaderLine=true;
			} else if (line.contains("BRAND")) {
				lastHeaderLine=true;
			// otherwise skip it.. 	
			} else if (!overridesProcessed){
				out.print("Skipping line"+String.valueOf(lineNo)+"<br />");			
			}
			lineNo++;
		}
		
		
		
		while((line = in.readLine()) != null) {
			lineNo++;
			out.print("<hr />");
			out.print("Processing line "+String.valueOf(lineNo)+" of Sheet: ");			
			
			String[] part = parser.parseLine(line);		
			boolean canProcess=true;
			
			String phioCode1 = "";
			String phioCode2 = "";
			
			if (part.length < (SIS_CODE_COLUMN-1) || part[SIS_CODE_COLUMN].length() == 0){
				out.print("<span class='error'>ERROR: Unable to process - productId is blank</span><br />");
				canProcess=false;
			} else {
				String productCode = part[SIS_CODE_COLUMN].trim();
				File phioXML = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode+"/"+productCode.replaceAll("/","_") + ".xml");
				int carat = productCode.indexOf("^");
				int dash = productCode.indexOf("-");				
				
				if (!phioXML.exists() && carat ==-1 && dash==-1){
					out.print("<span class='error'>Unable to process - can't locate PHIO data: "+productCode.replaceAll("/","_") + ".xml</span><br />");
					out.println("<span class='error'>Missing PHIO for "+productCode + " - "+part[2].trim() + "</span><br />");					
					canProcess=false;
							
				// Check if this is a COMBINED product (i.e. has 2 phio codes separated by "^")
				} else if (carat != -1) {
					phioCode1 = productCode.substring(0,carat);
					phioCode2 = productCode.substring(carat+1);
					
					File phioXML1 = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode+"/"+phioCode1.replaceAll("/","_") + ".xml");
					if (!phioXML1.exists()){
						out.print("<span class='error'>Unable to process - can't locate PHIO data: "+phioCode1.replaceAll("/","_") + ".xml</span><br />");
						out.println("<span class='error'>Missing PHIO for "+productCode + " - "+part[2].trim() + "</span><br />");					
						canProcess=false;						
					}
					
					File phioXML2 = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode+"/"+phioCode2.replaceAll("/","_") + ".xml");
					if (!phioXML2.exists()){
						out.print("<span class='error'>Unable to process - can't locate PHIO data: "+phioCode2.replaceAll("/","_") + ".xml</span><br />");
						out.println("<span class='error'>Missing PHIO for "+productCode + " - "+part[2].trim() + "</span><br />");					
						canProcess=false;						
					}
				// Check if this is a COMBINED product (i.e. has 2 phio codes separated by "-")
				} else if (dash != -1) {
						phioCode1 = productCode.substring(0,dash);
						phioCode2 = productCode.substring(dash+1);
						
						File phioXML1 = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode+"/"+phioCode1.replaceAll("/","_") + ".xml");
						if (!phioXML1.exists()){
							out.print("<span class='error'>Unable to process - can't locate PHIO data: "+phioCode1.replaceAll("/","_") + ".xml</span><br />");
							out.println("<span class='error'>Missing PHIO for "+productCode + " - "+part[2].trim() + "</span><br />");					
							canProcess=false;						
						}
						
						File phioXML2 = new File("_NEWROOTDIR_/PHIO-Data/"+fundCode+"/"+phioCode2.replaceAll("/","_") + ".xml");
						if (!phioXML2.exists()){
							out.print("<span class='error'>Unable to process - can't locate PHIO data: "+phioCode2.replaceAll("/","_") + ".xml</span><br />");
							out.println("<span class='error'>Missing PHIO for "+productCode + " - "+part[2].trim() + "</span><br />");					
							canProcess=false;						
						}					
				} 
			}
			if (canProcess){
				String productCode = part[140].trim();
				String productName = part[2].trim();
				System.out.println("Processing "+productCode + " - "+productName);
				out.print(productCode + " - "+productName+"<br />");
				%>				
				<c:set var="prodCode"><%=productCode%></c:set>
				<c:set var="prodDes"><%=productName%></c:set>
				<c:set var="prodDesTC" value="${fn:replace(go:TitleCase(prodDes),'Gmhba','GMHBA')}" />				
				<%
				// ################################################################
				// # 5. Write the product_master record (or get the productId if  
				//		it already exists)
				// ################################################################
				%>
				5.1 Determining productId<br />
				<%--<c:set var="productId">
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
				</c:set>						
				 
				<%--<c:if test="${productId ==''}">--%>
					5.2 Writing new product master<br />
					<c:set var="productId">
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
							<c:out value="${res.rows[0].lastId}" />						
						</sql:transaction>
					</c:set>
				<%--</c:if>--%>
				<%--	
				################################################################
				# 6. Using the product code get the appropriate PHIO xml   
				#    (phio xml will be productCode but replacing / with _ 
				#    e.g. HA1/00001 becomes HA1_00001.xml 						
				################################################################
				--%>
				<% if (phioCode1.length() == 0 && phioCode2.length() == 0){ %>
					<c:set var="productFilename"><%=productCode.replaceAll("/","_") + ".xml"%></c:set>
					6. Loading PHIO data from _NEWROOTDIR_/PHIO-Data/${fundCode}/${productFilename}<br />
					<c:import url="file:///_NEWROOTDIR_/PHIO-Data/${fundCode}/${productFilename}" var="xmlData" />
					
				<% } else { %>
					<c:set var="productFilename1"><%=phioCode1.replaceAll("/","_") + ".xml"%></c:set>
					<c:set var="productFilename2"><%=phioCode2.replaceAll("/","_") + ".xml"%></c:set>
					
					6.1 Loading PHIO data from _NEWROOTDIR_/PHIO-Data/${fundCode}/${productFilename1}<br />
					<c:import url="file:///_NEWROOTDIR_/PHIO-Data/${fundCode}/${productFilename1}" var="phioXML1" />
					
					6.2 Loading PHIO data from _NEWROOTDIR_/PHIO-Data/${fundCode}/${productFilename2}<br />
					<c:import url="file:///_NEWROOTDIR_/PHIO-Data/${fundCode}/${productFilename2}" var="phioXML2" />
					
					6.3 Merging the two phio documents<br />
					<c:set var="mergedPhioXML"> 
						<jsp:element name="merge">
							${phioXML1}
							${phioXML2}
						</jsp:element>
					</c:set>				

					<c:set var="xmlData">
						<x:transform xml="${mergedPhioXML}" xslt="${phioMergeXSL}" />
					</c:set>
					

					
				<% } %>							
				<%--
				################################################################
				# 7. Write the product_properties records   
				################################################################
				--%>
				7. Write product_properties<br />
				<c:set var="sqls">
					<x:transform xml="${xmlData}" xslt="${prodPropsXSL}">
						<x:param name="providerId" value="${providerId}" />
						<x:param name="productId" value="${productId}" />
					</x:transform>
				</c:set>
				<c:set var="sqlLen">${fn:length(sqls)-1}</c:set>
				<c:set var="finalSQL">${fn:substring(sqls,0,sqlLen)};</c:set>
				<sql:update sql="${finalSQL}" />				 

				<%--
				################################################################
				# 8. Write the product_properties_ext record (type=E)   
				################################################################
				--%>
				8. Write product_properties_ext (with type=E)<br />
				<c:set var="info">
					<x:transform xml="${xmlData}" xslt="${prodPropsExtXSL}" />
				</c:set>
				<sql:update>
					INSERT IGNORE INTO ctm.product_properties_ext(`ProductId`,`Text`,`Type`) 
					VALUES (?, ?,'E');
					<sql:param value="${productId}" />
					<sql:param value="${info}" />
				</sql:update>


				<%--
				################################################################
				# 9. Read the columns in the CSV and write the product_props
				#    (and build the ancillary xml)   
				################################################################
				--%>
				9. Read the CSV columns and write to product_properties/ancillary xml<br />
				<%
				XmlNode myNode = new XmlNode("ancillaryData");
				XmlNode overrideNode = new XmlNode("overrides");
				
				myNode.setAttribute("ProductCode", productCode);
				for (String key : map.keySet()){
					int idx = map.get(key);
					//System.out.println("processing "+key + " ["+String.valueOf(idx)+"]");
					key = key.replaceAll("_", "-");
					if (idx < firstNodeItem) {
						
						String currency = "";
						String value = "";
						value = part[idx];
						
						//see if the variable actually needs a currency format
						if((idx >= firstPrem && idx <= lastPrem) || idx==excessAmt) {
							value = value.replaceAll(",", "");
							value = value.replaceAll("\\$", "");
							value = value.trim();
							// Convert to BigDecimal
							try {
								BigDecimal d = new BigDecimal(value);
								formatter.setRoundingMode(RoundingMode.HALF_UP);
								currency = "$" + formatter.format(d);
							} catch (Exception e){
								currency = part[idx];
								value="0";
							}
						} else {
							currency = part[idx];
							value="0";						
						}
						if (currency.equals("")||currency.equals("-")){
							value="0";
						}
						%>
						<sql:update>
							REPLACE INTO ctm.product_properties VALUES(
								${productId}, '<%=key%>', 1, <%=value%>, '<%=currency%>', NULL, curdate(), '2040-12-31', '', 0
							);
						</sql:update>
						<%
					} else { 
						// Add the value to the ancillary xml
						
						String txtValue = part[idx].trim();						
						if (txtValue.equals("YES")||txtValue.equals("Y")){
							txtValue = "Y";							
						} else if (txtValue.equals("NO")||txtValue.equals("N")){
							txtValue = "N";
						} 
						myNode.put(key, txtValue);
					}						
					if (key.indexOf("/covered")>-1){
						int strPos=key.indexOf('/')+1;
						int endPos=key.lastIndexOf('/');
						if (endPos < strPos){
							strPos=0;
						}
						String propId = key.substring(strPos,endPos);
						String txtValue = "N";
						String amtValue = "0";
						if (part[idx].equals("YES")||part[idx].equals("Y")){
							txtValue = "Y";
							amtValue = "1";							
						} else if (part[idx].equals("NO")||part[idx].equals("N")){
							txtValue = "N";
							amtValue = "0";							
						}
						
						%>
						<sql:update>
						REPLACE INTO ctm.product_properties VALUES(
							${productId}, '<%=propId%>', 1, <%=amtValue%>, '<%=txtValue%>',	NULL, curdate(), '2040-12-31', '', 0
						);
						</sql:update><% 
					}
					
				}
				// Process the overrides.. 
				for (int idx : overrides.keySet()){
					if (idx < part.length){
						if (part[idx].trim().length() > 0 && !part[idx].trim().equals("-")) {
						
							XmlNode n = new XmlNode("override");
							n.setAttribute("xpath", overrides.get(idx));
							n.setText(part[idx]);
							overrideNode.addChild(n);
						}
					}
				}
				
				%>
				<%--
				################################################################
				# 10. Write the ancillary product_properties_ext (type=A)
				################################################################
				--%>
				10. Write the ancillary product_properties_ext (type=A)<br />
				<c:if test="${productId != ''}" >
					<sql:update>
						REPLACE INTO ctm.product_properties_ext VALUES(
								'${productId}', ?, 'A');
						<sql:param><%=myNode.getXML()%></sql:param>
					</sql:update>
				</c:if>

				<%--
				################################################################
				# 11. Merge the product properties
				################################################################
				--%>
				11.1 Merge the product_properties_ext recs<br />
				<sql:query var="propRecs">
					SELECT * FROM ctm.product_properties_ext
					WHERE type in ('A','E') 
					AND productid=${productId}
					LIMIT 2
				</sql:query>
				
				<c:set var="masterXML">
					<jsp:element name="merge">
						<c:forEach items="${propRecs.rows}" var="propRec">		
							${propRec.text}
						</c:forEach>
					</jsp:element>
				</c:set>				

				<c:set var="mergedXML">
					<x:transform xml="${masterXML}" xslt="${prodPropsMergeXSL}" />
				</c:set>
				
				
				11.2 Apply Any overrides that are required
				<c:set var="overridesXML"><%=overrideNode.getXML()%></c:set>
				
				
				<c:set var="overridesMaster">
					<jsp:element name="data">
						${mergedXML}
						${overridesXML}
					</jsp:element>
				</c:set>				

				<c:set var="finalXML">
					<x:transform xml="${overridesMaster}" xslt="${prodPropsOverridesXSL}" />
				</c:set>
				
				
				11.3 Write the final product_properties_ext rec (with type=M)<br />
				<c:if test="${productId != ''}" >
					<sql:update>
						REPLACE INTO ctm.product_properties_ext 
						VALUES('${productId}', ?, 'M');
						<sql:param><c:out value="${finalXML}" escapeXml="false"/></sql:param>
					</sql:update>
				</c:if>
				<%					
			}
		}
		in.close();
	}							
%>

<hr />
<h2>OPERATION COMPLETE.</h2>

</c:otherwise>
</c:choose>
</body>
</html>
