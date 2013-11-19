<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- IMPORTS -->
	<xsl:param name="today" />
	<xsl:param name="transactionId" />

	<xsl:template name="format_date">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" /><xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($month,'00')" /><xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($day,'00')" />
	</xsl:template>

	<xsl:template name="title_code">
		<xsl:param name="title" />
		<xsl:choose>
			<xsl:when test="$title='MR'">Mr</xsl:when>
			<xsl:when test="$title='MRS'">Mrs</xsl:when>
			<xsl:when test="$title='MISS'">Miss</xsl:when>
			<xsl:when test="$title='MS'">Ms</xsl:when>
			<xsl:when test="$title='DR'">Dr</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="card_type">
		<xsl:param name="cardtype" />
		<xsl:choose>
			<xsl:when test="$cardtype='v'">Visa</xsl:when>
			<xsl:when test="$cardtype='m'">MasterCard</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- ADDRESS VARIABLES -->
	<xsl:template name="get_street_name">
		<xsl:param name="address" />

		<xsl:choose>
			<!-- Non-Standard -->
			<xsl:when test="$address/nonStd='Y'">
				<xsl:value-of select="$address/fullAddressLineOne" />
			</xsl:when>

			<!-- Standard Address -->
			<xsl:otherwise>
				<xsl:choose>
				<!-- Smart capture unit and street number -->
				<xsl:when test="$address/unitSel != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitSel, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture unit, Smart capture street number -->
				<xsl:when test="$address/unitShop != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture unit and street number -->
				<xsl:when test="$address/unitShop != '' and $address/streetNum != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/streetNum, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Smart capture street number (only, no unit) -->
				<xsl:when test="$address/houseNoSel != ''">
					<xsl:value-of select="concat($address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture street number (only, no unit) -->
				<xsl:otherwise>
					<xsl:value-of select="concat($address/streetNum, ' ', $address/streetName)" />
				</xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="startDate">
		<xsl:call-template name="format_date">
			<xsl:with-param name="eurDate" select="/health/payment/details/start" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/address"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="streetName" select="translate($streetNameLower, $LOWERCASE, $UPPERCASE)" />
	<xsl:variable name="suburbName" select="translate(/health/application/address/suburbName, $LOWERCASE, $UPPERCASE)" />
	<xsl:variable name="state" select="translate(/health/application/address/state, $LOWERCASE, $UPPERCASE)" />

	<!-- Street Number -->
	<xsl:variable name="streetNo">
		<xsl:choose>
			<xsl:when test="/health/application/address/streetNum != ''">
				<xsl:value-of select="/health/application/address/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/application/address/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


	<!-- POSTAL ADDRESS VARIABLES -->
	<xsl:variable name="postal_streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/postal"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="postalIsSame">
		<xsl:choose>
			<xsl:when test="/health/application/postalMatch = 'Y'">yes</xsl:when>
			<xsl:otherwise>no</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="postal_streetName">
		<xsl:choose>
			<xsl:when test="$postalIsSame='no' and $postal_streetNameLower != ''">
				<xsl:value-of select="translate($postal_streetNameLower, $LOWERCASE, $UPPERCASE)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$streetName" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="postal_suburbName">
		<xsl:choose>
			<xsl:when test="$postalIsSame='no' and /health/application/postal/suburbName != ''">
				<xsl:value-of select="translate(/health/application/postal/suburbName, $LOWERCASE, $UPPERCASE)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$suburbName" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="postal_state">
		<xsl:choose>
			<xsl:when test="$postalIsSame='no' and /health/application/postal/state != ''">
				<xsl:value-of select="translate(/health/application/postal/state, $LOWERCASE, $UPPERCASE)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$state" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="postal_postCode">
		<xsl:choose>
			<xsl:when test="$postalIsSame='no' and /health/application/postal/postCode != ''">
				<xsl:value-of select="/health/application/postal/postCode" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/application/address/postCode" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="postal_streetNo">
		<xsl:choose>
			<xsl:when test="$postalIsSame='no' and /health/application/postal/streetNum != ''">
				<xsl:value-of select="/health/application/postal/streetNum" />
			</xsl:when>
			<xsl:when test="$postalIsSame='no' and /health/application/postal/houseNoSel != ''">
				<xsl:value-of select="/health/application/postal/houseNoSel" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$streetNo"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="email">
		<xsl:choose>
			<xsl:when test="/health/application/email != ''">
				<xsl:value-of select="/health/application/email" />
			</xsl:when>
			<xsl:when test="/health/contactDetails/email != ''">
				<xsl:value-of select="/health/contactDetails/email" />
			</xsl:when>
			<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

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

	<!-- FREQUENCY -->
	<xsl:variable name="frequency">
		<xsl:choose>
			<xsl:when test="/health/payment/details/frequency = 'A'">Yearly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'H'">HalfYearly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'Q'">Quarterly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'M'">Monthly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'F'">Fortnightly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'W'">Weekly</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- PAYMENT METHOD -->
	<xsl:variable name="payment_method">
		<xsl:choose>
			<xsl:when test="/health/payment/details/type = 'cc'">CreditCard</xsl:when>
			<xsl:when test="/health/payment/details/type = 'ba'">Bankaccount</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- Single/Couple/Family/SingleParent/NotSet -->
	<xsl:variable name="situation">
		<xsl:choose>
			<xsl:when test="/health/situation/healthCvr = 'S'">Single</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'F'">Family</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'C'">Couple</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'SPF'">SingleParent</xsl:when>
			<xsl:otherwise>NotSet</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
<xml>
	<transactionId><xsl:value-of select="$transactionId" /></transactionId>
	<FundProductCode><xsl:value-of select="fundData/fundCode" /></FundProductCode>
	<provider>WFD</provider>
	<data>
		<Broker>CTM</Broker>
		<BrokerClientID>WFD</BrokerClientID>
		<FundProductCode><xsl:value-of select="fundData/fundCode" /></FundProductCode>
		<ProductTitle>
			<xsl:choose>
				<xsl:when test="fundData/hospitalCoverName != ''"><xsl:value-of select="fundData/hospitalCoverName" /></xsl:when>
				<xsl:when test="fundData/extrasCoverName != ''"><xsl:value-of select="fundData/extrasCoverName" /></xsl:when>
				<xsl:otherwise>Unknown title</xsl:otherwise>
			</xsl:choose>
		</ProductTitle>
		<SaleCompletedTime></SaleCompletedTime>

		<Title><xsl:value-of select="application/primary/title" /></Title>
		<Surname><xsl:value-of select="application/primary/surname" /></Surname>
		<FirstName><xsl:value-of select="application/primary/firstname" /></FirstName>
		<OtherNames></OtherNames>
		<Gender><xsl:choose><xsl:when test="application/primary/gender = 'F'">F</xsl:when><xsl:otherwise>M</xsl:otherwise></xsl:choose></Gender>
		<DateofBirth>
			<xsl:call-template name="format_date">
				<xsl:with-param name="eurDate" select="application/primary/dob" />
			</xsl:call-template>
		</DateofBirth>
		<xsl:if test="string-length(previousfund/primary/fundName) &gt; 0 and previousfund/primary/fundName != 'NONE'">
			<PreviousFund>
				<xsl:call-template name="get-fund-name">
					<xsl:with-param name="fundName" select="previousfund/primary/fundName" />
				</xsl:call-template>
			</PreviousFund>
			<PreviousFundID><xsl:value-of select="previousfund/primary/memberID" /></PreviousFundID>
		</xsl:if>
		<HomeAddressLine1><xsl:value-of select="$streetName" /></HomeAddressLine1>
		<HomeAddressLine2></HomeAddressLine2>
		<HomeAddressLine3></HomeAddressLine3>
		<HomeSuburb><xsl:value-of select="$suburbName" /></HomeSuburb>
		<HomeState><xsl:value-of select="$state" /></HomeState>
		<HomePostcode><xsl:value-of select="application/address/postCode" /></HomePostcode>

		<PostalAddressLine1 name="Postal AddressLine1"><xsl:value-of select="$postal_streetName" /></PostalAddressLine1>
		<PostalAddressLine2 name="Postal AddressLine2"></PostalAddressLine2>
		<PostalAddressLine3 name="Postal AddressLine3"></PostalAddressLine3>
		<PostalSuburb name="Postal Suburb"><xsl:value-of select="$postal_suburbName" /></PostalSuburb>
		<PostalState name="Postal State"><xsl:value-of select="$postal_state" /></PostalState>
		<PostalPostcode name="Postal Postcode"><xsl:value-of select="$postal_postCode" /></PostalPostcode>

		<HomePh><xsl:value-of select="translate(application/other,' ()','')" /></HomePh>
		<WorkPh></WorkPh>
		<Mobile><xsl:value-of select="translate(application/mobile,' ()','')" /></Mobile>
		<Fax></Fax>
		<Email><xsl:value-of select="$email" /></Email>
		<ConfirmEmailAddress name="Confirm EmailAddress"><xsl:value-of select="$email" /></ConfirmEmailAddress>

		<RebateTier name="Rebate Tier">
			<xsl:if test="healthCover/rebate='Y'">
				<xsl:value-of select="healthCover/income" />
			</xsl:if>
		</RebateTier>
		<OngoingPremium><xsl:value-of select="format-number(application/paymentFreq,'######0.00')" /></OngoingPremium>
		<FirstPaymentAmount><xsl:value-of select="format-number(application/paymentFreq,'######0.00')" /></FirstPaymentAmount>
		<PaymentFrequency name="Payment Frequency"><xsl:value-of select="$frequency" /></PaymentFrequency>
		<PaymentMethod><xsl:value-of select="$payment_method" /></PaymentMethod>
		<PaymentDate name="Payment deduction date">
			<xsl:choose>
				<xsl:when test="payment/details/type='cc'"><xsl:value-of select="payment/credit/policyDay" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="payment/bank/policyDay" /></xsl:otherwise>
			</xsl:choose>
		</PaymentDate>
		<AccountCreditCardNumber name="Account/Credit Card Number">
			<xsl:choose>
				<xsl:when test="payment/details/type='cc'"><xsl:value-of select="translate(payment/credit/number,' ','')" /></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="translate(payment/bank/number,' ','')" />
				</xsl:otherwise>
			</xsl:choose>
		</AccountCreditCardNumber>
		<ConfirmAccountCreditCardNumber name="Confirm Account/Credit Card Number">
			<xsl:choose>
				<xsl:when test="payment/details/type='cc'"><xsl:value-of select="translate(payment/credit/number,' ','')" /></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="translate(payment/bank/number,' ','')" />
				</xsl:otherwise>
			</xsl:choose>
		</ConfirmAccountCreditCardNumber>
		<ExpiryDate name="Expiry Date">
			<xsl:if test="payment/details/type='cc'"><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" />/20<xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></xsl:if>
		</ExpiryDate>
		<AccountNameNameonCard name="Account Name/Name on Card">
			<xsl:choose>
				<xsl:when test="payment/details/type='cc'"><xsl:value-of select="payment/credit/name" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="payment/bank/account" /></xsl:otherwise>
			</xsl:choose>
		</AccountNameNameonCard>
		<ClaimsPaidbyCheque>false</ClaimsPaidbyCheque>
		<DirectCreditAccount name="Direct Credit Account (BSB followed by account no)">
			<xsl:choose>
				<xsl:when test="payment/details/type='cc' or payment/bank/claims!='Y'">
					<xsl:value-of select="format-number(translate(payment/bank/claim/bsb,' -',''),'000000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="translate(payment/bank/claim/number,' ','')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="translate(payment/bank/number,' ','')" />
				</xsl:otherwise>
			</xsl:choose>
		</DirectCreditAccount>
		<ConfirmDirectCreditAccount name="Confirm Direct Credit Account">
			<xsl:choose>
				<xsl:when test="payment/details/type='cc' or payment/bank/claims!='Y'">
					<xsl:value-of select="format-number(translate(payment/bank/claim/bsb,' -',''),'000000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="translate(payment/bank/claim/number,' ','')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="translate(payment/bank/number,' ','')" />
				</xsl:otherwise>
			</xsl:choose>
		</ConfirmDirectCreditAccount>

		<SingleFamily name="Single/Family">
			<xsl:choose>
				<xsl:when test="situation/healthCvr = 'S'">Single</xsl:when>
				<xsl:otherwise>Family</xsl:otherwise>
			</xsl:choose>
		</SingleFamily>
		<Cover><xsl:value-of select="$situation" /></Cover>
		<DateofJoining name="Date of Joining"><xsl:value-of select="$startDate" /></DateofJoining>
		<ClaimingRebate name="Claiming Rebate?"><xsl:choose><xsl:when test="healthCover/rebate = 'Y'">yes</xsl:when><xsl:otherwise>no</xsl:otherwise></xsl:choose></ClaimingRebate>
		<EligibleforMedicare name="Eligible for Medicare Card?">
			<xsl:choose>
				<xsl:when test="payment/medicare/cover = 'Y'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</EligibleforMedicare>
		<Entitled30OR40 name="Entitled30OR40%?">
			<xsl:if test="healthCover/rebate='Y'">
				<xsl:value-of select="healthCover/income" />
			</xsl:if>
		</Entitled30OR40>
		<MedicareCardNo name="Medicare Card No."><xsl:value-of select="translate(payment/medicare/number,' ','')" /></MedicareCardNo>
		<ExpDate name="Exp Date">
			<xsl:if test="payment/medicare/expiry/cardExpiryYear != ''">
				<xsl:text>20</xsl:text><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" />-<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" /><xsl:text>-01</xsl:text>
			</xsl:if>
		</ExpDate>
		<HospitalCoverSince name="Hospital Cover Since 01/07/2000">
			<xsl:choose>
				<xsl:when test="healthCover/primary/healthCoverLoading = ''">yes</xsl:when>
				<xsl:when test="healthCover/primary/healthCoverLoading = 'Y'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</HospitalCoverSince>
		<LHCExemption>
			<xsl:choose>
				<xsl:when test="loading &gt; 0">no</xsl:when>
				<xsl:otherwise>yes</xsl:otherwise>
			</xsl:choose>
		</LHCExemption>

		<xsl:if test="application/partner/firstname != ''">
			<null name="--------" />
			<Relationship1>Partner</Relationship1>
			<Title1><xsl:value-of select="application/partner/title" /></Title1>
			<FirstName1><xsl:value-of select="application/partner/firstname" /></FirstName1>
			<Surname1><xsl:value-of select="application/partner/surname" /></Surname1>
			<DateofBirth1>
				<xsl:call-template name="format_date">
					<xsl:with-param name="eurDate" select="application/partner/dob" />
				</xsl:call-template>
			</DateofBirth1>
			<Gender1><xsl:choose><xsl:when test="application/partner/gender = 'F'">F</xsl:when><xsl:otherwise>M</xsl:otherwise></xsl:choose></Gender1>
			<xsl:if test="string-length(previousfund/partner/fundName) &gt; 0 and previousfund/partner/fundName != 'NONE'">
				<PreviousFund>
					<xsl:call-template name="get-fund-name">
						<xsl:with-param name="fundName" select="previousfund/partner/fundName" />
					</xsl:call-template>
				</PreviousFund>
				<PreviousFundID><xsl:value-of select="previousfund/partner/memberID" /></PreviousFundID>
		</xsl:if>
		</xsl:if>

		<xsl:variable name="start">
			<xsl:choose>
				<xsl:when test="application/partner/firstname != ''">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each select="application/dependants/*[firstName!='']">
			<null name="--------" />
			<Relationship>
				<xsl:attribute name="name">Relationship<xsl:value-of select="position()+$start" /></xsl:attribute>
				<xsl:text>Dependant</xsl:text>
			</Relationship>
			<Title>
				<xsl:attribute name="name">Title<xsl:value-of select="position()+$start" /></xsl:attribute>
				<xsl:value-of select="title" />
			</Title>
			<FirstName>
				<xsl:attribute name="name">First Name<xsl:value-of select="position()+$start" /></xsl:attribute>
				<xsl:value-of select="firstName" />
			</FirstName>
			<Surname>
				<xsl:attribute name="name">Surname<xsl:value-of select="position()+$start" /></xsl:attribute>
				<xsl:value-of select="lastname" />
			</Surname>
			<DateofBirth>
				<xsl:attribute name="name">Date of Birth<xsl:value-of select="position()+$start" /></xsl:attribute>
				<xsl:call-template name="format_date">
					<xsl:with-param name="eurDate" select="dob" />
				</xsl:call-template>
			</DateofBirth>
			<Gender>
				<xsl:attribute name="name">Gender<xsl:value-of select="position()+$start" /></xsl:attribute>
				<xsl:choose>
					<xsl:when test="title='MR'">M</xsl:when>
					<xsl:otherwise>F</xsl:otherwise>
				</xsl:choose>
			</Gender>
		</xsl:for-each>
	</data>
</xml>
	</xsl:template>


	<xsl:template name="get-fund-name">
		<xsl:param name="fundName" />
		<xsl:choose>
			<xsl:when test="$fundName='NONE'">No current health fund</xsl:when>
			<xsl:when test="$fundName='AHM'">(AHM) AUSTRALIAN HEALTH MANAGEMENT</xsl:when>
			<xsl:when test="$fundName='AUSTUN'">AUSTRALIAN UNITY</xsl:when>
			<xsl:when test="$fundName='BUPA'">BUPA AUSTRALIA HEALTH</xsl:when>
			<xsl:when test="$fundName='FRANK'">FRANK HEALTH INSURANCE</xsl:when>
			<xsl:when test="$fundName='GMHBA'">(GMHBA) GEELONG MED &amp; HOS BEN ASSOC</xsl:when>
			<xsl:when test="$fundName='HBA'">(HBA) HOSPITAL BENEFITS ASSOCIATION</xsl:when>
			<xsl:when test="$fundName='HBF'">HBF HEALTH FUNDS INC</xsl:when>
			<xsl:when test="$fundName='HBFSA'">HEALTH PARTNERS</xsl:when>
			<xsl:when test="$fundName='HCF'">(HCF) HOSPITALS CONTRIBUTION FUND</xsl:when>
			<xsl:when test="$fundName='HHBFL'">HEALTHGUARD HEALTH BEN FUND</xsl:when>
			<xsl:when test="$fundName='MBF'">(MBF) MEDICAL BENEFIT FUND</xsl:when>
			<xsl:when test="$fundName='MEDIBK'">MEDIBANK PRIVATE</xsl:when>
			<xsl:when test="$fundName='NIB'">NIB HEALTH FUNDS</xsl:when>
			<xsl:when test="$fundName='WDHF'">WESTFUND</xsl:when>
			<xsl:when test="$fundName='ACA'">ACA HEALTH BENEFITS FUND</xsl:when>
			<xsl:when test="$fundName='AMA'">AMA HEALTH FUND LTD</xsl:when>
			<xsl:when test="$fundName='API'">API HEALTH LINX</xsl:when>
			<xsl:when test="$fundName='BHP'">BROKEN HILL PTY LIMITED</xsl:when>
			<xsl:when test="$fundName='CBHS'">CBHS</xsl:when>
			<xsl:when test="$fundName='CDH'">CESSNOCK DISTRICT HEALTH</xsl:when>
			<xsl:when test="$fundName='CI'">COMMERCIAL INSURER</xsl:when>
			<xsl:when test="$fundName='CPS'">CPS HEALTH BENEFITS SOCIETY</xsl:when>
			<xsl:when test="$fundName='CUA'">CUA HEALTH LIMITED</xsl:when>
			<xsl:when test="$fundName='CWH'">CENTRAL WEST HEALTH</xsl:when>
			<xsl:when test="$fundName='DFS'">DRUIDS FRIENDLY SOCIETY</xsl:when>
			<xsl:when test="$fundName='DHBS'">DEFENCE HEALTH</xsl:when>
			<xsl:when test="$fundName='FI'">FEDERATION INSURANCE</xsl:when>
			<xsl:when test="$fundName='GMF'">GOLDFIELDS MEDICAL FUND</xsl:when>
			<xsl:when test="$fundName='GU'">GRAND UNITED</xsl:when>
			<xsl:when test="$fundName='HEA'">HEALTH.COM.AU</xsl:when>
			<xsl:when test="$fundName='HCI'">HEALTH CARE INSURANCE</xsl:when>
			<xsl:when test="$fundName='HIF'">HIF</xsl:when>
			<xsl:when test="$fundName='IFHP'">INTERNATIONAL FED HEALTH PLANS</xsl:when>
			<xsl:when test="$fundName='IMAN'">IMAN HEALTH CARE</xsl:when>
			<xsl:when test="$fundName='IOOF'">IND ORDER OF ODDFELLOWS</xsl:when>
			<xsl:when test="$fundName='IOR'">INDEPEND ORDER OF RECHABITES</xsl:when>
			<xsl:when test="$fundName='LHMC'">LYSAGHT PEOPLECARE</xsl:when>
			<xsl:when test="$fundName='LVHHS'">LATROBE HEALTH SERVICES</xsl:when>
			<xsl:when test="$fundName='MU'">MANCHESTER UNITY AUSTRALIA</xsl:when>
			<xsl:when test="$fundName='MC'">MUTUAL COMMUNITY</xsl:when>
			<xsl:when test="$fundName='MDHF'">MILDURA DISTRICT HOSPITAL FUND</xsl:when>
			<xsl:when test="$fundName='NATMUT'">NATIONAL MUTUAL HEALTH INS</xsl:when>
			<xsl:when test="$fundName='NHBA'">NATIONAL HEALTH BENEFITS AUST</xsl:when>
			<xsl:when test="$fundName='NHBS'">NAVY HEALTH</xsl:when>
			<xsl:when test="$fundName='NRMA'">NRMA</xsl:when>
			<xsl:when test="$fundName='PWAL'">PHOENIX WELFARE ASSOC LTD</xsl:when>
			<xsl:when test="$fundName='QCH'">QUEENSLAND COUNTRY HEALTH</xsl:when>
			<xsl:when test="$fundName='QTUHS'">TEACHERS UNION HEALTH (QLD)</xsl:when>
			<xsl:when test="$fundName='RBHS'">RESERVE BANK HEALTH SOCIETY</xsl:when>
			<xsl:when test="$fundName='RTEHF'">RAILWAY &amp; TRANSPORT HEALTH FUND</xsl:when>
			<xsl:when test="$fundName='SAPOL'">POLICE HEALTH</xsl:when>
			<xsl:when test="$fundName='SGIC'">SGIC HEALTH</xsl:when>
			<xsl:when test="$fundName='SGIO'">SGIO HEALTH</xsl:when>
			<xsl:when test="$fundName='SLHI'">ST LUKES HEALTH</xsl:when>
			<xsl:when test="$fundName='TFHS'">TEACHERS FEDERATION HEALTH</xsl:when>
			<xsl:when test="$fundName='TFS'">TRANSPORT HEALTH</xsl:when>
			<xsl:when test="$fundName='UAOD'">DRUIDS HEALTH BENEFITS FUND</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>