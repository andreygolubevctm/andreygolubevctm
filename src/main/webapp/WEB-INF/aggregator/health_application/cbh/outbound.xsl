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
			<xsl:when test="$title='MR'">Mr</xsl:when>
			<xsl:when test="$title='MRS'">Mrs</xsl:when>
			<xsl:when test="$title='MISS'">Miss</xsl:when>
			<xsl:when test="$title='MS'">Ms</xsl:when>
			<xsl:when test="$title='DR'">Dr</xsl:when>
			<xsl:otherwise>Not Known</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- ADDRESS VARIABLES -->
	<xsl:variable name="streetName" select="/health/application/address/streetName" />
	<xsl:variable name="suburbName" select="/health/application/address/suburbName" />
	<xsl:variable name="state" select="/health/application/address/state" />

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

	<xsl:variable name="postCode">
		<xsl:value-of select="/health/application/address/postCode" />
	</xsl:variable>

	<!-- POSTAL ADDRESS VARIABLES -->
	<xsl:variable name="postal_streetNameLower">
			<xsl:value-of select="/health/application/postal/streetName"/>
	</xsl:variable>

	<xsl:variable name="postal_streetName">
		<xsl:if test="$postal_streetNameLower != ' '">
			<xsl:value-of select="translate($postal_streetNameLower, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_suburbName">
		<xsl:if test="/health/application/postal/suburbName != ''">
			<xsl:value-of select="translate(/health/application/postal/suburbName, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_state">
		<xsl:if test="/health/application/postal/state != ''">
			<xsl:value-of select="translate(/health/application/postal/state, $LOWERCASE, $UPPERCASE)" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_postCode">
		<xsl:if test="/health/application/postal/postCode != ''">
			<xsl:value-of select="/health/application/postal/postCode" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="postal_streetNo">
		<xsl:choose>
			<xsl:when test="/health/application/postal/streetNum != ''">
				<xsl:value-of select="/health/application/postal/streetNum" />
			</xsl:when>
			<xsl:when test="/health/application/postal/houseNoSel != ''">
				<xsl:value-of select="/health/application/postal/houseNoSel" />
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- Check for PO Box - and format accordingly -->
	<xsl:variable name="checkPOBox" select="translate(/health/application/postal/streetName,'pobx., ','POBX')" />

	<xsl:template name="get_street_name">
		<xsl:param name="address" />
				<xsl:value-of select="$address/fullAddressLineOne" />
	</xsl:template>
	<xsl:variable name="streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/address"/>
		</xsl:call-template>
	</xsl:variable>

	<!-- POSTAL ADDRESS VARIABLES -->
	<xsl:variable name="postalAddress" select="/health/application/postal" />

	<xsl:variable name="postal_streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="$postalAddress"/>
		</xsl:call-template>
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
		<p21ns:membershipApplication xmlns:p21ns="http://networklogic.com.au/p21online/version-1">
			<membershipDetails>
				<xsl:attribute name="staffNumber"></xsl:attribute>
				<xsl:attribute name="spouseAuth">
					<xsl:choose>
						<xsl:when test="application/partner/authority = 'Y'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="spouseCbaGroup">
					<xsl:choose>
						<xsl:when test="application/cbh/partneremployee = 'Y'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="privacyNoContact">N</xsl:attribute>
				<xsl:attribute name="privacySilentNo">N</xsl:attribute>

				<!-- PRIMARY -->
				<dependantDetails>
					<xsl:attribute name="title">
						<xsl:call-template name="title_code">
							<xsl:with-param name="title" select="application/primary/title" />
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="firstName"><xsl:value-of select="substring(application/primary/firstname, 1, 40)" /></xsl:attribute>
					<xsl:attribute name="aliasName"></xsl:attribute>
					<xsl:attribute name="otherName"></xsl:attribute>
					<xsl:attribute name="surname"><xsl:value-of select="substring(application/primary/surname, 1, 40)" /></xsl:attribute>
					<xsl:attribute name="gender"><xsl:value-of select="application/primary/gender" /></xsl:attribute>
					<xsl:attribute name="relationship">1</xsl:attribute>
					<xsl:attribute name="dateOfBirth"><xsl:value-of select="translate(application/primary/dob, '/', '-')" /></xsl:attribute>
					<xsl:attribute name="maidenName"></xsl:attribute>
					<xsl:attribute name="postNominal"></xsl:attribute>
					<xsl:attribute name="personId"></xsl:attribute>
					<xsl:attribute name="benefitTemplate"></xsl:attribute>

					<xsl:if test="string-length(application/other) &gt; 0">
						<contactDetails>
							<xsl:attribute name="contactType">H</xsl:attribute>
							<xsl:attribute name="phoneNumber"><xsl:value-of select="translate(application/other, ' ()', '')" /></xsl:attribute>
						</contactDetails>
					</xsl:if>

					<xsl:if test="string-length(application/mobile) &gt; 0">
						<contactDetails>
							<xsl:attribute name="contactType">M</xsl:attribute>
							<xsl:attribute name="phoneNumber"><xsl:value-of select="translate(application/mobile, ' ()', '')" /></xsl:attribute>
						</contactDetails>
					</xsl:if>

					<contactDetails>
						<xsl:attribute name="contactType">E</xsl:attribute>
						<xsl:attribute name="emailAddress">
							<xsl:choose>
								<xsl:when test="application/email != ''"><xsl:value-of select="substring(application/email, 1, 50)" /></xsl:when>
								<xsl:when test="contactDetails/email != ''"><xsl:value-of select="substring(contactDetails/email, 1, 50)" /></xsl:when>
								<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</contactDetails>

					<addressDetails>
						<xsl:attribute name="addressType">H</xsl:attribute>
						<xsl:attribute name="addressLine1"><xsl:value-of select="substring($streetNameLower, 1, 60)" /></xsl:attribute>
						<xsl:attribute name="addressLine2">
							<xsl:if test="string-length($streetNameLower) &gt; 60"><xsl:value-of select="substring($streetNameLower, 60, 60)" /></xsl:if>
						</xsl:attribute>
						<xsl:attribute name="addressLine3"></xsl:attribute>
						<xsl:attribute name="suburb"><xsl:value-of select="$suburbName" /></xsl:attribute>
						<xsl:attribute name="state"><xsl:value-of select="$state" /></xsl:attribute>
						<xsl:attribute name="postcode"><xsl:value-of select="$postCode" /></xsl:attribute>
					</addressDetails>

					<xsl:choose>
						<xsl:when test="application/postalMatch = 'Y'">
							<addressDetails>
								<xsl:attribute name="addressType">P</xsl:attribute>
								<xsl:attribute name="addressLine1"><xsl:value-of select="substring($streetNameLower, 1, 60)" /></xsl:attribute>
								<xsl:attribute name="addressLine2">
									<xsl:if test="string-length($streetNameLower) &gt; 60"><xsl:value-of select="substring($streetNameLower, 60, 60)" /></xsl:if>
								</xsl:attribute>
								<xsl:attribute name="addressLine3"></xsl:attribute>
								<xsl:attribute name="suburb"><xsl:value-of select="$suburbName" /></xsl:attribute>
								<xsl:attribute name="state"><xsl:value-of select="$state" /></xsl:attribute>
								<xsl:attribute name="postcode"><xsl:value-of select="$postCode" /></xsl:attribute>
							</addressDetails>
						</xsl:when>
						<xsl:otherwise>
							<addressDetails>
								<xsl:attribute name="addressType">P</xsl:attribute>
								<xsl:attribute name="addressLine1"><xsl:value-of select="substring(/health/application/postal/fullAddressLineOne, 1, 60)" /></xsl:attribute>
								<xsl:attribute name="addressLine2">
									<xsl:if test="string-length(/health/application/postal/fullAddressLineOne) &gt; 60"><xsl:value-of select="substring(/health/application/postal/fullAddressLineOne, 60, 60)" /></xsl:if>
								</xsl:attribute>
								<xsl:attribute name="addressLine3"></xsl:attribute>
								<xsl:attribute name="suburb"><xsl:value-of select="$postal_suburbName" /></xsl:attribute>
								<xsl:attribute name="state"><xsl:value-of select="$postal_state" /></xsl:attribute>
								<xsl:attribute name="postcode"><xsl:value-of select="$postal_postCode" /></xsl:attribute>
							</addressDetails>
						</xsl:otherwise>
					</xsl:choose>
				</dependantDetails>

				<!-- PARTNER -->
				<xsl:if test="application/partner/firstname != '' and (situation/healthCvr = 'C' or situation/healthCvr = 'F')">
					<dependantDetails>
						<xsl:attribute name="title">
							<xsl:call-template name="title_code">
								<xsl:with-param name="title" select="application/partner/title" />
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="firstName"><xsl:value-of select="substring(application/partner/firstname, 1, 40)" /></xsl:attribute>
						<xsl:attribute name="otherName"></xsl:attribute>
						<xsl:attribute name="surname"><xsl:value-of select="substring(application/partner/surname, 1, 40)" /></xsl:attribute>
						<xsl:attribute name="gender"><xsl:value-of select="application/partner/gender" /></xsl:attribute>
						<xsl:attribute name="relationship"><xsl:value-of select="application/cbh/partnerrel" /></xsl:attribute>
						<xsl:attribute name="dateOfBirth"><xsl:value-of select="translate(application/partner/dob, '/', '-')" /></xsl:attribute>
						<xsl:attribute name="personId"></xsl:attribute>
						<xsl:attribute name="benefitTemplate"></xsl:attribute>
						<xsl:attribute name="medicareFullname"></xsl:attribute>
						<xsl:attribute name="mediFirstName"></xsl:attribute>
						<xsl:attribute name="mediSurname"></xsl:attribute>
						<xsl:attribute name="sameCard"></xsl:attribute>
						<xsl:attribute name="dependentMedicareNumber"></xsl:attribute>
						<xsl:attribute name="dependentExpiryDate"></xsl:attribute>
						<xsl:attribute name="dependentupi"></xsl:attribute>
					</dependantDetails>
				</xsl:if>

				<!-- DEPENDANTS -->
				<xsl:if test="situation/healthCvr = 'SPF' or situation/healthCvr = 'F'">
					<xsl:for-each select="application/dependants/*[firstName!='']">
						<dependantDetails>
							<xsl:attribute name="title">
								<xsl:call-template name="title_code">
									<xsl:with-param name="title" select="title" />
								</xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="firstName"><xsl:value-of select="substring(firstName, 1, 40)" /></xsl:attribute>
							<xsl:attribute name="otherName"></xsl:attribute>
							<xsl:attribute name="surname"><xsl:value-of select="substring(lastname, 1, 40)" /></xsl:attribute>
							<xsl:attribute name="gender">
								<xsl:choose>
									<xsl:when test="title='MR'">M</xsl:when>
									<xsl:otherwise>F</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="relationship">
								<xsl:choose>
									<xsl:when test="title='MR'">4</xsl:when>
									<xsl:otherwise>5</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="dateOfBirth"><xsl:value-of select="translate(dob, '/', '-')" /></xsl:attribute>
							<xsl:attribute name="personId"></xsl:attribute>
							<xsl:attribute name="benefitTemplate"></xsl:attribute>
							<xsl:attribute name="medicareFullname"></xsl:attribute>
							<xsl:attribute name="mediFirstName"></xsl:attribute>
							<xsl:attribute name="mediSurname"></xsl:attribute>
							<xsl:attribute name="sameCard"></xsl:attribute>
							<xsl:attribute name="dependentMedicareNumber"></xsl:attribute>
							<xsl:attribute name="dependentExpiryDate"></xsl:attribute>
							<xsl:attribute name="dependentupi"></xsl:attribute>

							<studentDeclaration>
								<xsl:attribute name="studentName"><xsl:value-of select="substring(concat(firstName, ' ', lastname), 1, 40)" /></xsl:attribute>
								<xsl:attribute name="institutionName"><xsl:value-of select="substring(school, 1, 40)" /></xsl:attribute>
								<xsl:attribute name="institutionPhone"></xsl:attribute>
							</studentDeclaration>
						</dependantDetails>
					</xsl:for-each>
				</xsl:if>

				<eligibilityGroup>
					<xsl:attribute name="type">
						<xsl:choose>
							<xsl:when test="application/cbh/currentemployee = 'Y'">C</xsl:when>
							<xsl:when test="application/cbh/formeremployee = 'Y'">F</xsl:when>
							<xsl:when test="application/cbh/familymember = 'Y'">D</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="eligibilityText">
						<xsl:choose>
							<xsl:when test="application/cbh/currentemployee = 'Y'">Current Member of the CBA Group</xsl:when>
							<xsl:when test="application/cbh/formeremployee = 'Y'">Former Employee</xsl:when>
							<xsl:when test="application/cbh/familymember = 'Y'">Dependant of Existing Member</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="heardAbout">1400</xsl:attribute>
					<xsl:attribute name="heardAboutText">Compare the Market</xsl:attribute>
					<xsl:attribute name="eligibilityStartDate"></xsl:attribute>
					<xsl:attribute name="dependentEligGrg">
						<xsl:choose>
							<xsl:when test="application/cbh/currentemployee = 'Y'"><xsl:value-of select="application/cbh/currentwork" /></xsl:when>
							<xsl:when test="application/cbh/formeremployee = 'Y'"><xsl:value-of select="application/cbh/formerwork" /></xsl:when>
							<xsl:when test="application/cbh/familymember = 'Y'"><xsl:value-of select="application/cbh/familywork" /></xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="dependentEligEmployee">
						<xsl:choose>
							<xsl:when test="application/cbh/currentemployee = 'Y'"></xsl:when>
							<xsl:when test="application/cbh/formeremployee = 'Y'"></xsl:when>
							<xsl:when test="application/cbh/familymember = 'Y'"><xsl:value-of select="substring(application/cbh/familynumber, 1, 30)" /></xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="dependentEligEmployeeno">
						<xsl:choose>
							<xsl:when test="application/cbh/currentemployee = 'Y'"><xsl:value-of select="substring(application/cbh/currentnumber, 1, 30)" /></xsl:when>
							<xsl:when test="application/cbh/formeremployee = 'Y'"><xsl:value-of select="substring(application/cbh/formernumber, 1, 30)" /></xsl:when>
							<xsl:when test="application/cbh/familymember = 'Y'"><xsl:value-of select="substring(application/cbh/familynumber, 1, 30)" /></xsl:when>
						</xsl:choose>
					</xsl:attribute>
				</eligibilityGroup>

				<salesChannel>
					<xsl:attribute name="promotionCode">214</xsl:attribute>
					<xsl:attribute name="salesChannelId">6</xsl:attribute>
					<xsl:attribute name="saleRep"></xsl:attribute>
					<xsl:attribute name="refOperator"></xsl:attribute>
				</salesChannel>

				<employmentDetails>
					<xsl:attribute name="employmentGroupID"></xsl:attribute>
					<xsl:attribute name="employmentName"></xsl:attribute>
				</employmentDetails>

				<memberServiceOnline>
					<xsl:attribute name="autoRegister">
						<xsl:choose>
							<xsl:when test="application/cbh/register = 'Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="termsConditionsAccept">
						<xsl:choose>
							<xsl:when test="application/cbh/register = 'Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</memberServiceOnline>

				<memberPromotionCode>
					<xsl:attribute name="promotionCode">214</xsl:attribute>
					<xsl:attribute name="promotionCodeStub"><xsl:value-of select="$transactionId" /></xsl:attribute>
				</memberPromotionCode>

				<eligibilityPromotionGroup>
					<xsl:attribute name="type">6</xsl:attribute>
					<xsl:attribute name="relationship"></xsl:attribute>
					<xsl:attribute name="employerId">
						<xsl:choose>
							<xsl:when test="application/cbh/currentemployee = 'Y'"><xsl:value-of select="substring(application/cbh/currentnumber, 1, 20)" /></xsl:when>
							<xsl:when test="application/cbh/formeremployee = 'Y'"><xsl:value-of select="substring(application/cbh/formernumber, 1, 20)" /></xsl:when>
							<xsl:when test="application/cbh/familymember = 'Y'"><xsl:value-of select="substring(application/cbh/familynumber, 1, 20)" /></xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="membershipName"></xsl:attribute>
				</eligibilityPromotionGroup>

				<coverDetails>
					<xsl:attribute name="coverType">
						<xsl:choose>
							<xsl:when test="/health/situation/healthCvr = 'SM'">S</xsl:when>
							<xsl:when test="/health/situation/healthCvr = 'SF'">S</xsl:when>
							<xsl:when test="/health/situation/healthCvr = 'S'">S</xsl:when>
							<xsl:when test="/health/situation/healthCvr = 'F'">F</xsl:when>
							<xsl:when test="/health/situation/healthCvr = 'C'">C</xsl:when>
							<xsl:when test="/health/situation/healthCvr = 'SPF'">P</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="hospitalProduct"><xsl:value-of select="substring(fundData/hospitalCoverName, 1, 60)" /></xsl:attribute>
					<xsl:attribute name="hospitalProductId">
						<xsl:choose>
							<xsl:when test="fundData/hospitalCoverName = 'Comprehensive Hospital'">15</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Comprehensive Hospital 70'">16</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Comprehensive Hospital 100'">17</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Limited Hospital'">18</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Limited Hospital 70'">19</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Limited Hospital 100'">20</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Basic Hospital'">21</xsl:when>
							<xsl:when test="fundData/hospitalCoverName = 'Basic Hospital Excess 500'">35</xsl:when>
							<xsl:when test="starts-with(fundData/hospitalCoverName, 'FlexiSaver')">36</xsl:when><!-- Flexisaver -->
							<xsl:when test="starts-with(fundData/hospitalCoverName, 'Kick')">22</xsl:when><!-- Kickstart -->
							<xsl:when test="starts-with(fundData/hospitalCoverName, 'Step')">26</xsl:when><!-- Stepup -->
							<xsl:when test="fundData/hospitalCoverName = 'CBHS Prestige'">31</xsl:when>
							<xsl:when test="starts-with(fundData/hospitalCoverName, 'CBHS Prestige (')">33</xsl:when><!-- CBHS Prestige (with non-student dependant/s) -->
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="extrasProduct"><xsl:value-of select="substring(fundData/extrasCoverName, 1, 60)" /></xsl:attribute>
					<xsl:attribute name="extrasProductId">
						<xsl:choose>
							<xsl:when test="fundData/extrasCoverName = 'Top Extras'">4</xsl:when>
							<xsl:when test="fundData/extrasCoverName = 'Intermediate Extras'">13</xsl:when>
							<xsl:when test="fundData/extrasCoverName = 'Essential Extras'">14</xsl:when>
							<xsl:when test="starts-with(fundData/extrasCoverName, 'Kick')">23</xsl:when><!-- Kickstart -->
							<xsl:when test="starts-with(fundData/extrasCoverName, 'Step')">27</xsl:when><!-- Stepup -->
							<xsl:when test="fundData/extrasCoverName = 'CBHS Prestige'">32</xsl:when>
							<xsl:when test="starts-with(fundData/extrasCoverName, 'CBHS Prestige (')">34</xsl:when><!-- CBHS Prestige (with non-student dependant/s) -->
							<xsl:when test="starts-with(fundData/hospitalCoverName, 'FlexiSaver')">37</xsl:when><!-- Flexisaver -->
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="coverStartType">3</xsl:attribute>
					<xsl:attribute name="coverFromDate"><xsl:value-of select="payment/details/start" /></xsl:attribute>
					<xsl:attribute name="coverPaymentDate"></xsl:attribute>
				</coverDetails>

				<deductionDetails>
					<xsl:attribute name="deductionType">
						<xsl:choose>
							<xsl:when test="payment/details/type = 'cc'">B</xsl:when><!-- Invoice -->
							<xsl:when test="payment/details/type = 'ba'">D</xsl:when><!-- Direct Debit -->
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="deductionDay"></xsl:attribute>
					<xsl:attribute name="frequency">
						<xsl:choose>
							<xsl:when test="payment/details/frequency = 'F'">Fortnightly</xsl:when>
							<xsl:when test="payment/details/frequency = 'A'">Yearly</xsl:when>
							<xsl:when test="payment/details/frequency = 'H'">Half-yearly</xsl:when>
							<xsl:when test="payment/details/frequency = 'Q'">Quarterly</xsl:when>
							<xsl:when test="payment/details/frequency = 'M'">Monthly</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="deductionBillingGroupId">
						<xsl:choose>
							<xsl:when test="payment/details/frequency = 'F'">8</xsl:when>
							<xsl:when test="payment/details/frequency = 'A'">22</xsl:when>
							<xsl:when test="payment/details/frequency = 'H'">21</xsl:when>
							<xsl:when test="payment/details/frequency = 'Q'">20</xsl:when>
							<xsl:when test="payment/details/frequency = 'M'">16</xsl:when>
						</xsl:choose>
					</xsl:attribute>

					<accountInfo>
						<xsl:choose>
							<xsl:when test="payment/details/type = 'ba'">
								<xsl:attribute name="accountType">B</xsl:attribute>
								<xsl:attribute name="accountBSB"><xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" /></xsl:attribute>
								<xsl:attribute name="accountNumber"><xsl:value-of select="translate(payment/bank/number,' ','')" /></xsl:attribute>
								<xsl:attribute name="accountName"><xsl:value-of select="substring(payment/bank/account, 1, 80)" /></xsl:attribute>
								<xsl:attribute name="accountBankName"><xsl:value-of select="substring(payment/bank/name, 1, 80)" /></xsl:attribute>
								<xsl:attribute name="accountBranch">unknown</xsl:attribute><!-- as per http://itsupport.intranet:8080/browse/HLT-151?focusedCommentId=379428&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-379428 -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="accountType"></xsl:attribute>
								<xsl:attribute name="accountBSB"></xsl:attribute>
								<xsl:attribute name="accountNumber"></xsl:attribute>
								<xsl:attribute name="accountName"></xsl:attribute>
								<xsl:attribute name="accountBankName"></xsl:attribute>
								<xsl:attribute name="accountBranch"></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</accountInfo>
				</deductionDetails>

				<claimBenefitPayment>
					<xsl:attribute name="chequeOnly">
						<xsl:choose>
							<!-- Do you want to supply bank account details for claims to be paid into? -->
							<xsl:when test="payment/details/claims = 'Y'">N</xsl:when>
							<xsl:otherwise>Y</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<accountInfo>
						<xsl:choose>
							<!-- Would you like your claim refunds paid into the same account? -->
							<xsl:when test="payment/details/claims = 'Y' and (payment/bank/claims = 'N' or payment/details/type = 'cc')">
								<xsl:attribute name="accountType">B</xsl:attribute>
								<xsl:attribute name="accountBSB"><xsl:value-of select="format-number(translate(payment/bank/claim/bsb,' -',''),'000000')" /></xsl:attribute>
								<xsl:attribute name="accountNumber"><xsl:value-of select="translate(payment/bank/claim/number,' ','')" /></xsl:attribute>
								<xsl:attribute name="accountName"><xsl:value-of select="substring(payment/bank/claim/account, 1, 80)" /></xsl:attribute>
								<xsl:attribute name="accountBankName"><xsl:value-of select="substring(payment/bank/claim/name, 1, 80)" /></xsl:attribute>
								<xsl:attribute name="accountBranch">unknown</xsl:attribute><!-- as per http://itsupport.intranet:8080/browse/HLT-151?focusedCommentId=379428&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-379428 -->
							</xsl:when>
							<!-- Would you like your claim refunds paid into the same account? -->
							<xsl:when test="payment/details/claims = 'Y' and payment/bank/claims = 'Y' and payment/details/type = 'ba'">
								<xsl:attribute name="accountType">B</xsl:attribute>
								<xsl:attribute name="accountBSB"><xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" /></xsl:attribute>
								<xsl:attribute name="accountNumber"><xsl:value-of select="translate(payment/bank/number,' ','')" /></xsl:attribute>
								<xsl:attribute name="accountName"><xsl:value-of select="substring(payment/bank/account, 1, 80)" /></xsl:attribute>
								<xsl:attribute name="accountBankName"><xsl:value-of select="substring(payment/bank/name, 1, 80)" /></xsl:attribute>
								<xsl:attribute name="accountBranch">unknown</xsl:attribute><!-- as per http://itsupport.intranet:8080/browse/HLT-151?focusedCommentId=379428&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-379428 -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="accountType"></xsl:attribute>
								<xsl:attribute name="accountBSB"></xsl:attribute>
								<xsl:attribute name="accountNumber"></xsl:attribute>
								<xsl:attribute name="accountName"></xsl:attribute>
								<xsl:attribute name="accountBankName"></xsl:attribute>
								<xsl:attribute name="accountBranch"></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</accountInfo>
				</claimBenefitPayment>

				<rebateRegistration>
					<xsl:attribute name="allEligibile">
						<xsl:choose><xsl:when test="healthCover/rebate = 'Y' and payment/medicare/cover = 'Y'">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="savingsProvision">N</xsl:attribute>
					<xsl:attribute name="sendRegistration">N</xsl:attribute>
					<xsl:attribute name="rebateTierId">0</xsl:attribute>
					<xsl:attribute name="savingProvisionType"></xsl:attribute>

					<medicareCardDetails>
						<xsl:choose>
							<xsl:when test="healthCover/rebate = 'Y' and payment/medicare/cover = 'Y'">
								<xsl:attribute name="firstName"><xsl:value-of select="substring(payment/medicare/firstName, 1, 40)" /></xsl:attribute>
								<xsl:attribute name="surname"><xsl:value-of select="substring(payment/medicare/surname, 1, 40)" /></xsl:attribute>
								<xsl:attribute name="upi"></xsl:attribute>
								<xsl:attribute name="medicareNumber"><xsl:value-of select="translate(payment/medicare/number,' ','')" /></xsl:attribute>
								<xsl:attribute name="expiryDate"><xsl:value-of select="format-number(payment/medicare/expiry/cardExpiryMonth, '00')" /><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" /></xsl:attribute>
								<xsl:attribute name="cardcolour"></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="firstName"></xsl:attribute>
								<xsl:attribute name="surname"></xsl:attribute>
								<xsl:attribute name="upi"></xsl:attribute>
								<xsl:attribute name="medicareNumber"></xsl:attribute>
								<xsl:attribute name="expiryDate"></xsl:attribute>
								<xsl:attribute name="cardcolour"></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</medicareCardDetails>
				</rebateRegistration>

				<lhcDetails>
					<xsl:attribute name="hospitalCoverSinceJuly2000">
						<xsl:choose>
							<xsl:when test="healthCover/primary/healthCoverLoading = ''">Y</xsl:when>
							<xsl:when test="healthCover/primary/healthCoverLoading = 'Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="exemptionRequired">N</xsl:attribute>
				</lhcDetails>

				<previousFundDetails>
					<xsl:attribute name="fundName">
						<xsl:call-template name="get-fund-name">
							<xsl:with-param name="fundName" select="previousfund/primary/fundName" />
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="membershipId"><xsl:value-of select="substring(previousfund/primary/memberID, 1, 10)" /></xsl:attribute>
					<xsl:attribute name="requireDetails"></xsl:attribute>
					<xsl:attribute name="previousFundId">
						<xsl:call-template name="get-fund-id">
							<xsl:with-param name="fundName" select="previousfund/primary/fundName" />
						</xsl:call-template>
					</xsl:attribute>
				</previousFundDetails>
			</membershipDetails>
		</p21ns:membershipApplication>
	</xsl:template>

	<!-- List supplied in PDF on job http://itsupport.intranet:8080/browse/HLT-151 -->
	<xsl:template name="get-fund-name">
		<xsl:param name="fundName" />
		<xsl:choose>
			<xsl:when test="$fundName='AHM'">Australian Health Management</xsl:when>
			<xsl:when test="$fundName='AUSTUN'">Australian Unity Health Limited</xsl:when>
			<xsl:when test="$fundName='BUPA'">BUPA</xsl:when>
			<xsl:when test="$fundName='FRANK'">Other</xsl:when>
			<xsl:when test="$fundName='GMHBA'">GMHBA Limited</xsl:when>
			<xsl:when test="$fundName='HBA'">HBA</xsl:when>
			<xsl:when test="$fundName='HBF'">HBF Health Funds Inc</xsl:when>
			<xsl:when test="$fundName='HBFSA'">Health-Partners Incorporated</xsl:when>
			<xsl:when test="$fundName='HCF'">HCF (Hospitals Contribution Fund of Australia Limited)</xsl:when>
			<xsl:when test="$fundName='HHBFL'">Other</xsl:when>
			<xsl:when test="$fundName='MBF'">MBF Australia Ltd</xsl:when>
			<xsl:when test="$fundName='MU'">Manchester Unity Australia Ltd</xsl:when>
			<xsl:when test="$fundName='MEDIBK'">Medibank Private Limited</xsl:when>
			<xsl:when test="$fundName='NIB'">NIB Health Funds Ltd</xsl:when>
			<xsl:when test="$fundName='WDHF'">Westfund Ltd</xsl:when>
			<xsl:when test="$fundName='ACA'">ACA Health Benefits Fund</xsl:when>
			<xsl:when test="$fundName='AMA'">Other</xsl:when>
			<xsl:when test="$fundName='API'">Other</xsl:when>
			<xsl:when test="$fundName='BHP'">Other</xsl:when>
			<xsl:when test="$fundName='CBHS'">CBHS Health Fund Limited</xsl:when>
			<xsl:when test="$fundName='CDH'">Cessnock District Health Benefits Fund</xsl:when>
			<xsl:when test="$fundName='CI'">Other</xsl:when>
			<xsl:when test="$fundName='CPS'">Other</xsl:when>
			<xsl:when test="$fundName='CUA'">Credicare Health Fund Limited</xsl:when>
			<xsl:when test="$fundName='CWH'">Central West Health Cover</xsl:when>
			<xsl:when test="$fundName='DFS'">Other</xsl:when>
			<xsl:when test="$fundName='DHBS'">Defence Health Limited</xsl:when>
			<xsl:when test="$fundName='FI'">Other</xsl:when>
			<xsl:when test="$fundName='GMF'">GMF Health</xsl:when>
			<xsl:when test="$fundName='GU'">Grand United Corporate Health</xsl:when>
			<xsl:when test="$fundName='HCI'">Health Care Insurance Limited</xsl:when>
			<xsl:when test="$fundName='HIF'">Health Insurance Fund of WA</xsl:when>
			<xsl:when test="$fundName='IFHP'">Other</xsl:when>
			<xsl:when test="$fundName='IMAN'">Other</xsl:when>
			<xsl:when test="$fundName='IOOF'">Other</xsl:when>
			<xsl:when test="$fundName='IOR'">Other</xsl:when>
			<xsl:when test="$fundName='LHMC'">Other</xsl:when>
			<xsl:when test="$fundName='LVHHS'">Latrobe Health Services</xsl:when>
			<xsl:when test="$fundName='MC'">Mutual Community</xsl:when>
			<xsl:when test="$fundName='MDHF'">Mildura District Hospital Fund Ltd</xsl:when>
			<xsl:when test="$fundName='NATMUT'">Other</xsl:when>
			<xsl:when test="$fundName='NHBA'">National Health Benefits Australia Pty Ltd (onemedifund)</xsl:when>
			<xsl:when test="$fundName='NHBS'">Navy Health Ltd</xsl:when>
			<xsl:when test="$fundName='NRMA'">MBF Alliances Pty Ltd - NRMA Health Insurance</xsl:when>
			<xsl:when test="$fundName='PWAL'">Phoenix Health Fund Limited</xsl:when>
			<xsl:when test="$fundName='QCH'">Queensland Country Health Ltd</xsl:when>
			<xsl:when test="$fundName='QTUHS'">Teachers Union Health</xsl:when>
			<xsl:when test="$fundName='RBHS'">Reserve Bank Health Society Ltd</xsl:when>
			<xsl:when test="$fundName='RTEHF'">Railway and Transport Health Fund Limited</xsl:when>
			<xsl:when test="$fundName='SAPOL'">Police Health</xsl:when>
			<xsl:when test="$fundName='SGIC'">MBF Alliances Pty Ltd - SGIC Health Insurance</xsl:when>
			<xsl:when test="$fundName='SGIO'">MBF Alliances Pty Ltd - SGIO Health Insurance</xsl:when>
			<xsl:when test="$fundName='SLHI'">St.Lukes Health</xsl:when>
			<xsl:when test="$fundName='TFHS'">Teachers Federation Health Ltd</xsl:when>
			<xsl:when test="$fundName='TFS'">Transport Health Pty Ltd</xsl:when>
			<xsl:when test="$fundName='UAOD'">Druids Health Fund</xsl:when>
			<xsl:when test="$fundName='HEA'">Other</xsl:when>
			<xsl:when test="$fundName='NONE'">Medicare Only</xsl:when>
			<xsl:when test="string-length($fundName) &gt; 0">Other</xsl:when>
			<xsl:otherwise>Medicare Only</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="get-fund-id">
		<xsl:param name="fundName" />
		<xsl:choose>
			<xsl:when test="$fundName='AHM'">20</xsl:when>
			<xsl:when test="$fundName='AUSTUN'">21</xsl:when>
			<xsl:when test="$fundName='BUPA'">53</xsl:when>
			<xsl:when test="$fundName='FRANK'">30</xsl:when>
			<xsl:when test="$fundName='GMHBA'">11</xsl:when>
			<xsl:when test="$fundName='HBA'">4</xsl:when>
			<xsl:when test="$fundName='HBF'">12</xsl:when>
			<xsl:when test="$fundName='HBFSA'">31</xsl:when>
			<xsl:when test="$fundName='HCF'">6</xsl:when>
			<xsl:when test="$fundName='HHBFL'">30</xsl:when>
			<xsl:when test="$fundName='MBF'">9</xsl:when>
			<xsl:when test="$fundName='MU'">10</xsl:when>
			<xsl:when test="$fundName='MEDIBK'">3</xsl:when>
			<xsl:when test="$fundName='NIB'">7</xsl:when>
			<xsl:when test="$fundName='WDHF'">48</xsl:when>
			<xsl:when test="$fundName='ACA'">19</xsl:when>
			<xsl:when test="$fundName='AMA'">30</xsl:when>
			<xsl:when test="$fundName='API'">30</xsl:when>
			<xsl:when test="$fundName='BHP'">30</xsl:when>
			<xsl:when test="$fundName='CBHS'">1</xsl:when>
			<xsl:when test="$fundName='CDH'">23</xsl:when>
			<xsl:when test="$fundName='CI'">30</xsl:when>
			<xsl:when test="$fundName='CPS'">30</xsl:when>
			<xsl:when test="$fundName='CUA'">16</xsl:when>
			<xsl:when test="$fundName='CWH'">22</xsl:when>
			<xsl:when test="$fundName='DFS'">30</xsl:when>
			<xsl:when test="$fundName='DHBS'">14</xsl:when>
			<xsl:when test="$fundName='FI'">30</xsl:when>
			<xsl:when test="$fundName='GMF'">26</xsl:when>
			<xsl:when test="$fundName='GU'">27</xsl:when>
			<xsl:when test="$fundName='HCI'">28</xsl:when>
			<xsl:when test="$fundName='HIF'">29</xsl:when>
			<xsl:when test="$fundName='IFHP'">30</xsl:when>
			<xsl:when test="$fundName='IMAN'">30</xsl:when>
			<xsl:when test="$fundName='IOOF'">30</xsl:when>
			<xsl:when test="$fundName='IOR'">30</xsl:when>
			<xsl:when test="$fundName='LHMC'">30</xsl:when>
			<xsl:when test="$fundName='LVHHS'">32</xsl:when>
			<xsl:when test="$fundName='MC'">5</xsl:when>
			<xsl:when test="$fundName='MDHF'">34</xsl:when>
			<xsl:when test="$fundName='NATMUT'">30</xsl:when>
			<xsl:when test="$fundName='NHBA'">35</xsl:when>
			<xsl:when test="$fundName='NHBS'">36</xsl:when>
			<xsl:when test="$fundName='NRMA'">18</xsl:when>
			<xsl:when test="$fundName='PWAL'">38</xsl:when>
			<xsl:when test="$fundName='QCH'">40</xsl:when>
			<xsl:when test="$fundName='QTUHS'">45</xsl:when>
			<xsl:when test="$fundName='RBHS'">42</xsl:when>
			<xsl:when test="$fundName='RTEHF'">41</xsl:when>
			<xsl:when test="$fundName='SAPOL'">39</xsl:when>
			<xsl:when test="$fundName='SGIC'">13</xsl:when>
			<xsl:when test="$fundName='SGIO'">33</xsl:when>
			<xsl:when test="$fundName='SLHI'">43</xsl:when>
			<xsl:when test="$fundName='TFHS'">44</xsl:when>
			<xsl:when test="$fundName='TFS'">47</xsl:when>
			<xsl:when test="$fundName='UAOD'">25</xsl:when>
			<xsl:when test="$fundName='HEA'">54</xsl:when>
			<xsl:when test="$fundName='NONE'">0</xsl:when>
			<xsl:when test="string-length($fundName) &gt; 0">30</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>