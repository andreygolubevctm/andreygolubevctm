<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://exslt.org/math"
				extension-element-prefixes="math">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="SPName" />
	<xsl:param name="CustLoginId" />
	<xsl:param name="password" />


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="serviceProvider">au.com.Compare</xsl:variable>
		<xsl:variable name="isoDate">T10:10:10Z</xsl:variable>

		<xsl:variable name="region">
			<xsl:choose>
				<!-- REGION 1 (Worldwide) -->
				<xsl:when test="destinations/af/af !='' ">37c47d9d-cc54-4543-a9f1-9ff6011349b2</xsl:when>
				<xsl:when test="destinations/am/us !='' ">37c47d9d-cc54-4543-a9f1-9ff6011349b2</xsl:when>
				<xsl:when test="destinations/am/ca !='' ">37c47d9d-cc54-4543-a9f1-9ff6011349b2</xsl:when>
				<xsl:when test="destinations/am/sa !='' ">37c47d9d-cc54-4543-a9f1-9ff6011349b2</xsl:when>

				<!-- REGION 2 (Worldwide excluding Americas and Africa) -->
				<!-- Europe -->
				<xsl:when test="destinations/eu">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>

				<!-- UK -->
				<xsl:when test="destinations/eu/uk">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>

				<!-- Japan -->
				<xsl:when test="destinations/as/jp !='' ">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>

				<!-- India -->
				<xsl:when test="destinations/as/in !='' ">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>

				<!-- China -->
				<xsl:when test="destinations/as/ch !='' ">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>

				<!-- HongKong -->
				<xsl:when test="destinations/as/hk !='' ">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>

				<!-- Middle East -->
				<xsl:when test="destinations/me/me !='' ">b054b9d7-41d9-470f-a487-9ff60113539c</xsl:when>


				<!-- REGION 3 (South East Asia) -->
				<!-- Thailand -->
				<xsl:when test="destinations/as/th !='' ">eac89a74-662c-4e36-a0b6-9ff60113602a</xsl:when>


				<!-- REGION 4 (NZ/Pacific Islands) -->
				<!-- NZ, bro -->
				<xsl:when test="destinations/pa/nz">8ecf958d-8708-4b22-8e96-9ff601136a2c</xsl:when>

				<!-- Bali -->
				<xsl:when test="destinations/pa/ba">8ecf958d-8708-4b22-8e96-9ff601136a2c</xsl:when>

				<!-- Pacific Islands -->
				<xsl:when test="destinations/pa/pi">8ecf958d-8708-4b22-8e96-9ff601136a2c</xsl:when>

				<!-- Indonesia -->
				<xsl:when test="destinations/pa/in !='' ">8ecf958d-8708-4b22-8e96-9ff601136a2c</xsl:when>

				<!-- REGION 5 (Domestic) -->
				<!-- Australia -->
				<xsl:when test="destinations/au/au !='' ">833b107a-9dc7-4d52-841d-6074884dcf50</xsl:when>

				<!-- Default to REGION 1 (Worldwide) -->
				<!-- Any other country -->
				<xsl:when test="destinations/do/do !='' ">37c47d9d-cc54-4543-a9f1-9ff6011349b2</xsl:when>

				<xsl:otherwise>37c47d9d-cc54-4543-a9f1-9ff6011349b2</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
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
					<!-- Service Provider's Date/Time in UTC time format (YYYY-MM-DDThh:nn:ssZ) or (YYYY-MM-DDThh:nn:ss+08:00) SGT/PHT -->
					<ClientDt>
						<xsl:value-of select="$today" /><xsl:value-of select="$isoDate" />
					</ClientDt>
					<CustLangPref>en</CustLangPref>
					<ClientApp>
						<Org>com.au.comparethemarket</Org>
						<Name>Compare the Market</Name>
						<Version>1.0</Version>
					</ClientApp>
				</SignonRq>
				<InsuranceSvcRq>
					<RqUID><xsl:call-template name="util_randomNumber" /></RqUID>
					<PersPkgPolicyQuoteInqRq>
					<!-- Service Provider's Transaction Request Date/Time in UTC time format, can be similar to <ClientDt> -->
					<TransactionRequestDt>
						<xsl:value-of select="$today" /><xsl:value-of select="$isoDate" />
					</TransactionRequestDt>
					<!-- For a Quick Quote, no Policy Holder or Insured details are required.  Please send: <InsuredOrPrincipal xsi:nil="true" /> -->
					<InsuredOrPrincipal xsi:nil="true" />
					<!-- <PersPolicy> node is mandatory and contains the ACE-defined Product definitions for this Policy. -->
					<PersPolicy>
					<!-- <CompanyProductCd> element is mandatory to specify the ACE-provided Product Code -->
					<CompanyProductCd>
						<xsl:choose>
							<xsl:when test="destinations/*[not(self::au)]/*">FDFF3520-404C-4021-A031-9FF601111143</xsl:when>
							<xsl:when test="destinations/au/au">1425FDC9-24DF-4E90-8048-9FF60124EEAF</xsl:when>
							<xsl:otherwise>FDFF3520-404C-4021-A031-9FF601111143</xsl:otherwise>
						</xsl:choose>
					</CompanyProductCd>

					<!-- <ContractTerm> is a mandatory node -->
					<ContractTerm>
						<!-- <EffectiveDt> element is mandatory to specify the Travel Start Date in XML Date format (YYYY-MM-DD) -->

						<xsl:variable name="todayYYYY"><xsl:value-of select="substring($today,1,4)" /></xsl:variable>
						<xsl:variable name="todayMM"><xsl:value-of select="substring($today,6,2)" /></xsl:variable>

						<xsl:variable name="oneyearYYYY">
							<xsl:choose>
								<xsl:when test="$todayMM = '01' ">
									<xsl:value-of select="$todayYYYY" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="number($todayYYYY) + 1" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="oneyearMM">
							<xsl:choose>
								<xsl:when test="$todayMM = '01' ">12</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number(number($todayMM) - 1,'00')" />
								</xsl:otherwise>
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
									<xsl:value-of select="concat($oneyearYYYY, '-', $oneyearMM, substring($today,8,3))" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<EffectiveDt><xsl:value-of select="$fromDate" /></EffectiveDt>
						<!-- <ExpirationDt> element is mandatory to specify the Travel End Date in XML Date format (YYYY-MM-DD) -->
						<ExpirationDt><xsl:value-of select="$toDate" /></ExpirationDt>
					</ContractTerm>
					<!-- <com.acegroup_Destination> node is mandatory to specify the ACE-provided Destination Code and Destination Description -->
					<com.acegroup_Destination>
						<!-- ACE-provided Destination Code in System.GUID format -->
						<RqUID><xsl:value-of select="$region" /></RqUID>
						<!-- ACE-provided Destination Description -->
						<DestinationDesc><xsl:value-of select="$region" /></DestinationDesc>
					</com.acegroup_Destination>
					<!-- <com.acegroup_InsuredPackage> node is mandatory to specify the ACE-provided Insured Type Code and Insured Type Description -->
					<com.acegroup_InsuredPackage>
						<!-- ACE-provided Insured Type Code in System.GUID format -->
						<RqUID>
							<xsl:choose>
								<xsl:when test="adults = '1'">5CC9A8D2-8298-4CD0-946C-9CCD00372B4F</xsl:when>
								<xsl:otherwise>CC5E1A96-2923-40B6-B8EF-9E13004388AF</xsl:otherwise>
							</xsl:choose>
						</RqUID>
						<!-- ACE-provided Insured Type Description -->
						<InsuredPackageDesc>
							<xsl:choose>
								<xsl:when test="adults = '1'">Single</xsl:when>
								<xsl:otherwise>Joint</xsl:otherwise>
							</xsl:choose>
						</InsuredPackageDesc>
					</com.acegroup_InsuredPackage>
					<!-- <com.acegroup_Plan> node is mandatory to specify the ACE-provided Plan Code and Plan Description -->
					<com.acegroup_Plan>
						<!-- ACE-provided Plan Code in System.GUID format.  To retrieve quotes for all plans for this product, please send the following values -->
						<RqUID>00000000-0000-0000-0000-000000000000</RqUID>
						<!-- ACE-provided Plan Description. To retrieve quotes for a specific plan for this product, please send the following values -->
						<PlanDesc>Unspecified</PlanDesc>
					</com.acegroup_Plan>
					</PersPolicy>
					<!-- <com.acegroup_DataExtensions> node is used to send additional details. This node is optional. If not applicable, please send: <com.acegroup_DataExtensions xsi:nil="true" /> -->
					<com.acegroup_DataExtensions xsi:nil="true" />
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

	<xsl:template name="util_makeHex">
		<xsl:param name="digit" />

		<xsl:choose>
			<xsl:when test="$digit='10'">A</xsl:when>
			<xsl:when test="$digit='11'">B</xsl:when>
			<xsl:when test="$digit='12'">C</xsl:when>
			<xsl:when test="$digit='13'">D</xsl:when>
			<xsl:when test="$digit='14'">E</xsl:when>
			<xsl:when test="$digit='15'">F</xsl:when>
			<xsl:otherwise><xsl:value-of select="$digit" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template name="util_randomNumber">
		<xsl:variable name="pre1" select="floor(math:random()*16)"/>
		<xsl:variable name="pre2" select="floor(math:random()*16)"/>
		<xsl:variable name="pre3" select="floor(math:random()*16)"/>
		<xsl:variable name="pre4" select="floor(math:random()*16)"/>
		<xsl:variable name="pre5" select="floor(math:random()*16)"/>
		<xsl:variable name="pre6" select="floor(math:random()*16)"/>
		<xsl:variable name="pre7" select="floor(math:random()*16)"/>
		<xsl:variable name="pre8" select="floor(math:random()*16)"/>
		<xsl:variable name="pre9" select="floor(math:random()*16)"/>
		<xsl:variable name="pre10" select="floor(math:random()*16)"/>
		<xsl:variable name="pre11" select="floor(math:random()*16)"/>
		<xsl:variable name="pre12" select="floor(math:random()*16)"/>
		<xsl:variable name="pre13" select="floor(math:random()*16)"/>
		<xsl:variable name="pre14" select="floor(math:random()*16)"/>
		<xsl:variable name="pre15" select="floor(math:random()*16)"/>
		<xsl:variable name="pre16" select="floor(math:random()*16)"/>
		<xsl:variable name="pre17" select="floor(math:random()*16)"/>
		<xsl:variable name="pre18" select="floor(math:random()*16)"/>
		<xsl:variable name="pre19" select="floor(math:random()*16)"/>
		<xsl:variable name="pre20" select="floor(math:random()*16)"/>
		<xsl:variable name="pre21" select="floor(math:random()*16)"/>
		<xsl:variable name="pre22" select="floor(math:random()*16)"/>
		<xsl:variable name="pre23" select="floor(math:random()*16)"/>
		<xsl:variable name="pre24" select="floor(math:random()*16)"/>
		<xsl:variable name="pre25" select="floor(math:random()*16)"/>
		<xsl:variable name="pre26" select="floor(math:random()*16)"/>
		<xsl:variable name="pre27" select="floor(math:random()*16)"/>
		<xsl:variable name="pre28" select="floor(math:random()*16)"/>
		<xsl:variable name="pre29" select="floor(math:random()*16)"/>
		<xsl:variable name="pre30" select="floor(math:random()*16)"/>
		<xsl:variable name="pre31" select="floor(math:random()*16)"/>
		<xsl:variable name="pre32" select="floor(math:random()*16)"/>

		<xsl:variable name="pos1">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre1" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos2">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre2" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos3">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre3" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos4">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre4" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos5">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre5" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos6">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre6" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos7">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre7" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos8">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre8" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos9">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre9" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos10">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre10" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos11">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre11" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos12">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre12" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos13">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre13" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos14">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre14" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos15">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre15" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos16">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre16" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos17">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre17" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos18">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre18" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos19">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre19" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos20">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre20" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos21">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre21" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos22">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre22" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos23">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre23" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos24">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre24" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos25">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre25" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos26">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre26" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos27">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre27" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos28">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre28" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos29">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre29" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos30">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre30" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos31">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre31" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos32">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre32" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$pos1" /><xsl:value-of select="$pos2" /><xsl:value-of select="$pos3" /><xsl:value-of select="$pos4" />
		<xsl:value-of select="$pos5" /><xsl:value-of select="$pos6" /><xsl:value-of select="$pos7" /><xsl:value-of select="$pos8" />-<xsl:value-of select="$pos9" />
		<xsl:value-of select="$pos10" /><xsl:value-of select="$pos11" /><xsl:value-of select="$pos12" />-<xsl:value-of select="$pos13" />
		<xsl:value-of select="$pos14" /><xsl:value-of select="$pos15" /><xsl:value-of select="$pos16" />-<xsl:value-of select="$pos17" />
		<xsl:value-of select="$pos18" /><xsl:value-of select="$pos19" /><xsl:value-of select="$pos20" />-<xsl:value-of select="$pos21" />
		<xsl:value-of select="$pos22" /><xsl:value-of select="$pos23" /><xsl:value-of select="$pos24" /><xsl:value-of select="$pos25" />
		<xsl:value-of select="$pos26" /><xsl:value-of select="$pos27" /><xsl:value-of select="$pos28" /><xsl:value-of select="$pos29" />
		<xsl:value-of select="$pos30" /><xsl:value-of select="$pos31" /><xsl:value-of select="$pos32" />
	</xsl:template>
</xsl:stylesheet>
