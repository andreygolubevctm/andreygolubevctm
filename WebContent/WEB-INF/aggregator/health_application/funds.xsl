<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<!-- Template for all of th Health Funds -->
	<xsl:template name="get_fund">
		<xsl:param name="fundCode" />
		<xsl:choose>
			<xsl:when test="$fundCode ='ACA'">ACA Health Benefits Fund</xsl:when>
			<xsl:when test="$fundCode ='AHM'">ahm - Aust Health Management Ins</xsl:when>
			<xsl:when test="$fundCode ='AMA'">AMA Health Fund Limited</xsl:when>
			<xsl:when test="$fundCode ='API'">API Health Linx</xsl:when>
			<xsl:when test="$fundCode ='AUSTUN'">Australian Unity Health Insurance</xsl:when>
			<xsl:when test="$fundCode ='BHP'">Broken Hill Pty Limited</xsl:when>
			<xsl:when test="$fundCode ='BUPA'">Bupa Australia</xsl:when>
			<xsl:when test="$fundCode ='CBHS'">CBHS Health Fund Limited</xsl:when>
			<xsl:when test="$fundCode ='CDH'">CDH - Cessnock District Health Benefits Fund</xsl:when>
			<xsl:when test="$fundCode ='CWH'">Central West Health Cover</xsl:when>
			<xsl:when test="$fundCode ='CI'">Commercial Insurer</xsl:when>
			<xsl:when test="$fundCode ='CPS'">CPS Health Benefits Society</xsl:when>
			<xsl:when test="$fundCode ='CUA'">CUA Health Limited</xsl:when>
			<xsl:when test="$fundCode ='DHBS'">Defence Health Limited</xsl:when>
			<xsl:when test="$fundCode ='DOC'">The Doctors Health Fund</xsl:when>
			<xsl:when test="$fundCode ='DFS'">Druids Friendly Society</xsl:when>
			<xsl:when test="$fundCode ='UAOD'">Druids Health Benefits Fund</xsl:when>
			<xsl:when test="$fundCode ='FI'">Federation Insurance</xsl:when>
			<xsl:when test="$fundCode ='FRANK'">Frank Health Insurance</xsl:when>
			<xsl:when test="$fundCode ='GMF'">GMF - Goldfields Medical Fund</xsl:when>
			<xsl:when test="$fundCode ='HHBFL'">GMF - Healthguard Health Ben Fund</xsl:when>
			<xsl:when test="$fundCode ='GMHBA'">GMHBA - Geelong Med &amp; Hos Ben Assoc</xsl:when>
			<xsl:when test="$fundCode ='GU'">Grand United Corporate Health</xsl:when>
			<xsl:when test="$fundCode ='HBA'">HBA - Hospital Benefits Association</xsl:when>
			<xsl:when test="$fundCode ='HBF'">HBF Health Funds inc</xsl:when>
			<xsl:when test="$fundCode ='HCF'">HCF - Hospitals Contribution Fund</xsl:when>
			<xsl:when test="$fundCode ='HCI'">Health Care Insurance Ltd</xsl:when>
			<xsl:when test="$fundCode ='HEA'">Health.com.au</xsl:when>
			<xsl:when test="$fundCode ='HBFSA'">Health Partners</xsl:when>
			<xsl:when test="$fundCode ='HIF'">Hif - Health Ins Fund of Aust Ltd</xsl:when>
			<xsl:when test="$fundCode ='IMAN'">Iman Health Care</xsl:when>
			<xsl:when test="$fundCode ='IOOF'">Ind Order of OddFellows</xsl:when>
			<xsl:when test="$fundCode ='IOR'">Independ Order of Rechabites</xsl:when>
			<xsl:when test="$fundCode ='IFHP'">International Fed Health Plans</xsl:when>
			<xsl:when test="$fundCode ='LVHHS'">Latrobe Health Services</xsl:when>
			<xsl:when test="$fundCode ='MU'">Manchester Unity Australia</xsl:when>
			<xsl:when test="$fundCode ='MBF'">MBF - Medical Benefit Fund</xsl:when>
			<xsl:when test="$fundCode ='MEDIBK'">Medibank Private Limited</xsl:when>
			<xsl:when test="$fundCode ='MDHF'">Mildura District Hospital Fund</xsl:when>
			<xsl:when test="$fundCode ='MC'">Mutual Community</xsl:when>
			<xsl:when test="$fundCode ='NHBA'">National Health Benefits Aust Ltd</xsl:when>
			<xsl:when test="$fundCode ='NATMUT'">National Mutual Health Ins</xsl:when>
			<xsl:when test="$fundCode ='NHBS'">Navy Health</xsl:when>
			<xsl:when test="$fundCode ='NIB'">NIB Health Funds Limited</xsl:when>
			<xsl:when test="$fundCode ='NRMA'">NRMA - Nat Roads &amp; Motorists Ass</xsl:when>
			<xsl:when test="$fundCode ='OTHER'">Other</xsl:when>
			<xsl:when test="$fundCode ='LHMC'">Peoplecare (Lysaght)</xsl:when>
			<xsl:when test="$fundCode ='PWAL'">Phoenix Welfare Assoc Ltd</xsl:when>
			<xsl:when test="$fundCode ='SAPOL'">Police Health</xsl:when>
			<xsl:when test="$fundCode ='QCH'">Queensland Country Health Fund Ltd</xsl:when>
			<xsl:when test="$fundCode ='RTEHF'">Railway &amp; Transport Health Fund</xsl:when>
			<xsl:when test="$fundCode ='RBHS'">Reserve Bank Health Soc Ltd</xsl:when>
			<xsl:when test="$fundCode ='SGIC'">SGIC Health</xsl:when>
			<xsl:when test="$fundCode ='SGIO'">SGIO Health</xsl:when>
			<xsl:when test="$fundCode ='SLHI'">St Lukes Health</xsl:when>
			<xsl:when test="$fundCode ='TFHS'">Teachers Health Fund</xsl:when>
			<xsl:when test="$fundCode ='TFS'">Transport Health</xsl:when>
			<xsl:when test="$fundCode ='QTUHS'">TUH - Teachers Union Health (QLD)</xsl:when>
			<xsl:when test="$fundCode ='WDHF'">Westfund Limited</xsl:when>
			<xsl:otherwise>No current health fund</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>