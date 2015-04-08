<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ai="http://www.softsure.co.za/"
	exclude-result-prefixes="soap ai">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../../includes/ranking.xsl"/>
	<xsl:import href="../../includes/get_price_availability.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="defaultProductId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="quoteURL" />


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:variable name="hasProductSuccess">
			<xsl:call-template name="responseHasValidProduct">
			</xsl:call-template>
		</xsl:variable>

		<results>
			<xsl:choose>
				<xsl:when test="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode = 'Status_Success' and /soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:PremiumQuoted/ai:SSPremiumQuoted">

					<xsl:for-each select="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:PremiumQuoted/ai:SSPremiumQuoted">

						<xsl:variable name="validationErrors">
							<xsl:call-template name="validateResponse">
							</xsl:call-template>
						</xsl:variable>

						<xsl:choose>
							<!-- ACCEPTABLE -->
							<xsl:when test="$validationErrors = ''">
								<xsl:call-template name="priceBlock" />
							</xsl:when>

							<!-- UNACCEPTABLE -->
							<xsl:otherwise>
								<xsl:if test="$hasProductSuccess = ''">
									<xsl:element name="price">
										<xsl:attribute name="productId">
											<xsl:call-template name="getProductId" />
										</xsl:attribute>
										<xsl:attribute name="service">AI</xsl:attribute>
										<available>N</available>
										<transactionId><xsl:value-of select="$transactionId"/></transactionId>

										<xsl:choose>
											<xsl:when test="error">
												<!--  Error generated by SOAPClient -->
												<xsl:copy-of select="error"></xsl:copy-of>
											</xsl:when>

											<xsl:when test="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode">
												<!--  Map AI's error codes to match ours -->
												<xsl:variable name="error_type">
													<xsl:choose>
														<xsl:when test="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode = 'Status_Failed'">
															returned_error
														</xsl:when>
														<xsl:when test="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode = 'Status_Knockout'">
															knock_out
														</xsl:when>
														<xsl:when test="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode = 'Status_MissingData'">
															returned_error
														</xsl:when>
														<xsl:otherwise>
															unknown
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>

												<xsl:choose>
													<xsl:when test="$validationErrors != ''">
														<xsl:call-template name="error_message">
															<xsl:with-param name="service">AI</xsl:with-param>
															<xsl:with-param name="error_type">invalid</xsl:with-param>
															<xsl:with-param name="message">
															<xsl:copy-of select="$validationErrors"></xsl:copy-of>
															</xsl:with-param>
															<xsl:with-param name="code"></xsl:with-param>
															<xsl:with-param name="data"></xsl:with-param>
														</xsl:call-template>
													</xsl:when>

													<xsl:otherwise>
														<xsl:call-template name="error_message">
															<xsl:with-param name="service">AI</xsl:with-param>
															<xsl:with-param name="error_type"><xsl:value-of select="$error_type"/></xsl:with-param>
															<xsl:with-param name="message"><xsl:value-of select="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusResults"></xsl:value-of></xsl:with-param>
															<xsl:with-param name="code"></xsl:with-param>
															<xsl:with-param name="data"><xsl:value-of select="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode"></xsl:value-of></xsl:with-param>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>

											<xsl:otherwise>
												<xsl:call-template name="error_message">
													<xsl:with-param name="service">AI</xsl:with-param>
													<xsl:with-param name="error_type">unknown</xsl:with-param>
													<xsl:with-param name="message">uncaught error</xsl:with-param>
													<xsl:with-param name="code"></xsl:with-param>
													<xsl:with-param name="data"></xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>

										</xsl:choose>
									</xsl:element>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>

				<xsl:otherwise>
					<!-- UNACCEPTABLE -->
					<xsl:element name="price">
						<xsl:attribute name="productId"><xsl:value-of select="$defaultProductId" /></xsl:attribute>
						<xsl:attribute name="service">AI</xsl:attribute>
						<available>N</available>
						<transactionId><xsl:value-of select="$transactionId"/></transactionId>
						<xsl:call-template name="error_message">
							<xsl:with-param name="service">AI</xsl:with-param>
							<xsl:with-param name="error_type">unknown</xsl:with-param>
							<xsl:with-param name="message">uncaught error</xsl:with-param>
							<xsl:with-param name="code"></xsl:with-param>
							<xsl:with-param name="data"></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</results>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="priceBlock">
		<xsl:variable name="referenceNumber">
			<xsl:value-of select="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:ReferenceNo"/>
		</xsl:variable>

		<xsl:variable name="productId">
			<xsl:call-template name="getProductId" />
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$productId != 'ERROR' and ai:Quoted = 'true'">

				<xsl:element name="price">
					<xsl:attribute name="service">AI</xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$productId"/></xsl:attribute>

					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>

					<headlineOffer>ONLINE</headlineOffer>
					<onlineAvailable>Y</onlineAvailable>
					<xsl:choose>
						<xsl:when test="$productId = 'AI-01-03'">
							<offlineAvailable>N</offlineAvailable>
						</xsl:when>
						<xsl:otherwise>
							<offlineAvailable>Y</offlineAvailable>
						</xsl:otherwise>
					</xsl:choose>

					<callbackAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
							<xsl:with-param name="hasModifications">N</xsl:with-param>
						</xsl:call-template>
					</callbackAvailable>

					<callbackAvailableWithModifications>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
							<xsl:with-param name="hasModifications">Y</xsl:with-param>
						</xsl:call-template>
					</callbackAvailableWithModifications>

					<xsl:call-template name="priceInfo">
						<xsl:with-param name="tagName">onlinePrice</xsl:with-param>
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="init"><xsl:value-of select="ai:MonthlyPremium/ai:InitFee"/></xsl:with-param>
						<xsl:with-param name="monthlyPremium"><xsl:value-of select="ai:MonthlyPremium/ai:TotalPremium"/></xsl:with-param>
						<xsl:with-param name="annualPremium"><xsl:value-of select="ai:AnnualPremium/ai:TotalPremium"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="priceInfo">
						<xsl:with-param name="tagName">offlinePrice</xsl:with-param>
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="init"><xsl:value-of select="ai:MonthlyPremium/ai:InitFee"/></xsl:with-param>
						<xsl:with-param name="monthlyPremium"><xsl:value-of select="ai:MonthlyPremium/ai:TotalPremium"/></xsl:with-param>
						<xsl:with-param name="annualPremium"><xsl:value-of select="ai:AnnualPremium/ai:TotalPremium"/></xsl:with-param>
					</xsl:call-template>

					<productDes>AI Car Insurance</productDes>
					<underwriter>The Hollard Insurance Company (PTY) LTD</underwriter>
					<brandCode>AI</brandCode>
					<acn>78 090 584 473</acn>
					<afsLicenceNo>241436</afsLicenceNo>

					<excess>
						<total><xsl:value-of select="ai:Excess"/></total>
						<excess>
							<description>Male driver, under the age of 30 or less than 2 years holding an Australian driving licence</description>
							<amount>$1500</amount>
						</excess>
						<excess>
							<description>Female driver under the age of 30 or less than 2 years holding an Australian driving licence</description>
							<amount>$900</amount>
						</excess>
						<excess>
							<description>Unlisted drivers</description>
							<amount>$1000</amount>
						</excess>
						<excess>
							<description>Single car accident excess</description>
							<amount>$300</amount>
						</excess>
						<excess>
							<description>Theft / Malicious Damage excess</description>
							<amount>$1000</amount>
						</excess>
						<excess>
							<description>Claim within first 6 months of policy inception</description>
							<amount>$600</amount>
						</excess>

						<xsl:if test="$request/vehicle/parking = '1' or  $request/vehicle/parking = '7'">
							<excess>
								<description>Undisclosed parking excess</description>
								<amount>$1000</amount>
							</excess>
						</xsl:if>
					</excess>

					<conditions>
						<condition/>
					</conditions>

					<leadNo><xsl:value-of select="$referenceNumber"/></leadNo>
					<telNo>1300 284 875</telNo>
					<openingHours>Monday to Friday (9am-7pm EST)</openingHours>
					<quoteUrl><xsl:value-of select="$quoteURL" /><xsl:value-of select="$referenceNumber"/></quoteUrl>
					<refnoUrl/>

					<xsl:choose>
						<xsl:when test="$productId = 'AI-01-02'">
							<pdsaUrl>http://b2b.aiinsurance.com.au/SSPublicDocs/Comprehensive_Cover_PDS_02.pdf</pdsaUrl>
							<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
							<pdsaDesShort>PDS</pdsaDesShort>
							<pdsbUrl>http://b2b.aiinsurance.com.au/SSPublicDocs/Smart-Box_Privacy_Document_PDS_02.pdf</pdsbUrl>
							<pdsbDesLong>Smart Box Privacy Statement</pdsbDesLong>
							<pdsbDesShort>PS</pdsbDesShort>
							<pdscUrl>http://b2b.aiinsurance.com.au/SSPublicDocs/Smart-Box_QA_01.pdf</pdscUrl>
							<pdscDesLong>Smart Box Q&amp;A</pdscDesLong>
							<pdscDesShort>QA</pdscDesShort>
						</xsl:when>

						<xsl:otherwise>
							<pdsaUrl>http://b2b.aiinsurance.com.au/SSPublicDocs/Comprehensive_Cover_PDS_02.pdf</pdsaUrl>
							<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
							<pdsaDesShort>PDS</pdsaDesShort>
							<pdsbUrl/>
							<pdsbDesLong/>
							<pdsbDesShort/>
						</xsl:otherwise>
					</xsl:choose>

					<fsgUrl />
					<disclaimer>
						<![CDATA[
						The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:
						<ul>
							<li>Driver's history or offences or claims</li>
							<li>Age or licence type of additional drivers</li>
							<li>Vehicle condition, accessories and modifications</li>
						</ul>
						]]>
					</disclaimer>
					<transferring />

					<xsl:call-template name="ranking">
						<xsl:with-param name="productId" select="$productId" />
					</xsl:call-template>

					<discount>
						<online></online>
						<offline></offline>
					</discount>

				</xsl:element>

			</xsl:when>
			<xsl:otherwise>
				<!-- UNACCEPTABLE -->
				<xsl:element name="price">
					<xsl:attribute name="productId"><xsl:value-of select="$productId"/></xsl:attribute>
					<xsl:attribute name="service">AI</xsl:attribute>
					<available>N</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<xsl:call-template name="error_message">
						<xsl:with-param name="service">AI</xsl:with-param>
						<xsl:with-param name="error_type">unknown</xsl:with-param>
						<xsl:with-param name="message">uncaught error</xsl:with-param>
						<xsl:with-param name="code"></xsl:with-param>
						<xsl:with-param name="data"></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Create the onlinePrice & offlinePrice elements -->
	<xsl:template name="priceInfo">

		<xsl:param name="tagName" />
		<xsl:param name="productId" />
		<xsl:param name="init" />
		<xsl:param name="monthlyPremium" />
		<xsl:param name="annualPremium" />

		<xsl:element name="{$tagName}">

			<lumpSumTotal>
				<xsl:call-template name="util_mathCeil">
					<xsl:with-param name="num" select="$annualPremium"/>
				</xsl:call-template>
			</lumpSumTotal>
			<instalmentFirst>
				<xsl:value-of select="format-number($monthlyPremium + $init, '0.##')"/>
			</instalmentFirst>
			<instalmentCount>11</instalmentCount>
			<instalmentPayment>
				<xsl:value-of select="$monthlyPremium"/>
			</instalmentPayment>
			<instalmentTotal><xsl:value-of select="format-number(($monthlyPremium * 12) + 110, '#.##')"/></instalmentTotal>

			<xsl:call-template name="productInfo">
				<xsl:with-param name="productId" select="$productId" />
				<xsl:with-param name="priceType" select="$tagName" />
				<xsl:with-param name="kms" select="''" />
			</xsl:call-template>

		</xsl:element>

	</xsl:template>

	<!-- VALIDATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template name="validateResponse">
		<xsl:if test="not(ai:Product)">
			<validationError>MISSING: Product name,</validationError>
		</xsl:if>
		<xsl:if test="not(ai:Excess)">
			<validationError>MISSING: Excess,</validationError>
		</xsl:if>
		<xsl:if test="not(ai:MonthlyPremium)">
			<validationError>MISSING: MonthlyPremium,</validationError>
		</xsl:if>
		<xsl:if test="not(ai:MonthlyPremium/ai:TotalPremium)">
			<validationError>MISSING: MonthlyPremium/TotalPremium,</validationError>
		</xsl:if>
		<xsl:if test="not(ai:AnnualPremium)">
			<validationError>MISSING: AnnualPremium,</validationError>
		</xsl:if>
		<xsl:if test="not(ai:AnnualPremium/ai:TotalPremium)">
			<validationError>MISSING: AnnualPremium/TotalPremium,</validationError>
		</xsl:if>
	</xsl:template>

	<xsl:template name="productInfo">
		<xsl:param name="productId" />
		<xsl:param name="priceType" />
		<xsl:param name="kms" />

		<xsl:choose>

			<xsl:when test="$productId = 'AI-01-01'">
				<name>Classic Comprehensive Cover</name>
				<des>A specialist car insurer which focuses on providing a wide range of uniquely tailored policies.</des>
				<feature>Includes 65% Maximum No Claim Discount &amp; a Reducible Basic Excess structure</feature>
				<info>
					<![CDATA[
					<p>AI Insurance provides comprehensive car insurance which includes cover for younger drivers and non standard vehicles.
					<br>Features and benefits include:</p>
					<li style="font-size:11px;"><strong>Lifetime Protected 65% No Claims Discount</strong> (NCD) provided with each policy</li>
					<li style="font-size:11px;"><strong>Excess free windscreen cover</strong> (limited to one excess free claim per period)*</li>
					<li style="font-size:11px;"><strong>Faultless excess</strong> - no excess payable for accident claims where the driver is not at fault and the at fault drivers details have been provided to AI Insurance*</li>
					<li style="font-size:11px;"><strong>Reducible basic excess</strong> - AI Insurance rewards you for each year that you don't make a claim by reducing your excess*</li>
					<li style="font-size:11px;"><strong>Client choice of repairer</strong> - AI Insurance allows clients to select their repairer of choice*<br>
					*Refer to the Product Disclosure Statement for more information.</li>
					<p style="margin-top:5px;">AI Insurance comprehensive car policies are underwritten by The Hollard Insurance Company Pty Ltd. Hollard is a member of the international Hollard Insurance Group which provides a wide range of insurance products and services to more than 6.5 million policyholders worldwide.</p>
					<p>Hollard has won the Australian Banking and Finance Magazine's awards for Best General Insurance Product (2008) and Nice Insurer of the Year (2007).</p>
					]]>
				</info>
				<terms>
					<![CDATA[
						<p><b>Maximum No Claims discount:</b></p>
						<p>With AI Insurance you will automatically receive a 65% maximum no claims discount and Rating 1 protection.</p>
					]]>
				</terms>
				<carbonOffset />
				<kms />

			</xsl:when>

			<xsl:when test="$productId = 'AI-01-02'">
				<name>Smart-Box Comprehensive Cover</name>
				<des>One of only a few telematics based insurance products available in the Australian market.</des>
				<feature>Insurance telematics is the use of a black box device in a car to record driving related behaviors for individualised premium</feature>
				<info>
					<![CDATA[
					<p>AI Insurance provides comprehensive car insurance which includes cover for younger drivers and non standard vehicles.
					<br>Features and benefits include:</p>
					<li style="font-size:11px;"><strong>Lifetime Protected 65% No Claims Discount</strong> (NCD) provided with each policy</li>
					<li style="font-size:11px;"><strong>Excess free windscreen cover</strong> (limited to one excess free claim per period)*</li>
					<li style="font-size:11px;"><strong>Faultless excess</strong> - no excess payable for accident claims where the driver is not at fault and the at fault drivers details have been provided to AI Insurance*</li>
					<li style="font-size:11px;"><strong>Reducible basic excess</strong> - AI Insurance rewards you for each year that you don't make a claim by reducing your excess*</li>
					<li style="font-size:11px;"><strong>Client choice of repairer</strong> - AI Insurance allows clients to select their repairer of choice*<br>
					*Refer to the Product Disclosure Statement for more information.</li>
					<p style="margin-top:5px;">AI Insurance comprehensive car policies are underwritten by The Hollard Insurance Company Pty Ltd. Hollard is a member of the international Hollard Insurance Group which provides a wide range of insurance products and services to more than 6.5 million policyholders worldwide.</p>
					<p>Hollard has won the Australian Banking and Finance Magazine's awards for Best General Insurance Product (2008) and Nice Insurer of the Year (2007).</p>
					]]>
				</info>
				<terms>
					<![CDATA[
						<p><b>Telematics device installation requirement:</b></p>
						<p>If you think that you are a "safer and better" driver than most other road users, here’s your chance to demonstrate your driving behavior to us – more accurate, individualized and cheaper premiums being your objective.</p>
					]]>
				</terms>
				<carbonOffset />
				<kms />
			</xsl:when>

			<xsl:when test="$productId = 'AI-01-03'">
				<name>Classic Plus Comprehensive Cover</name>
				<des>A specialist car insurer which focuses on providing a wide range of uniquely tailored policies.</des>
				<feature>Price shown includes 20% Online Discount</feature>
				<info>
					<![CDATA[
					<p>AI Insurance provides comprehensive car insurance which includes cover for younger drivers and non standard vehicles.
					<br>Features and benefits include:</p>
					<li style="font-size:11px;"><strong>Lifetime Protected 65% No Claims Discount</strong> (NCD) provided with each policy</li>
					<li style="font-size:11px;"><strong>Excess free windscreen cover</strong> (limited to one excess free claim per period)*</li>
					<li style="font-size:11px;"><strong>Faultless excess</strong> - no excess payable for accident claims where the driver is not at fault and the at fault drivers details have been provided to AI Insurance*</li>
					<li style="font-size:11px;"><strong>Reducible basic excess</strong> - AI Insurance rewards you for each year that you don't make a claim by reducing your excess*</li>
					<li style="font-size:11px;"><strong>Client choice of repairer</strong> - AI Insurance allows clients to select their repairer of choice*<br>
					*Refer to the Product Disclosure Statement for more information.</li>
					<p style="margin-top:5px;">AI Insurance comprehensive car policies are underwritten by The Hollard Insurance Company Pty Ltd. Hollard is a member of the international Hollard Insurance Group which provides a wide range of insurance products and services to more than 6.5 million policyholders worldwide.</p>
					<p>Hollard has won the Australian Banking and Finance Magazine's awards for Best General Insurance Product (2008) and Nice Insurer of the Year (2007).</p>
					]]>
				</info>
				<terms>
					<![CDATA[
						<p><b>Terms of the 20% online discount promotion:</b></p>
						<p>The discount applies to AI comprehensive car insurance policies purchased online and initiated after 4th September 2014, and is applicable to premium only - not fees and statutory charges - and does not extend to renewal of a policy. AI Insurance reserves the right to amend the discount amount and/or the period and base rate premiums are subject to change at their discretion.</p>
					]]>
				</terms>
				<carbonOffset />
				<kms />

			</xsl:when>
		</xsl:choose>
	</xsl:template>

<!-- GET THE PRODUCT ID ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="getProductId">
		<xsl:choose>
			<xsl:when test="ai:Product = 'CLASSIC'">AI-01-01</xsl:when>
			<xsl:when test="ai:Product = 'CLASSICSB'">AI-01-02</xsl:when>
			<xsl:when test="ai:Product = 'CLASSICPL'">AI-01-03</xsl:when>
			<xsl:otherwise>ERROR</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- CONFIRM RESPONSE INCLUDES AT LEAST ONE VALID PRODUCT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="responseHasValidProduct">
		<xsl:variable name="hasValidProduct">
			<xsl:choose>
				<xsl:when test="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:Results/ai:StatusCode = 'Status_Success' and /soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:PremiumQuoted/ai:SSPremiumQuoted">
					<xsl:for-each select="/soap:Envelope/soap:Body/ai:GetMultiPremiumResponse/ai:GetMultiPremiumResult/ai:PremiumQuoted/ai:SSPremiumQuoted">
						<xsl:variable name="validationErrors">
							<xsl:call-template name="validateResponse">
							</xsl:call-template>
						</xsl:variable>

						<xsl:if test="$validationErrors = ''">YES</xsl:if>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$hasValidProduct" />
	</xsl:template>

</xsl:stylesheet>