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
			<xsl:when test="$cardtype='m'">Mcard</xsl:when>
			<xsl:when test="$cardtype='a'">Amex</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- ADDRESS VARIABLES -->
	<xsl:template name="get_street_name">
		<xsl:param name="address" />
		<xsl:value-of select="$address/fullAddressLineOne" />
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
			<xsl:when test="/health/payment/details/frequency = 'A'">Yrly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'H'">6Mtly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'Q'">Qtly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'M'">Mtly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'F'">Fnght</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'W'">Wkly</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- Single/Couple/Family/SingleParent -->
	<xsl:variable name="situation">
		<xsl:choose>
			<xsl:when test="/health/situation/healthCvr = 'SM'">Sgl</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'SF'">Sgl</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'S'">Sgl</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'F'">Fam</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'C'">Cpl</xsl:when>
			<xsl:when test="/health/situation/healthCvr = 'SPF'">SPFam</xsl:when>
			<xsl:otherwise></xsl:otherwise>
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
<xml>
	<transactionId><xsl:value-of select="$transactionId" /></transactionId>
	<FundProductCode><xsl:value-of select="fundData/fundCode" /></FundProductCode>
	<provider>HIF</provider>
	<data>
		<!-- <Person> -->
			<!-- Primary -->
			<PersonId>0</PersonId>
			<EffDate><xsl:value-of select="$startDate" /></EffDate>
			<Relationship>Membr</Relationship>
			<Title>
				<xsl:call-template name="title_code">
					<xsl:with-param name="title" select="application/primary/title" />
				</xsl:call-template>
			</Title>
			<FirstName><xsl:value-of select="application/primary/firstname" /></FirstName>
			<Surname><xsl:value-of select="application/primary/surname" /></Surname>
			<Gender><xsl:choose><xsl:when test="application/primary/gender = 'F'">F</xsl:when><xsl:otherwise>M</xsl:otherwise></xsl:choose></Gender>
			<Birthdate>
				<xsl:call-template name="format_date">
					<xsl:with-param name="eurDate" select="application/primary/dob" />
				</xsl:call-template>
			</Birthdate>
			<xsl:if test="healthCover/rebate = 'Y'">
				<MediCardNo><xsl:value-of select="translate(payment/medicare/number,' ','')" /></MediCardNo>
				<MediCardExpDate>
					<xsl:if test="payment/medicare/expiry/cardExpiryYear != ''">
						<xsl:text>20</xsl:text><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" />-<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" /><xsl:text>-01</xsl:text>
					</xsl:if>
				</MediCardExpDate>
				<MediCardFirstName><xsl:value-of select="payment/medicare/firstName" /></MediCardFirstName>
				<MediCardSecondName><xsl:value-of select="payment/medicare/middleInitial" /></MediCardSecondName>
				<MediCardSurname><xsl:value-of select="payment/medicare/surname" /></MediCardSurname>
			</xsl:if>
			<EmailAddress><xsl:value-of select="$email" /></EmailAddress>
			<xsl:if test="string-length($primaryFund) &gt; 0 and $primaryFund != 'NONE'">
				<Transferring>true</Transferring>
				<PreviousFund><xsl:value-of select="$primaryFund" /></PreviousFund>
				<PreviousFundMemberNo><xsl:value-of select="previousfund/primary/memberID" /></PreviousFundMemberNo>
				<!-- TODO This is not in the API -->
				<PreviousFundAuthority><xsl:value-of select="previousfund/primary/authority" /></PreviousFundAuthority>
			</xsl:if>
			<IsMember>true</IsMember>
			<JoinDate><xsl:value-of select="$startDate" /></JoinDate>
			<LifetimeHealthCoverLoading>
				<!-- TODO When switching to use the API, this needs to be upgraded -->
				<xsl:value-of select="loading" />
				<!-- TODO remove this -->
				<xsl:text>%</xsl:text>
			</LifetimeHealthCoverLoading>

			<!-- TODO remove this once on API -->
			<null name="--------" />
		<!-- </Person> -->

		<xsl:if test="string-length(application/partner/firstname) &gt; 0">
			<!-- <Person> -->
				<!-- Partner -->
				<PersonId>0</PersonId>
				<EffDate><xsl:value-of select="$startDate" /></EffDate>
				<Relationship>Ptnr</Relationship>
				<Title>
					<xsl:call-template name="title_code">
						<xsl:with-param name="title" select="application/partner/title" />
					</xsl:call-template>
				</Title>
				<FirstName><xsl:value-of select="application/partner/firstname" /></FirstName>
				<Surname><xsl:value-of select="application/partner/surname" /></Surname>
				<Gender><xsl:choose><xsl:when test="application/partner/gender = 'F'">F</xsl:when><xsl:otherwise>M</xsl:otherwise></xsl:choose></Gender>
				<Birthdate>
					<xsl:call-template name="format_date">
						<xsl:with-param name="eurDate" select="application/partner/dob" />
					</xsl:call-template>
				</Birthdate>
				<xsl:if test="string-length($partnerFund) &gt; 0 and $partnerFund != 'NONE'">
					<Transferring>true</Transferring>
					<PreviousFund><xsl:value-of select="$partnerFund" /></PreviousFund>
					<PreviousFundMemberNo><xsl:value-of select="previousfund/partner/memberID" /></PreviousFundMemberNo>
					<!-- TODO This is not in the API -->
					<PreviousFundAuthority><xsl:value-of select="previousfund/partner/authority" /></PreviousFundAuthority>
				</xsl:if>
				<JoinDate><xsl:value-of select="$startDate" /></JoinDate>

				<!-- TODO remove this once on API -->
				<null name="--------" />
			<!-- </Person> -->
		</xsl:if>

		<!-- Dependants -->
		<xsl:variable name="start">
			<xsl:choose>
				<xsl:when test="string-length(application/partner/firstname) &gt; 0">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="application/dependants/*[firstName != '']">
			<!-- <Person> -->
				<PersonId>0</PersonId>
				<EffDate><xsl:value-of select="$startDate" /></EffDate>
				<Relationship>
					<xsl:choose>
						<xsl:when test="title = 'MR'">Son</xsl:when>
						<xsl:otherwise>Dtr</xsl:otherwise>
					</xsl:choose>
				</Relationship>
				<Title>
					<xsl:choose>
						<xsl:when test="title = 'MR'">Mr</xsl:when>
						<xsl:otherwise>Ms</xsl:otherwise>
					</xsl:choose>
				</Title>
				<FirstName><xsl:value-of select="firstName" /></FirstName>
				<Surname><xsl:value-of select="lastname" /></Surname>
				<Gender><xsl:choose><xsl:when test="title='MR'">M</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose></Gender>
				<Birthdate>
					<xsl:call-template name="format_date">
						<xsl:with-param name="eurDate" select="dob" />
					</xsl:call-template>
				</Birthdate>

				<!-- TODO remove this once on API -->
				<null name="--------" />
				<JoinDate><xsl:value-of select="$startDate" /></JoinDate>
			<!-- </Person> -->
		</xsl:for-each>

		<!-- <Contacts> -->
			<!-- <Address> -->
				<AddressCode>H</AddressCode>
				<!-- <Code>H</Code> -->
				<EffDate><xsl:value-of select="$startDate" /></EffDate>
				<!-- <Overseas>false</Overseas> -->
				<Line1><xsl:value-of select="$streetName" /></Line1>
				<Locality><xsl:value-of select="$suburbName" /></Locality>
				<State><xsl:value-of select="$state" /></State>
				<Postcode><xsl:value-of select="application/address/postCode" /></Postcode>
				<xsl:choose>
					<xsl:when test="application/postalMatch = 'Y'">
					</xsl:when>
					<xsl:otherwise>
						<AddressCode>P</AddressCode>
						<EffDate><xsl:value-of select="$startDate" /></EffDate>
						<Overseas>false</Overseas>
						<Line1><xsl:value-of select="$postal_streetName" /></Line1>
						<Locality><xsl:value-of select="$postal_suburbName" /></Locality>
						<State><xsl:value-of select="$postal_state" /></State>
						<Postcode><xsl:value-of select="$postal_postCode" /></Postcode>
					</xsl:otherwise>
				</xsl:choose>
			<!-- </Address> -->

			<!-- <Phone> -->
				<xsl:if test="string-length(application/other) &gt; 0">
					<PhoneCode>H</PhoneCode>
					<!-- <Code>H</Code> -->
					<Number><xsl:value-of select="translate(application/other,' ()','')" /></Number>
				</xsl:if>
				<xsl:if test="string-length(application/mobile) &gt; 0">
					<PhoneCode>M</PhoneCode>
					<!-- <Code>M</Code> -->
					<Number><xsl:value-of select="translate(application/mobile,' ()','')" /></Number>
				</xsl:if>
			<!-- </Phone> -->

			<EmailAddress><xsl:value-of select="$email" /></EmailAddress>
			<CorrMethID name="Correspondence method">Mail</CorrMethID>
			<IsSendEmail>
				<xsl:choose>
					<xsl:when test="application/contactPoint = 'E'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</IsSendEmail>
		<!-- </Contacts> -->

		<xsl:if test="string-length(application/contactPoint) &gt; 0">
			<CommunicationPreference>
				<xsl:choose>
					<xsl:when test="application/contactPoint = 'E'">Email</xsl:when>
					<xsl:when test="application/contactPoint = 'P'">Post</xsl:when>
					<xsl:when test="application/contactPoint = 'S'">SMS</xsl:when>
				</xsl:choose>
			</CommunicationPreference>
		</xsl:if>

		<!-- <Cover> -->
			<EffDate><xsl:value-of select="$startDate" /></EffDate>
			<Class><xsl:value-of select="$situation" /></Class>
			<CoverType>
				<xsl:choose>
					<xsl:when test="string-length(fundData/hospitalCoverName) &gt; 0 and string-length(fundData/extrasCoverName) &gt; 0">C</xsl:when><!-- Combined -->
					<xsl:when test="string-length(fundData/hospitalCoverName) &gt; 0">H</xsl:when><!-- Hospital -->
					<xsl:when test="string-length(fundData/extrasCoverName) &gt; 0">A</xsl:when><!-- Ancillary -->
				</xsl:choose>
			</CoverType>
			<ProductSelection><xsl:value-of select="fundData/fundCode" /></ProductSelection>
			<!-- TODO remove these once on API -->
				<HospitalCoverName><xsl:value-of select="fundData/hospitalCoverName" /></HospitalCoverName>
				<ExtrasCoverName><xsl:value-of select="fundData/extrasCoverName" /></ExtrasCoverName>
			<!--
			<AccountIgnored>false</AccountIgnored>
			Chq = Cheque, D/Cr = Direct Credit
			<BenefitPaymentMethod></BenefitPaymentMethod>
			<CoverRateSelection></CoverRateSelection>
			-->

			<!-- Account is only specified if BenefitPaymentMethod = D/Cr; This is the account that benefits will be paid into. -->
			<xsl:if test="blahblahblah = 'D/Cr'">
				<!-- <Account> -->
					<AccountType>credit</AccountType>
					<!-- Bank = Bank Account, C/U = Credit Union, Cbank = Direct Credit Bank Account, B/Soc = Building Society -->
					<DebitCreditID></DebitCreditID>
					<!-- 7 characters '000-000' -->
					<BSB></BSB>
					<InstitutionName></InstitutionName>
					<AccountNumber></AccountNumber>
					<AccountName></AccountName>
				<!-- </Account> -->
			</xsl:if>
		<!-- </Cover> -->

		<!-- <Contributions> -->
			<DirectDebitContribPayments>true</DirectDebitContribPayments>
			<EffDate><xsl:value-of select="$startDate" /></EffDate>
			<ContribFreq><xsl:value-of select="$frequency" /></ContribFreq>
			<Rebate><xsl:choose><xsl:when test="healthCover/rebate = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></Rebate>
			<xsl:if test="healthCover/rebate = 'Y'">
				<!-- <RebateTier>
					<EffDate><xsl:value-of select="$startDate" /></EffDate> -->
					<Tier name="Rebate Tier"><xsl:value-of select="healthCover/income" /></Tier>
				<!-- </RebateTier> -->
				<PercentageRebate name="%rebate"><xsl:value-of select="rebate" /></PercentageRebate>
			</xsl:if>
			<EligibleMedicare name="Eligible for Medicare?">
				<xsl:choose>
					<xsl:when test="payment/medicare/cover = 'Y'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</EligibleMedicare>

			<!-- <Account> -->
				<DebitCreditID>
					<xsl:call-template name="card_type">
						<xsl:with-param name="cardtype" select="payment/credit/type" />
					</xsl:call-template>
				</DebitCreditID>
				<ExpiryMonth><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" /></ExpiryMonth>
				<ExpiryYear><xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></ExpiryYear>
				<CCV><xsl:value-of select="payment/credit/ccv" /></CCV>
				<AccountNumber><xsl:value-of select="translate(payment/credit/number,' ','')" /></AccountNumber>
				<AccountName><xsl:value-of select="payment/credit/name" /></AccountName>
			<!-- </Account> -->
		<!-- </Contributions> -->

		<!-- <Membership> -->
		<!-- </Membership> -->

		<BrokerID>CTM</BrokerID>
		<Emigrate name="Did any person emigrate?"><xsl:value-of select="application/hif/emigrate" /></Emigrate>
		<Premium><xsl:value-of select="format-number(application/paymentFreq, '######0.00')" /></Premium>
		<Excess><xsl:value-of select="fundData/excess" /></Excess>
	</data>
</xml>
	</xsl:template>



	<xsl:template name="get-fund-name">
		<xsl:param name="fundName" />
		<xsl:choose>
			<xsl:when test="$fundName='AHM'">AHM</xsl:when>
			<xsl:when test="$fundName='AUSTUN'">AU</xsl:when>
			<xsl:when test="$fundName='BUPA'">BUPA</xsl:when>
			<xsl:when test="$fundName='FRANK'">OTH</xsl:when>
			<xsl:when test="$fundName='GMHBA'">GMHBA</xsl:when>
			<xsl:when test="$fundName='HBA'">OTH</xsl:when>
			<xsl:when test="$fundName='HBF'">HBF</xsl:when>
			<xsl:when test="$fundName='HBFSA'">HP</xsl:when>
			<xsl:when test="$fundName='HCF'">HCF</xsl:when>
			<xsl:when test="$fundName='HHBFL'">HHBF</xsl:when>
			<xsl:when test="$fundName='MBF'">MBF</xsl:when>
			<xsl:when test="$fundName='MEDIBK'">MP</xsl:when>
			<xsl:when test="$fundName='NIB'">NIB</xsl:when>
			<xsl:when test="$fundName='WDHF'">WDHF</xsl:when>
			<xsl:when test="$fundName='ACA'">ACA</xsl:when>
			<xsl:when test="$fundName='AMA'">AMA</xsl:when>
			<xsl:when test="$fundName='API'">OTH</xsl:when>
			<xsl:when test="$fundName='BHP'">OTH</xsl:when>
			<xsl:when test="$fundName='CBHS'">CBHS</xsl:when>
			<xsl:when test="$fundName='CDH'">CDH</xsl:when>
			<xsl:when test="$fundName='CI'">OTH</xsl:when>
			<xsl:when test="$fundName='CPS'">OTH</xsl:when>
			<xsl:when test="$fundName='CUA'">CUA</xsl:when>
			<xsl:when test="$fundName='CWH'">OTH</xsl:when>
			<xsl:when test="$fundName='DFS'">OTH</xsl:when>
			<xsl:when test="$fundName='DHBS'">OTH</xsl:when>
			<xsl:when test="$fundName='FI'">OTH</xsl:when>
			<xsl:when test="$fundName='GMF'">GMF</xsl:when>
			<xsl:when test="$fundName='GU'">GU</xsl:when>
			<xsl:when test="$fundName='HEA'">OTH</xsl:when>
			<xsl:when test="$fundName='HCI'">HCI</xsl:when>
			<xsl:when test="$fundName='HIF'">HIF</xsl:when>
			<xsl:when test="$fundName='IFHP'">OTH</xsl:when>
			<xsl:when test="$fundName='IMAN'">OTH</xsl:when>
			<xsl:when test="$fundName='IOOF'">IOOF</xsl:when>
			<xsl:when test="$fundName='IOR'">IOR</xsl:when>
			<xsl:when test="$fundName='LHMC'">LHMC</xsl:when>
			<xsl:when test="$fundName='LVHHS'">LHS</xsl:when>
			<xsl:when test="$fundName='MC'">OTH</xsl:when>
			<xsl:when test="$fundName='MDHF'">MDHF</xsl:when>
			<xsl:when test="$fundName='NATMUT'">OTH</xsl:when>
			<xsl:when test="$fundName='NHBA'">OTH</xsl:when>
			<xsl:when test="$fundName='NHBS'">NAVY</xsl:when>
			<xsl:when test="$fundName='NRMA'">SGIO</xsl:when>
			<xsl:when test="$fundName='PWAL'">PWAL</xsl:when>
			<xsl:when test="$fundName='QCH'">QCH</xsl:when>
			<xsl:when test="$fundName='QTUHS'">QTUHS</xsl:when>
			<xsl:when test="$fundName='RBHS'">RBHS</xsl:when>
			<xsl:when test="$fundName='RTEHF'">RTEFS</xsl:when>
			<xsl:when test="$fundName='SAPOL'">SAPOL</xsl:when>
			<xsl:when test="$fundName='SGIC'">OTH</xsl:when>
			<xsl:when test="$fundName='SGIO'">SGIO</xsl:when>
			<xsl:when test="$fundName='SLHI'">SLMHB</xsl:when>
			<xsl:when test="$fundName='TFHS'">OTH</xsl:when>
			<xsl:when test="$fundName='TFS'">TFS</xsl:when>
			<xsl:when test="$fundName='UAOD'">UAOD</xsl:when>
			<xsl:when test="$fundName='NONE'">NONE</xsl:when>
			<xsl:when test="string-length($fundName) &gt; 0">OTH</xsl:when>
			<xsl:otherwise>NONE</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>