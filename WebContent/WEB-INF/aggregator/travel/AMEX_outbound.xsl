<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cal="java.util.GregorianCalendar" xmlns:sdf="java.text.SimpleDateFormat" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="cal sdf java">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/util_functions.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="SPName" />
	<xsl:param name="CustLoginId" />
	<xsl:param name="password" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="isoDate">T10:10:10Z</xsl:variable>

		<xsl:variable name="quoteCode">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:choose>
						<xsl:when test="destinations/*[not(self::au)]/*">SingleTrip</xsl:when>
						<xsl:when test="destinations/au/au">SingleDomestic</xsl:when>
						<xsl:otherwise>SingleTrip</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>Annual</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fromDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="util_isoDate">
						<xsl:with-param name="eurDate" select="dates/fromDate" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$today" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="toDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="util_isoDate">
						<xsl:with-param name="eurDate" select="dates/toDate" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="yearPlus" select="cal:add(1, 1)"/> <!-- Year -->
					<xsl:value-of select="sdf:format(sdf:new('yyyy-MM-dd'),cal:getTime())" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="region">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:choose>
						<!-- REGION 1 (Worldwide) -->
						<xsl:when test="destinations/af/af">aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:when>
						<xsl:when test="destinations/am/us">aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:when>
						<xsl:when test="destinations/am/ca">aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:when>
						<xsl:when test="destinations/am/sa">aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:when>
						<xsl:when test="destinations/do/do">aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:when>

						<!-- REGION 2 (Worldwide excluding Americas and Africa) -->
						<xsl:when test="destinations/eu/eu">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>
						<xsl:when test="destinations/eu/uk">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>
						<xsl:when test="destinations/me/me">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>
						<xsl:when test="destinations/as/jp">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>
						<xsl:when test="destinations/as/in">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>
						<xsl:when test="destinations/as/ch">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>
						<xsl:when test="destinations/as/hk">c4ee8e38-b191-45b3-b1ed-a2e4003f8b36</xsl:when>

						<!-- REGION 3 (South East Asia) -->
						<xsl:when test="destinations/as/th">e09e1c38-0efc-4a86-ba52-a2e4003f9803</xsl:when>

						<!-- REGION 4 (NZ/Pacific Islands) -->
						<xsl:when test="destinations/pa/nz">84421cdc-bfe1-42d6-a3d4-a2e4003fa71a</xsl:when>
						<xsl:when test="destinations/pa/ba">84421cdc-bfe1-42d6-a3d4-a2e4003fa71a</xsl:when>
						<xsl:when test="destinations/pa/pi">84421cdc-bfe1-42d6-a3d4-a2e4003fa71a</xsl:when>
						<xsl:when test="destinations/pa/in">84421cdc-bfe1-42d6-a3d4-a2e4003fa71a</xsl:when>

						<!-- REGION 5 (Domestic) -->
						<xsl:when test="destinations/au/au">245b95d7-d772-4d8d-90f6-a2e4003fb3f7</xsl:when>

						<!-- Default to REGION 1 (Worldwide) -->
						<xsl:otherwise>aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>aeae6488-662f-4a5c-9c2d-a2e4003f7a86</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="destination">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:choose>
						<!-- REGION 1 (Worldwide) -->
						<xsl:when test="destinations/af/af">Worldwide</xsl:when>
						<xsl:when test="destinations/am/us">Worldwide</xsl:when>
						<xsl:when test="destinations/am/ca">Worldwide</xsl:when>
						<xsl:when test="destinations/am/sa">Worldwide</xsl:when>
						<xsl:when test="destinations/do/do">Worldwide</xsl:when>

						<!-- REGION 2 (Worldwide excluding Americas and Africa) -->
						<xsl:when test="destinations/eu/eu">Europe</xsl:when>
						<xsl:when test="destinations/eu/uk">Europe</xsl:when>
						<xsl:when test="destinations/me/me">Europe</xsl:when>

						<!-- REGION 3 (South East Asia) -->
						<xsl:when test="destinations/as/jp">South East Asia</xsl:when>
						<xsl:when test="destinations/as/in">South East Asia</xsl:when>
						<xsl:when test="destinations/as/ch">South East Asia</xsl:when>
						<xsl:when test="destinations/as/hk">South East Asia</xsl:when>
						<xsl:when test="destinations/as/th">South East Asia</xsl:when>

						<!-- REGION 4 (NZ/Pacific Islands) -->
						<xsl:when test="destinations/pa/nz">Pacific</xsl:when>
						<xsl:when test="destinations/pa/ba">Pacific</xsl:when>
						<xsl:when test="destinations/pa/pi">Pacific</xsl:when>
						<xsl:when test="destinations/pa/in">Pacific</xsl:when>

						<!-- REGION 5 (Domestic) -->
						<xsl:when test="destinations/au/au">Domestic</xsl:when>

						<!-- Default to REGION 1 (Worldwide) -->
						<xsl:otherwise>Worldwide</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>Worldwide</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- START ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		<soap:Body>
			<GetTravelQuoteArray xmlns="http://ACE.Global.Travel.CRS.Schemas.ACORD.WS/">
			<ACORD xmlns="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteReq">
				<SignonRq>
				<SignonPswd>
					<CustId>
					<SPName><xsl:value-of select="$SPName" /></SPName>
					<CustLoginId><xsl:value-of select="$CustLoginId" /></CustLoginId>
					</CustId>
					<CustPswd>
					<EncryptionTypeCd>None</EncryptionTypeCd>
					<Pswd><xsl:value-of select="$password" /></Pswd>
					</CustPswd>
				</SignonPswd>
				<ClientDt><xsl:value-of select="$today" /><xsl:value-of select="$isoDate" /></ClientDt>
				<CustLangPref>en</CustLangPref>
				<ClientApp>
					<Org>CompareTheMarket</Org>
					<Name>CompareTheMarket</Name>
					<Version>1.0</Version>
				</ClientApp>
				</SignonRq>
				<InsuranceSvcRq>
				<RqUID><xsl:call-template name="util_randomNumber" /></RqUID>
				<PersPkgPolicyQuoteInqRq>
					<TransactionRequestDt><xsl:value-of select="$today" /><xsl:value-of select="$isoDate" /></TransactionRequestDt>
					<InsuredOrPrincipal xsi:nil="true" />
					<PersPolicy>
					<!-- <CompanyProductCd> element is mandatory to specify the ACE-provided Product Code -->
					<CompanyProductCd>da62d3aa-9f65-4e5c-8e94-a2e4003a685c</CompanyProductCd>
					<ContractTerm>
						<!-- <EffectiveDt> element is mandatory to specify the Travel Start Date in XML Date format (YYYY-MM-DD) -->
						<EffectiveDt><xsl:value-of select="$fromDate" /></EffectiveDt>
						<!-- <ExpirationDt> element is mandatory to specify the Travel End Date in XML Date format (YYYY-MM-DD) -->
						<ExpirationDt><xsl:value-of select="$toDate" /></ExpirationDt>
					</ContractTerm>
					<com.acegroup_Destination>
						<RqUID><xsl:value-of select="$region" /></RqUID>
						<DestinationDesc><xsl:value-of select="$destination" /></DestinationDesc>
					</com.acegroup_Destination>
					<!-- <com.acegroup_InsuredPackage> node is mandatory to specify the ACE-provided Insured Type Code and Insured Type Description -->
					<com.acegroup_InsuredPackage>
						<!-- ACE-provided Insured Type Code in System.GUID format -->
						<RqUID><xsl:choose>
								<xsl:when test="(children = '0') and (adults = '1')">851cfff2-ed6e-4835-a7fd-9d0d0019c474</xsl:when>
								<xsl:when test="(children = '0') and (adults = '2')">cc5e1a96-2923-40b6-b8ef-9e13004388af</xsl:when>
								<xsl:otherwise>d4a1fb1a-88bb-44b1-ab0f-20ce60cf449d</xsl:otherwise>
							</xsl:choose></RqUID>
						<!-- ACE-provided Insured Type Description -->
						<InsuredPackageDesc><xsl:choose>
								<xsl:when test="(children = '0') and (adults = '1')">Individual</xsl:when>
								<xsl:when test="(children = '0') and (adults = '2')">Joint</xsl:when>
								<xsl:otherwise>Family/Group</xsl:otherwise>
							</xsl:choose></InsuredPackageDesc>
					</com.acegroup_InsuredPackage>
					<com.acegroup_Plan>
						<RqUID>00000000-0000-0000-0000-000000000000</RqUID>
						<PlanDesc>Unspecified</PlanDesc>
					</com.acegroup_Plan>
					</PersPolicy>
					<com.acegroup_DataExtensions>
					<DataItem type="System.Int" key="NoOfChildren">
					<value><xsl:value-of select="children" /></value>
					</DataItem>
					<DataItem type="System.Int" key="AdultAge1">
						<xsl:choose>
								<xsl:when test="(oldest &gt; 17) and (oldest &lt; 90)">
									<value><xsl:value-of select="oldest" /></value>
								</xsl:when>
								<xsl:otherwise>
									<value>0</value>
								</xsl:otherwise>
							</xsl:choose>
					</DataItem>
					<DataItem type="System.Int" key="AdultAge2">
						<xsl:choose>
								<xsl:when test="adults = 2 and (oldest &gt; 17) and (oldest &lt; 90)">
									<value><xsl:value-of select="oldest" /></value>
								</xsl:when>
								<xsl:otherwise>
									<value>0</value>
								</xsl:otherwise>
							</xsl:choose>
					</DataItem>
					<DataItem type="System.Int" key="AdultAge3">
						<value>0</value>
					</DataItem>
					<DataItem type="System.Int" key="AdultAge4">
						<value>0</value>
					</DataItem>
					<DataItem type="System.String" key="QuoteCode">
						<value><xsl:value-of select="$quoteCode" /></value>
					</DataItem>
					<DataItem type="System.Boolean" key="IsFullQuote">
						<value>false</value>
					</DataItem>
					<DataItem key="Source_System" type="System.String">
						<value>comparethemarket</value>
					</DataItem>
					</com.acegroup_DataExtensions>
				</PersPkgPolicyQuoteInqRq>
				</InsuranceSvcRq>
			</ACORD>
			</GetTravelQuoteArray>
		</soap:Body>
		</soap:Envelope>

	</xsl:template>

<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="util_isoDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($month, '00')" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($day, '00')" />
	</xsl:template>
</xsl:stylesheet>