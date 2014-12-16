<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- PARAMETERS -->
	<xsl:param name="today" />
	<xsl:param name="transactionId" />

	<!-- IMPORTS -->
	<xsl:include href="../utils.xsl"/>
	<xsl:include href="../funds.xsl"/>

	<!-- VARIABLES -->

	<xsl:variable name="todays_date">
		<xsl:variable name="year" 	select="substring($today,1,4)" />
		<xsl:variable name="month" 	select="substring($today,6,2)" />
		<xsl:variable name="day" 	select="substring($today,9,2)" />

		<xsl:value-of select="$year" />
		<xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($month,'00')" />
		<xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($day,'00')" />
	</xsl:variable>

	<xsl:template name="last_day_of_month">
		<xsl:param name="month" />
		<xsl:choose>
			<xsl:when test="$month = '01' or $month = '03' or $month = '05' or $month = '07' or $month = '08' or $month = '10' or $month = '12'">
				<xsl:text>31</xsl:text>
			</xsl:when>
			<xsl:when test="$month = '04' or $month = '06' or $month = '09' or $month = '11'">
				<xsl:text>30</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>28</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="get_title">
		<xsl:param name="title"/>
		<xsl:choose>
			<xsl:when test="$title = 'MR'">
				<xsl:text>Mr</xsl:text>
			</xsl:when>
			<xsl:when test="$title = 'MRS'">
				<xsl:text>Mrs</xsl:text>
			</xsl:when>
			<xsl:when test="$title = 'MISS'">
				<xsl:text>Miss</xsl:text>
			</xsl:when>
			<xsl:when test="$title = 'MS'">
				<xsl:text>Ms</xsl:text>
			</xsl:when>
			<xsl:when test="$title = 'DR'">
				<xsl:text>Dr</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- FREQUENCY -->
	<xsl:variable name="frequency">
		<xsl:choose>
			<xsl:when test="/health/payment/details/frequency = 'A'">Yearly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'H'">HalfYearly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'Q'">Quarterly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'M'">Monthly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'F'">Fortnightly</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="familyType">
		<xsl:choose>
			<xsl:when test="/health/situation/healthCvr = 'S'">S</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'C'">C</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'SPF'">U</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'F'">F</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
		<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:web="http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0" xmlns:v1="http://bupa.com.au/xsd/Facade/ctm/v1">
			<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
				<wsa:Action>http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0/IWebFacadeCtmService/EnrolNewMembershipCtm</wsa:Action>
			</soap:Header>
			<soap:Body>
				<web:EnrolNewMembershipCtm>
					<!--Optional: -->
					<web:request>
						<v1:ChannelDetails>
							<v1:ReferenceId><xsl:value-of select="$transactionId" /></v1:ReferenceId>
							<v1:SalesChannel>Call Centre</v1:SalesChannel>
						</v1:ChannelDetails>
						<v1:Contributor>
							<v1:Title>
								<xsl:call-template name="get_title">
									<xsl:with-param name="title" select="application/primary/title" />
								</xsl:call-template>
							</v1:Title>
							<v1:FirstName><xsl:value-of select="application/primary/firstname" /></v1:FirstName>
							<v1:MiddleName><xsl:value-of select="application/primary/middleName" /></v1:MiddleName>
							<v1:Surname><xsl:value-of select="application/primary/surname" /></v1:Surname>
							<v1:Gender><xsl:value-of select="application/primary/gender" /></v1:Gender>
							<v1:DateOfBirth>
								<xsl:call-template name="format_date">
											<xsl:with-param name="eurDate" select="application/primary/dob" />
								</xsl:call-template>T00:00:00.000+00:00</v1:DateOfBirth>
						</v1:Contributor>
						<v1:ContributorPreviousFundDetails>
							<v1:FundName>
								<xsl:call-template name="get_fund">
									<xsl:with-param name="fundCode" select="previousfund/primary/fundName" />
								</xsl:call-template>
							</v1:FundName>
							<v1:ClearanceAuthorityProvided>
								<xsl:choose>
									<xsl:when test="previousfund/primary/authority = 'Y'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</v1:ClearanceAuthorityProvided>
							<v1:CertifiedEntryAge><xsl:value-of select="primaryCAE" /></v1:CertifiedEntryAge>
							<v1:HasContinuousCover>
								<xsl:choose>
									<xsl:when test="healthCover/primary/healthCoverLoading = ''">true</xsl:when>
									<xsl:when test="healthCover/primary/healthCoverLoading = 'Y'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</v1:HasContinuousCover>
						</v1:ContributorPreviousFundDetails>
						<xsl:if test="$familyType !='S' and $familyType !='U'">
						<!--Optional: -->
							<v1:Partner>
								<v1:Title>
									<xsl:call-template name="get_title">
										<xsl:with-param name="title" select="application/partner/title" />
									</xsl:call-template>
								</v1:Title>
								<v1:FirstName><xsl:value-of select="application/partner/firstname" /></v1:FirstName>
								<v1:MiddleName><xsl:value-of select="application/partner/middleName" /></v1:MiddleName>
								<v1:Surname><xsl:value-of select="application/partner/surname" /></v1:Surname>
								<v1:Gender><xsl:value-of select="application/partner/gender" /></v1:Gender>
								<v1:DateOfBirth>
									<xsl:call-template name="format_date">
												<xsl:with-param name="eurDate" select="application/partner/dob" />
									</xsl:call-template>T00:00:00.000+00:00</v1:DateOfBirth>
							</v1:Partner>
							<!--Optional: -->
							<v1:PartnerPreviousFundDetails>
								<v1:FundName>
									<xsl:call-template name="get_fund">
										<xsl:with-param name="fundCode" select="previousfund/partner/fundName" />
									</xsl:call-template>
								</v1:FundName>
								<v1:ClearanceAuthorityProvided>
									<xsl:choose>
										<xsl:when test="previousfund/partner/authority = 'Y'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</v1:ClearanceAuthorityProvided>
								<v1:CertifiedEntryAge><xsl:value-of select="partnerCAE" /></v1:CertifiedEntryAge>
								<v1:HasContinuousCover>
									<xsl:choose>
										<xsl:when test="healthCover/partner/healthCoverLoading = ''">true</xsl:when>
										<xsl:when test="healthCover/partner/healthCoverLoading = 'Y'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</v1:HasContinuousCover>
							</v1:PartnerPreviousFundDetails>
						</xsl:if>
						<xsl:if test="$familyType !='S' and $familyType != 'C'">
							<!--Optional: -->
							<v1:Dependents>
								<!--Zero or more repetitions: -->
								<xsl:for-each select="application/dependants/*[firstName!='']">
									<v1:PersonDetails>
										<v1:Title>
											<xsl:choose>
												<xsl:when test="title = 'MR'">Mr</xsl:when>
												<xsl:otherwise>Miss</xsl:otherwise>
											</xsl:choose>
										</v1:Title>
										<v1:FirstName><xsl:value-of select="firstName" /></v1:FirstName>
										<v1:MiddleName><xsl:value-of select="middleName" /></v1:MiddleName>
										<v1:Surname><xsl:value-of select="lastname" /></v1:Surname>
										<v1:Gender>
											<xsl:choose>
												<xsl:when test="title = 'MR'">M</xsl:when>
												<xsl:otherwise>F</xsl:otherwise>
											</xsl:choose>
										</v1:Gender>
										<v1:DateOfBirth>
											<xsl:call-template name="format_date">
														<xsl:with-param name="eurDate" select="dob" />
											</xsl:call-template>T00:00:00.000+00:00</v1:DateOfBirth>
									</v1:PersonDetails>
								</xsl:for-each>
							</v1:Dependents>
						</xsl:if>
						<v1:MedicareDetails>
							<v1:NameOnCard>
								<xsl:value-of select="payment/medicare/firstName" /><xsl:text> </xsl:text>
									<xsl:if test="payment/medicare/middleInitial != ''"><xsl:value-of select="payment/medicare/middleInitial" /><xsl:text> </xsl:text></xsl:if>
								<xsl:value-of select="payment/medicare/surname" />
							</v1:NameOnCard>
							<v1:CardNumber><xsl:value-of select="translate(payment/medicare/number,' ','')" /></v1:CardNumber>
							<xsl:variable name="day">
									<xsl:call-template name="last_day_of_month">
										<xsl:with-param name="month" select="payment/medicare/expiry/cardExpiryMonth" />
									</xsl:call-template>
							</xsl:variable>
							<v1:ExpiryDate>20<xsl:value-of select="payment/medicare/expiry/cardExpiryYear" />-<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" />-<xsl:value-of select="$day" />T00:00:00.000+00:00</v1:ExpiryDate>
							<v1:AllMembersAreUnderMedicare>
								<xsl:choose>
									<xsl:when test="payment/medicare/cover = 'Y'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</v1:AllMembersAreUnderMedicare>
						</v1:MedicareDetails>
						<v1:ResidentialAddress>
							<v1:AddressLine>
								<xsl:text>&lt;![CDATA[</xsl:text>
								<xsl:value-of select="application/address/fullAddressLineOne" />
								<xsl:text>]]&gt;</xsl:text>
							</v1:AddressLine>
							<v1:Postcode><xsl:value-of select="application/address/postCode" /></v1:Postcode>
							<v1:Suburb>
								<xsl:text>&lt;![CDATA[</xsl:text>
								<xsl:value-of select="application/address/suburbName" />
								<xsl:text>]]&gt;</xsl:text>
							</v1:Suburb>
							<v1:State><xsl:value-of select="application/address/state" /></v1:State>
							<v1:Country>AU</v1:Country>
						</v1:ResidentialAddress>
						<xsl:if test="application/postalMatch != 'Y'">
							<!--Optional: -->
							<v1:PostalAddress>
								<v1:AddressLine>
									<xsl:text>&lt;![CDATA[</xsl:text>
									<xsl:value-of select="application/postal/fullAddressLineOne" />
									<xsl:text>]]&gt;</xsl:text>
								</v1:AddressLine>
								<v1:Postcode><xsl:value-of select="application/postal/postCode" /></v1:Postcode>
								<v1:Suburb>
									<xsl:text>&lt;![CDATA[</xsl:text>
									<xsl:value-of select="application/postal/suburbName" />
									<xsl:text>]]&gt;</xsl:text>
								</v1:Suburb>
								<v1:State><xsl:value-of select="application/postal/state" /></v1:State>
								<v1:Country>AU</v1:Country>
							</v1:PostalAddress>
						</xsl:if>
						<v1:Contact>
							<v1:Email><xsl:value-of select="application/email" /></v1:Email>
							<v1:Phone><xsl:value-of select="application/other" /></v1:Phone>
							<v1:Mobile><xsl:value-of select="application/mobile" /></v1:Mobile>
						</v1:Contact>
						<v1:CoverDetails>
							<v1:EffectiveDate>
								<xsl:call-template name="format_date">
											<xsl:with-param name="eurDate" select="payment/details/start" />
								</xsl:call-template>T00:00:00.000+00:00</v1:EffectiveDate>
							<v1:PackageCode><xsl:value-of select="fundData/fundCode" /></v1:PackageCode>
							<v1:PackageDescription><xsl:value-of select="application/productTitle" /></v1:PackageDescription>
							<v1:FamilyType><xsl:value-of select="$familyType" /></v1:FamilyType>
							<v1:Rebate><xsl:value-of select="rebate" /></v1:Rebate>
							<v1:IncomeTier>
								<xsl:choose>
									<xsl:when test="healthCover/rebate='N'">3</xsl:when>
									<xsl:when test="healthCover/income=0">0</xsl:when>
									<xsl:when test="healthCover/income=1">1</xsl:when>
									<xsl:when test="healthCover/income=2">2</xsl:when>
									<xsl:otherwise>3</xsl:otherwise>
								</xsl:choose>
							</v1:IncomeTier>
							<v1:PackageRate><xsl:value-of select="format-number(application/paymentFreq,'######0.00')" /></v1:PackageRate>
							<v1:Frequency><xsl:value-of select="$frequency" /></v1:Frequency>
						</v1:CoverDetails>
						<v1:PaymentDetails>
							<v1:PaymentFrequency><xsl:value-of select="$frequency" /></v1:PaymentFrequency>
							<xsl:choose>
								<xsl:when test="/health/payment/details/type = 'ba'">
									<!--Optional: -->
									<v1:BankAccount>
										<v1:FinancialInstitutionName><xsl:value-of select="payment/bank/name" /></v1:FinancialInstitutionName>
										<v1:AccountName><xsl:value-of select="payment/bank/account" /></v1:AccountName>
										<v1:BSB><xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" /></v1:BSB>
										<v1:AccountNumber><xsl:value-of select="payment/bank/number" /></v1:AccountNumber>
									</v1:BankAccount>
								</xsl:when>
								<xsl:otherwise>
									<!--Optional: -->
									<v1:CreditCard>
										<v1:CardHolderName>
											<xsl:choose>
												<xsl:when test="not(contains(payment/credit/ipp/tokenisation, 'fail,')) and payment/credit/ipp/tokenisation != ''">
													<xsl:value-of select="payment/credit/name" />
												</xsl:when>
												<xsl:otherwise>UNPROCESSED</xsl:otherwise>
											</xsl:choose>
										</v1:CardHolderName>
										<v1:TokenisationRefId>
											<xsl:choose>
												<xsl:when test="not(contains(payment/credit/ipp/tokenisation, 'fail,')) and payment/credit/ipp/tokenisation != ''">
													<xsl:value-of select="payment/credit/ipp/tokenisation" />
												</xsl:when>
												<xsl:otherwise>00000000-0000-0000-0000-000000000000</xsl:otherwise>
											</xsl:choose>
										</v1:TokenisationRefId>
										<v1:MaskedCardNumber>
											<xsl:if test="payment/credit/ipp/tokenisation != 'fail' and payment/credit/ipp/tokenisation != ''">
												<xsl:value-of select="payment/credit/ipp/maskedNumber" />
											</xsl:if>
										</v1:MaskedCardNumber>
										<v1:ExpiryDate>20<xsl:value-of select="payment/credit/expiry/cardExpiryYear" />-<xsl:value-of select="payment/credit/expiry/cardExpiryMonth" />-01T00:00:00.000+00:00</v1:ExpiryDate>
										<v1:CreditCardType>
											<xsl:choose>
												<xsl:when test="payment/credit/type = 'a'">Amex</xsl:when>
												<xsl:when test="payment/credit/type = 'm'">MasterCard</xsl:when>
												<xsl:when test="payment/credit/type = 'v'">Visa</xsl:when>
											</xsl:choose>
										</v1:CreditCardType>
									</v1:CreditCard>
								</xsl:otherwise>
							</xsl:choose>
						</v1:PaymentDetails>
					</web:request>
				</web:EnrolNewMembershipCtm>
			</soap:Body>
		</soap:Envelope>
	</xsl:template>

</xsl:stylesheet>