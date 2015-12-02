<?xml version="1.0" encoding="UTF-8"?>
<!-- Place Holder File-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan">

    <!-- PARAMETERS -->
    <xsl:param name="today"/>
    <xsl:param name="overrideEmail"></xsl:param>
    <xsl:param name="keyname"/>
    <xsl:param name="keycode"/>
    <xsl:param name="SoapUrl"/>
    <xsl:param name="SoapAction"/>
    <xsl:param name="transactionId"/>

    <!-- IMPORTS -->
    <xsl:include href="../utils.xsl"/>
    <xsl:include href="../../includes/utils.xsl"/>

    <xsl:variable name="startDate">
        <xsl:call-template name="format_date">
            <xsl:with-param name="eurDate" select="/health/payment/details/start"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- Previous Fund Start/End dates -->
    <xsl:variable name="prevFundEnd">
        <xsl:call-template name="subtract_1_day">
            <xsl:with-param name="isoDate" select="$startDate"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="prevFundStart">
        <xsl:call-template name="subtract_1_day">
            <xsl:with-param name="isoDate" select="$prevFundEnd"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="streetNameCapitalised">
        <xsl:call-template name="titleize">
            <xsl:with-param name="title" select="normalize-space(/health/application/address/fullAddressLineOne)"/>
            <xsl:with-param name="firstWord" select="1 = 1"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="suburbCapitalised">
        <xsl:call-template name="titleize">
            <xsl:with-param name="title" select="normalize-space(/health/application/address/suburbName)"/>
            <xsl:with-param name="firstWord" select="1 = 1"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="streetName">
        <xsl:value-of select="$streetNameCapitalised"/>
    </xsl:variable>
    <xsl:variable name="suburbName">
        <xsl:value-of select="$suburbCapitalised"/>
    </xsl:variable>
    <xsl:variable name="state">
        <xsl:value-of select="/health/application/address/state"/>
    </xsl:variable>

    <xsl:variable name="address">
        <xsl:value-of
                select="concat($streetName, ' ', $suburbName, ' ', $state, ' ', /health/application/address/postCode)"/>
    </xsl:variable>

    <!-- Street Number -->
    <xsl:variable name="streetNo">
        <xsl:choose>
            <xsl:when test="/health/application/address/streetNum != ''">
                <xsl:value-of select="/health/application/address/streetNum"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/health/application/address/houseNoSel"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- POSTAL ADDRESS VARIABLES -->
    <xsl:variable name="postalAddress" select="/health/application/postal"/>

    <xsl:variable name="postal_streetName" select="/health/application/postal/fullAddressLineOne"/>
    <xsl:variable name="postal_suburbName" select="$postalAddress/suburbName"/>
    <xsl:variable name="postal_state" select="$postalAddress/state"/>

    <xsl:variable name="postal_address">
        <xsl:value-of
                select="concat($postal_streetName, ' ', $postal_suburbName, ' ', $postal_state, ' ', $postalAddress/postCode)"/>
    </xsl:variable>

    <!-- Street Number -->
    <xsl:variable name="postal_streetNo">
        <xsl:choose>
            <xsl:when test="$postalAddress/streetNum != ''">
                <xsl:value-of select="$postalAddress/streetNum"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$postalAddress/houseNoSel"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="emailAddress">
        <xsl:choose>
            <xsl:when test="$overrideEmail!=''">
                <xsl:value-of select="$overrideEmail"/>
            </xsl:when>
            <xsl:when test="health/application/email != ''">
                <xsl:value-of select="health/application/email"/>
            </xsl:when>
            <xsl:when test="health/contactDetails/email != ''">
                <xsl:value-of select="health/contactDetails/email"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    email is mandatory
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <!-- MAIN TEMPLATE -->
    <xsl:template match="/health">
        <!-- Force First letter to be a Capital then all lowercase and strip out special characters from the whole string -->
        <xsl:variable name="primaryFirstname">
            <xsl:call-template name="format_person_name">
                <xsl:with-param name="name" select="application/primary/firstname,"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="primarySurname">
            <xsl:call-template name="format_person_name">
                <xsl:with-param name="name" select="application/primary/surname,"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- FUND PRODUCT SPECIFIC VALUES -->
        <soap:Envelope xmlns:hsl="http://HSL.OMS.Public.API.Service"
                       xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
            <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
                <wsse:Security soap:mustUnderstand="true"
                               xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                    <wsse:UsernameToken wsu:Id="UsernameToken-2"
                                        xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
                        <wsse:Username>
                            <xsl:value-of select="$keyname"/>
                        </wsse:Username>
                        <wsse:Password
                                Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">
                            <xsl:value-of select="$keycode"/>
                        </wsse:Password>
                        <wsu:Created><xsl:value-of select="$today"/>T00:00:00Z
                        </wsu:Created>
                    </wsse:UsernameToken>
                </wsse:Security>
                <wsa:To>
                    <xsl:value-of select="$SoapUrl"/>
                </wsa:To>
                <wsa:Action>
                    <xsl:value-of select="$SoapAction"/>
                </wsa:Action>
            </soap:Header>
            <soap:Body>
                <hsl:SubmitMembership>
                    <hsl:xmlFile>
                        <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                        <MembershipApplication xmlns="http://www.hambs.com.au/MemberServices/MemberServices.xsd">
                            <SubmittedBy>Agent</SubmittedBy>
                            <Persons>
                                <Person>
                                    <PersonID>0</PersonID>
                                    <!-- yyyy-mm-dd -->
                                    <xsl:if test="$startDate = ''">
                                        <xsl:message terminate="yes">
                                            startDate is mandatory
                                        </xsl:message>
                                    </xsl:if>
                                    <EffDate>
                                        <xsl:value-of select="$startDate"/>
                                    </EffDate>
                                    <Relationship>Membr</Relationship>
                                    <Title>
                                        <xsl:choose>
                                            <xsl:when test="application/primary/title='MR'">Mr</xsl:when>
                                            <xsl:when test="application/primary/title='MRS'">Mrs</xsl:when>
                                            <xsl:when test="application/primary/title='MISS'">Miss</xsl:when>
                                            <xsl:when test="application/primary/title='MS'">Ms</xsl:when>
                                            <xsl:when test="application/primary/title='DR'">Dr</xsl:when>
                                        </xsl:choose>
                                    </Title>
                                    <FirstName>
                                        <xsl:value-of select="$primaryFirstname"/>
                                    </FirstName>
                                    <Surname>
                                        <xsl:value-of select="$primarySurname"/>
                                    </Surname>
                                    <xsl:if test="application/primary/gender = ''">
                                        <xsl:message terminate="yes">
                                            gender is mandatory
                                        </xsl:message>
                                    </xsl:if>
                                    <Gender>
                                        <xsl:value-of select="application/primary/gender"/>
                                    </Gender>
                                    <Birthdate>
                                        <xsl:call-template name="format_date">
                                            <xsl:with-param name="eurDate" select="application/primary/dob"/>
                                        </xsl:call-template>
                                    </Birthdate>

                                    <xsl:variable name="medicareFirstname">
                                        <xsl:call-template name="format_person_name">
                                            <xsl:with-param name="name" select="payment/medicare/firstName"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="medicareSurname">
                                        <xsl:call-template name="format_person_name">
                                            <xsl:with-param name="name" select="payment/medicare/surname,"/>
                                        </xsl:call-template>
                                    </xsl:variable>

                                    <MediCardNo>
                                        <xsl:value-of select="translate(payment/medicare/number,' ','')"/>
                                    </MediCardNo>
                                    <MediCardExpDate>
                                        <xsl:text>20</xsl:text><xsl:value-of
                                            select="payment/medicare/expiry/cardExpiryYear"/>-<xsl:value-of
                                            select="payment/medicare/expiry/cardExpiryMonth"/><xsl:text>-01</xsl:text>
                                    </MediCardExpDate>
                                    <MediCardFirstName>
                                        <xsl:value-of select="$medicareFirstname"/>
                                    </MediCardFirstName>
                                    <xsl:if test="payment/medicare/middleInitial!= ''">
                                        <MediCardSecondName>
                                            <xsl:value-of select="payment/medicare/middleInitial"/>
                                        </MediCardSecondName>
                                    </xsl:if>
                                    <MediCardSurname>
                                        <xsl:value-of select="$medicareSurname"/>
                                    </MediCardSurname>

                                    <IsRebateApplicant>
                                        <xsl:choose>
                                            <xsl:when test="healthCover/rebate='Y'">true</xsl:when>
                                            <xsl:otherwise>false</xsl:otherwise>
                                        </xsl:choose>
                                    </IsRebateApplicant>
                                    <FullTimeStudent>false</FullTimeStudent>
                                    <EmailAddress>
                                        <xsl:value-of select="$emailAddress"/>
                                    </EmailAddress>

                                    <xsl:variable name="primaryFund">
                                        <xsl:call-template name="get-fund-name">
                                            <xsl:with-param name="fundName" select="previousfund/primary/fundName"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <IsMember>true</IsMember>
                                    <JoinDate>
                                        <xsl:value-of select="$startDate"/>
                                    </JoinDate>
                                    <Properties>
                                        <!-- emigrate to australia -->
                                        <xsl:if test="application/hif/emigrate = 'Y'">
                                            <Property>
                                                <Name>MediE</Name>
                                                <Value>
                                                    <xsl:value-of select="$today"/>
                                                </Value>
                                            </Property>
                                        </xsl:if>
                                        <!-- our dedicated health insurance consultants will give you a call to chat about your health insurance needs and questions -->
                                        <xsl:if test="health/application/call = 'Y'">
                                            <Property>
                                                <Name>CallB</Name>
                                                <Value>callback required</Value>
                                            </Property>
                                        </xsl:if>
                                        <!-- your current health fund - member & membership number -->
                                        <xsl:if test="$primaryFund !='NONE' and $primaryFund !=''">
                                            <Property>
                                                <Name>TrnWT</Name>
                                                <Value>
                                                    <xsl:value-of
                                                            select="concat($primaryFund, ' ' ,previousfund/primary/memberID)"/>
                                                </Value>
                                            </Property>
                                        </xsl:if>

                                        <xsl:if test="healthCover/rebate='Y'">
                                            <Property>
                                                <Name>RebTr</Name>
                                                <Value>
                                                    <xsl:value-of select="healthCover/income"/>
                                                </Value>
                                            </Property>
                                        </xsl:if>
                                        <!-- CTM reference number  -->
                                        <Property>
                                            <Name>AgtRf</Name>
                                            <Value>CTM<xsl:value-of select="$transactionId"/>
                                            </Value>
                                        </Property>
                                        <xsl:if test="healthCover/rebate='Y'">
                                            <Property>
                                                <Name>FGR</Name>
                                                <Value><xsl:value-of select="$today"/></Value>
                                            </Property>
                                        </xsl:if>
                                    </Properties>
                                </Person>
                                <xsl:if test="application/partner/firstname != ''">
                                    <xsl:variable name="partnerFirstname">
                                        <xsl:call-template name="format_person_name">
                                            <xsl:with-param name="name" select="application/partner/firstname,"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="partnerSurname">
                                        <xsl:call-template name="format_person_name">
                                            <xsl:with-param name="name" select="application/partner/surname,"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <Person>
                                        <PersonID>0</PersonID>
                                        <EffDate>
                                            <xsl:value-of select="$startDate"/>
                                        </EffDate>
                                        <Relationship>
                                            <xsl:choose>
                                                <xsl:when test="$partnerSurname = $primarySurname">Sps</xsl:when>
                                                <xsl:otherwise>Ptnr</xsl:otherwise>
                                            </xsl:choose>
                                        </Relationship>
                                        <Title>
                                            <xsl:choose>
                                                <xsl:when test="application/partner/title='MR'">Mr</xsl:when>
                                                <xsl:when test="application/partner/title='MRS'">Mrs</xsl:when>
                                                <xsl:when test="application/partner/title='MISS'">Miss</xsl:when>
                                                <xsl:when test="application/partner/title='MS'">Ms</xsl:when>
                                                <xsl:when test="application/partner/title='DR'">Dr</xsl:when>
                                            </xsl:choose>
                                        </Title>
                                        <FirstName>
                                            <xsl:value-of select="$partnerFirstname"/>
                                        </FirstName>
                                        <Surname>
                                            <xsl:value-of select="$partnerSurname"/>
                                        </Surname>
                                        <Gender>
                                            <xsl:value-of select="application/partner/gender"/>
                                        </Gender>
                                        <Birthdate>
                                            <xsl:call-template name="format_date">
                                                <xsl:with-param name="eurDate" select="application/partner/dob"/>
                                            </xsl:call-template>
                                        </Birthdate>
                                        <IsRebateApplicant>false</IsRebateApplicant>
                                        <FullTimeStudent>false</FullTimeStudent>

                                        <xsl:variable name="partnerFund">
                                            <xsl:call-template name="get-fund-name">
                                                <xsl:with-param name="fundName" select="previousfund/partner/fundName"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <IsMember>false</IsMember>
                                        <JoinDate>
                                            <xsl:value-of select="$startDate"/>
                                        </JoinDate>
                                        <Properties>
                                            <!-- emigrate to australia -->
                                            <!-- Spouse Authority -->
                                            <xsl:if test="previousfund/partner/authority = 'Y'">
                                                <Property>
                                                    <Name>AUTSP</Name>
                                                    <Value>
                                                        <xsl:value-of
                                                                select="concat($partnerFirstname, ' ' ,$partnerSurname)"/>
                                                    </Value>
                                                </Property>
                                            </xsl:if>
                                            <!-- your current health fund - spouse & membership number -->
                                            <xsl:if test="$partnerFund !='NONE'">
                                                <Property>
                                                    <Name>TrWT2</Name>
                                                    <Value>
                                                        <xsl:value-of
                                                                select="concat($partnerFund, ' ' , previousfund/partner/memberID)"/>
                                                    </Value>
                                                </Property>
                                            </xsl:if>
                                        </Properties>
                                    </Person>
                                </xsl:if>
                                <xsl:for-each select="application/dependants/*">
                                    <xsl:if test="firstName!=''">
                                        <Person>
                                            <PersonID>0</PersonID>
                                            <EffDate>
                                                <xsl:value-of select="$startDate"/>
                                            </EffDate>
                                            <Relationship>
                                                <xsl:choose>
                                                    <xsl:when test="title = 'MR'">Son</xsl:when>
                                                    <xsl:otherwise>Dtr</xsl:otherwise>
                                                </xsl:choose>
                                            </Relationship>
                                            <Title>
                                                <xsl:choose>
                                                    <xsl:when test="title = 'MR'">Mr</xsl:when>
                                                    <xsl:when test="title='MRS'">Mrs</xsl:when>
                                                    <xsl:when test="title='MISS'">Miss</xsl:when>
                                                    <xsl:when test="title='MS'">Ms</xsl:when>
                                                </xsl:choose>
                                            </Title>
                                            <FirstName>
                                                <xsl:call-template name="format_person_name">
                                                    <xsl:with-param name="name" select="firstName"/>
                                                </xsl:call-template>
                                            </FirstName>
                                            <Surname>
                                                <xsl:call-template name="format_person_name">
                                                    <xsl:with-param name="name" select="lastname"/>
                                                </xsl:call-template>
                                            </Surname>
                                            <Gender>
                                                <xsl:choose>
                                                    <xsl:when test="title='MR'">M</xsl:when>
                                                    <xsl:otherwise>F</xsl:otherwise>
                                                </xsl:choose>
                                            </Gender>
                                            <Birthdate>
                                                <xsl:call-template name="format_date">
                                                    <xsl:with-param name="eurDate" select="dob"/>
                                                </xsl:call-template>
                                            </Birthdate>
                                            <FullTimeStudent>
                                                <xsl:choose>
                                                    <xsl:when test="fulltime='Y'">true</xsl:when>
                                                    <xsl:otherwise>false</xsl:otherwise>
                                                </xsl:choose>
                                            </FullTimeStudent>
                                            <xsl:if test="school!=''">
                                                <EDInstitutionName>
                                                    <xsl:value-of select="school"/>
                                                </EDInstitutionName>
                                            </xsl:if>
                                            <Transferring>false</Transferring>
                                            <IsMember>false</IsMember>
                                            <JoinDate>
                                                <xsl:value-of select="$startDate"/>
                                            </JoinDate>
                                        </Person>
                                    </xsl:if>
                                </xsl:for-each>
                            </Persons>
                            <Contacts>
                                <Addresses>
                                    <Address>
                                        <Code>H</Code>
                                        <EffDate>
                                            <xsl:value-of select="$startDate"/>
                                        </EffDate>
                                        <Overseas>false</Overseas>
                                        <Line1>
                                            <xsl:value-of select="$streetName"/>
                                        </Line1>
                                        <Locality>
                                            <xsl:value-of select="$suburbName"/>
                                        </Locality>
                                        <State>
                                            <xsl:value-of select="$state"/>
                                        </State>
                                        <Postcode>
                                            <xsl:value-of select="/health/application/address/postCode"/>
                                        </Postcode>
                                    </Address>
                                    <xsl:if test="not(application/postalMatch) or application/postalMatch!='Y'">
                                        <Address>
                                            <Code>P</Code>
                                            <EffDate>
                                                <xsl:value-of select="$startDate"/>
                                            </EffDate>
                                            <Overseas>false</Overseas>
                                            <Line1>
                                                <xsl:value-of select="$postal_streetName"/>
                                            </Line1>
                                            <Locality>
                                                <xsl:value-of select="$postal_suburbName"/>
                                            </Locality>
                                            <State>
                                                <xsl:value-of select="$postal_state"/>
                                            </State>
                                            <Postcode>
                                                <xsl:value-of select="$postalAddress/postCode"/>
                                            </Postcode>
                                        </Address>
                                    </xsl:if>
                                </Addresses>
                                <Phones>
                                    <xsl:if test="application/mobile != ''">
                                        <Phone>
                                            <Code>M</Code>
                                            <Number>
                                                <xsl:value-of select="translate(application/mobile,' ()','')"/>
                                            </Number>
                                        </Phone>
                                    </xsl:if>
                                    <xsl:if test="application/other != ''">
                                        <Phone>
                                            <Code>
                                                <xsl:choose>
                                                    <xsl:when test="substring(application/other,1,2)='04'">M</xsl:when>
                                                    <xsl:otherwise>H</xsl:otherwise>
                                                </xsl:choose>
                                            </Code>
                                            <Number>
                                                <xsl:value-of select="translate(application/other,' ()','')"/>
                                            </Number>
                                        </Phone>
                                    </xsl:if>
                                </Phones>
                                <EmailAddress>
                                    <xsl:value-of select="$emailAddress"/>
                                </EmailAddress>
                                <xsl:variable name="CommMedium">
                                    <xsl:choose>
                                        <xsl:when test="application/contactPoint = 'E'">1</xsl:when>
                                        <xsl:when test="application/contactPoint = 'P'">4</xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="CorrMethID">
                                    <xsl:choose>
                                        <xsl:when test="application/contactPoint = 'E'">Email</xsl:when>
                                        <xsl:when test="application/contactPoint = 'P'">Mail</xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="IsSendEmail">
                                    <xsl:choose>
                                        <xsl:when test="application/contactPoint = 'E'">true</xsl:when>
                                        <xsl:otherwise>false</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <CorrMethID>
                                    <xsl:value-of select="$CorrMethID"/>
                                </CorrMethID>
                                <IsSendEmail>
                                    <xsl:value-of select="$IsSendEmail"/>
                                </IsSendEmail>

                                <IsReceiveMarketing>true</IsReceiveMarketing>

                                <CommunicationPreferences>
                                    <xsl:if test="string-length(application/contactPoint) &gt; 0">
                                        <CommunicationPreference>
                                            <CommGroup>1</CommGroup>
                                            <CommMedium>
                                                <xsl:value-of select="$CommMedium"/>
                                            </CommMedium>
                                            <IsUsed>Y</IsUsed>
                                        </CommunicationPreference>
                                        <CommunicationPreference>
                                            <CommGroup>24</CommGroup>
                                            <CommMedium>
                                                <xsl:value-of select="$CommMedium"/>
                                            </CommMedium>
                                            <IsUsed>Y</IsUsed>
                                        </CommunicationPreference>
                                        <CommunicationPreference>
                                            <CommGroup>7</CommGroup>
                                            <CommMedium>
                                                <xsl:value-of select="$CommMedium"/>
                                            </CommMedium>
                                            <IsUsed>Y</IsUsed>
                                        </CommunicationPreference>
                                    </xsl:if>
                                </CommunicationPreferences>
                            </Contacts>
                            <Cover>
                                <EffDate>
                                    <xsl:value-of select="$startDate"/>
                                </EffDate>
                                <Class>
                                    <xsl:choose>
                                        <xsl:when test="situation/healthCvr = 'SM'">Sgl</xsl:when>
                                        <xsl:when test="situation/healthCvr = 'SF'">Sgl</xsl:when>
                                        <xsl:when test="situation/healthCvr = 'S'">Sgl</xsl:when>
                                        <xsl:when test="situation/healthCvr = 'C'">Cpl</xsl:when>
                                        <xsl:when test="situation/healthCvr = 'SPF'">SPFam</xsl:when>
                                        <xsl:when test="situation/healthCvr = 'F'">Fam</xsl:when>
                                        <xsl:otherwise>
                                            <xsl:message terminate="yes">
                                                situation/healthCvr is invalid
                                            </xsl:message>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Class>

                                <!-- set to blank because of CoverRateSelection -->
                                <CoverType>BLANK</CoverType>
                                <ProductSelection>BLANK</ProductSelection>

                                <AccountIgnored>false</AccountIgnored>
                                <xsl:if test="payment/details/claims='Y'">
                                    <BenefitPaymentMethod>D/Cr</BenefitPaymentMethod>
                                </xsl:if>
                                <CoverRateSelection>
                                    <xsl:value-of select="fundData/fundCode"/>
                                </CoverRateSelection>
                                <xsl:if test="payment/details/claims='Y'">
                                    <Account>
                                        <AccountType>credit</AccountType>
                                        <DebitCreditID>Bank</DebitCreditID>
                                        <xsl:choose>
                                            <xsl:when test="payment/details/type='cc' or payment/bank/claims!='Y'">
                                                <BSB>
                                                    <xsl:value-of
                                                            select="concat(substring(payment/bank/claim/bsb,1,3),'-',substring(payment/bank/claim/bsb,4,3))"/>
                                                </BSB>
                                                <AccountNumber>
                                                    <xsl:value-of select="translate(payment/bank/claim/number,' ','')"/>
                                                </AccountNumber>
                                                <AccountName>
                                                    <xsl:value-of select="payment/bank/claim/account"/>
                                                </AccountName>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <BSB>
                                                    <xsl:value-of
                                                            select="concat(substring(payment/bank/bsb,1,3),'-',substring(payment/bank/bsb,4,3))"/>
                                                </BSB>
                                                <AccountNumber>
                                                    <xsl:value-of select="translate(payment/bank/number,' ','')"/>
                                                </AccountNumber>
                                                <AccountName>
                                                    <xsl:value-of select="payment/bank/account"/>
                                                </AccountName>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </Account>
                                </xsl:if>
                            </Cover>
                            <Contributions>
                                <DirectDebitContribPayments>true</DirectDebitContribPayments>
                                <EffDate>
                                    <xsl:value-of select="$startDate"/>
                                </EffDate>
                                <ContribFreq>
                                    <xsl:choose>
                                        <xsl:when test="payment/details/frequency='W'">Wkly</xsl:when>
                                        <xsl:when test="payment/details/frequency='F'">Fnght</xsl:when>
                                        <xsl:when test="payment/details/frequency='M'">Mtly</xsl:when>
                                        <xsl:when test="payment/details/frequency='Q'">Qtly</xsl:when>
                                        <xsl:when test="payment/details/frequency='H'">6Mtly</xsl:when>
                                        <xsl:when test="payment/details/frequency='A'">Yrly</xsl:when>
                                    </xsl:choose>
                                </ContribFreq>
                                <ContribRateSelection>
                                    <xsl:value-of select="fundData/fundCode"/>
                                </ContribRateSelection>
                                <Rebate>
                                    <xsl:choose>
                                        <xsl:when test="healthCover/rebate='Y'">true</xsl:when>
                                        <xsl:otherwise>false</xsl:otherwise>
                                    </xsl:choose>
                                </Rebate>
                                <xsl:if test="healthCover/rebate = 'Y'">
                                    <RebateTier>
                                        <EffDate>
                                            <xsl:value-of select="$startDate"/>
                                        </EffDate>
                                        <Tier>
                                            <xsl:value-of select="healthCover/income"/>
                                        </Tier>
                                    </RebateTier>
                                </xsl:if>
                                <EligibleMedicare>
                                    <xsl:choose>
                                        <xsl:when test="payment/medicare/cover = 'Y'">true</xsl:when>
                                        <xsl:otherwise>false</xsl:otherwise>
                                    </xsl:choose>
                                </EligibleMedicare>
                                <DebitOnDate>
                                    <xsl:choose>
                                        <xsl:when test="payment/details/type='cc'">
                                            <xsl:value-of select="/health/payment/credit/policyDay"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="/health/payment/bank/policyDay"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </DebitOnDate>
                                <Account>
                                    <xsl:choose>
                                        <xsl:when test="payment/details/type='cc'">
                                            <DebitCreditID>
                                                <xsl:value-of select="payment/gateway/nab/cardType"/>
                                            </DebitCreditID>
                                            <ExpiryMonth>
                                                <xsl:value-of select="payment/gateway/nab/expiryMonth"/>
                                            </ExpiryMonth>
                                            <ExpiryYear>
                                                <xsl:value-of select="payment/gateway/nab/expiryYear"/>
                                            </ExpiryYear>
                                            <AccountNumber>
                                                <xsl:value-of select="payment/gateway/nab/cardNumber"/>
                                            </AccountNumber>
                                            <xsl:if test="payment/gateway/nab/cardName != ''">
                                                <AccountName>
                                                    <xsl:value-of select="payment/gateway/nab/cardName"/>
                                                </AccountName>
                                            </xsl:if>
                                            <TempCRN>
                                                <xsl:value-of select="payment/gateway/nab/crn"/>
                                            </TempCRN>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <AccountType>debit</AccountType>
                                            <DebitCreditID>Bank</DebitCreditID>
                                            <BSB>
                                                <xsl:value-of
                                                        select="concat(substring(payment/bank/bsb,1,3),'-',substring(payment/bank/bsb,4,3))"/>
                                            </BSB>
                                            <AccountNumber>
                                                <xsl:value-of select="translate(payment/bank/number,' ','')"/>
                                            </AccountNumber>
                                            <AccountName>
                                                <xsl:value-of select="payment/bank/account"/>
                                            </AccountName>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Account>
                            </Contributions>
                            <Membership>
                                <Agency>
                                    <EffDate>
                                        <xsl:value-of select="$startDate"/>
                                    </EffDate>
                                    <AgencyID>CTM</AgencyID>
                                </Agency>
                            </Membership>
                        </MembershipApplication>
                        <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                    </hsl:xmlFile>
                    <hsl:BrokerID>CTM1</hsl:BrokerID>
                </hsl:SubmitMembership>
            </soap:Body>
        </soap:Envelope>
    </xsl:template>
    <xsl:template name="get-fund-name">
        <xsl:param name="fundName"/>
        <xsl:choose>
            <!--ACA Health Benefits-->
            <xsl:when test="$fundName='ACA'">ACA</xsl:when>
            <!-- Defence Health Limited -->
            <xsl:when test="$fundName='DHBS'">AHB</xsl:when>
            <xsl:when test="$fundName='AHM'">GEH</xsl:when>
            <!-- The Doctors Health Fund -->
            <xsl:when test="$fundName='AMA'">AMA</xsl:when>
            <xsl:when test="$fundName='UAOD'">Oth</xsl:when>
            <!--  Australian Unity Health Limited -->
            <xsl:when test="$fundName='AUSTUN'">AU</xsl:when>
            <xsl:when test="$fundName='BUPA'">BUP</xsl:when>
            <xsl:when test="$fundName='CBHS'">CBH</xsl:when>
            <!--  CDH Benefits Fund (Cessnock District Health) -->
            <xsl:when test="$fundName='CDH'">CDH</xsl:when>
            <!--  CUA Health Limited -->
            <xsl:when test="$fundName='CUA'">CPS</xsl:when>
            <!--  FRANK Health Insurance -->
            <xsl:when test="$fundName='FRANK'">FHI</xsl:when>
            <!--  GMF Health -->
            <xsl:when test="$fundName='GMF'">GMF</xsl:when>
            <!--  Grand United Corporate Health -->
            <xsl:when test="$fundName='GMHBA'">GMH</xsl:when>
            <xsl:when test="$fundName='GU'">GU</xsl:when>
            <!--<xsl:when test="$fundName='GU'">GUC</xsl:when>-->
            <!--  HBF Health Limited -->
            <xsl:when test="$fundName='HBF'">HBF</xsl:when>
            <xsl:when test="$fundName='HCF'">HCF</xsl:when>
            <xsl:when test="$fundName='HCI'">HCI</xsl:when>
            <!-- health.com.au -->
            <xsl:when test="$fundName='HEA'">HEA</xsl:when>
            <xsl:when test="$fundName='HIF'">HIF</xsl:when>
            <xsl:when test="$fundName='LHMC'">LHM</xsl:when>
            <xsl:when test="$fundName='LVHHS'">LHS</xsl:when>
            <xsl:when test="$fundName='MDHF'">MDH</xsl:when>
            <xsl:when test="$fundName='MEDIBK'">MP</xsl:when>
            <xsl:when test="$fundName='NHBS'">NHB</xsl:when>
            <xsl:when test="$fundName='NIB'">NIB</xsl:when>
            <xsl:when test="$fundName='TFHS'">NTF</xsl:when>
            <xsl:when test="$fundName='SAPOL'">PHF</xsl:when>
            <xsl:when test="$fundName='PWAL'">PWA</xsl:when>
            <xsl:when test="$fundName='QCH'">MIM</xsl:when>
            <xsl:when test="$fundName='RBHS'">RBH</xsl:when>
            <xsl:when test="$fundName='RTEHF'">RTE</xsl:when>
            <xsl:when test="$fundName='SLHI'">SL</xsl:when>
            <xsl:when test="$fundName='HBFSA'">SPS</xsl:when>
            <xsl:when test="$fundName='FI'">TFS</xsl:when>
            <!-- Westfund Health Insurance -->
            <xsl:when test="$fundName='WDHF'">WDH</xsl:when>
            <xsl:when test="$fundName='NONE'">NONE</xsl:when>
            <!-- Hmmmm -->
            <xsl:when test="$fundName='QTUHS'">TUH</xsl:when>
            <xsl:when test="$fundName='WDHF'">WDH</xsl:when>
            <!-- All other funds in our list -->
            <xsl:when test="$fundName != ''">OTH</xsl:when>
            <xsl:otherwise>NONE</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="titleize">
        <xsl:param name="title"/>
        <xsl:param name="firstWord"/>
        <xsl:choose>
            <xsl:when test="contains($title, ' ')">
                <xsl:call-template name="upperFirst">
                    <xsl:with-param name="word" select="substring-before($title, ' ')"/>
                    <xsl:with-param name="firstWord" select="$firstWord"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="titleize">
                    <xsl:with-param name="title" select="substring-after($title, ' ')"></xsl:with-param>
                    <xsl:with-param name="firstWord" select="1 = 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="upperFirst">
                    <xsl:with-param name="word" select="$title"/>
                    <xsl:with-param name="firstWord" select="$firstWord"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="upperFirst">
        <xsl:param name="word"/>
        <xsl:param name="firstWord"/>
        <xsl:choose>
            <xsl:when test="string-length($word) &lt;= 3 and not($firstWord)">
                <xsl:value-of select="$word"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(substring($word, 1, 1), $LOWERCASE, $UPPERCASE)"/>
                <xsl:value-of select="substring($word, 2 , string-length($word) - 1)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>