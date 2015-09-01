<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="logger" value="${go:getLogger('jsp:data.upload')}" />
<fmt:parseDate var="startDate" value="${param.startDate}" type="DATE" pattern="dd/MM/yyyy"/>
<fmt:parseDate var="endDate" value="${param.endDate}" type="DATE" pattern="dd/MM/yyyy"/>

<settings:setVertical verticalCode="GENERIC" />

<sql:setDataSource dataSource="jdbc/ctm" />


<c:set var="environment">${environmentService.getEnvironmentAsString()}</c:set>
<c:set var="quoteType" value="LMI_Upload" />

<%-- EDIT THIS SHIT ONLY! --%>
<%-- -------------------- --%>
<%-- TODO: This would be CARLMI/HOMELMI in new version --%>
<c:set var="vertical" value="Carlmi" /> <%-- 'Carlmi', 'Homelmi' --%>
<c:set var="date" value="2015-07-13" /> <%-- Date in the file name --%>
<c:set var="debug" value="false"/> <%-- This will stop all Mysql transactions when true --%>
<c:set var="restart" value="false"/> <%-- Doesn't do much anymore. Used to TRUNCATE TABLE, but was removed... --%>
<c:set var="step_1" value="true"/>
<c:set var="step_2" value="true"/>
<c:set var="step_5" value="true"/>
<%-- -------------------- --%>
<%-- STOP EDITING...      --%>

<%-- Testing setting to true to see if it works... --%>
<c:set var="step_3" value="false"/> <%-- Must stay false. set to false to keep feature_category as is, instead of regenerating --%>
<c:set var="step_4" value="false"/> <%-- Must stay false. set to false to keep feature_details as is, instead of regenerating --%>

<%-- TODO --%>
<%-- 1. Need to handle x96 which is like a dash '-' --%>
<%-- 1. Need to handle x92 which is like a quote ''' --%>
<%-- 2. Need to handle line breaks within cells --%>
<%-- END TODO --%>

<c:set var="dataDocument" value="data/${vertical}-Features-Data/${date} - LMI Data.csv" />
<%-- TODO: change to feature --%>
<c:set var="defaultType">'F'</c:set>
<c:set var="defaultAI">'AI'</c:set>
<%-- TODO: change to CARLMI-COMP and HOMELMI-HOME --%>
<c:set var="defaultPolicyType">CARLMI-COMP, HOMELMI-H&C</c:set> <%-- Vertical-Value Pair for default Policy types, ONE per vertical--%>
<c:set var="badData">''</c:set>
<c:set var="badData2">'-'</c:set>
<c:set var="emptyData">'',''</c:set>
<c:set var="additionalInformationText">'Additional Information'</c:set>
<c:set var="crazyDelim" value="~"/>
<c:set var="check">\</c:set>
<c:set var="clean"></c:set>
<c:set var="insertVertical" value="${fn:toUpperCase(vertical)}"/>
<c:set var="insertQuotedVertical" value="'${insertVertical}'"/>

<c:choose>
	<c:when test="${debug == true }">
		<c:set var="debugStart">START TRANSACTION;</c:set>
		<c:set var="debugEnd">ROLLBACK;</c:set>
		<c:set var="debugMode"><h2 class="safe">DEBUG: ON (MySQL queries are still independent with no actual changes so false errors may appear)</h2></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="debugStart" value=""/>
		<c:set var="debugEnd" value=""/>
		<c:set var="debugMode"><h2 class="error">DEBUG: OFF</h2></c:set>
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${restart == true }">
		<c:set var="restartMode"><h2 class="error">RESTART: ON</h2></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="restartMode"><h2 class="safe">RESTART: OFF</h2></c:set>
	</c:otherwise>
</c:choose>

<core:doctype />
<go:html>
<%-- <core:head quoteType="${quoteType}" title="Upload ${vertical} Features"/> --%>

<go:style marker="css-head">
body {
	font-family: sans-serif;
	font-size: 11px;
}
.error {
	font-weight: Bold;
	color: red;
}
.warning {
	font-weight: Bold;
	color: orange;
}
.safe {
	font-weight: Bold;
	color: green;
}
</go:style>

<body>

<c:choose>
	<c:when test="${environment != 'localhost' }">
		<go:style marker="css-head">
		body {
			background-color: black;
			color: white;
			text-align: center;
		}
		h1 {
			text-align: center;
			font-size: 35px;
		}
		</go:style>
		<h1>Sergei says NO!</h1>
		<img src="/ctm/common/images/Sergei.jpg"/>

	</c:when>
	<c:otherwise>

		<h1>UPDATE ${insertVertical} LMI DATA</h1>

		${debugMode}
		${restartMode}

			<%-- ------------------------- --%>
			<%-- GATHER SOME INITIAL STATS --%>
			<%-- ------------------------- --%>

			<%-- ------------------------------ --%>
			<%-- Get the sheet dimensions		--%>
			<%-- ------------------------------ --%>
			<h2>Gathering Data...</h2>
			<go:importCsvToToken var="dimensions"
				csvFilePath="${dataDocument}"
				templateVar="'%0%'"
				startRow="0"
				hasDimensions="true"
				/>
			<c:set var="dimensionsLength" value="${fn:length(dimensions)}"/>
			<c:set var="dimensionsValues" value="${dimensions[dimensionsLength-1]}"/>
			<c:set var="dimensionsList" value="${fn:split(dimensionsValues, ':')}"/>
			<c:set var="columnz" value="${dimensionsList[0] - 1}"/> <%-- -1 for index starting at 0 in the data sheet shit --%>
			<c:set var="rowz" value="${dimensionsList[1] - 1}"/> <%-- -1 for index starting at 0 in the data sheet shit --%>
			${logger.debug('DIMENSIONS: ${columnz } (+1) x ${rowz } (+1)')}
			<p>Columnz: ${columnz } (+1)</p>
			<p>Rowz: ${rowz } (+1)</p>

			<%-- Lets work out the default Policy Type --%>
			<c:set var="defaultPolicyTypeArray" value="${fn:split(defaultPolicyType, ',')}"/>
			<c:forEach var="defaultPolicy" items="${defaultPolicyTypeArray}" varStatus="status">
				<c:set var="defaultPolicySubArray" value="${fn:split(defaultPolicy, '-')}"/>
				<c:if test="${fn:trim(fn:toUpperCase(defaultPolicySubArray[0])) == insertVertical}">
					<c:set var="defaultPolicyTypeName" value="${defaultPolicySubArray[1]}"/>
				</c:if>
			</c:forEach>
			<p>Default Policy Type: ${defaultPolicyTypeName}</p>
			${logger.debug('Default Policy Type: ${defaultPolicyTypeName}')}

			<%-- Initial database counts for use later... --%>
			<sql:query var="categoriesInitialData">
				SELECT * FROM aggregator.features_category WHERE vertical = ${insertQuotedVertical};
			</sql:query>
			${logger.debug('categoriesInitialData: SELECT * FROM aggregator.features_category WHERE vertical = ${insertQuotedVertical};')}


			<%-- -------------- --%>
			<%-- Data Lists		--%>
			<%-- -------------- --%>

			<c:if test="${restart eq false }">

			<sql:query var="initialProductData">
				SELECT id, brandId FROM aggregator.features_products WHERE vertical = '${insertVertical}';
			</sql:query>

			<c:set var="prefix" value="" />
			<c:forEach var="currentProduct" items="${initialProductData.rows}" varStatus="status">
				<%-- Product ID's  e.g 1,2,3,4,5--%>
				<c:set var="productIdList" value="${productIdList}${prefix}${currentProduct.id}" />

				<%-- Brand ID's 1911,1912,1913--%>
				<c:set var="contains" value="false"/>
				<c:set var="currentBrand" value="${currentProduct.brandId}"/>
				<c:forEach var="testBrand" items="${brandIdList}">
					<c:if test="${testBrand eq currentBrand}">
						<c:set var="contains" value="true"/>
					</c:if>
				</c:forEach>
				<c:if test="${contains eq false }">
					<c:set var="brandIdList" value="${brandIdList}${prefix}${currentBrand}" />
				</c:if>

				<c:set var="prefix" value="," />
			</c:forEach>
			<p>productIdList: '${productIdList}' </p>
			${logger.debug('productIdList: '${productIdList}' ')}
			<p>brandIdList: '${brandIdList }'</p>
			${logger.debug('brandIdList: '${brandIdList }'')}

			<%-- -------------- FEATURES MAIN DATA ------------- --%>
			<c:if test="${not empty productIdList}">
				<sql:query var="initialFeatureData">
					SELECT fid FROM aggregator.features_main WHERE pid IN (${productIdList});
				</sql:query>
				<c:set var="prefix" value="" />
				<c:forEach var="currentValue" items="${initialFeatureData.rows}" varStatus="status">
					<%-- Feature ID's --%>
					<c:set var="contains" value="false"/>
					<c:set var="currentFeature" value="${currentValue.fid}"/>
					<c:forEach var="testFeature" items="${featureIdList}">
						<c:if test="${testFeature eq currentFeature}">
							<c:set var="contains" value="true"/>
						</c:if>
					</c:forEach>
					<c:if test="${contains eq false }">
						<c:set var="featureIdList" value="${featureIdList}${prefix}${currentFeature}" />
					</c:if>

					<c:set var="prefix" value="," />
				</c:forEach>
			</c:if>
			<p>featureIdList: '${featureIdList }'</p>
			${logger.debug('featureIdList: '${featureIdList }'')}

				<%-- THIS SHOULDN'T BE NEEDED - AMS framework doesn't use feature_category to display categories of data on the page.
				It uses a fake feature row. --%>
			<c:set var="categoryIdList" value="" />
			<c:if test="${not empty featureIdList}">
				<sql:query var="initialCategoryData">
					SELECT categoryId FROM aggregator.features_details WHERE id IN (${featureIdList});
				</sql:query>
				<c:set var="prefix" value="" />
				<c:forEach var="currentValue" items="${initialCategoryData.rows}" varStatus="status">
					<%-- Category ID's --%>
					<c:set var="contains" value="false"/>
					<c:set var="currentCategory" value="${currentValue.categoryId}"/>
					<c:forEach var="testCategory" items="${categoryIdList}">
						<c:if test="${testCategory eq currentCategory}">
							<c:set var="contains" value="true"/>
						</c:if>
					</c:forEach>
					<c:if test="${contains eq false }">
						<c:set var="categoryIdList" value="${categoryIdList}${prefix}${currentCategory}" />
					</c:if>

					<c:set var="prefix" value="," />
				</c:forEach>
			</c:if>
			<p>categoryIdList: '${categoryIdList }'</p>
			${logger.debug('categoryIdList: '${categoryIdList }'')}

			</c:if>


			<sql:query var="productsInitialQuery">
				SELECT count(id) as count FROM aggregator.features_products WHERE vertical = ${insertQuotedVertical};
			</sql:query>
			<c:forEach var="productsInitial" items="${productsInitialQuery.rows}" varStatus="status"><c:set var="productsInitialResult" value="${productsInitial.count }"/></c:forEach>
			<c:choose>
				<c:when test="${not empty brandIdList}">
					<sql:query var="brandsInitialQuery">
						SELECT count(id) as count FROM aggregator.features_brands WHERE id IN (${brandIdList});
					</sql:query>
					<c:forEach var="brandsInitial" items="${brandsInitialQuery.rows}" varStatus="status"><c:set var="brandsInitialResult" value="${brandsInitial.count }"/></c:forEach>
				</c:when>
				<c:otherwise>
					<c:set var="brandsInitialResult" value="0"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${not empty categoryIdList}">
					<sql:query var="categoriesInitialQuery">
						SELECT count(id) as count FROM aggregator.features_category WHERE id IN (${categoryIdList});
					</sql:query>
					<c:forEach var="categoriesInitial" items="${categoriesInitialQuery.rows}" varStatus="status"><c:set var="categorysInitialResult" value="${categoriesInitial.count }"/></c:forEach>
				</c:when>
				<c:otherwise>
					<c:set var="categorysInitialResult" value="0"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${not empty featureIdList}">
					<sql:query var="detailsInitialQuery">
						SELECT count(id) as count FROM aggregator.features_details WHERE id IN (${featureIdList});
					</sql:query>
					<c:forEach var="detailsInitial" items="${detailsInitialQuery.rows}" varStatus="status"><c:set var="detailsInitialResult" value="${detailsInitial.count }"/></c:forEach>
				</c:when>
				<c:otherwise>
					<c:set var="detailsInitialResult" value="0"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${not empty productIdList}">
					<sql:query var="mainInitialQuery">
						SELECT count(id) as count FROM aggregator.features_main WHERE pid IN (${productIdList});
					</sql:query>
					<c:forEach var="mainInitial" items="${mainInitialQuery.rows}" varStatus="status"><c:set var="mainInitialResult" value="${mainInitial.count }"/></c:forEach>
				</c:when>
				<c:otherwise>
					<c:set var="mainInitialResult" value="0"/>
				</c:otherwise>
			</c:choose>

			<%-- ------------------------- --%>
			<%-- FEATURES BRANDS	       --%>
			<%-- ------------------------- --%>
			<c:if test="${step_1 eq true }">
			${logger.debug('STARTING FEATURES BRANDS')}

			<h2>Step 1. features_Brands</h2>

			<c:set var="features_brands" value="${go:getStringBuilder()}" />
			${go:appendString(features_brands ,'INSERT INTO aggregator.features_brands (displayName, realName) VALUES ')}

				<%-- Builds new features_brands records to add in --%>
			<c:set var="features_brand" value="${go:getStringBuilder()}" />
			<c:set var="features_brand_guts" value="${go:getStringBuilder()}" />
			<c:set var="prefix" value="" />
			<c:forEach var="i" begin="2" end="${rowz}">
				<go:importCsvToToken var="featuresBrand"
					csvFilePath="${dataDocument}"
					templateVar="'%0%'${crazyDelim}'%1%'"
					startRow="${i}" endRow="${i+1}"
					encodeHtml="true"
					/>

					<%-- Use this to work out if we have contained the category already or not so that we dont duplicate --%>
					<c:set var="featuresBrandArray" value="${fn:split(featuresBrand , crazyDelim)}" />
					<c:set var="currentBrand">${featuresBrandArray[0]}</c:set>
					<c:set var="currentBrandClean" value="${fn:replace(currentBrand, '[', '')}" />
					<c:set var="contains" value="true" />
					<c:forEach var="testBrand" items="${existingBrands}">
						<c:if test="${testBrand eq currentBrandClean}">
							<c:set var="contains" value="false" />
						</c:if>
					</c:forEach>
					<c:set var="featuresBrandClean" value="${fn:replace(featuresBrand[0], crazyDelim, ',')}" />
					<c:choose>
						<c:when test="${fn:contains(featuresBrand[0], badData) || empty featuresBrand[0]}">
							<div class="error">ERROR: NO BRAND DETECTED (something is missing man...) | BRAND: '${featuresBrand[0]}'|</div>
						</c:when>
						<c:otherwise>
							<c:if test="${contains eq true}">
								${go:appendString(features_brand_guts , prefix)}
								${go:appendString(features_brand_guts ,'(')}
								<c:set var="existingBrands">${existingBrands}${prefix}${currentBrandClean}</c:set>
								<c:set var="prefix" value="," />
								${go:appendString(features_brand_guts , featuresBrandClean)}
								${go:appendString(features_brand_guts ,')')}
							</c:if>
						</c:otherwise>
					</c:choose>
			</c:forEach>

			${go:appendString(features_brands , features_brand_guts)}
			${go:appendString(features_brands , ';')}
			${features_brands.toString()}
			<%-- DELETES EXISTING FEATURES_BRANDS AND INSERTS NEW ONE --%>
			<c:catch var="features_brands_delete">
				<sql:transaction>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugStart}</sql:update>
					</c:if>
					<c:if test="${not empty brandIdList}">
						<sql:update>
							<c:choose>
								<c:when test="${restart eq true}">
								</c:when>
								<c:otherwise>
									DELETE FROM aggregator.features_brands WHERE id IN (${brandIdList});
								</c:otherwise>
							</c:choose>
						</sql:update>
					</c:if>
					<sql:update>
						${features_brands.toString()}
					</sql:update>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugEnd}</sql:update>
					</c:if>
				</sql:transaction>
			</c:catch>

			<h3>UPDATING features_brands: </h3>
			<p class="error">${features_brands_delete }</p>
			</c:if>
			<%-- ------------------------- --%>
			<%-- FEATURES PRODUCTS	       --%>
			<%-- ------------------------- --%>
			<c:if test="${step_2 eq true }">
			${logger.debug('STARTING FEATURES PRODUCTS')}

			<h2>Step 2. features_Products</h2>

			<sql:query var="brandData">
				SELECT displayName, id FROM aggregator.features_brands;
			</sql:query>

			<sql:query var="productTypeData">
				SELECT id, code FROM aggregator.features_product_type;
			</sql:query>

			<c:set var="prefix" value="" />

			<go:importCsvToToken var="featuresProducts"
				csvFilePath="${dataDocument}"
				templateVar="'%3%','%DATE:5%', '%4%','${insertVertical}':'%0%':'%2%':'%4%'"
				startRow="2"
				encodeHtml="true"
				/>

				<c:set var="features_products" value="${go:getStringBuilder()}" />
				${go:appendString(features_products ,'INSERT INTO aggregator.features_products (name, date, ref, vertical, brandId, product_type) VALUES ')}

				<%-- Add the operator to the list details - if exists --%>
				<c:forEach var="featuresProduct" items="${featuresProducts}" varStatus="status" begin="0">
					<c:set var="featuresProductArray" value="${fn:split(featuresProduct , ':')}" />

					<%-- Lettuce find the Brand ID for this --%>
					<c:set var="brandID"></c:set>
					<c:forEach var="brand" items="${brandData.rows}" varStatus="status">
						<c:set var="brandName">'${brand.displayName}'</c:set>
						<c:if test="${featuresProductArray[1] eq brandName}">
							<c:set var="brandID">${brand.id}</c:set>
						</c:if>
					</c:forEach>
					<%-- Lettuce find the Product Type ID for this --%>

					<c:choose>
						<c:when test="${featuresProductArray[2] eq badData }">
							<c:set var="policyTypeName">'${defaultPolicyTypeName}'</c:set>
						</c:when>
						<c:otherwise>
							<c:set var="policyTypeName">${featuresProductArray[2]}</c:set>
						</c:otherwise>
					</c:choose>

					<c:set var="productTypeID"></c:set>
					<c:forEach var="productType" items="${productTypeData.rows}" varStatus="status">
						<c:set var="productTypeCode">'${productType.code}'</c:set>
						<c:if test="${policyTypeName eq productTypeCode}">
							<c:set var="productTypeID">${productType.id}</c:set>
						</c:if>
					</c:forEach>

					<c:set var="contains" value="false" />
					<c:set var="currentLMIRef">${featuresProductArray[3]}</c:set>
					<c:forEach var="testLMIRef" items="${existingLMIRef}">
						<c:if test="${testLMIRef eq currentLMIRef}">
							<c:set var="contains" value="true" />
						</c:if>
					</c:forEach>

					<c:choose>
						<c:when test="${featuresProductArray[0] != badData && not empty brandID && productTypeID != badData}">
							<c:choose>
								<c:when test="${contains eq false}"> <%--At this stage we want to still insert the product even with a duplicated reference... --%>
									<c:set var="existingLMIRef">${existingLMIRef}${prefix}${currentLMIRef}</c:set>
								</c:when>
								<c:otherwise>
									<div class="warning">WARNING!: DUPLICATED LMI REFERENCE' ${currentLMIRef}</div>
								</c:otherwise>
							</c:choose>
							${go:appendString(features_products , prefix)}
							<c:set var="prefix" value="," />
							${go:appendString(features_products , '(')}
							${go:appendString(features_products , featuresProductArray[0])}
							${go:appendString(features_products , prefix)}
							${go:appendString(features_products , brandID)}
							${go:appendString(features_products , prefix)}
							${go:appendString(features_products , productTypeID)}
							${go:appendString(features_products , ')')}
						</c:when>
						<c:when test="${fn:contains(featuresProduct, emptyData) || empty brandID}">
							<%-- This is due to LMI data with extra blank rows added to the xslx so just ignore --%>
							<div class="error">EMPTY DATA: OMITTING: ${featuresProductArray[0]}</div>
						</c:when>
						<c:otherwise>
							<div class="error">ERROR: OMITTING: ${featuresProductArray[0]}</div>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				${go:appendString(features_products , ';')}
				${features_products.toString()}
				<c:set var="features_products_delete">
					<sql:transaction>
						<c:if test="${debug == 'true' }">
							<sql:update>${debugStart}</sql:update>
						</c:if>
						<c:if test="${not empty productIdList}">
							<sql:update>
								<c:choose>
									<c:when test="${restart eq true}">
									</c:when>
									<c:otherwise>
										DELETE FROM aggregator.features_products WHERE id IN (${productIdList});
									</c:otherwise>
								</c:choose>
							</sql:update>
						</c:if>
						<sql:update>
							${features_products.toString()}
						</sql:update>
						<c:if test="${debug == 'true' }">
							<sql:update>${debugEnd}</sql:update>
						</c:if>
					</sql:transaction>
				</c:set>

			<h3>UPDATING features_products: ${features_products_delete }</h3>
			</c:if>
			<%-- ------------------------- --%>
			<%-- FEATURES CATEGORIES       --%>
			<%-- ------------------------- --%>
			<c:if test="${step_3 eq true }">
			${logger.debug('STARTING FEATURES CATEGORIES')}

			<h2>Step 3. features_category</h2>
			<c:set var="features_category" value="${go:getStringBuilder()}" />
			<c:set var="features_category_guts" value="${go:getStringBuilder()}" />
			<c:set var="prefix" value="" />
			${go:appendString(features_category ,'INSERT INTO  aggregator.features_category (name, sequence, vertical) VALUES ')}

			<c:forEach var="i" begin="6" end="${columnz}" step="2">

				<%-- TODO UPDATE TO ADD NEW features_details entries for "fake features" for the titles.--%>
				<go:importCsvToToken var="featuresCategory"
					csvFilePath="${dataDocument}"
					templateVar="%${i}%"
					startRow="0" endRow="1"
					encodeHtml="true"
					/>
						<c:set var="newCategoryName">'${fn:trim(featuresCategory[0])}'</c:set>
						<%-- Attempt to match up the existing category orders with the new categories. This won't be perfect, like if someone changes a name... --%>
						<c:set var="categoryOrder">999</c:set>
						<c:forEach var="category" items="${categoriesInitialData.rows}" varStatus="status">
							<c:set var="categoryName">'${category.name}'</c:set>
							<c:if test="${newCategoryName eq categoryName}">
								<c:set var="categoryOrder">${category.sequence}</c:set>
							</c:if>
						</c:forEach>

						<%-- Use this to work out if we have contained the category already or not so that we dont duplicate --%>
						<c:set var="contains" value="true" />
						<c:forEach var="testCategory" items="${existingCategories}">
							<c:if test="${testCategory eq newCategoryName}">
								<c:set var="contains" value="false" />
							</c:if>
						</c:forEach>

						<c:if test="${categoryOrder == 999 && contains eq true}">
							<div class="warning">Warning: No Order found for ${newCategoryName}</div>
						</c:if>
						<c:choose>
							<c:when test="${fn:contains(newCategoryName, badData)}">
								<div class="error">ERROR: NO CATEGORY DETECTED (OMITTED)</div>
							</c:when>
							<c:otherwise>
								<c:if test="${contains eq true}">
									${go:appendString(features_category_guts , prefix)}
									${go:appendString(features_category_guts ,'(')}
									<c:set var="existingCategories">${existingCategories}${prefix}${newCategoryName}</c:set>
									<c:set var="prefix" value="," />
									${go:appendString(features_category_guts , newCategoryName)}
									${go:appendString(features_category_guts , prefix)}
									${go:appendString(features_category_guts , categoryOrder)}
									${go:appendString(features_category_guts , prefix)}
									${go:appendString(features_category_guts , insertQuotedVertical)}
									${go:appendString(features_category_guts ,')')}
								</c:if>
							</c:otherwise>
						</c:choose>
			</c:forEach>
			${go:appendString(features_category , features_category_guts)}
			${go:appendString(features_category ,';')}
			${features_category.toString()}

			<c:set var="features_category_replace">
				<sql:transaction>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugStart}</sql:update>
					</c:if>
					<c:if test="${not empty categoryIdList || restart eq true}">
						<sql:update>
							<c:choose>
								<c:when test="${restart eq true}">
								</c:when>
								<c:otherwise>
									DELETE FROM aggregator.features_category WHERE id IN (${categoryIdList});
								</c:otherwise>
							</c:choose>
						</sql:update>
					</c:if>
					<c:if test="${debug != 'true' }"> <%-- Unique name's required so this bombs out in normal debug mode... --%>
						<sql:update>
							${features_category.toString()}
						</sql:update>
					</c:if>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugEnd}</sql:update>
					</c:if>
				</sql:transaction>
			</c:set>

			<h3>UPDATING features_category: ${features_category_replace }</h3>
			</c:if>
			<%-- ------------------------- --%>
			<%-- FEATURES DETAILS	       --%>
			<%-- ------------------------- --%>
			<c:if test="${step_4 eq true }">
			${logger.debug('STARTING FEATURES DETAILS')}

			<h2>Step 4. features_details</h2>
			<c:set var="features_details" value="${go:getStringBuilder()}" />
			<c:set var="prefixBracket" value="(" />
			${go:appendString(features_details ,'INSERT INTO  aggregator.features_details (name, type, status, categoryId, vertical) VALUES ')}

			<%-- Grab the Categories ID's so we can avoid the need for lube --%>
			<sql:query var="categoryData">
				SELECT * FROM aggregator.features_category;
			</sql:query>

			<c:set var="prefix" value="" />
				<%-- TODO: THIS MAY BE REMOVED IF FEATURES_DETAILS ARE MANUALLY ADDED
				detect if new column appears in spreadsheet that isn't in features_details.
				APPEARS TO BE DYNAMICALLY CREATED BASED ON WHATS IN THE RATE SHEET. --%>
			<c:forEach var="i" begin="6" end="${columnz}" step="2">
				${go:appendString(features_details , prefix)}
				${go:appendString(features_details , prefixBracket)}
				<go:importCsvToToken var="featuresDetails"
					csvFilePath="${dataDocument}"
					templateVar="%${i}%"
					startRow="-1" endRow="2"
					encodeHtml="true"
					/>
					<c:set var="categoryName" value="'${fn:trim(featuresDetails[1])}'"/>
					<%-- Lettuce find the Category ID for this --%>
					<c:forEach var="category" items="${categoryData.rows}" varStatus="status">
						<c:set var="newCategoryName">'${category.name}'</c:set>
						<c:if test="${categoryName eq newCategoryName}">
							<c:set var="categoryID">${category.id}</c:set>
						</c:if>
					</c:forEach>

					<c:set var="prefix" value="," />
					<c:set var="featureName">${fn:trim(featuresDetails[2])}</c:set>

					<c:if test="${fn:length(featureName) == 1 }"> <!-- Cater for additional information sorting (prevent ordering as 1, 10, 11, 12, 2, 3, 4) -->
						<c:set var="featureName">0${featureName}</c:set>
					</c:if>
					<c:set var="featureName">'${featureName}'</c:set>

					<c:set var="featureType">'${fn:trim(featuresDetails[0])}'</c:set>
					${go:appendString(features_details , featureName)}
					${go:appendString(features_details , prefix)}
					<%-- TODO: Don't want it to re-create this, as we have more data to add to it that doesn't come from the rate sheet --%>
					<c:choose>
						<c:when test="${featureType eq badData}">
							<div class="error">ERROR: TYPE omitted again: ${featuresDetails[2]} -> Setting to ${defaultType} (${featureType})</div>
							${go:appendString(features_details , defaultType)}
						</c:when>
						<c:otherwise>
							${go:appendString(features_details , featureType)}
						</c:otherwise>
					</c:choose>
					${go:appendString(features_details , prefix)}
					${go:appendString(features_details , "1")}
					${go:appendString(features_details , prefix)}
					${go:appendString(features_details , categoryID)}
					${go:appendString(features_details , prefix)}
					${go:appendString(features_details , insertQuotedVertical)}
					${go:appendString(features_details , ')')}

			</c:forEach>
			${go:appendString(features_details ,';')}
			${features_details.toString()}

			<c:set var="features_details_replace">
				<sql:transaction>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugStart}</sql:update>
					</c:if>
					<c:if test="${not empty featureIdList || restart eq true}">
						<sql:update>
							<c:choose>
								<c:when test="${restart eq true}">
								</c:when>
								<c:otherwise>
									DELETE FROM aggregator.features_details WHERE id IN (${featureIdList});
								</c:otherwise>
							</c:choose>
						</sql:update>
					</c:if>
					<sql:update>
						${features_details.toString()}
					</sql:update>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugEnd}</sql:update>
					</c:if>
				</sql:transaction>
			</c:set>

			<h3>UPDATING features_details: ${features_details_replace }</h3>

			</c:if>
			<%-- ------------------------- --%>
			<%-- FEATURES MAIN		       --%>
			<%-- ------------------------- --%>
			<c:if test="${step_5 eq true }">
			${logger.debug('STARTING FEATURES MAIN')}

			<h2>Step 5. features_main</h2>
			<c:set var="features_main" value="${go:getStringBuilder()}" />
			<c:set var="prefixBracket" value="(" />
			${go:appendString(features_main ,'INSERT INTO  aggregator.features_main (pid, fid, val, description) VALUES ')}

			<sql:query var="productsData">
				SELECT ref, id, name FROM aggregator.features_products;
			</sql:query>
			<sql:query var="detailsData">
				SELECT fd.name as name, fd.id as id, fc.name as category
				FROM aggregator.features_details as fd
				LEFT JOIN aggregator.features_category as fc
				ON fd.categoryId = fc.id
				WHERE fd.vertical = ${insertQuotedVertical} AND fc.vertical = ${insertQuotedVertical};
			</sql:query>
			<sql:query var="AICategoryResult">
				SELECT id FROM aggregator.features_category WHERE name = ${additionalInformationText} AND vertical = ${insertQuotedVertical};
			</sql:query>
			<c:forEach var="AICategory" items="${AICategoryResult.rows}" varStatus="status">
				<c:set var="AICategoryId">${AICategory.id}</c:set>
			</c:forEach>

			<sql:query var="AIData">
				SELECT id FROM aggregator.features_details WHERE categoryId = ${AICategoryId};
			</sql:query>
			<c:set var="prefix" value="" />
			<c:forEach var="currentValue" items="${AIData.rows}" varStatus="status">
				<%-- Category ID's --%>
				<c:set var="contains" value="false"/>
				<c:set var="currentId" value="${currentValue.id}"/>
				<c:forEach var="testCategory" items="${AICategoryIdList}">
					<c:if test="${testCategory eq currentId}">
						<c:set var="contains" value="true"/>
					</c:if>
				</c:forEach>
				<c:if test="${contains eq false }">
					<c:set var="AICategoryIdList" value="${AICategoryIdList}${prefix}${currentId}" />
				</c:if>

				<c:set var="prefix" value="," />
			</c:forEach>

			<c:set var="prefix" value="" />
			<%-- Iterate down each Column --%>
			<c:forEach var="col" begin="6" end="${columnz}" step="2">
				<go:importCsvToToken var="featuresMainName"
					csvFilePath="${dataDocument}"
					templateVar="%${col}%"
					startRow="0" endRow="2"
					encodeHtml="true"
				/>
				<c:if test="${featuresMainName[0] != badData }">
					<c:set var="categoryName">'${fn:trim(featuresMainName[0])}'</c:set>
				</c:if>
				<c:if test="${featuresMainName[1] != badData }">
					<c:set var="featureName">${fn:trim(featuresMainName[1])}</c:set>
					<c:if test="${fn:length(featureName) == 1 }"> <!-- Cater for additional information sorting (prevent ordering as 1, 10, 11, 12, 2, 3, 4) -->
						<c:set var="featureName">0${featureName}</c:set>
					</c:if>
					<c:set var="featureName">'${featureName}'</c:set>
				</c:if>

				<%-- Iterate for each row --%>
				<c:forEach var="row" begin="2" end="${rowz}">

					<go:importCsvToToken var="featuresMain"
						csvFilePath="${dataDocument}"
						templateVar="'%4%'${crazyDelim}'%3%'${crazyDelim}'%${col}%'${crazyDelim}'%${col+1}%'"
						startRow="${row}" endRow="${row+1}"
						encodeHtml="true"
					/>
					<c:set var="featuresMainClean1" value="${fn:replace(featuresMain, '[', '')}" />
					<c:set var="featuresMainClean2" value="${fn:replace(featuresMainClean1, ']', '')}" />
					<c:set var="featuresMainArray" value="${fn:split(featuresMainClean2, crazyDelim)}" />

					<%-- Lettuce find the product ID for this --%>
					<c:set var="productID">''</c:set>
					<c:set var="detailsID">''</c:set>
					<c:forEach var="product" items="${productsData.rows}" varStatus="status">
						<c:set var="productRef">'${product.ref}'</c:set>
						<c:set var="productName">'${product.name}'</c:set>
						<c:if test="${featuresMainArray[0] eq productRef && featuresMainArray[1] eq productName}">
							<c:set var="productID">${product.id}</c:set>
						</c:if>
					</c:forEach>
					<c:set var="featureValue" value="'${fn:trim(fn:substring(featuresMainArray[2], 1, fn:length(featuresMainArray[2])-1))}'"/>
					<c:set var="featureExtraValue" value="'${fn:trim(fn:substring(featuresMainArray[3], 1, fn:length(featuresMainArray[3])-1))}'"/>

					<c:if test="${featureValue == badData2 }">
						<c:set var="featureValue" value="''"/>
					</c:if>
					<c:if test="${featureExtraValue == badData2 }">
						<c:set var="featureExtraValue" value="''"/>
					</c:if>
					<%-- Lettuce find the feature ID for this --%>
					<c:forEach var="details" items="${detailsData.rows}" varStatus="status">
						<c:set var="detailsName">${details.name}</c:set>
						<c:if test="${fn:length(detailsName) == 1 }"> <!-- Cater for additional information sorting (prevent ordering as 1, 10, 11, 12, 2, 3, 4) -->
							<c:set var="detailsName">0${detailsName}</c:set>
						</c:if>
						<c:set var="detailsName">'${detailsName}'</c:set>
						<c:set var="detailsCategory">'${details.category}'</c:set>
						<c:set var="featureNameClean" value="${fn:replace(featureName, check, clean)}" />
						<c:set var="categoryNameClean" value="${fn:replace(categoryName, check, clean)}" />

						<c:if test="${(featureNameClean eq detailsName) && categoryNameClean eq detailsCategory}">
							<c:set var="detailsID">${details.id}</c:set>
						</c:if>
					</c:forEach>

					<%-- Special case for Additional Information Section. If 'AI' is not specified for the value then default to it --%>
					<c:set var="contains" value="false" />
					<c:forEach var="item" items="${AICategoryIdList}">
						<c:if test="${item eq detailsID}">
							<c:set var="contains" value="true" />
						</c:if>
					</c:forEach>
					<c:if test="${contains eq true && (featureValue == badData && featureExtraValue != badData)}">
						<c:set var="featureValue" value="${defaultAI}"/>
					</c:if>

					<%-- Special case for Additional Information Section. If 'AI' IS specified for the value but has no ExtraValue then remove it --%>
					<c:if test="${featureValue == defaultAI && featureExtraValue == badData }">
						<c:set var="featureValue" value="''"/>
					</c:if>

					<%-- Temporary Truncation of data due to database size - Pending feedback 		--%>
					<%-- -------------------------------------------------------------------------- --%>
					<c:if test="${(fn:length(featureValue)) > 45 }">
						${logger.debug('VALUE: ${fn:length(featureValue)} : ${featureValue}')}
						<c:set var="featureValue" value="${fn:substring(featureValue, 0, 43)}'"/>
					</c:if>

					<c:if test="${(fn:length(featureExtraValue)) > 999 }">
						${logger.debug('DESCRIPTION: ${fn:length(featureExtraValue)} : ${featureExtraValue}')}
						<c:set var="featureExtraValue" value="${fn:substring(featureExtraValue, 0, 997)}'"/>
					</c:if>
					${logger.debug('Done ')}
					<%-- -------------------------------------------------------------------------- --%>

					<c:choose>
						<c:when test="${detailsID eq badData || productID eq badData}">
							${logger.debug('ERROR: Bad Data with DetailID or ProductID: OMITTING ${featureName} || ${featuresMainArray[0]} [ FID: ${detailsID} | PID: ${productID } ]')}
							<div class="error">ERROR: Bad Data (Row ${row}, Col ${col}) with DetailID or ProductID: OMITTING ${featureName } || ${featuresMainArray[0] } [ FID: ${detailsID } | PID: ${productID } ]</div>
						</c:when>
						<c:otherwise>
							<%--${logger.debug('${featureName } || ${featuresMainArray[0] } [ FID: ${detailsID } | PID: ${productID } ]')}--%>
							${go:appendString(features_main , prefix)}
							${go:appendString(features_main , prefixBracket)}
							<c:set var="prefix" value="," />
							${go:appendString(features_main , productID)}
							${go:appendString(features_main , prefix)}
							${go:appendString(features_main , detailsID)} <%-- FID --%>
							${go:appendString(features_main , prefix)}
							${go:appendString(features_main , featureValue)}
							${go:appendString(features_main , prefix)}
							${go:appendString(features_main , featureExtraValue)}
							${go:appendString(features_main , ')')}
						</c:otherwise>
					</c:choose>
				</c:forEach>
				${logger.debug('Done Col: ${featureName}')}
			</c:forEach>
			${logger.debug('Done here')}
			${go:appendString(features_main ,';')}
			<p>${features_main.toString()}</p>
				${logger.debug('Done here2')}
			<c:set var="features_main_replace">
				<sql:transaction>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugStart}</sql:update>
					</c:if>
					<c:if test="${not empty featureIdList}">
						<sql:update>
							<c:choose>
								<c:when test="${restart eq true}">
								</c:when>
								<c:otherwise>
									DELETE FROM aggregator.features_main WHERE fid IN (${featureIdList});
								</c:otherwise>
							</c:choose>
						</sql:update>
					</c:if>
					<sql:update>
						${features_main.toString()}
					</sql:update>
					<c:if test="${debug == 'true' }">
						<sql:update>${debugEnd}</sql:update>
					</c:if>
				</sql:transaction>
			</c:set>
				${logger.debug('Done here3')}
			<h3>UPDATING features_main: ${features_main_replace }</h3>
			</c:if>
			<%-- ------------------------- --%>
			<%-- FEATURES RESULTS		       --%>
			<%-- ------------------------- --%>
			<c:if test="${debug != 'true' }">
				${logger.debug('PRINTING RESULTS')}
				<h1>RESULTS</h1>

				<sql:query var="brands">
					SELECT count(id) as count FROM aggregator.features_brands;
				</sql:query>
				<sql:query var="categories">
					SELECT count(id) as count FROM aggregator.features_category WHERE vertical = ${insertQuotedVertical};
				</sql:query>
				<sql:query var="products">
					SELECT count(id) as count FROM aggregator.features_products WHERE vertical = ${insertQuotedVertical};
				</sql:query>
				<sql:query var="details">
					SELECT count(id) as count FROM aggregator.features_details;
				</sql:query>
				<sql:query var="main">
					SELECT count(id) as count FROM aggregator.features_main;
				</sql:query>

			</c:if>

			${debugMode}
			${restartMode}

			<table width="100%" border=1 cellspacing=0 cellpadding=5>
				<tr>
					<th>TABLE</th>
					<th>ORIGINAL</th>
					<th>NEW</th>
				</tr>
				<tr>
					<td>BRANDS (features_brands)</td>
					<td>${brandsInitialResult}</td>
					<td><c:forEach var="brand" items="${brands.rows}" varStatus="status">${brand.count}</c:forEach></td>
				</tr>
				<tr>
					<td>CATEGORIES (features_category)</td>
					<td>${categorysInitialResult}</td>
					<td><c:forEach var="category" items="${categories.rows}" varStatus="status">${category.count}</c:forEach></td>
				</tr>
				<tr>
					<td>PRODUCTS (features_products)</td>
					<td>${productsInitialResult}</td>
					<td><c:forEach var="product" items="${products.rows}" varStatus="status">${product.count}</c:forEach></td>
				</tr>
				<tr>
					<td>FEATURES (features_details)</td>
					<td>${detailsInitialResult}</td>
					<td><c:forEach var="detail" items="${details.rows}" varStatus="status">${detail.count}</c:forEach></td>
				</tr>
				<tr>
					<td>TOTAL FEATURES (features_main)</td>
					<td>${mainInitialResult}</td>
					<td><c:forEach var="main" items="${main.rows}" varStatus="status">${main.count}</c:forEach></td>
				</tr>
			</table>
		</c:otherwise>
	</c:choose>
</body>
</go:html>