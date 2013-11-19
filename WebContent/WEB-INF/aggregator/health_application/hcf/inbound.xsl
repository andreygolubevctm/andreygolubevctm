<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">hcf</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<!--
				This list of error codes is based on the HCF's Web Service Function Specification
				(EAPP_Functional_Specification_v03.2.docx) which is attached to job HLT-90.
			-->
			<error code="001">000</error>
			<error code="002">001</error>
			<error code="003">002</error>
			<error code="004">003</error>
			<error code="005">004</error>
			<error code="006">005</error>
			<error code="007">022</error>
			<error code="008">023</error>
			<error code="009">024</error>
			<error code="011">025</error>
			<error code="013">021</error>
			<error code="014">000</error>
			<error code="015">033</error>
			<error code="016">042</error>
			<error code="017">000</error>
			<error code="018">000</error>
			<error code="019">000</error>
			<error code="020">000</error>
			<error code="021">000</error>
			<error code="022">059</error>
			<error code="024">061</error>
			<error code="025">063</error>
			<error code="026">000</error>
			<error code="027">000</error>
			<error code="028">000</error>
			<error code="029">000</error>
			<error code="030">000</error>
			<error code="031">007</error>
			<error code="032">008</error>
			<error code="033">009</error>
			<error code="034">010</error>
			<error code="035">011</error>
			<error code="036">013</error>
			<error code="037">014</error>
			<error code="038">015</error>
			<error code="039">016</error>
			<error code="040">017</error>
			<error code="041">000</error>
			<error code="057">000</error>
			<error code="058">000</error>
			<error code="059">044</error>
			<error code="060">049</error>
			<error code="061">000</error>
			<error code="062">050</error>
			<error code="063">051</error>
			<error code="064">052</error>
			<error code="065">053</error>
			<error code="069">046</error>
			<error code="070">048</error>
			<error code="071">047</error>
			<error code="072">000</error>
			<error code="073">034</error>
			<error code="074">035</error>
			<error code="075">000</error>
			<error code="076">000</error>
			<error code="077">000</error>
			<error code="078">000</error>
			<error code="079">000</error>
			<error code="086">021</error>
			<error code="088">000</error>
			<error code="093">000</error>
			<error code="094">000</error>
			<error code="095">021</error>
			<error code="096">006</error>
			<error code="097">032</error>
			<error code="098">000</error>
			<error code="099">000</error>
			<error code="100">000</error>
			<error code="101">012</error>
			<error code="102">019</error>
			<error code="103">000</error>
			<error code="105">000</error>
			<error code="106">000</error>
			<error code="107">000</error>
			<error code="109">000</error>
			<error code="110">000</error>
			<error code="111">000</error>
			<error code="112">000</error>
			<error code="113">021</error>
			<error code="117">000</error>
			<error code="119">000</error>
			<error code="124">000</error>
			<error code="127">000</error>
			<error code="128">000</error>
			<error code="130">032</error>
			<error code="131">131</error>
			<error code="132">000</error>
			<error code="135">000</error>
			<error code="140">044</error>
			<error code="144">000</error>
			<error code="145">000</error>
			<error code="146">000</error>
			<error code="148">000</error>
			<error code="149">000</error>
			<error code="150">000</error>
			<error code="153">000</error>
			<error code="154">000</error>
			<error code="155">000</error>
			<error code="156">002</error>
			<error code="157">003</error>
			<error code="158">008</error>
			<error code="159">009</error>
			<error code="160">014</error>
			<error code="161">015</error>
			<error code="162">022</error>
			<error code="163">022</error>
			<error code="164">023</error>
			<error code="165">031</error>
			<error code="166">000</error>
			<error code="167">030</error>
			<error code="168">032</error>
			<error code="169">061</error>
			<error code="170">063</error>
			<error code="171">000</error>
			<error code="172">000</error>
			<error code="173">000</error>
			<error code="174">000</error>
			<error code="175">000</error>
			<error code="176">000</error>
			<error code="181">045</error>
			<error code="182">000</error>
			<error code="183">046</error>
			<error code="184">051</error>
			<error code="185">025</error>
			<error code="186">025</error>
			<error code="187">024</error>
			<error code="188">042</error>
			<error code="189">000</error>
			<error code="190">026</error>
			<error code="191">027</error>
			<error code="192">028</error>
			<error code="194">029</error>
			<error code="195">026</error>
			<error code="196">026</error>
			<error code="197">027</error>
			<error code="200">029</error>
			<error code="201">029</error>
			<error code="204">028</error>
			<error code="205">000</error>
			<error code="206">000</error>
			<error code="207">000</error>
			<error code="208">002</error>
			<error code="209">003</error>
			<error code="210">022</error>
			<error code="211">022</error>
			<error code="212">026</error>
			<error code="213">026</error>
			<error code="214">031</error>
			<error code="215">000</error>
			<error code="216">030</error>
			<error code="217">008</error>
			<error code="218">009</error>
			<error code="219">014</error>
			<error code="220">015</error>
			<error code="221">000</error>
			<error code="222">000</error>
			<error code="223">062</error>
			<error code="224">061</error>
			<error code="225">063</error>
			<error code="227">042</error>
			<error code="228">056</error>
			<error code="229">058</error>
			<error code="230">057</error>
			<error code="231">000</error>
			<error code="232">000</error>
			<error code="233">000</error>
			<error code="234">056</error>
			<error code="235">000</error>
			<error code="236">000</error>
			<error code="237">000</error>
			<error code="238">050</error>
			<error code="239">052</error>
			<error code="240">053</error>
			<error code="244">000</error>
			<error code="245">000</error>
			<error code="246">000</error>
			<error code="247">062</error>
			<error code="250">020</error>
			<error code="251">018</error>
			<error code="252">018</error>
			<error code="253">038</error>
			<error code="254">000</error>
			<error code="255">000</error>
			<error code="256">039</error>
			<error code="257">000</error>
			<error code="258">000</error>
			<error code="259">000</error>
			<error code="260">054</error>
			<error code="261">054</error>
			<error code="262">054</error>
			<error code="263">054</error>
			<error code="264">000</error>
			<error code="265">000</error>
			<error code="266">066</error>
			<error code="267">000</error>
			<error code="269">000</error>
			<error code="270">000</error>
			<error code="271">000</error>
			<error code="272">000</error>
			<error code="273">000</error>
			<error code="276">052</error>
			<error code="277">000</error>
			<error code="278">000</error>
			<error code="279">000</error>
			<error code="280">000</error>
			<error code="281">052</error>
			<error code="282">000</error>
			<error code="283">060</error>
			<error code="284">000</error>
			<error code="285">000</error>
			<error code="286">000</error>
			<error code="287">000</error>
			<error code="288">000</error>
			<error code="289">000</error>
			<error code="290">000</error>
			<error code="291">000</error>
			<error code="292">000</error>
			<error code="293">000</error>
			<error code="294">000</error>
			<error code="295">000</error>
			<error code="296">000</error>
			<error code="297">000</error>
			<error code="298">000</error>
			<error code="299">000</error>
			<error code="300">044</error>
			<error code="301">000</error>
			<error code="302">000</error>
			<error code="303">000</error>
			<error code="317">000</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/GetHCFSaleInfo">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="errorCount"><xsl:value-of select="GetAppInfo/ErrorCount" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$errorCount=0">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</success>

			<policyNo>
				<xsl:value-of select="GetHCFGeneratedInfo/CovernoteMemberNumber" />
			</policyNo>

			<errors>
				<xsl:for-each select="GetErrorDetails/*">
					<xsl:if test="substring(name(),1,9)='ErrorCode'">
						<xsl:variable name="detailName"><xsl:value-of select="concat('ErrorDetail',substring(name(),10))" /></xsl:variable>

						<xsl:call-template name="maperrors">
							<xsl:with-param name="code" select="." />
							<xsl:with-param name="message" select="/GetHCFSaleInfo/GetErrorDetails/*[name()=$detailName]" />
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</errors>
		</result>
	</xsl:template>

	<!-- Error returned by SOAP aggregator -->
	<xsl:template match="/error">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>
			<success>false</success>
			<policyNo></policyNo>
			<errors>
				<xsl:call-template name="maperrors">
					<xsl:with-param name="code" select="code" />
					<xsl:with-param name="message" select="message" />
				</xsl:call-template>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>