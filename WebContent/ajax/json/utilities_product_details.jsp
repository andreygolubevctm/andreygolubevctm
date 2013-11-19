<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="useCache" value="${true}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="utilities" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>
		
		<c:set var="tranId" value="${data['utilities/transactionId']}" />
		
		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:choose>
			<c:when test="${useCache eq true}">
				<c:set var="productDetailsXml"><ProductDetail xmlns="http://switchwise.com.au/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><Downloads><DocumentLink><FileName>APG-Energy_Offer_Summary_aug09.pdf</FileName><Name>Offer Summary</Name><DocumentType>Offer Summary</DocumentType></DocumentLink><DocumentLink><FileName>Customer_Charter DEC2010.pdf</FileName><Name>Customer Charter</Name><DocumentType>Customer Charter</DocumentType></DocumentLink><DocumentLink><FileName>final apg10_113 privacypolicy_sept10.pdf</FileName><Name>Privacy Policy</Name><DocumentType>Privacy Policy</DocumentType></DocumentLink><DocumentLink><FileName>final apg10_110 vic offer booklet_may11_web.pdf</FileName><Name>Terms and Conditions Document</Name><DocumentType>Terms and Conditions Document</DocumentType></DocumentLink></Downloads><Features><FeatureGroup><Lines><FeatureLine><Content i:nil="true"/><Prompt>Discount - None</Prompt><FeatureLineId>19814</FeatureLineId></FeatureLine><FeatureLine><Content>Free 12 month membership to the Australian Power &amp; Gas Online Rewards Programme.</Content><Prompt>Rewards Programme</Prompt><FeatureLineId>23588</FeatureLineId></FeatureLine></Lines><Name>Discounts and Bonuses</Name></FeatureGroup><FeatureGroup><Lines><FeatureLine><Content>Electricity bills issued every 3 months.</Content><Prompt>Standard Billing</Prompt><FeatureLineId>26651</FeatureLineId></FeatureLine><FeatureLine><Content>Gas bills issued every 2 months.</Content><Prompt>Standard Billing</Prompt><FeatureLineId>26653</FeatureLineId></FeatureLine></Lines><Name>Billing Options</Name></FeatureGroup><FeatureGroup><Lines><FeatureLine><Content>$33 if contract cancelled at any time during first 3 years.</Content><Prompt>Contract Early Termination Fee</Prompt><FeatureLineId>19812</FeatureLineId></FeatureLine><FeatureLine><Content>28 days notice required for cancellation by customer</Content><Prompt>Contract Term - 3 Years</Prompt><FeatureLineId>19813</FeatureLineId></FeatureLine></Lines><Name>Contract Features</Name></FeatureGroup><FeatureGroup><Lines><FeatureLine><Content i:nil="true"/><Prompt>100%</Prompt><FeatureLineId>19811</FeatureLineId></FeatureLine><FeatureLine><Content>$3 per week GreenPower premium (included in cost &amp; savings figures shown above)</Content><Prompt>GreenPower Premium</Prompt><FeatureLineId>19819</FeatureLineId></FeatureLine></Lines><Name>Accredited GreenPower %</Name></FeatureGroup></Features><PaymentOptions><FeatureGroup><Lines><FeatureLine><Content/><Prompt>BPAY</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine><FeatureLine><Content/><Prompt>Cash (Australia Post)</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine><FeatureLine><Content/><Prompt>Direct Debit</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine><FeatureLine><Content/><Prompt>Cheque</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine><FeatureLine><Content/><Prompt>EnergyPay Direct</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine><FeatureLine><Content/><Prompt>EnergyPay</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine><FeatureLine><Content>Visa, Mastercard, American Express</Content><Prompt>Credit Card</Prompt><FeatureLineId>0</FeatureLineId></FeatureLine></Lines><Name i:nil="true"/></FeatureGroup></PaymentOptions><Product><CanApply>true</CanApply><ContractLength>3 Years</ContractLength><EstimatedCost><Minimum>2050</Minimum><Maximum>2050</Maximum></EstimatedCost><EstimatedSaving><Minimum>-130</Minimum><Maximum>-130</Maximum></EstimatedSaving><GreenPercent>100</GreenPercent><GreenRating>3_5</GreenRating><MaxCancellationFee>$33</MaxCancellationFee><ProductID>1010</ProductID><Retailer><Code>APG</Code><Name>Australian Power &amp; Gas</Name><RetailerID>6</RetailerID><SmallLogo>apg_SwirlLogo.png</SmallLogo><Phone1 i:nil="true"/><Phone2 i:nil="true"/><Fax i:nil="true"/><Email i:nil="true"/><Url i:nil="true"/></Retailer><ProductClassPackage>ElectricityGas</ProductClassPackage><ProductDescription>Greentricity 100% - Dual Fuel</ProductDescription><StarRating>3_5</StarRating><CallRetailer/><CallRetailerPhone>or call 1300 279 482</CallRetailerPhone><PaymentFrequency i:nil="true"/><PaymentMethod>BPAY,Cash (Australia Post),Cheque,Credit Card,Direct Debit,EnergyPay,EnergyPay Direct</PaymentMethod><BillingMethod>Standard Billing,Standard Billing</BillingMethod><FullOrSelfService i:nil="true"/><HasAddOnFeature>false</HasAddOnFeature><IdentificationRequired>false</IdentificationRequired><PaymentInformationRequired>false</PaymentInformationRequired><NeedToAgreeToPowerOff>false</NeedToAgreeToPowerOff><ReviewRating>3.02272727272727</ReviewRating><ReviewQuantity>11</ReviewQuantity></Product><Rates><Rate><EffectiveFromDate>2012-12-20T00:00:00</EffectiveFromDate><NetworkArea>APG-UNE-RES-VIC</NetworkArea><Prices><Price><Amount>82.88</Amount><Description>Supply charge</Description><GSTAmount>91.166</GSTAmount><Period>1-Jan to 31-Dec</Period><PriceMeterType>Supply</PriceMeterType><UOM>c/day</UOM></Price><Price><Amount>26.160</Amount><Description>Usage</Description><GSTAmount>28.7760</GSTAmount><Period>1-Jan to 31-Dec</Period><PriceMeterType>OffPeak</PriceMeterType><UOM>c/kWh</UOM></Price></Prices><ProductClass>Electricity</ProductClass><TariffDescription>Electricity GDGR (peak)</TariffDescription></Rate><Rate><EffectiveFromDate>2012-12-20T00:00:00</EffectiveFromDate><NetworkArea>APG-AGLSTH-RES-VIC</NetworkArea><Prices><Price><Amount>53.94</Amount><Description>Supply charge</Description><GSTAmount>59.330</GSTAmount><Period>1-Jan to 31-Dec</Period><PriceMeterType>Supply</PriceMeterType><UOM>c/day</UOM></Price><Price><Amount>1.861</Amount><Description>Gas 3 (peak) Usage first 5250 MJ/qtr</Description><GSTAmount>2.0471</GSTAmount><Period>1-Jun to 30-Sep</Period><PriceMeterType>UsageStep</PriceMeterType><UOM>c/MJ</UOM></Price><Price><Amount>1.559</Amount><Description>Remaining usage/qtr</Description><GSTAmount>1.7150</GSTAmount><Period>1-Jun to 30-Sep</Period><PriceMeterType>Remaining</PriceMeterType><UOM>c/MJ</UOM></Price><Price><Amount>1.768</Amount><Description>Gas 3 (peak) Usage first 5250 MJ/qtr</Description><GSTAmount>1.9448</GSTAmount><Period>1-Oct to 31-May</Period><PriceMeterType>UsageStep</PriceMeterType><UOM>c/MJ</UOM></Price><Price><Amount>1.408</Amount><Description>Remaining usage/qtr</Description><GSTAmount>1.5489</GSTAmount><Period>1-Oct to 31-May</Period><PriceMeterType>Remaining</PriceMeterType><UOM>c/MJ</UOM></Price></Prices><ProductClass>Gas</ProductClass><TariffDescription>Gas 3 (peak)</TariffDescription></Rate></Rates><TermConditions xmlns:a="http://schemas.microsoft.com/2003/10/Serialization/Arrays"><a:string>10 business days cooling off period</a:string><a:string>Any connection, disconnection or special meter reading charges incurred by Australian Power &amp; Gas will be charged to your account</a:string><a:string>Australian Power &amp; Gas may require a security deposit</a:string><a:string>Australian Power &amp; Gas may vary your tariff and/or pay on time discount by providing you with written notice</a:string><a:string>Australian Power &amp; Gas may perform a credit check</a:string></TermConditions><ValidationMessages i:nil="true"/></ProductDetail></c:set>
			</c:when>
			<c:otherwise>
				<c:import var="config" url="/WEB-INF/aggregator/utilities/config_product_details.xml" />
				<go:soapAggregator config = "${config}"
									transactionId = "${tranId}" 
									xml = "" 
									var = "productDetailsXml"
									debugVar="debugXml" />
			</c:otherwise>
		</c:choose>
							
		<%-- Add the results to the current session data --%>
		<%-- 
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${productDetailsXml}" />
		<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
		--%>

		<go:log>${productDetailsXml}</go:log>
		<go:log>${debugXml}</go:log>
	</c:when>
	<c:otherwise>
		<c:set var="productDetailsXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error>
		</c:set>		
		<go:setData dataVar="data" xpath="soap-response" xml="${productDetailsXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(productDetailsXml)}
