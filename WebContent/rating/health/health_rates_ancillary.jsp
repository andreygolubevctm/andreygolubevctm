<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.*,java.util.*,java.text.*,java.math.*,au.com.bytecode.opencsv.CSVParser,com.disc_au.web.go.xml.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %> 
<sql:setDataSource dataSource="jdbc/ctm"/>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Upload Ancillary Health Rates</title>
<style type="text/css">
	body {
		font-family:sans-serif; 
		font-size:11px;
	}
</style>
</head>
<body>

<%
	
	CSVParser parser = new CSVParser(',','"');

	// Open the rates csv 
	BufferedReader in = new BufferedReader(new FileReader("_NEWROOTDIR_/rating/health/health_rates_ancillary_hcf.csv"));
	String line;
	
	String productCode;
	String prevProductCode = "";
	int sequenceNo = 1;
	HashMap<String, Integer> map = new HashMap<String, Integer>();
	int lineNo = 0; 
	DecimalFormat formatter = new DecimalFormat("#,###,##0.00");
	formatter.setRoundingMode(RoundingMode.HALF_UP);
	
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
	map.put("grossMonthlyLhc",col++);
	map.put("grossFortnightlyLhc",col++);
	map.put("grossAnnualLhc",col++);
	map.put("grossMonthlyPremium",col++);
	map.put("grossFortnightlyPremium",col++);
	map.put("grossAnnualPremium",col++);
	map.put("30PcMonthlyPremium",col++);
	map.put("30PcFortnightlyPremium",col++);
	map.put("30PcAnnualPremium",col++);
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

	
	for (int i=0;i<7;i++){
		line = in.readLine();
	}
	while((line = in.readLine()) != null) {
		lineNo++;
		System.out.println(lineNo);
		
		String[] part = parser.parseLine(line);		
		
		if (part.length > 0 && part[0].length() > 0){

			productCode = part[0].trim();
%>
			<sql:query var="product">
				SELECT productId from ctm.product_master 
				WHERE productCode = '<%=productCode %>'
				LIMIT 1
			</sql:query>
			<c:set var="productId" value="${product.rows[0].productId}" />
			<c:if test="${productId > 0}">
<%		
			// Reset the sequence number on change of product
			if (productCode != prevProductCode){
				sequenceNo = 1;
				prevProductCode = productCode;
			} else {
				sequenceNo++;
			}

			
			XmlNode myNode = new XmlNode("ancillaryData");
			myNode.setAttribute("ProductCode", productCode);
			for (String key : map.keySet()){
				int idx = map.get(key);
				key = key.replaceAll("_", "-");
				if (idx < firstNodeItem) {
					
					String currency = "";
					String value = "";
					value = part[idx];
					
					//see if the variable actually needs a currency format
					if((idx >= firstPrem && idx <= lastPrem) || idx==excessAmt) {
						value = value.replaceAll(",", "");
						value = value.replaceAll("\\$", "");
						
						// Convert to BigDecimal
						try {
							BigDecimal d = new BigDecimal(value);
							formatter.setRoundingMode(RoundingMode.HALF_UP);
							currency = "$" + formatter.format(d);
						} catch (Exception e){
							
							currency = part[idx];
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
						${productId}, 
						'<%=key%>', 
						<%=sequenceNo%>, 
						<%=value%>,
						'<%=currency%>', 
						NULL,
						curdate(),
						'2040-12-31', 
						'',
						0 
					);
					</sql:update>
					
					<br />
					<%
				} else {
					myNode.put(key, part[idx]);
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
					}
					System.out.println(key +"="+part[idx] + " -> " + propId +"="+txtValue);
					%>
					<sql:update>
					REPLACE INTO ctm.product_properties VALUES(
						${productId}, 
						'<%=propId%>', 
						<%=sequenceNo%>, 
						<%=amtValue%>,
						'<%=txtValue%>', 
						NULL,
						curdate(),
						'2040-12-31', 
						'',
						0 
					);
					</sql:update><% 
					
				}
					
			}
			%>
				<c:if test="${productId != ''}" >
					<sql:update>
					REPLACE INTO ctm.product_properties_ext VALUES(
							'${productId}', ?, 'A');
						<sql:param><%=myNode.getXML()%></sql:param>
					</sql:update>
				</c:if>
			</c:if><%			
		}
		
		
	}

%>






</body>
</html>
