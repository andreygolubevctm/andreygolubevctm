<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%--

!!  WARNING  !!!

this was made for CUA so it may not work for other provider use and your own risk

--%>
<c:set var="ProviderId" value="" />
<c:if test="${not empty param.providerId}"><c:set var="ProviderId" value="${param.providerId}" /></c:if>
<c:if test="${not empty param.providerName}"><c:set var="providerName" value="${param.providerName}" /></c:if>

<sql:query var="products">
	SELECT concat(pp1.Text,'') as 'hospitalCoverName', concat(pp2.Text,'') as 'extrasCoverName'
	FROM ctm.product_properties pp1
	LEFT JOIN ctm.product_properties pp2
		ON pp1.productid = pp2.productid
				AND pp2.propertyId = 'extrasCoverName'
			WHERE
						pp1.propertyId = 'hospitalCoverName'
						AND pp1.productid IN (
							SELECT ProductId
							FROM ctm.product_master
							WHERE ProviderId = ?
								AND (Status != 'N' AND Status != 'X')
								AND ProductCat = 'HEALTH'
								AND EffectiveStart <= curDate() AND EffectiveEnd >= curDate()
						)
					GROUP BY pp1.Text, pp2.Text

					<sql:param value="${ProviderId}" />
</sql:query>

<c:set var="quote">"</c:set>
<promoData>
	<c:if test="${products.rowCount > 0}">
		<c:forEach var="rr" items="${products.rows}" varStatus="status">
			<c:set var="ignore">
			<c:choose>
				<%-- combined --%>
				<c:when test="${rr.hospitalCoverName == rr.extrasCoverName}">
					<c:set var="coverNameSplit" value="${fn:split(rr.extrasCoverName, '_')}" />
					<c:if test="${coverNameSplit[0] == 'C'}">
						<c:set var="situation" value="Couple" />
					</c:if>
					<c:if test="${coverNameSplit[0] == 'F'}">
							<c:set var="situation" value="Family" />
					</c:if>
					<c:if test="${coverNameSplit[0] == 'S'}">
							<c:set var="situation" value="Single" />
					</c:if>
					<c:if test="${coverNameSplit[0] == 'SP'}">
							<c:set var="situation" value="Single_Parent" />
					</c:if>

					<c:set var="fileName" value="${fn:replace(rr.extrasCoverName, '+', 'And')}" />
					<c:set var="fileName" value="${fn:replace(fileName, '- $', 'With_')}" />
					<c:set var="fileName" value="${fn:replace(fileName, '%', '_Percent')}" />
					<c:set var="fileName" value="${fn:replace(fileName, ' ', '_')}" />

					<c:set var="coverNames" value="hospital=${quote}${rr.hospitalCoverName}${quote} extras=${quote}${rr.extrasCoverName}${quote}" />
					<c:set var="hospitalPDF" value="health_fund_info/${providerName}/${coverNameSplit[1]}/Combined/${situation}/${fileName}.pdf" />
					<c:set var="possiableHospitalPDF" value="${hospitalPDF}" />
											<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_With_', '')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />

						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_Percent250_', '_Percent_250_')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />

						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_With_', '')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_Percent_', '_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_Percent_', '_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_With_', '_Percent_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false && coverNameSplit[1] == 'NSW'}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, 'NSW', 'ACT')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_And_', '_Percent_And_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<go:log>cannot find ${possiableHospitalPDF}</go:log>
						</c:if>
						<c:set var="hospitalPDF" value="${possiableHospitalPDF}" />
					<c:set var="extrasPDF" value="health_fund_info/${providerName}/${coverNameSplit[1]}/Combined/${situation}/${fileName}.pdf" />
					<c:set var="path" value="c:/Dev/web_ctm/WebContent/${extrasPDF}" />
					<c:if test="${file:exists(path) == false}">
						<c:set var="extrasPDF" value="${fn:replace(extrasPDF, 'Silver_Extras', 'Gold_Silver')}" />
					</c:if>
				</c:when>
					<c:when test="${not empty rr.hospitalCoverName && not empty rr.extrasCoverName}">
						<c:set var="coverNameSplit" value="${fn:split(rr.extrasCoverName, '_')}" />
						<c:if test="${coverNameSplit[0] == 'C'}">
							<c:set var="situation" value="Couple" />
						</c:if>
						<c:if test="${coverNameSplit[0] == 'F'}">
							<c:set var="situation" value="Family" />
						</c:if>
						<c:if test="${coverNameSplit[0] == 'S'}">
							<c:set var="situation" value="Single" />
						</c:if>
						<c:if test="${coverNameSplit[0] == 'SP'}">
							<c:set var="situation" value="Single_Parent" />
						</c:if>

						<c:set var="hospitalFileName" value="${fn:replace(rr.hospitalCoverName, '- $', 'With_')}" />
						<c:set var="hospitalFileName" value="${fn:replace(hospitalFileName, ' ', '_')}" />
						<c:set var="hospitalFileName" value="${fn:replace(hospitalFileName, '%', '_Percent')}" />
						<c:set var="fileName" value="${fn:replace(rr.extrasCoverName, '- $', 'With_')}" />
						<c:set var="fileName" value="${fn:replace(fileName, ' ', '_')}" />
						<c:set var="fileName" value="${fn:replace(fileName, '%', '_Percent')}" />

						<c:set var="coverNames" value="hospital=${quote}${rr.hospitalCoverName}${quote} extras=${quote}${rr.extrasCoverName}${quote}" />
						<c:set var="extrasPDF" value="health_fund_info/${providerName}/${coverNameSplit[1]}/Extras/${situation}/${fileName}.pdf" />
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${extrasPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="extrasPDF" value="${fn:replace(extrasPDF, 'Silver_Extras', 'Gold_Silver')}" />
						</c:if>

						<c:set var="hospitalPDF" value="health_fund_info/${providerName}/${coverNameSplit[1]}/Hospital/${situation}/${hospitalFileName}.pdf" />

						<c:set var="possiableHospitalPDF" value="${hospitalPDF}" />
											<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_With_', '')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />

						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_Percent250_', '_Percent_250_')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />

						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_With_', '')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_Percent_', '_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_Percent_', '_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_With_', '_Percent_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false && coverNameSplit[1] == 'NSW'}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, 'NSW', 'ACT')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_And_', '_Percent_And_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<go:log>cannot find ${possiableHospitalPDF}</go:log>
						</c:if>
						<c:set var="hospitalPDF" value="${possiableHospitalPDF}" />
					</c:when>
					<c:when test="${not empty rr.hospitalCoverName }">
						<c:set var="coverNameSplit" value="${fn:split(rr.hospitalCoverName, '_')}" />
						<c:if test="${coverNameSplit[0] == 'C'}">
							<c:set var="situation" value="Couple" />
						</c:if>
						<c:if test="${coverNameSplit[0] == 'F'}">
							<c:set var="situation" value="Family" />
						</c:if>
						<c:if test="${coverNameSplit[0] == 'S'}">
							<c:set var="situation" value="Single" />
						</c:if>
						<c:if test="${coverNameSplit[0] == 'SP'}">
							<c:set var="situation" value="Single_Parent" />
						</c:if>

						<c:set var="fileName" value="${fn:replace(rr.hospitalCoverName, '- $', 'With_')}" />
						<c:set var="fileName" value="${fn:replace(fileName, '%', '_Percent')}" />
						<c:set var="fileName" value="${fn:replace(fileName, ' ', '_')}" />

						<c:set var="coverNames" value="hospital=${quote}${rr.hospitalCoverName}${quote}" />
						<c:set var="hospitalPDF" value="health_fund_info/${providerName}/${coverNameSplit[1]}/Hospital/${situation}/${fileName}.pdf" />
						<c:set var="possiableHospitalPDF" value="${hospitalPDF}" />
												<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_With_', '')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />

						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_Percent250_', '_Percent_250_')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />

						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_With_', '')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_Percent_', '_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(hospitalPDF, '_Percent_', '_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_With_', '_Percent_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false && coverNameSplit[1] == 'NSW'}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, 'NSW', 'ACT')}" />
						</c:if>
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="possiableHospitalPDF" value="${fn:replace(possiableHospitalPDF, '_And_', '_Percent_And_')}" />
						</c:if>

						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${possiableHospitalPDF}" />
						<c:if test="${file:exists(path) == false}">
							<go:log>cannot find ${possiableHospitalPDF}</go:log>
						</c:if>
						<c:set var="hospitalPDF" value="${possiableHospitalPDF}" />
					</c:when>
					<c:otherwise>
							<c:set var="coverNameSplit" value="${fn:split(rr.extrasCoverName, '_')}" />
							<c:if test="${coverNameSplit[0] == 'C'}">
								<c:set var="situation" value="Couple" />
							</c:if>
							<c:if test="${coverNameSplit[0] == 'F'}">
								<c:set var="situation" value="Family" />
							</c:if>
							<c:if test="${coverNameSplit[0] == 'S'}">
								<c:set var="situation" value="Single" />
							</c:if>
							<c:if test="${coverNameSplit[0] == 'SP'}">
								<c:set var="situation" value="Single_Parent" />
							</c:if>

						<c:set var="fileName" value="${fn:replace(rr.extrasCoverName, '- $', 'With_')}" />
						<c:set var="fileName" value="${fn:replace(fileName, '%', '_Percent')}" />
						<c:set var="fileName" value="${fn:replace(fileName, ' ', '_')}" />

						<c:set var="coverNames" value="extras=${quote}${rr.extrasCoverName}${quote}" />
						<c:set var="extrasPDF" value="health_fund_info/${providerName}/${coverNameSplit[1]}/Extras/${situation}/${fileName}.pdf" />
						<c:set var="path" value="c:/Dev/web_ctm/WebContent/${extrasPDF}" />
						<c:if test="${file:exists(path) == false}">
							<c:set var="extrasPDF" value="${fn:replace(extrasPDF, 'Silver_Extras', 'Gold_Silver')}" />
						</c:if>
					</c:otherwise>
				</c:choose>
				</c:set>
	<promo ${coverNames} >
		<hospitalPDF>${hospitalPDF}</hospitalPDF>
		<extrasPDF>${extrasPDF}</extrasPDF>
		<promoText></promoText>
		<discountText></discountText>
	</promo>
		</c:forEach>
	</c:if>
</promoData>