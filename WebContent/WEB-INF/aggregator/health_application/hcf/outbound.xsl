<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">
	
	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- IMPORTS -->
	<xsl:param name="transactionId" />
	<xsl:param name="today" />
	<xsl:param name="keycode" />

	<xsl:include href="utils.xsl"/>

	<!-- UnitType -->
	<xsl:variable name="unitType">
		<xsl:choose>
			<xsl:when test="/health/application/address/unitType = 'CO'">Cottage</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'DU'">Duplex</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'HO'">House</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'L'">Level</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'M'">Maisonette</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'MA'">Marine Berth</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'PE'">Penthouse</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'RE'">Rear</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'RO'">Room</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'SI'">Site</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'SU'">Suite</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'TO'">Townhouse</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'UN'">Unit</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'VI'">Villa</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'WA'">Ward</xsl:when>
			<xsl:when test="/health/application/address/unitType = 'OT'">Other</xsl:when>
			<xsl:otherwise>NONE</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- ADDRESS VARIABLES -->
	<xsl:template name="get_street_name">
		<xsl:param name="address" />
		<xsl:value-of select="$address/fullAddressLineOne" />
	</xsl:template>		
	<xsl:variable name="streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/address"/>
		</xsl:call-template>
	</xsl:variable>
		
	<xsl:variable name="streetName" select="translate($streetNameLower, $LOWERCASE, $UPPERCASE)" />
	<xsl:variable name="suburbName" select="translate(/health/application/address/suburbName, $LOWERCASE, $UPPERCASE)" /> 
	<xsl:variable name="state" select="translate(/health/application/address/state, $LOWERCASE, $UPPERCASE)" />
	
	<xsl:variable name="address">
		<xsl:value-of select="concat($streetName, ' ', $suburbName, ' ', $state, ' ', /health/application/address/postCode)" />
	</xsl:variable>
		
	<xsl:variable name="unitDetails">
		<xsl:choose>
			<xsl:when test="$unitType != 'NONE'">
				<xsl:value-of select="concat($unitType, ' ', /health/application/address/unitSel)" />
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

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

	<xsl:variable name="streetDetails" select="concat($streetNo, ' ', /health/application/address/streetName)" />

	<!-- POSTAL ADDRESS VARIABLES -->
	<xsl:variable name="postal_streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/postal"/>
		</xsl:call-template>
	</xsl:variable>
		
	<xsl:variable name="postal_streetName" select="translate($postal_streetNameLower, $LOWERCASE, $UPPERCASE)" />
	<xsl:variable name="postal_suburbName" select="translate(/health/application/postal/suburbName, $LOWERCASE, $UPPERCASE)" /> 
	<xsl:variable name="postal_state" select="translate(/health/application/postal/state, $LOWERCASE, $UPPERCASE)" />
	
	<xsl:variable name="postal_address">
		<xsl:value-of select="concat($postal_streetName, ' ', $postal_suburbName, ' ', $postal_state, ' ', /health/application/postal/postCode)" />
	</xsl:variable>
		
	<!-- Street Number -->
	<xsl:variable name="postal_streetNo">
		<xsl:choose>
			<xsl:when test="/health/application/postal/streetNum != ''">
				<xsl:value-of select="/health/application/postal/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/application/postal/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="todays_date">
		<xsl:variable name="year"><xsl:value-of select="substring($today,1,4)" /></xsl:variable>
   		<xsl:variable name="month"><xsl:value-of select="substring($today,6,2)" /></xsl:variable>
   		<xsl:variable name="day"><xsl:value-of select="substring($today,9,2)" /></xsl:variable>    	
	    	
		<xsl:value-of select="format-number($day,'00')" />
		<xsl:value-of select="format-number($month,'00')" />		
		<xsl:value-of select="$year" />
	</xsl:variable>


	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
		<!-- FUND PRODUCT SPECIFIC VALUES -->
		<xsl:variable name="excessCode">
			<xsl:choose>
				<xsl:when test="fundData/hospitalCoverName = ''"></xsl:when>
				<xsl:when test="fundData/excess = '$900.00' or fundData/excess = '$900'">H</xsl:when>
				<xsl:when test="fundData/excess = '$450.00' or fundData/excess = '$450'">H</xsl:when>
				<xsl:when test="fundData/excess = '$500.00' or fundData/excess = '$500'">G</xsl:when>
				<xsl:when test="fundData/excess = '$250.00' or fundData/excess = '$250'">G</xsl:when>
				<xsl:when test="fundData/excess = '$300.00' or fundData/excess = '$300'">F</xsl:when>
				<xsl:when test="fundData/excess = '$150.00' or fundData/excess = '$150'">F</xsl:when>
				<xsl:when test="fundData/excess = '$0.00' or fundData/excess = '$0'">A</xsl:when>
				<xsl:otherwise>ERROR: Unable to determine Excess Code</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
	
		<xsl:variable name="extrasCover">
			<xsl:choose>
				<xsl:when test="starts-with(fundData/extrasCoverName, 'Fit ')">FitFree</xsl:when>
				<xsl:when test="starts-with(fundData/extrasCoverName, 'General Extras Plus')">generalplus</xsl:when>
				<xsl:when test="starts-with(fundData/extrasCoverName, 'Multicover')">multicover</xsl:when>
				<xsl:when test="starts-with(fundData/extrasCoverName, 'Super Multicover')">supermulticover</xsl:when>
				<xsl:when test="starts-with(fundData/extrasCoverName, 'Young Singles')">YoungSingleCouple</xsl:when>
				<xsl:when test="fundData/extrasCoverName = ''">none</xsl:when>
				<xsl:otherwise>ERROR: Unable to determine Extras Cover</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:variable name="hospitalCover">
			<xsl:choose>
				<xsl:when test="starts-with(fundData/hospitalCoverName, 'Fit ')">FitFree</xsl:when>
				<xsl:when test="starts-with(fundData/hospitalCoverName, 'Young Singles')">YoungSingleCouple</xsl:when>
				<xsl:when test="starts-with(fundData/hospitalCoverName, 'Hospital Advanced Savings')">AdvSavings</xsl:when>
				<xsl:when test="starts-with(fundData/hospitalCoverName, 'Advanced Savings')">AdvSavings</xsl:when>
				<xsl:when test="starts-with(fundData/hospitalCoverName, 'Top Plus Cover')">TopPlus</xsl:when>
				<xsl:when test="starts-with(fundData/hospitalCoverName, 'Budget Hospital')">BudgetHosp</xsl:when>
				<xsl:when test="fundData/hospitalCoverName = ''">none</xsl:when>		
				<xsl:otherwise>ERROR: Unable to determine Hospital Cover</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="healthCvr" select="situation/healthCvr" />

		<GetHCFSaleInfo>
			<GetAppInfo>
				<NumTransmissions />
				<ErrorCount />
			</GetAppInfo>
			<GetAgentDetails>
				<AgentId>R20903</AgentId>
				<DealCode>CTM</DealCode>
				<Password><xsl:value-of select="$keycode" /></Password>
				<AgentCustomerId>
					<xsl:value-of select="$transactionId" />
				</AgentCustomerId>
				<AgentPaymentId>
					<xsl:value-of select="$transactionId" />
				</AgentPaymentId>
			</GetAgentDetails>
			<GetHCFGeneratedInfo>
				<CovernoteMemberNumber />
			</GetHCFGeneratedInfo>
			<GetClientDetails>
				<Title>
					<xsl:call-template name="title_code">
						<xsl:with-param name="title" select="application/primary/title" />
					</xsl:call-template>
				</Title>
				<GivenName><xsl:value-of select="application/primary/firstname" /></GivenName>
				<Surname><xsl:value-of select="application/primary/surname" /></Surname>
				<DOB>
					<xsl:call-template name="format_date">
						<xsl:with-param name="eurDate" select="application/primary/dob" />
					</xsl:call-template>
				</DOB>
				<Gender><xsl:value-of select="application/primary/gender" /></Gender>
				<xsl:choose>
					<xsl:when test="$unitDetails != ''">
						<Address1><xsl:value-of select="$unitDetails" /></Address1>
						<Address2><xsl:value-of select="$streetDetails" /></Address2>
					</xsl:when>
					<xsl:when test="string-length($streetNameLower) > 26">
						<xsl:variable name="Address1Sub" select="substring($streetNameLower,0,26)" ></xsl:variable>
						<xsl:variable name="Address2Sub" select="substring($streetNameLower,26,string-length($streetNameLower))" ></xsl:variable>
						<Address1>
							<xsl:choose>
								<xsl:when test="contains($Address1Sub,' ')">
									<xsl:variable name="Address1End">
										<xsl:call-template name="get-before-last-space">
										<xsl:with-param name="input" select="substring-after($Address1Sub,' ')"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="concat(substring-before($Address1Sub,' '), $Address1End)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$Address1Sub" />
								</xsl:otherwise>
							</xsl:choose>
						</Address1>
						<Address2>
							<xsl:variable name="Address2Begin">
								<xsl:call-template name="get-after-last-space">
									<xsl:with-param name="input" select="$Address1Sub"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="concat($Address2Begin, $Address2Sub)" />
						</Address2>
					</xsl:when>
					<xsl:otherwise>
				<Address1><xsl:value-of select="$streetNameLower" /></Address1>
				<Address2></Address2>
					</xsl:otherwise>
				</xsl:choose>
				<Suburb><xsl:value-of select="$suburbName" /></Suburb>
				<State><xsl:value-of select="$state" /></State>
				<PostCode><xsl:value-of select="application/address/postCode" /></PostCode>
				
				<PostalSameResidenceInd>
					<xsl:choose>
						<xsl:when test="application/postalMatch = 'Y'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</PostalSameResidenceInd>
				<xsl:if test="not(application/postalMatch) or application/postalMatch != 'Y'">
					<xsl:choose>
						<xsl:when test="string-length($postal_streetNameLower) > 26">
						<xsl:variable name="Address1Sub" select="substring($postal_streetNameLower,1,26)" ></xsl:variable>
						<xsl:variable name="Address2Sub" select="substring($postal_streetNameLower,26,string-length($postal_streetNameLower))" ></xsl:variable>
							<PostalAddress1>
								<xsl:choose>
									<xsl:when test="contains($Address1Sub,' ')">
										<xsl:variable name="Address1End">
											<xsl:call-template name="get-before-last-space">
											<xsl:with-param name="input" select="substring-after($Address1Sub,' ')"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="concat(substring-before($Address1Sub,' '), $Address1End)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Address1Sub" />
									</xsl:otherwise>
								</xsl:choose>
							</PostalAddress1>
							<PostalAddress2>
								<xsl:variable name="Address2Begin">
									<xsl:call-template name="get-after-last-space">
										<xsl:with-param name="input" select="$Address1Sub"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="concat($Address2Begin, $Address2Sub)" />
							</PostalAddress2>
						</xsl:when>
						<xsl:otherwise>
					<PostalAddress1><xsl:value-of select="$postal_streetNameLower" /></PostalAddress1>
					<PostalAddress2></PostalAddress2>
						</xsl:otherwise>
					</xsl:choose>
					<PostalSuburb><xsl:value-of select="$postal_suburbName" /></PostalSuburb>
					<PostalState><xsl:value-of select="$postal_state" /></PostalState>
					<PostalPostCode><xsl:value-of select="application/postal/postCode" /></PostalPostCode>
				</xsl:if>
				<HomePhone>
					<xsl:choose>
						<xsl:when test="application/other != ''"><xsl:value-of select="translate(application/other,' ()','')" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="translate(contactDetails/contactNumber/other,' ()','')" /></xsl:otherwise>
					</xsl:choose>
				</HomePhone>
				<WorkPhone></WorkPhone>
				<MobilePhone><xsl:value-of select="translate(application/mobile,' ()','')" /></MobilePhone>
				<EmailAddress>
				<xsl:choose>
					<xsl:when test="application/email != ''">
						<xsl:value-of select="application/email" />
					</xsl:when>
					<xsl:when test="contactDetails/email != ''">
						<xsl:value-of select="contactDetails/email" />
					</xsl:when>    							
					<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
				</xsl:choose>				
				</EmailAddress>
				<MaritalStatus>
					<xsl:choose>
						<xsl:when test="$healthCvr='S'">S</xsl:when>
						<xsl:when test="$healthCvr='C'">F</xsl:when>
						<xsl:when test="$healthCvr='F'">F</xsl:when>
						<xsl:when test="$healthCvr='SPF'">P</xsl:when>
					</xsl:choose>
				</MaritalStatus>
				
				<NumDependants>
					<xsl:choose>
						<!--No dependents if Single or Couple -->
						<xsl:when test="$healthCvr = 'S' or $healthCvr = 'C'">0</xsl:when>
						<!-- Calculate the number of dependents based on the field count -->
						<xsl:otherwise><xsl:value-of select="count(application/dependants/*)" /></xsl:otherwise>
					</xsl:choose>
				</NumDependants>
				
				<DeclareDate><xsl:value-of select="$todays_date" /></DeclareDate>
				
				<RegisterFurtherCommunication>Y</RegisterFurtherCommunication>
				<PEANum>0</PEANum>
			</GetClientDetails>
			<GetPolicyDetails>
				<CommencementDate>
					<xsl:call-template name="format_date">
						<xsl:with-param name="eurDate" select="payment/details/start" />
					</xsl:call-template>				
				</CommencementDate>
				<HospitalCover><xsl:value-of select="$hospitalCover"/></HospitalCover>
				<ExtrasCover><xsl:value-of select="$extrasCover"/></ExtrasCover>
				
				<PreExistingAilments>N</PreExistingAilments>
				<FederalRebate><xsl:value-of select="healthCover/rebate" /></FederalRebate>
				<xsl:choose>
				<xsl:when test="healthCover/rebate='Y'">
					<RebateTier><xsl:value-of select="healthCover/income" /></RebateTier>
					<MedicareNumber><xsl:value-of select="translate(payment/medicare/number,' ','')" /></MedicareNumber>
					<MedicareGivenName><xsl:value-of select="payment/medicare/firstName" /></MedicareGivenName>
					<MedicareMiddleInitial><xsl:value-of select="payment/medicare/middleInitial" /></MedicareMiddleInitial>
					<MedicareSurname><xsl:value-of select="payment/medicare/surname" /></MedicareSurname>
					<MedicareDOB>
						<xsl:call-template name="format_date">
							<xsl:with-param name="eurDate" select="application/primary/dob" />
						</xsl:call-template>
					</MedicareDOB>
					
					<MedicareGender><xsl:value-of select="application/primary/gender" /></MedicareGender>
					<MedicareExpiryDate>
						<xsl:if test="healthCover/rebate = 'Y'">
							<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" />20<xsl:value-of select="payment/medicare/expiry/cardExpiryYear" />
						</xsl:if>
					</MedicareExpiryDate>
				</xsl:when>
				<xsl:otherwise>
					<RebateTier></RebateTier>
					<MedicareNumber></MedicareNumber>
					<MedicareGivenName></MedicareGivenName>
					<MedicareMiddleInitial></MedicareMiddleInitial>
					<MedicareSurname></MedicareSurname>
					<MedicareDOB></MedicareDOB>
					<MedicareGender></MedicareGender>
					<MedicareExpiryDate></MedicareExpiryDate>
				</xsl:otherwise>
				</xsl:choose>
				<MedicareEligibility>Y</MedicareEligibility>				
				<ContinuousCover>
				<xsl:choose>
				<xsl:when test="healthCover/primary/healthCoverLoading = ''">Y</xsl:when>
				<xsl:when test="healthCover/primary/healthCoverLoading = 'Y'">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
				</ContinuousCover>
				<PartnerContinuousCover>
					<xsl:choose>
					<xsl:when test="healthCover/partner/healthCoverLoading='Y'">Y</xsl:when>
					<xsl:when test="healthCover/partner/healthCoverLoading=''">Y</xsl:when>
					<xsl:when test="$healthCvr = 'S' or $healthCvr='SPF'">N</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</PartnerContinuousCover>
				<BasePremium />
				<TotalPremium />

				<ExcessCode><xsl:value-of select="$excessCode"/></ExcessCode>
				<TransferFromFund>
					<xsl:choose>
						<xsl:when test="(previousfund/primary/fundName!='NONE' and
											previousfund/primary/fundName!= 'OTHER' and
											previousfund/primary/fundName!= '') or
										(previousfund/partner/fundName!='NONE' and
											previousfund/partner/fundName!= 'OTHER' and
											previousfund/partner/fundName!='')">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</TransferFromFund>
			</GetPolicyDetails>
			<xsl:choose>
				<!-- partner details if couple or family -->
				<xsl:when test="$healthCvr = 'C' or $healthCvr ='F'">
				<GetPartnerDetails>
					<PartnerTitle>
						<xsl:call-template name="title_code">
							<xsl:with-param name="title" select="application/partner/title" />
						</xsl:call-template>
					</PartnerTitle>
					<PartnerGivenName><xsl:value-of select="application/partner/firstname" /></PartnerGivenName>
					<PartnerSurname><xsl:value-of select="application/partner/surname" /></PartnerSurname>
					<PartnerDOB>
						<xsl:call-template name="format_date">
							<xsl:with-param name="eurDate" select="application/partner/dob" />
						</xsl:call-template>
					</PartnerDOB>
					<PartnerGender><xsl:value-of select="application/partner/gender" /></PartnerGender>
				</GetPartnerDetails>
			</xsl:when>
			<xsl:otherwise>
				<GetPartnerDetails>
					<PartnerTitle />
					<PartnerGivenName />
					<PartnerSurname />
					<PartnerDOB />
					<PartnerGender />				
				</GetPartnerDetails>
			</xsl:otherwise>
			</xsl:choose>

			<!-- dependent details if family or single parent family -->
			<xsl:if test="$healthCvr ='F' or $healthCvr='SPF'">
				<GetDependantsDetails>
					<xsl:variable name="dependants" select="application/dependants" />
					<xsl:for-each select="$dependants/*">
						
							<xsl:variable name="srcElementName">dependant<xsl:value-of select="position()" /></xsl:variable>
							<xsl:variable name="srcElement" select="$dependants/*[name()=$srcElementName]" />
																	
							<xsl:variable name="destIdx" select="position()-1" />
							
							<xsl:if test="string-length($srcElement/firstName) &gt; 0">
								<xsl:element name="{concat('DependantTitle',$destIdx)}">
									<xsl:call-template name="title_code">
										<xsl:with-param name="title" select="$srcElement/title" />
									</xsl:call-template>
								</xsl:element>
								<xsl:element name="{concat('DependantGivenName',$destIdx)}">
									<xsl:value-of select="$srcElement/firstName" />
								</xsl:element>
								<xsl:element name="{concat('DependantSurname',$destIdx)}">
									<xsl:value-of select="$srcElement/lastname" />
								</xsl:element>
								<xsl:element name="{concat('DependantGender',$destIdx)}">
									<xsl:choose>
										<xsl:when test="$srcElement/title='MR'">M</xsl:when>
										<xsl:otherwise>F</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
								<xsl:element name="{concat('DependantDOB',$destIdx)}">
									<xsl:call-template name="format_date">
										<xsl:with-param name="eurDate" select="$srcElement/dob" />
									</xsl:call-template>
								</xsl:element>
								<xsl:element name="{concat('Relationship',$destIdx)}">
									<xsl:choose>
										<xsl:when test="normalize-space($srcElement/school)!=''">4</xsl:when>
										<xsl:otherwise>3</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
								<xsl:element name="{concat('DependantSchool',$destIdx)}">
									<xsl:value-of select="$srcElement/school" />
								</xsl:element>
							</xsl:if>
					</xsl:for-each>
				</GetDependantsDetails>
			</xsl:if>
			<GetOneOffPaymentDetails>
				<OneOffPayment>N</OneOffPayment>
				<xsl:choose>
					<xsl:when test="1=0">
						<CCType>
							<xsl:call-template name="cc_type">
								<xsl:with-param name="type" select="payment/credit/type" />
							</xsl:call-template>
						</CCType>
						<CCNumber><xsl:value-of select="translate(payment/credit/number,' ','')" /></CCNumber>
						<CCcvv><xsl:value-of select="payment/credit/ccv" /></CCcvv>
						<CCExpiryDate><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" />20<xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></CCExpiryDate>
						<InitialPaymentFrequency>
							<xsl:choose>
								<xsl:when test="payment/details/frequency='A'">Y</xsl:when>
								<xsl:otherwise><xsl:value-of select="payment/details/frequency" /></xsl:otherwise>
							</xsl:choose>
						</InitialPaymentFrequency>
					</xsl:when>
					<xsl:otherwise>
						<CCType />
						<CCNumber />
						<CCcvv />
						<CCExpiryDate />
						<InitialPaymentFrequency />					
					</xsl:otherwise>
				</xsl:choose>				
				<InitialAmountPaid />
				<HCFInvoiceId />
				<NABReceiptNo />
				<NABAuthNo />
				<PaymentTimestamp />
			</GetOneOffPaymentDetails>
			<GetDirectDebitPaymentDetails>
				<DebitAccountInd>Y</DebitAccountInd>
				<xsl:choose>
					<xsl:when test="payment/details/type='ba'">
						<DebitType>E</DebitType>
					</xsl:when>								
					<xsl:when test="payment/details/type='cc'">
						<DebitType>C</DebitType>
					</xsl:when>
					<xsl:otherwise>
						ERROR: Unable to determine DebitType
					</xsl:otherwise>
				</xsl:choose>			
				<DebitFrequency>
					<xsl:choose>
						<xsl:when test="payment/details/frequency='A'">Y</xsl:when>
						<xsl:otherwise><xsl:value-of select="payment/details/frequency" /></xsl:otherwise>
					</xsl:choose>
				</DebitFrequency>
				<xsl:choose>
					<xsl:when test="payment/details/type='ba'">
						<DebitDay><xsl:value-of select="payment/bank/day" /></DebitDay>
					</xsl:when>								
					<xsl:when test="payment/details/type='cc'">
						<DebitDay><xsl:value-of select="payment/credit/day" /></DebitDay>
					</xsl:when>
					<xsl:otherwise>
						ERROR: Unable to determine DebitType for DebitDay
					</xsl:otherwise>
				</xsl:choose>							
			</GetDirectDebitPaymentDetails>
			<GetDebitCCDetails>
				<xsl:choose>
					<xsl:when test="payment/details/type='cc'">
						<DDCCHolderName><xsl:value-of select="payment/credit/name" /></DDCCHolderName>
						<DDCCType>
							<xsl:call-template name="cc_type">
								<xsl:with-param name="type" select="payment/credit/type" />
							</xsl:call-template>
						</DDCCType>
						<DDCCNumber><xsl:value-of select="translate(payment/credit/number,' ','')" /></DDCCNumber>
						<DDCCExpiryDate><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" />20<xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></DDCCExpiryDate>
					</xsl:when>
					<xsl:otherwise>
						<DDCCHolderName />
						<DDCCType />
						<DDCCNumber />
						<DDCCExpiryDate />					
					</xsl:otherwise>
				</xsl:choose>
			</GetDebitCCDetails>
			<GetDebitEzipayDetails>
				<EPInstitutionName />
				<EPBranchName />
				<xsl:choose>
					<xsl:when test="payment/details/type='ba'">
						<xsl:variable name="bankNumber"><xsl:value-of select="payment/bank/number" /></xsl:variable>
						<EPAccountName><xsl:value-of select="payment/bank/name" /></EPAccountName>
						<EPAccountNum><xsl:value-of select="format-number($bankNumber, '000000000')" /></EPAccountNum>
						<EPBSBNum><xsl:value-of select="payment/bank/bsb" /></EPBSBNum>
					</xsl:when>
					<xsl:otherwise>
						<EPAccountName />
						<EPAccountNum />
						<EPBSBNum />					
					</xsl:otherwise>
				</xsl:choose>
			</GetDebitEzipayDetails>
			<GetDirectCreditDetails>
				<DirectCredit>N</DirectCredit>
				<CRAccountName />
				<CRAccountNum />
				<CRBSBNum />
			</GetDirectCreditDetails>
				<GetPrevHealthFundDetails>
					<xsl:choose>
						<xsl:when test="previousfund/primary/fundName!='NONE' and
										previousfund/primary/fundName!='OTHER' and
										previousfund/primary/fundName!=''">
							<xsl:variable name="primaryFund">
								<xsl:call-template name="get-fund-name">
									<xsl:with-param name="fundName" select="previousfund/primary/fundName" />
								</xsl:call-template>
							</xsl:variable>
							<OldFundId><xsl:value-of select="$primaryFund" /></OldFundId>
							<OldFundMemberNumber><xsl:value-of select="previousfund/primary/memberID" /></OldFundMemberNumber>
							<OldFundGivenName><xsl:value-of select="application/primary/firstname" /></OldFundGivenName>
							<OldFundSurname><xsl:value-of select="application/primary/surname" /></OldFundSurname>
							<OldFundTransferAuthDate><xsl:value-of select="$todays_date" /></OldFundTransferAuthDate>
						</xsl:when>
						<xsl:otherwise>
							<OldFundId />
							<OldFundMemberNumber />
							<OldFundGivenName />
							<OldFundSurname />
							<OldFundTransferAuthDate />						
						</xsl:otherwise>						
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="previousfund/partner/fundName!='NONE' and  
										previousfund/partner/fundName!='OTHER' and
										previousfund/partner/fundName!=''">				
							<xsl:variable name="partnerFund">
								<xsl:call-template name="get-fund-name">
									<xsl:with-param name="fundName" select="previousfund/primary/fundName" />
								</xsl:call-template>
							</xsl:variable>
							<OldPartnerFundId><xsl:value-of select="$partnerFund" /></OldPartnerFundId>
							<OldPartnerFundMemberNo><xsl:value-of select="previousfund/partner/memberID" /></OldPartnerFundMemberNo>
							<OldPartnerFundGivenName><xsl:value-of select="application/partner/firstname" /></OldPartnerFundGivenName>
							<OldPartnerFundSurname><xsl:value-of select="application/partner/surname" /></OldPartnerFundSurname>
							<OldPartnerFundTransferAuthDate><xsl:value-of select="$todays_date" /></OldPartnerFundTransferAuthDate>
						</xsl:when>
						<xsl:otherwise>
							<OldPartnerFundId />
							<OldPartnerFundMemberNo />
							<OldPartnerFundGivenName />
							<OldPartnerFundSurname />
							<OldPartnerFundTransferAuthDate />						
						</xsl:otherwise>
					</xsl:choose>
				</GetPrevHealthFundDetails>
		</GetHCFSaleInfo>
	</xsl:template>
	
	<xsl:template name="get-before-last-space">
	<xsl:param name="input"/>
		<!-- Test whether the input token contains a space. -->
		<xsl:if test="contains($input,' ')">
		<!-- Output a token. -->
		<xsl:value-of select="concat(' ', substring-before($input,' '))"/>
		<!-- Call this template with the rest of the string. -->
		<xsl:call-template name="get-before-last-space">
			<xsl:with-param name="input" select="substring-after($input,' ')"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="get-after-last-space">
	<xsl:param name="input"/>
	<xsl:choose>
		<!-- Test whether the input token contains a space. -->
		<xsl:when test="contains($input,' ')">
			<!-- Call this template with the rest of the string. -->
			<xsl:call-template name="get-after-last-space">
				<xsl:with-param name="input" select="substring-after($input,' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<!-- There is no space, so just output the input. -->
			<xsl:value-of select="$input"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

	<xsl:template name="get-fund-name">
		<!-- ACC	AUSTRALIAN CASUALTY COMPANY -->
		<!-- DFS	DRUIDS FRIENDLY SOCIETY -->
		<!-- IHF	ILLAWARRA HEALTH FUND -->
		<!-- LVHHS	LATROBE HEALTH SERVICES -->
		<xsl:param name="fundName" />
		<xsl:choose>
			<!--H.COM = HEALTH.COM.AU -->
			<xsl:when test="$fundName='HEA'">H.COM</xsl:when>
			<xsl:otherwise><xsl:value-of select="$fundName"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>