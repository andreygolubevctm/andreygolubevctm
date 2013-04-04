<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/get_street_name.xsl"/>
	<xsl:import href="../includes/utils.xsl"/>


<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:key name="keyAccs" match="item" use="@code"/>
	<xsl:variable name="tableAccs" select="document('AGIS_vehicle_accessories.xml')" />


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/quote">


<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="streetName">
			<xsl:choose>
				<xsl:when test="riskAddress/nonStd='Y'">
					<xsl:value-of select="riskAddress/nonStdStreet" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/streetName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="streetNumber">
			<xsl:choose>
				<xsl:when test="riskAddress/streetNum != ''">
					<xsl:value-of select="riskAddress/streetNum" />
				</xsl:when>
				<xsl:when test="riskAddress/streetNum !=''">
					<xsl:value-of select="riskAddress/streetNum" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/houseNoSel" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="unitLevel">
			<xsl:choose>
				<xsl:when test="riskAddress/nonStd='Y'">
					<xsl:value-of select="riskAddress/unitShop" />
				</xsl:when>
				<xsl:when test="riskAddress/unitSel !=''">
					<xsl:value-of select="riskAddress/unitSel" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/unitShop" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excessCode">

			<xsl:variable name="excessDif" select="(excess - baseExcess)" />

			<xsl:choose>
				<xsl:when test="baseExcess=''"></xsl:when>
				<xsl:when test="$excessDif &lt;=0">0</xsl:when>
				<xsl:when test="$excessDif = 100">2</xsl:when>
				<xsl:when test="$excessDif = 200">4</xsl:when>
				<xsl:when test="$excessDif = 300">6</xsl:when>
				<xsl:when test="$excessDif = 400">8</xsl:when>
				<xsl:when test="$excessDif &gt;=500">A</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<env:Envelope env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
			xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<env:Header />
		<env:Body>
			<ns2:request xmlns:ns2="https://ecommerce.disconline.com.au/services/schema/2.0/car_quote">

<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<header>
					<partnerId><xsl:value-of select="$partnerId"/></partnerId>
					<sourceId><xsl:value-of select="$sourceId"/></sourceId>
					<schemaVersion>2.0</schemaVersion>
					<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
					<extension>
						<excess><xsl:value-of select="$excessCode" /></excess>
					</extension>
					<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
				</header>

<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<details>
					<cover>A</cover>
					<vehicle>
						<redbookCode><xsl:value-of select="vehicle/redbookCode" /></redbookCode>
						<securityDevice><xsl:value-of select="vehicle/securityOption" /></securityDevice>
						<modified><xsl:value-of select="vehicle/modifications" /></modified>
						<accidentHailDamage><xsl:value-of select="vehicle/damage" /></accidentHailDamage>
						<annualKilometres>
							<xsl:call-template name="kilometreCode">
								<xsl:with-param name="kms" select="translate(vehicle/annualKilometres,'0123456789kms,','0123456789')" />
							</xsl:call-template>
						</annualKilometres>

						<xsl:call-template name="nonStandardAccessories" />

						<!-- Factory Options -->
						<xsl:choose>
							<xsl:when test="vehicle/factoryOptions = 'Y'">
								<factoryOptionList>
								<xsl:for-each select="*[starts-with(name(),'opts')]">
									<factoryOptionCode><xsl:value-of select="opt" /></factoryOptionCode>
								</xsl:for-each>
								</factoryOptionList>
							</xsl:when>

							<xsl:otherwise>
								<noFactoryOptions />
							</xsl:otherwise>
						</xsl:choose>
					</vehicle>
					<address>
						<xsl:if test="$unitLevel != ''">
							<unitLevel><xsl:value-of select="$unitLevel"/></unitLevel>
						</xsl:if>
						<streetNumber><xsl:value-of select="$streetNumber"/></streetNumber>
						<streetName><xsl:value-of select="$streetName" /></streetName>
						<suburbName><xsl:value-of select="riskAddress/suburbName" /></suburbName>
						<state><xsl:value-of select="riskAddress/state" /></state>
						<postCode><xsl:value-of select="riskAddress/postCode" /></postCode>
					</address>
					<whereParked><xsl:value-of select="vehicle/parking" /></whereParked>
					<vehicleUse><xsl:value-of select="vehicle/use" /></vehicleUse>
					<finance><xsl:value-of select="vehicle/finance" /></finance>
					<commencementDate>
						<xsl:call-template name="util_isoDate">
							<xsl:with-param name="eurDate" select="options/commencementDate" />
						</xsl:call-template>
					</commencementDate>
					<regularDriver>
						<DOB>
							<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="drivers/regular/dob" />
							</xsl:call-template>
						</DOB>
						<gender><xsl:value-of select="drivers/regular/gender" /></gender>
						<maritalStatus><xsl:value-of select="drivers/regular/maritalStatus" /></maritalStatus>
						<employmentStatus><xsl:value-of select="drivers/regular/employmentStatus" /></employmentStatus>
						<claims>
						<xsl:choose>
							<xsl:when test="drivers/regular/claims='U'">Y</xsl:when>
							<xsl:otherwise><xsl:value-of select="drivers/regular/claims" /></xsl:otherwise>
						</xsl:choose>
						</claims>
						<ownsAnotherCar><xsl:value-of select="drivers/regular/ownsAnotherCar" /></ownsAnotherCar>
						<NCD><xsl:value-of select="drivers/regular/ncd" /></NCD>
						<xsl:choose>
						<xsl:when test="drivers/regular/ncd='5'">
							<NCDPro><xsl:value-of select="drivers/regular/ncdpro" /></NCDPro>
						</xsl:when>
						<xsl:otherwise>
							<NCDPro>N</NCDPro>
						</xsl:otherwise>
						</xsl:choose>
					</regularDriver>

					<xsl:choose>
						<xsl:when test="drivers/spouse/exists = 'Y'">
							<spouse>
								<DOB>
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="drivers/spouse/dob" />
									</xsl:call-template>
								</DOB>
								<gender><xsl:value-of select="drivers/spouse/gender" /></gender>
								<employmentStatus><xsl:value-of select="drivers/spouse/employmentStatus" /></employmentStatus>
							</spouse>
						</xsl:when>
						<xsl:otherwise>
							<noSpouse />
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="drivers/young/exists = 'Y'">
							<youngestDriver>
								<DOB>
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="drivers/young/dob" />
									</xsl:call-template>
								</DOB>
								<gender><xsl:value-of select="drivers/young/gender" /></gender>
							</youngestDriver>
						</xsl:when>
						<xsl:otherwise>
							<noYoungestDriver />
						</xsl:otherwise>
					</xsl:choose>
					<ageRestriction><xsl:value-of select="options/driverOption" /></ageRestriction>
				</details>
			</ns2:request>
		</env:Body>
	</env:Envelope>

	</xsl:template>


<!-- SUPPORT TEMPLATES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="kilometreCode">
		<xsl:param name="kms" />

		<xsl:choose>
			<xsl:when test="$kms &lt; 5001">K</xsl:when>
			<xsl:when test="$kms &lt; 8001">L</xsl:when>
			<xsl:when test="$kms &lt; 10001">M</xsl:when>
			<xsl:when test="$kms &lt; 12001">N</xsl:when>
			<xsl:when test="$kms &lt; 15001">O</xsl:when>
			<xsl:when test="$kms &lt; 17501">P</xsl:when>
			<xsl:when test="$kms &lt; 20001">Q</xsl:when>
			<xsl:when test="$kms &lt; 25001">R</xsl:when>
			<xsl:when test="$kms &lt; 30001">S</xsl:when>
			<xsl:otherwise>T</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="nonStandardAccessories">
		<xsl:choose>
			<xsl:when test="vehicle/accessories = 'Y'">

				<nonStandardAccessoryList>
				<xsl:for-each select="accs/*[starts-with(name(),'acc')]">
					<xsl:sort select="name()" />

					<!--  set up some variables because the context will change inside the for loop -->
					<xsl:variable name="accCode" select="sel" />
					<xsl:variable name="accInc" select="inc" />
					<xsl:variable name="accPrc" select="prc" />

					<xsl:for-each select='$tableAccs/*'>
						<xsl:variable name="elementName" select="key('keyAccs', $accCode)/@name"/>

						<xsl:choose>
							<xsl:when test="$elementName != ''">
								<xsl:element name="{$elementName}">
									<xsl:attribute name="code"><xsl:value-of select="$accCode" /></xsl:attribute>

									<!-- Purchase prices supplied? -->
									<xsl:choose>
										<xsl:when test="$accInc = 'N'">
											<purchasePrice><xsl:value-of select="$accPrc" /></purchasePrice>
										</xsl:when>
										<xsl:otherwise>
											<includedInCar />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:comment>Error: Unknown Non-standard accessory "<xsl:value-of select="$accCode"/>"</xsl:comment>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
				</nonStandardAccessoryList>
			</xsl:when>

			<xsl:otherwise>
				<noNonStandardAccessories />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>