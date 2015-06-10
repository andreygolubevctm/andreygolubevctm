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

	<xsl:variable name="address" select="/health/application/address" />

	<xsl:variable name="suburbName" select="$address/suburbName" />
	<xsl:variable name="state" select="$address/state" />

	<!-- Street Number -->
	<xsl:variable name="streetNo">
		<xsl:choose>
			<xsl:when test="$address/streetNum != ''">
				<xsl:value-of select="$address/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/application/address/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="postCode">
		<xsl:value-of select="/health/application/address/postCode" />
	</xsl:variable>

	<!-- POSTAL ADDRESS VARIABLES -->
	<xsl:variable name="postalAddress" select="/health/application/postal" />

	<xsl:variable name="postal_streetName">
		<xsl:if test="$postalAddress/fullAddressLineOne != ' '">
			<xsl:value-of select="translate($postalAddress/fullAddressLineOne, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_suburbName">
		<xsl:if test="/health/application/postal/suburbName != ''">
			<xsl:value-of select="translate($postalAddress/suburbName, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_state">
		<xsl:if test="$postalAddress/state != ''">
			<xsl:value-of select="translate($postalAddress/state, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_postCode">
		<xsl:if test="$postalAddress/postCode != ''">
			<xsl:value-of select="$postalAddress/postCode" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="streetNameLower" select="$address/fullAddressLineOne" />

	<!-- Single/Couple/Family/SingleParent/NotSet -->
	<xsl:variable name="situation">
		<xsl:choose>
			<xsl:when test="/health/situation/healthCvr = 'SM'">
				<xsl:text>Single</xsl:text>
			</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'SF'">
				<xsl:text>Single</xsl:text>
			</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'S'">
				<xsl:text>Single</xsl:text>
			</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'F'">
				<xsl:text>Family</xsl:text>
			</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'C'">
				<xsl:text>Couple</xsl:text>
			</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'SPF'">
				<xsl:text>SingleParent</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>NotSet</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

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
			<xsl:otherwise>
				<xsl:text>NotSet</xsl:text>
			</xsl:otherwise>
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

	<!-- FREQUENCY -->
	<xsl:variable name="coverPeriod">
		<xsl:choose>
			<xsl:when test="/health/payment/details/frequency = 'A'">12</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'H'">6</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'Q'">3</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'M'">1</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- PAYMENT METHOD -->
	<xsl:variable name="payment_method">
		<xsl:choose>
			<xsl:when test="/health/payment/details/type = 'cc'">DirectDebitByCreditCardAccount</xsl:when>
			<xsl:when test="/health/payment/details/type = 'ba'">DirectDebitByBankAccount</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- NOMINATED DAY -->
	<xsl:variable name="nominated_date">
		<xsl:choose>
			<xsl:when test="/health/payment/credit/policyDay != ''"><xsl:value-of select="/health/payment/credit/policyDay" /></xsl:when>
			<xsl:when test="/health/payment/bank/policyDay != ''"><xsl:value-of select="/health/payment/bank/policyDay" /></xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="card_type">
		<xsl:param name="cardtype" />
		<xsl:choose>
			<xsl:when test="$cardtype='a'">Amex</xsl:when>
			<xsl:when test="$cardtype='v'">Visa</xsl:when>
			<xsl:when test="$cardtype='m'">MasterCard</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
		<!-- FUND PRODUCT SPECIFIC VALUES -->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://ws.australianunity.com.au/B2B/Broker">
			<soapenv:Header>
			</soapenv:Header>
			<soapenv:Body>

				<ProcessApplication>
					<request>
						<TxnSource>
							<TxnId><xsl:value-of select="$transactionId" /></TxnId>
							<SourceName>CompareTheMarket</SourceName>
						</TxnSource>
						<Timestamp><xsl:value-of select="$today" />T00:00:00Z</Timestamp>
						<Application>
							<Applicant>
								<DateOfBirth>
									<xsl:call-template name="format_date">
										<xsl:with-param name="eurDate" select="application/primary/dob" />
									</xsl:call-template>
									<xsl:text>T00:00:00</xsl:text>
								</DateOfBirth>
								<FirstName><xsl:value-of select="application/primary/firstname" /></FirstName>
								<Gender><xsl:choose><xsl:when test="application/primary/gender = 'M'">Male</xsl:when><xsl:otherwise>Female</xsl:otherwise></xsl:choose></Gender>
								<LastName><xsl:value-of select="application/primary/surname" /></LastName>
								<Salutation>
									<xsl:call-template name="get_title">
										<xsl:with-param name="title" select="application/primary/title" />
									</xsl:call-template>
								</Salutation>
							</Applicant>

							<FamilyType><xsl:value-of select="$situation" /></FamilyType>

						<xsl:variable name="dependants" select="application/dependants" />
						<Dependants>
							<xsl:if test="string-length(application/partner/firstname) &gt; 0">
								<Dependant>
									<DateOfBirth>
										<xsl:call-template name="format_date">
											<xsl:with-param name="eurDate" select="application/partner/dob" />
										</xsl:call-template>
										<xsl:text>T00:00:00</xsl:text>
									</DateOfBirth>
									<FirstName><xsl:value-of select="application/partner/firstname" /></FirstName>
									<Gender><xsl:choose><xsl:when test="application/partner/gender = 'M'">Male</xsl:when><xsl:otherwise>Female</xsl:otherwise></xsl:choose></Gender>
									<LastName><xsl:value-of select="application/partner/surname" /></LastName>
									<Salutation>
										<xsl:call-template name="get_title">
											<xsl:with-param name="title" select="application/partner/title" />
										</xsl:call-template>
									</Salutation>
									<Relationship>Spouse</Relationship>
								</Dependant>
							</xsl:if>

							<!-- Dependants available under Family or Single Parent Family -->
							<xsl:if test="/health/situation/healthCvr = 'F' or /health/situation/healthCvr = 'SPF'">
								<xsl:for-each select="$dependants/*">
									<xsl:variable name="srcElementId"><xsl:value-of select="position()" /></xsl:variable>
									<xsl:variable name="srcElementName">dependant<xsl:value-of select="position()" /></xsl:variable>
									<xsl:variable name="srcElement" select="$dependants/*[name()=$srcElementName]" />

									<xsl:if test="string-length($srcElement/firstName) &gt; 0">
										<Dependant>
											<DateOfBirth>
												<xsl:call-template name="format_date">
													<xsl:with-param name="eurDate" select="$srcElement/dob" />
												</xsl:call-template>
												<xsl:text>T00:00:00</xsl:text>
											</DateOfBirth>
											<FirstName><xsl:value-of select="$srcElement/firstName" /></FirstName>
											<Gender><xsl:choose>
												<xsl:when test="$srcElement/title = 'MR'">Male</xsl:when>
													<xsl:otherwise>Female</xsl:otherwise>
												</xsl:choose>
											</Gender>
											<LastName><xsl:value-of select="$srcElement/lastname" /></LastName>
											<Salutation>
												<xsl:call-template name="get_title">
													<xsl:with-param name="title" select="$srcElement/title" />
												</xsl:call-template>
											</Salutation>
											<Relationship><xsl:choose>
												<xsl:when test="string-length($srcElement/school) = 0">Child</xsl:when>
													<xsl:otherwise>Student</xsl:otherwise>
												</xsl:choose>
											</Relationship>
										</Dependant>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</Dependants>

							<Contact>
								<GenericResidentialAddress>
									<Suburb><xsl:value-of select="$suburbName" /></Suburb>
									<State><xsl:value-of select="$state" /></State>
									<Postcode><xsl:value-of select="$postCode" /></Postcode>
									<Dpid>
										<xsl:choose>
											<xsl:when test="string-length($address/dpId) &gt; 0"><xsl:value-of select="$address/dpId" /></xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</Dpid>
									<Line1><xsl:value-of select="$address/fullAddressLineOne" /></Line1>
									<!-- Line2: not required -->
								</GenericResidentialAddress>

							<xsl:if test="$postal_streetName != ''">
								<GenericPostalAddress>
									<Suburb><xsl:value-of select="$postal_suburbName" /></Suburb>
									<State><xsl:value-of select="$postal_state" /></State>
									<Postcode><xsl:value-of select="$postal_postCode" /></Postcode>
									<Dpid>
										<xsl:choose>
											<xsl:when test="string-length($postalAddress/dpId) &gt; 0"><xsl:value-of select="$postalAddress/dpId" /></xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</Dpid>
									<Line1><xsl:value-of select="$postalAddress/fullAddressLineOne" /></Line1>
								</GenericPostalAddress>
							</xsl:if>
								<UseGenericAddress>true</UseGenericAddress>
								<HasSameAddresses><xsl:choose><xsl:when test="application/postalMatch = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></HasSameAddresses>
								<EmailAddress>
									<xsl:choose>
										<xsl:when test="string-length(application/email) &gt; 0">
											<xsl:value-of select="application/email" />
										</xsl:when>
										<xsl:when test="string-length(contactDetails/email) &gt; 0">
											<xsl:value-of select="contactDetails/email" />
										</xsl:when>
										<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
									</xsl:choose>
								</EmailAddress>
								<xsl:variable name="mobileNumber" select="translate(application/mobile,' ()','')" />
								<xsl:variable name="otherNumber" select="translate(application/other,' ()','')" />

								<xsl:if test="$mobileNumber != '' and substring($mobileNumber,1,2)='04'">
									<MobilePhone><xsl:value-of select="$mobileNumber" /></MobilePhone>
								</xsl:if>
								<xsl:if test="$otherNumber != ''">
									<BHPhone><xsl:value-of select="$otherNumber" /></BHPhone>
								</xsl:if>
								<xsl:if test="$mobileNumber != '' and substring($mobileNumber,1,2)!='04'">
									<AHPhone><xsl:value-of select="$mobileNumber" /></AHPhone>
								</xsl:if>
							</Contact>

							<QuotedPremium>
								<Amount><xsl:value-of select="format-number(application/paymentAmt,'######0.00')" /></Amount>
								<HasDirectDebitDiscount>
								<xsl:choose>
									<xsl:when test="payment/details/type='ba'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
								</HasDirectDebitDiscount>
								<HasLHCLoading>
									<xsl:choose>
										<xsl:when test="loading &gt; 0">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</HasLHCLoading>
								<IncludedGovernmentRebate>
									<xsl:choose>
										<xsl:when test="healthCover/rebate='N'">0</xsl:when>
										<xsl:when test="healthCover/income=0">30</xsl:when>
										<xsl:when test="healthCover/income=1">20</xsl:when>
										<xsl:when test="healthCover/income=2">10</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</IncludedGovernmentRebate>
								<CoverPeriod><xsl:value-of select="$coverPeriod"/></CoverPeriod>
							</QuotedPremium>

							<StartDate><xsl:value-of select="$todays_date" /><xsl:text>T00:00:00</xsl:text></StartDate>

							<!-- <CommunicationPreferences>
								<CommunicationPreference>
									<Content />
									<Channel/>
								</CommunicationPreference>
							</CommunicationPreferences> -->

							<!-- <ReferralDetails></ReferralDetails> -->

							<PaymentOptionFlag>OngoingDirectDebit</PaymentOptionFlag>
							<OngoingPayment>
							<Method><xsl:value-of select="$payment_method"/></Method>
							<PaymentFrequency><xsl:value-of select="$frequency"/></PaymentFrequency>
							<FirstDeductionDate>
								<xsl:choose>
									<xsl:when test="payment/details/type='cc'">
										<xsl:value-of select="payment/credit/policyDay" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="payment/bank/policyDay" />
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>T00:00:00</xsl:text>
							</FirstDeductionDate>
							<Amount><xsl:value-of select="format-number(application/paymentFreq,'######0.00')" /></Amount>

						<xsl:choose>
							<xsl:when test="payment/details/type='ba'">
							<BankAccountDetails>
								<BankName><xsl:value-of select="payment/bank/name" /></BankName>
								<BsbNumber><xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" /></BsbNumber>
								<AccountNumber><xsl:value-of select="translate(payment/bank/number,' ','')" /></AccountNumber>
								<HolderName><xsl:value-of select="payment/bank/account" /></HolderName>
							</BankAccountDetails>
							</xsl:when>
							<xsl:otherwise>
							<CreditCardDetails>
								<HolderName><xsl:value-of select="payment/credit/name" /></HolderName>
								<Number><xsl:value-of select="translate(payment/credit/number,' ','')" /></Number>
								<ExpiryMonth><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" /></ExpiryMonth>
								<ExpiryYear><xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></ExpiryYear>
								<CCVNumber><xsl:value-of select="payment/credit/ccv" /></CCVNumber>
								<CreditCardType>
									<xsl:call-template name="card_type">
										<xsl:with-param name="cardtype" select="payment/credit/type" />
									</xsl:call-template>
								</CreditCardType>
							</CreditCardDetails>
							</xsl:otherwise>
						</xsl:choose>
							</OngoingPayment>
							
						<xsl:variable name="hospitalCode">
						<xsl:choose>
							<xsl:when test="contains(fundData/fundCode, ' &amp; ')">
								<xsl:value-of select="substring-before(fundData/fundCode, ' &amp; ')"/>
							</xsl:when>
							<xsl:when test="string-length(fundData/extrasCoverName) = 0 and string-length(fundData/hospitalCoverName) &gt; 0">
								<xsl:value-of select="normalize-space(fundData/fundCode)"/>
							</xsl:when>
						</xsl:choose>
						</xsl:variable>

						<xsl:variable name="extrasCode">
						<xsl:choose>
							<xsl:when test="contains(fundData/fundCode, ' &amp; ')">
								<xsl:value-of select="substring-after(fundData/fundCode, ' &amp; ')"/>
							</xsl:when>
							<xsl:when test="string-length(fundData/extrasCoverName) &gt; 0 and string-length(fundData/hospitalCoverName) = 0">
								<xsl:value-of select="normalize-space(fundData/fundCode)"/>
							</xsl:when>
						</xsl:choose>
						</xsl:variable>

						<xsl:variable name="combinationCode">
						<xsl:choose>
							<xsl:when test="contains(fundData/fundCode, ' &amp; ')">
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="string-length(fundData/hospitalCoverName) &gt; 0 and string-length(fundData/extrasCoverName) &gt; 0">
									<xsl:value-of select="fundData/fundCode"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						</xsl:variable>

						<xsl:if test="$hospitalCode !=''">
							<HospitalProductCode><xsl:value-of select="$hospitalCode"/></HospitalProductCode>
						</xsl:if>

						<xsl:if test="$extrasCode !=''">
							<ExtrasProductCode><xsl:value-of select="$extrasCode"/></ExtrasProductCode>
						</xsl:if>

						<xsl:if test="$combinationCode !=''">
							<CombinationProductCode><xsl:value-of select="$combinationCode"/></CombinationProductCode>
						</xsl:if>

							<IsTransferedFromOtherFund><xsl:choose><xsl:when test="previousfund/primary/fundName != 'NONE'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></IsTransferedFromOtherFund>
							<IsClaimingGovernmentRebate><xsl:choose><xsl:when test="healthCover/rebate = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></IsClaimingGovernmentRebate>
							<ApplicantHospitalCoverContinuity>
								<xsl:choose>
									<xsl:when test="previousfund/primary/fundName != 'NONE'">Continuous</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</ApplicantHospitalCoverContinuity>
							<SpouseHospitalCoverContinuity>
								<xsl:choose>
								<xsl:when test="previousfund/partner/fundName != 'NONE'">Continuous</xsl:when>
								<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</SpouseHospitalCoverContinuity>
						</Application>
					</request>
				</ProcessApplication>

			</soapenv:Body>
		</soapenv:Envelope>
	</xsl:template>

</xsl:stylesheet>