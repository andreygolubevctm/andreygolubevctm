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

	<xsl:template name="format_date_to_slashes">
		<xsl:param name="date"/>
		<xsl:variable name="year" 		select="substring-before($date,'-')" />
		<xsl:variable name="month-temp" select="substring-after($date,'-')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'-')" />
		<xsl:variable name="day" 		select="substring-after($month-temp,'-')" />
		<xsl:value-of select="format-number($day,'00')" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="format-number($month,'00')" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$year" />
	</xsl:template>

	<xsl:template name="title_code">
		<xsl:param name="title" />
		<xsl:choose>
			<xsl:when test="$title='MR'">1</xsl:when>
			<xsl:when test="$title='MRS'">2</xsl:when>
			<xsl:when test="$title='MISS'">3</xsl:when>
			<xsl:when test="$title='MS'">4</xsl:when>
			<xsl:when test="$title='DR'">6</xsl:when>
			<xsl:otherwise>12</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- If NSW or ACT, and Prod2 has a product that has an hospital component, ask question:-
	Do you hold a current health care card, such as a Concession Card, Health Benefits Card, Pensioner Health Benefits and Transport Concession Card, Pharmaceutical Benefits Concession Card or Social Security card?
	- If answer is 'Yes' customer needs to enter 'CustPensionNo' - char(10)
	- 'CustPensionStartDate' can be defaulted to Effective Date (Join Date)
	- AMB does NOT need to be populated in Prod4 in this instance.

	- If answer is 'No' AMB needs to be populated in Prod4

	- For all other states, AMB is not required at all
	- For NSW and ACT where Prod2 is an Extras Only product, AMB is not required.
					-->
	<xsl:variable name="state" select="/health/situation/state" />
	<xsl:variable name="needsAMB">
		<xsl:choose>
			<xsl:when test="($state = 'NSW' or $state = 'ACT') and string-length(/health/fundData/hospitalCoverName) &gt; 0">
				<xsl:choose>
					<xsl:when test="/health/WeDontHaveAPensionerQuestionYet = 'no'">yes</xsl:when>
					<xsl:otherwise>no</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>no</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- ADDRESS VARIABLES -->
	<xsl:variable name="address" select="/health/application/address" />
	<xsl:variable name="suburbName" select="$address/suburbName" />
	<xsl:variable name="state" select="$address/state" />
	<xsl:variable name="addressLineOne">
		<xsl:if test="$address/fullAddressLineOne != ' '">
			<xsl:value-of select="translate($address/fullAddressLineOne, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postCode">
		<xsl:value-of select="$address/postCode" />
	</xsl:variable>

	<!-- POSTAL ADDRESS VARIABLES -->
	<xsl:variable name="postalAddress" select="/health/application/postal" />

	<xsl:variable name="postalAddressLineOne">
		<xsl:if test="$postalAddress/fullAddressLineOne != ' '">
			<xsl:value-of select="translate($postalAddress/fullAddressLineOne, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_suburbName">
		<xsl:if test="$postalAddress/suburbName != ''">
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

	<!-- NOMINATED DAY -->
	<xsl:variable name="nominated_date">
		<xsl:choose>
			<xsl:when test="/health/payment/credit/policyDay != ''"><xsl:value-of select="/health/payment/credit/policyDay" /></xsl:when>
			<xsl:when test="/health/payment/bank/policyDay != ''"><xsl:value-of select="/health/payment/bank/policyDay" /></xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- PREVIOUS FUNDS -->
	<xsl:variable name="primaryFund">
		<xsl:call-template name="get-fund-name">
			<xsl:with-param name="fundName" select="/health/previousfund/primary/fundName" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="partnerFund">
		<xsl:call-template name="get-fund-name">
			<xsl:with-param name="fundName" select="/health/previousfund/partner/fundName" />
		</xsl:call-template>
	</xsl:variable>



	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
		<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://www.w3.org/2005/08/addressing">
			<s:Header>
				<a:Action s:mustUnderstand="1">http://tempuri.org/IMembershipService/EnrolMember</a:Action>
				<a:To s:mustUnderstand="1">https://webagdev.ahm.com.au/WHICSServices/MembershipService.svc</a:To>
			<!-- 	<a:MessageID>urn:uuid:aaaabbbb-cccc-dddd-eeee-ffffffffffff</a:MessageID>
				<a:ReplyTo>
					<a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
				</a:ReplyTo> -->
			</s:Header>
			<s:Body>
				<EnrolMember xmlns="http://tempuri.org/">
				<wsEnrolMemberRequest xmlns:b="http://schemas.datacontract.org/2004/07/Civica.WHICSServices" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
					<b:RecordSize>0</b:RecordSize>
					<b:WHICSUserIP>202.56.61.2</b:WHICSUserIP><!-- 192.168.12.168 -->

					<!-- Campaign Code -->
					<b:Campaign>9000</b:Campaign>

					<!-- Indicator telling if information is complete (Y/N). Incomplete records can be found via WR26. Data type: A string that represents String (1) -->
					<b:Complete>Y</b:Complete>

					<b:CoverSourceCurr>U60210</b:CoverSourceCurr>

					<!-- Array of Customer -->
					<b:Customers>
						<!-- PRIMARY -->
						<b:Customer>
							<xsl:variable name="hasPreviousFund">
								<xsl:choose>
									<xsl:when test="$primaryFund != 'NONE' and string-length($primaryFund) &gt; 0">Y</xsl:when>
									<xsl:otherwise>N</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- If Previous Fund  and Continuous Cover then = 30, else = NULL -->
							<xsl:if test="$hasPreviousFund = 'Y' and (healthCover/primary/healthCoverLoading = '' or healthCover/primary/healthCoverLoading = 'Y')">
								<b:CustCertifiedAge>30</b:CustCertifiedAge>
							</xsl:if>

							<b:CustDOB><xsl:value-of select="application/primary/dob" /></b:CustDOB>

							<b:CustDateOn><xsl:value-of select="payment/details/start" /></b:CustDateOn>

							<!-- If Previous Fund Exists (CustPrevFundCode) then Enrol = 3, else Enrol = 1 -->
							<b:CustEnrolCode>
								<xsl:choose>
									<xsl:when test="$hasPreviousFund = 'Y'">3</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</b:CustEnrolCode>

							<!-- Gender. Data type: A string that represents String (1). -->
							<b:CustGender><xsl:value-of select="application/primary/gender" /></b:CustGender>

							<!-- Given name. Data type: A string that represents String (24). -->
							<b:CustGivenName><xsl:value-of select="application/primary/firstname" /></b:CustGivenName>

							<b:CustMedicare>
								<xsl:if test="healthCover/rebate = 'Y'"><xsl:value-of select="translate(payment/medicare/number,' ','')" /></xsl:if>
							</b:CustMedicare>
							<b:CustMedicareExpiry>
								<xsl:if test="healthCover/rebate = 'Y'"><xsl:value-of select="format-number(payment/medicare/expiry/cardExpiryMonth, '00')" /><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" /></xsl:if>
							</b:CustMedicareExpiry>

							<!-- E - Email, H - Home Phone, M - Mobile Phone, P - Mail to Postal Address, W - Work Phone -->
							<!-- <b:CustPreferred></b:CustPreferred> -->

							<xsl:if test="$hasPreviousFund = 'Y'">
								<!-- Previous fund cover code. Only available if depedent added through API. Data type: A string that represents String (6). -->
								<b:CustPrevFundCode>
									<xsl:value-of select="$primaryFund" />
								</b:CustPrevFundCode>
								<!-- Previous fund number. Only available if depedent added through API. Data type: A string that represents String (10). -->
								<b:CustPrevFundNo>
									<xsl:variable name="memberID">
										<xsl:value-of select="translate(previousfund/primary/memberID, translate(previousfund/primary/memberID, '0123456789', ''), '')" />
									</xsl:variable>
									<xsl:if test="number($memberID) and string-length($memberID) &lt;= 10"><xsl:value-of select="$memberID" /></xsl:if>
								</b:CustPrevFundNo>
							</xsl:if>

							<!-- 1 - Client, 11 - Dependent Adult, 2 - Partner, 3 - Child, 4 - Student Dependent, 7 - Baby Pending, 9 - Deceased, 92 - Deceased Partner -->
							<b:CustRelationship>1</b:CustRelationship>

							<!-- Surname. Data type: A string that represents String (160). -->
							<b:CustSurname><xsl:value-of select="application/primary/surname" /></b:CustSurname>

							<b:CustTitle>
								<xsl:call-template name="title_code">
									<xsl:with-param name="title" select="application/primary/title" />
								</xsl:call-template>
							</b:CustTitle>
						</b:Customer>

						<!-- PARTNER -->
						<xsl:if test="application/partner/firstname != '' and (situation/healthCvr = 'C' or situation/healthCvr = 'F')">
							<xsl:variable name="hasPreviousFund">
								<xsl:choose>
									<xsl:when test="$partnerFund != 'NONE' and string-length($partnerFund) &gt; 0">Y</xsl:when>
									<xsl:otherwise>N</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<b:Customer>
								<xsl:if test="$hasPreviousFund = 'Y' and (healthCover/partner/healthCoverLoading = '' or healthCover/partner/healthCoverLoading = 'Y')">
									<b:CustCertifiedAge>30</b:CustCertifiedAge>
								</xsl:if>

								<b:CustDOB><xsl:value-of select="application/partner/dob" /></b:CustDOB>

								<b:CustDateOn><xsl:value-of select="payment/details/start" /></b:CustDateOn>

								<b:CustEnrolCode>
									<xsl:choose>
										<xsl:when test="$hasPreviousFund = 'Y'">3</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</b:CustEnrolCode>

								<b:CustGender><xsl:value-of select="application/partner/gender" /></b:CustGender>
								<b:CustGivenName><xsl:value-of select="application/partner/firstname" /></b:CustGivenName>

								<b:CustMedicare>
									<xsl:if test="healthCover/rebate = 'Y'"><xsl:value-of select="translate(payment/medicare/number,' ','')" /></xsl:if>
								</b:CustMedicare>
								<b:CustMedicareExpiry>
									<xsl:if test="healthCover/rebate = 'Y'"><xsl:value-of select="format-number(payment/medicare/expiry/cardExpiryMonth, '00')" /><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" /></xsl:if>
								</b:CustMedicareExpiry>

								<xsl:if test="$hasPreviousFund = 'Y'">
									<b:CustPrevFundCode>
										<xsl:value-of select="$partnerFund" />
									</b:CustPrevFundCode>
									<b:CustPrevFundNo>
										<xsl:variable name="memberID">
											<xsl:value-of select="translate(previousfund/partner/memberID, translate(previousfund/partner/memberID, '0123456789', ''), '')" />
										</xsl:variable>
										<xsl:if test="number($memberID) and string-length($memberID) &lt;= 10"><xsl:value-of select="$memberID" /></xsl:if>
									</b:CustPrevFundNo>
								</xsl:if>

								<!-- 1 - Client, 11 - Dependent Adult, 2 - Partner, 3 - Child, 4 - Student Dependent, 7 - Baby Pending, 9 - Deceased, 92 - Deceased Partner -->
								<b:CustRelationship>2</b:CustRelationship>

								<b:CustSurname><xsl:value-of select="application/partner/surname" /></b:CustSurname>
								<b:CustTitle>
									<xsl:call-template name="title_code">
										<xsl:with-param name="title" select="application/partner/title" />
									</xsl:call-template>
								</b:CustTitle>
							</b:Customer>
						</xsl:if>

						<!-- DEPENDANTS -->
						<xsl:if test="situation/healthCvr = 'SPF' or situation/healthCvr = 'F'">
							<xsl:for-each select="application/dependants/*[firstName!='']">
								<b:Customer>
									<b:CustDOB><xsl:value-of select="dob" /></b:CustDOB>

									<b:CustDateOn><xsl:value-of select="/health/payment/details/start" /></b:CustDateOn>

									<b:CustEducCode>
										<!-- This school list is found in the "A0560038 Data Validation Specification" document -->
										<xsl:if test="school != ''"><xsl:value-of select="school" /></xsl:if>
									</b:CustEducCode>

									<!-- If Previous Fund Exists (CustPrevFundCode) then Enrol = 3, else Enrol = 1 -->
									<b:CustEnrolCode>1</b:CustEnrolCode>

									<b:CustGender>
										<xsl:choose>
											<xsl:when test="title='MR'">M</xsl:when>
											<xsl:otherwise>F</xsl:otherwise>
										</xsl:choose>
									</b:CustGender>
									<b:CustGivenName><xsl:value-of select="firstName" /></b:CustGivenName>

									<!-- 1 - Client, 11 - Dependent Adult, 2 - Partner, 3 - Child, 4 - Student Dependent, 7 - Baby Pending, 9 - Deceased, 92 - Deceased Partner -->
									<b:CustRelationship>
										<xsl:choose>
											<xsl:when test="string-length(school) &gt; 0">4</xsl:when>
											<xsl:otherwise>3</xsl:otherwise>
										</xsl:choose>
									</b:CustRelationship>

									<b:CustSurname><xsl:value-of select="lastname" /></b:CustSurname>
									<b:CustTitle>
										<xsl:call-template name="title_code">
											<xsl:with-param name="title" select="title" />
										</xsl:call-template>
									</b:CustTitle>

									<!-- Student Declaration Date. Data type: A string that represents Date. -->
									<b:CustStudentDate><xsl:value-of select="schoolDate" /></b:CustStudentDate>
									<!-- Student Identification. Data type: A string that represents String (10). -->
									<b:CustStudentId><xsl:value-of select="schoolID" /></b:CustStudentId>
								</b:Customer>
							</xsl:for-each>
						</xsl:if>
					</b:Customers>

					<!-- Return information current at this date. Data type: A string that represents Date -->
					<!-- Date from when the policy starts e.g. 1/12/2012 -->
					<b:DateEff><xsl:value-of select="payment/details/start" /></b:DateEff>

					<!-- Direct debit -->
					<!-- Direct debit account number. Data type: A string that represents String (25) -->
					<!-- Direct debit account name. Data type: A string that represents String (32) -->
					<!-- Direct debit account type. Data type: A string that represents String (1) -->
					<!-- Direct debit BSB number. Data type: A string that represents String (6) -->
					<!-- DirectDRExpire Direct debit card expiry date. Data type: A string that represents mmyy -->
					<!-- Direct Debit BSB Number Description. Data type: A string that represents String (30) -->
					<!-- e.g. Commonwealth Bank -->
					<!-- Direct debit start date. Data type: A string that represents Date -->
					<!-- Date 1st drawing from bank would happen e.g. 1/12/2012 -->
					<xsl:if test="payment/details/type = 'ba'">
						<b:DirectDRAccount><xsl:value-of select="translate(payment/bank/number,' ','')" /></b:DirectDRAccount>
						<b:DirectDRAccountName><xsl:value-of select="payment/bank/account" /></b:DirectDRAccountName>
						<b:DirectDRBSBNo><xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" /></b:DirectDRBSBNo>
						<b:DirectDRInstitution><xsl:value-of select="payment/bank/name" /></b:DirectDRInstitution>
						<b:DirectDRStart>
							<xsl:call-template name="format_date_to_slashes">
								<xsl:with-param name="date" select="payment/bank/policyDay" />
							</xsl:call-template>
						</b:DirectDRStart>
					</xsl:if>
					<xsl:if test="payment/details/type = 'cc'">
						<!-- Tokenised card number that is returned by Westpac gateway -->
						<b:DirectDRAccount><xsl:value-of select="payment/gateway/number" /></b:DirectDRAccount>
						<b:DirectDRAccountName><xsl:value-of select="payment/gateway/name" /></b:DirectDRAccountName>
						<b:DirectDRAcctType>
							<xsl:choose>
								<xsl:when test="payment/gateway/type = 'VISA'">V</xsl:when>
								<xsl:when test="payment/gateway/type = 'MASTERCARD'">M</xsl:when>
							</xsl:choose>
						</b:DirectDRAcctType>
						<!-- mmyy -->
						<b:DirectDRExpire>
							<xsl:value-of select="substring(payment/gateway/expiry, 1, 2)" />
							<xsl:value-of select="substring(payment/gateway/expiry, 6)" />
						</b:DirectDRExpire>
						<!-- dd/mm/yyyy -->
						<b:DirectDRStart>
							<xsl:call-template name="format_date_to_slashes">
								<xsl:with-param name="date" select="payment/credit/policyDay" />
							</xsl:call-template>
						</b:DirectDRStart>
					</xsl:if>
					<xsl:if test="payment/details/claims='Y'">
					<xsl:choose>
							<xsl:when test="payment/details/type='cc' or payment/bank/claims='N' ">
							<b:DirectCRAccount><xsl:value-of select="translate(payment/bank/claim/number,' ','')" /></b:DirectCRAccount>
							<b:DirectCRAccountName><xsl:value-of select="payment/bank/claim/account" /></b:DirectCRAccountName>
							<b:DirectCRBSB><xsl:value-of select="concat(substring(payment/bank/claim/bsb,1,3),'-',substring(payment/bank/claim/bsb,4,3))" /></b:DirectCRBSB>
							<b:DirectCRInstitution><xsl:value-of select="payment/bank/claim/name" /></b:DirectCRInstitution>
						</xsl:when>
						<xsl:otherwise>
							<b:DirectCRAccount><xsl:value-of select="translate(payment/bank/number,' ','')" /></b:DirectCRAccount>
							<b:DirectCRAccountName><xsl:value-of select="payment/bank/account" /></b:DirectCRAccountName>
							<b:DirectCRBSB><xsl:value-of select="concat(substring(payment/bank/bsb,1,3),'-',substring(payment/bank/bsb,4,3))" /></b:DirectCRBSB>
							<b:DirectCRInstitution><xsl:value-of select="payment/bank/name" /></b:DirectCRInstitution>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:if>

					<!-- If rebate is selected = Y -->
					<b:EFGRInd>
						<xsl:choose><xsl:when test="healthCover/rebate = 'Y'">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>
					</b:EFGRInd>

					<!-- Optional. Email address. Data type: A string that represents String (255). -->
					<b:Email>
						<xsl:choose>
							<xsl:when test="application/email != ''">
								<xsl:value-of select="application/email" />
							</xsl:when>
							<xsl:when test="contactDetails/email != ''">
								<xsl:value-of select="contactDetails/email" />
							</xsl:when>
							<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
						</xsl:choose>
					</b:Email>

					<!-- Enrolment Code. Data type: A string that represents Integer (2) -->
					<!-- 1:New member, no previous health fund; 2:Previous Fund, 10:Rejoin Fund -->
					<b:EnrolCode>
						<xsl:choose>
							<xsl:when test="(string-length(previousfund/primary/fundName) &gt; 0 and previousfund/primary/fundName != 'NONE') or (string-length(previousfund/partner/fundName) &gt; 0 and previousfund/partner/fundName != 'NONE')">
								<xsl:choose>
									<xsl:when test="previousfund/primary/fundName = 'AHM' or previousfund/partner/fundName = 'AHM'">10</xsl:when>
									<xsl:otherwise>2</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</b:EnrolCode>

					<!-- Enrolment Source. Data type: A string that represents String (6) -->
					<b:EnrolSource>U60210</b:EnrolSource>

					<!-- Fund identification. Data type: A string that represents Integer (2) -->
					<!-- WX01 – Fund control in Genero -->
					<!-- Defaults to 1 -->
					<b:FundId>1</b:FundId>

					<!-- Income Tier. Data type: A string that represents Integer (2) -->
					<!-- WX42 Rebate Definition in Genero: 0, 1, 2, 3 -->
					<b:IncomeTier><xsl:value-of select="healthCover/income" /></b:IncomeTier>

					<!-- Marketing OptOut Flag. Data type: A string that represents String (1) -->
					<b:MarketingOptOut>Y</b:MarketingOptOut>

					<!-- Payment frequency. Data type: A string that represents Ustring (1) -->
					<!-- W:weekly, F:Fortnightly, M:Monthly, Q:Quarterly, H:Half yearly, Y:Yearly -->
					<b:PayFr>
						<xsl:choose>
							<xsl:when test="payment/details/frequency = 'A'">Y</xsl:when>
							<xsl:otherwise><xsl:value-of select="payment/details/frequency" /></xsl:otherwise>
						</xsl:choose>
					</b:PayFr>
					<!-- Payment method. Data type: A string that represents Ustring (1) -->
					<!-- D:Direct, B:Branch, G:Group -->
					<!-- Defaults to D -->
					<b:PayMh>D</b:PayMh>

					<!-- Mobile phone number. Data type: A string that represents String (15) -->
					<!-- Home telephone. Data type: A string that represents String (15) -->
					<!-- Work telephone. Data type: A string that represents String (15) -->
					<!-- <PhoneWork></PhoneWork> -->
					<b:PhoneHome>
						<xsl:if test="application/other != ''"><xsl:value-of select="translate(application/other, ' ()', '')" /></xsl:if>
					</b:PhoneHome>
					<b:PhoneMobile><xsl:value-of select="translate(application/mobile, ' ()', '')" /></b:PhoneMobile>

					<!-- Postal address country. Data type: A string that represents String (3) -->
					<!-- Postal address line 1. Data type: A string that represents String (40) -->
					<!-- Postal address name. Data type: A string that represents String (60) -->
					<!-- Postal address post code. Data type: A string that represents Integer (6) -->
					<!-- Postal address state. Derived from postcode/suburb. Data type: A string that represents String (3) -->
					<!-- Postal address suburb. Data type: A string that represents String (40) -->
					<xsl:choose>
						<xsl:when test="application/postalMatch = 'Y'">
							<!-- <b:PostCountry></b:PostCountry> -->
							<b:PostLine1><xsl:value-of select="$addressLineOne" /></b:PostLine1>
							<!-- AB:31/10/13 <b:PostDPID><xsl:value-of select="$address/dpId" /></b:PostDPID> -->
							<!-- <b:PostName></b:PostName> -->
							<b:PostPC><xsl:value-of select="$postCode" /></b:PostPC>
							<b:PostState><xsl:value-of select="$state" /></b:PostState>
							<b:PostSuburb><xsl:value-of select="$suburbName" /></b:PostSuburb>
						</xsl:when>
						<xsl:otherwise>
							<!-- <b:PostCountry></b:PostCountry> -->
							<b:PostLine1><xsl:value-of select="$postalAddressLineOne" /></b:PostLine1>
							<!-- AB:31/10/13 <b:PostDPID><xsl:value-of select="$postalAddress/dpId" /></b:PostDPID> -->
							<!-- <b:PostName></b:PostName> -->
							<b:PostPC><xsl:value-of select="$postal_postCode" /></b:PostPC>
							<b:PostState><xsl:value-of select="$postal_state" /></b:PostState>
							<b:PostSuburb><xsl:value-of select="$postal_suburbName" /></b:PostSuburb>
						</xsl:otherwise>
					</xsl:choose>

					<!-- e.g. B52 -->
					<b:Prod2><xsl:value-of select="fundData/fundCode" /></b:Prod2>
					<!-- e.g. AMB -->
					<xsl:if test="$needsAMB = 'yes'">
						<b:Prod4>AMB</b:Prod4>
					</xsl:if>

					<!-- Federal government 30% rebate declaration active. Data type: A string that represents String (1) -->
					<!-- Y/N ... If rebate is selected default Y -->
					<b:Rebate>
						<xsl:choose><xsl:when test="healthCover/rebate = 'Y'">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>
					</b:Rebate>

					<!-- S:Single, F:Family, P:Single Parent, D:Couple, X:Single Parent +18, T:Family +18 -->
					<!-- TODO: HOW TO PERFORM CHECK FOR +18? IS IT WHEN ALL DEPENDANTS ARE 18 OR OLDER? -->
					<b:ScaleCode>
						<xsl:choose>
							<xsl:when test="situation/healthCvr = 'S'">S</xsl:when>
							<xsl:when test="situation/healthCvr = 'F'">F</xsl:when>
							<xsl:when test="situation/healthCvr = 'C'">
								<!-- Condition to avoid error "No Rate record found in database [code F11]" -->
								<xsl:choose>
									<xsl:when test="fundData/hospitalCoverName = 'Lite Cover' or fundData/hospitalCoverName = 'First Step'">D</xsl:when>
									<xsl:when test="fundData/extrasCoverName = 'Lite Cover' or fundData/extrasCoverName = 'First Step'">D</xsl:when>
									<xsl:otherwise>F</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="situation/healthCvr = 'SPF'">P</xsl:when>
						</xsl:choose>
					</b:ScaleCode>

					<!-- Spouse authority. Data type: A string that represents String (1) -->
					<!-- <b:SpouseAuthority></b:SpouseAuthority> -->

					<!-- Street address country. Data type: A string that represents String (3) -->
					<!-- Home address line 1. Data type: A string that represents String (40) -->
					<!-- Home address post code. Data type: A string that represents Integer (6) -->
					<!-- Street address state. Derived from postcode/suburb. Data type: A string that represents String (3) -->
					<!-- Home address suburb. Data type: A string that represents String (40) -->
					<!-- <b:StreetCountry></b:StreetCountry> -->
					<b:StreetLine1><xsl:value-of select="$addressLineOne" /></b:StreetLine1>
					<!-- AB:31/10/13 <b:StreetDPID><xsl:value-of select="$postalAddress/dpId" /></b:StreetDPID> -->
					<b:StreetPC><xsl:value-of select="$postCode" /></b:StreetPC>
					<b:StreetState><xsl:value-of select="$state" /></b:StreetState>
					<b:StreetSuburb><xsl:value-of select="$suburbName" /></b:StreetSuburb>
					<SubFundId>1</SubFundId>
					<RateCode>0</RateCode>
				</wsEnrolMemberRequest>
				</EnrolMember>
			</s:Body>
		</s:Envelope>
	</xsl:template>

	<!-- List supplied by AHM on job http://itsupport.intranet:8080/browse/HLT-107 -->
	<xsl:template name="get-fund-name">
		<xsl:param name="fundName" />
		<xsl:choose>
			<xsl:when test="$fundName='AHM'">AHM</xsl:when>
			<xsl:when test="$fundName='AUSTUN'">AUF</xsl:when>
			<xsl:when test="$fundName='BUPA'">BUPA</xsl:when>
			<xsl:when test="$fundName='FRANK'">FHI</xsl:when>
			<xsl:when test="$fundName='GMHBA'">GMHBA</xsl:when>
			<xsl:when test="$fundName='HBA'">HBA</xsl:when>
			<xsl:when test="$fundName='HBF'">HBF</xsl:when>
			<xsl:when test="$fundName='HBFSA'">HEALTH</xsl:when>
			<xsl:when test="$fundName='HCF'">HCF</xsl:when>
			<xsl:when test="$fundName='HHBFL'">HHB</xsl:when>
			<xsl:when test="$fundName='MBF'">MBF</xsl:when>
			<xsl:when test="$fundName='MEDIBK'">MEDI</xsl:when>
			<xsl:when test="$fundName='NIB'">NIB</xsl:when>
			<xsl:when test="$fundName='WDHF'">WESTF</xsl:when>
			<xsl:when test="$fundName='ACA'">ACA</xsl:when>
			<xsl:when test="$fundName='AMA'">AMA</xsl:when>
			<xsl:when test="$fundName='API'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='BHP'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='CBHS'">CBHS</xsl:when>
			<xsl:when test="$fundName='CDH'">CDH</xsl:when>
			<xsl:when test="$fundName='CI'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='CPS'">CPS</xsl:when>
			<xsl:when test="$fundName='CUA'">C-CARE</xsl:when>
			<xsl:when test="$fundName='CWH'">CWHC</xsl:when>
			<xsl:when test="$fundName='DFS'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='DHBS'">DEFHTH</xsl:when>
			<xsl:when test="$fundName='FI'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='GMF'">GMF</xsl:when>
			<xsl:when test="$fundName='GU'">GUF</xsl:when>
			<xsl:when test="$fundName='HCI'">HCI</xsl:when>
			<xsl:when test="$fundName='HIF'">HIF</xsl:when>
			<xsl:when test="$fundName='HEA'">HLTH</xsl:when>
			<xsl:when test="$fundName='IFHP'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='IMAN'">IMAN</xsl:when>
			<xsl:when test="$fundName='IOOF'">IOOF</xsl:when>
			<xsl:when test="$fundName='IOR'">IOR</xsl:when>
			<xsl:when test="$fundName='LHMC'">LHMC</xsl:when>
			<xsl:when test="$fundName='LVHHS'">LTROBE</xsl:when>
			<xsl:when test="$fundName='MC'">MUTUAL</xsl:when>
			<xsl:when test="$fundName='MDHF'">MDHF</xsl:when>
			<xsl:when test="$fundName='MU'">MUF</xsl:when>
			<xsl:when test="$fundName='NATMUT'">NATMUT</xsl:when>
			<xsl:when test="$fundName='NHBA'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='NHBS'">NAVY</xsl:when>
			<xsl:when test="$fundName='NRMA'">NRMA</xsl:when>
			<xsl:when test="$fundName='PWAL'">PHNX</xsl:when>
			<xsl:when test="$fundName='QCH'">QCH</xsl:when>
			<xsl:when test="$fundName='QTUHS'">TUH</xsl:when>
			<xsl:when test="$fundName='RBHS'">R-BANK</xsl:when>
			<xsl:when test="$fundName='RTEHF'">R &amp; T</xsl:when>
			<xsl:when test="$fundName='SAPOL'">PHF</xsl:when>
			<xsl:when test="$fundName='SGIC'">SGIC</xsl:when>
			<xsl:when test="$fundName='SGIO'">SGIO</xsl:when>
			<xsl:when test="$fundName='SLHI'">LUK</xsl:when>
			<xsl:when test="$fundName='TFHS'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='TFS'">TFS</xsl:when>
			<xsl:when test="$fundName='UAOD'">UNKNWN</xsl:when>
			<xsl:when test="$fundName='NONE'">NONE</xsl:when>
			<xsl:when test="string-length($fundName) &gt; 0">UNKNWN</xsl:when>
			<xsl:otherwise>NONE</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>