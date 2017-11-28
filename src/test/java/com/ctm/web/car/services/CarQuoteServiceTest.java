package com.ctm.web.car.services;

import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.car.model.form.CarRequest;
import com.ctm.web.car.model.request.propensityscore.*;
import com.ctm.web.car.model.results.CarResult;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.simples.services.TransactionDetailService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.RestTemplate;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.ctm.web.car.services.CarQuoteService.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;

public class CarQuoteServiceTest {

    private static final Long TRANSACTION_ID = 1L;

    private CarQuoteService service;
    @Mock
    private CarRequest carRequest;
    @Mock
    private CarQuote carQuote;
    @Mock
    private ProviderFilterDao providerFilterDao;
    @Mock
    private ServiceConfigurationServiceBean serviceConfigurationServiceBean;
    @Mock
    private SessionDataServiceBean sessionDataServiceBean;
    @Mock
    private TransactionDetailService transactionDetailService;
    @Mock
    private RestTemplate restTemplate;

    @Before
    public void setup() {
        initMocks(this);
        service = new CarQuoteService(providerFilterDao, serviceConfigurationServiceBean, sessionDataServiceBean, transactionDetailService, restTemplate);
        ReflectionTestUtils.setField(service, "dataRobotUrl", "http://test.com");
    }

    @Test
    public void testGetResultPropertiesEmpty() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertTrue(resultProperties.isEmpty());
    }

    @Test
    public void testGetResultProperties() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final CarResult carResult = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult);
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertFalse(resultProperties.isEmpty());
        assertEquals(14, resultProperties.size());
    }

    @Test
    public void testGetResultProperties2() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final CarResult carResult1 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult1.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult1);
        final CarResult carResult2 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult2.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult2);
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertFalse(resultProperties.isEmpty());
        assertEquals(28, resultProperties.size());
    }

    @Test
    public void testGetResultProperties3() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final CarResult carResult1 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult1.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult1);
        final CarResult carResult2 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult2.getAvailable()).thenReturn(AvailableType.N);
        carResults.add(carResult2);
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertFalse(resultProperties.isEmpty());
        assertEquals(14, resultProperties.size());
    }

    @Test
    public void retrieveAndStoreCarQuotePropensityScore_with200Response() throws Exception {
        // Given
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(getTransactionDetails(false, false));

        ResponseEntity<Object> responseEntity = new ResponseEntity<Object>(get200Response(true), HttpStatus.OK);
        ArgumentCaptor<HttpEntity> argumentCaptor = ArgumentCaptor.forClass(HttpEntity.class);
        when(restTemplate.postForEntity(anyObject(), argumentCaptor.capture(), any())).thenReturn(responseEntity);

        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);

        //Then
        List<CarQuotePropensityScoreRequest> requestList = (List<CarQuotePropensityScoreRequest>) argumentCaptor.getValue().getBody();
        CarQuotePropensityScoreRequest carQuotePropensityScoreRequest = requestList.iterator().next();
        assertEquals(1, carQuotePropensityScoreRequest.getRankPosition().intValue());
        assertEquals(YesNo.Y, carQuotePropensityScoreRequest.getPhoneFlag());
        assertEquals(YesNo.Y, carQuotePropensityScoreRequest.getEmailFlag());
        assertEquals(DeviceType.DESKTOP, carQuotePropensityScoreRequest.getDeviceType());

        assertFalse(resultProperties.isEmpty());
        assertEquals("0.45", resultProperties.iterator().next().getValue());
    }

    @Test
    public void retrieveAndStoreCarQuotePropensityScore_with200Response_NoScore() throws Exception {
        // Given
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(getTransactionDetails(false, false));

        ResponseEntity<Object> responseEntity = new ResponseEntity<Object>(get200Response(false), HttpStatus.OK);
        ArgumentCaptor<HttpEntity> argumentCaptor = ArgumentCaptor.forClass(HttpEntity.class);
        when(restTemplate.postForEntity(anyObject(), argumentCaptor.capture(), any())).thenReturn(responseEntity);

        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);

        //Then
        assertFalse(resultProperties.isEmpty());
        assertEquals(null, resultProperties.iterator().next().getValue());
    }

    @Test
    public void retrieveAndStoreCarQuotePropensityScore_noResponse() throws Exception {
        // Given (valid request, but no response from data robot)
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(getTransactionDetails(false, false));

        ResponseEntity<Object> responseEntity = new ResponseEntity<Object>(null, HttpStatus.OK);
        when(restTemplate.postForEntity(anyObject(), anyObject(), any())).thenReturn(responseEntity);

        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);

        //Then
        assertFalse(resultProperties.isEmpty());
        assertEquals(null, resultProperties.iterator().next().getValue());
    }

    @Test
    public void retrieveAndStoreCarQuotePropensityScore_with400Response() throws Exception {
        // Given (valid request, but no response from data robot)
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(getTransactionDetails(false, false));

        ResponseEntity<Object> responseEntity = new ResponseEntity<Object>(get400Response(), HttpStatus.BAD_REQUEST);
        when(restTemplate.postForEntity(anyObject(), anyObject(), any())).thenReturn(responseEntity);

        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);

        //Then
        assertFalse(resultProperties.isEmpty());
        assertEquals(null, resultProperties.iterator().next().getValue());
    }

    @Test(expected = IllegalStateException.class)
    public void retrieveAndStoreCarQuotePropensityScore_emptyTransactionDetails() throws Exception {
        // Given
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(getTransactionDetails(true, false));

        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);

        //Then exception expected
    }

    @Test(expected = NullPointerException.class)
    public void retrieveAndStoreCarQuotePropensityScore_nullDate() throws Exception {
        // Given
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        Data transactionDetails = getTransactionDetails(true, false);
        transactionDetails.put(QUOTE_VEHICLE_BODY, "4SED");
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(transactionDetails);
        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);
        //Then exception expected
    }

    @Test
    public void retrieveAndStoreCarQuotePropensityScore_partialTransactionDetails() throws Exception {
        // Given
        final List<String> productIdsOrderedByRank = Arrays.asList("WOOL-01-01", "BUDD-05-01", "WOOL-05-05", "IB-01-01");
        Data transactionDetails = getTransactionDetails(false, true);
        when(transactionDetailService.getTransactionDetailsInXmlData(anyObject())).thenReturn(transactionDetails);


        ResponseEntity<Object> responseEntity = new ResponseEntity<Object>(get200Response(true), HttpStatus.OK);
        ArgumentCaptor<HttpEntity> argumentCaptor = ArgumentCaptor.forClass(HttpEntity.class);
        when(restTemplate.postForEntity(anyObject(), argumentCaptor.capture(), any())).thenReturn(responseEntity);
        // When
        final List<ResultProperty> resultProperties = service.buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, TRANSACTION_ID);

        //Then
        List<CarQuotePropensityScoreRequest> requestList = (List<CarQuotePropensityScoreRequest>) argumentCaptor.getValue().getBody();
        CarQuotePropensityScoreRequest carQuotePropensityScoreRequest = requestList.iterator().next();
        assertEquals(1, carQuotePropensityScoreRequest.getRankPosition().intValue());
        assertEquals(YesNo.Y, carQuotePropensityScoreRequest.getPhoneFlag());
        assertEquals(YesNo.Y, carQuotePropensityScoreRequest.getEmailFlag());
        assertEquals(DeviceType.DESKTOP, carQuotePropensityScoreRequest.getDeviceType());

        assertFalse(resultProperties.isEmpty());
        assertEquals("0.45", resultProperties.iterator().next().getValue());
    }


    private DataRobotCarQuotePropensityScoreResponse get200Response(final boolean withPropensityScore) {
        DataRobotCarQuotePropensityScoreResponse response = new DataRobotCarQuotePropensityScoreResponse();
        response.setCode(200);
        if(!withPropensityScore) return response;

        ClassProbability classProbability = new ClassProbability();
        classProbability.setOne(0.45);

        Prediction prediction = new Prediction();
        prediction.setClassProbabilities(classProbability);
        List<Prediction> predictions = Arrays.asList(prediction);
        response.setPredictions(predictions);
        return response;
    }

    private DataRobotCarQuotePropensityScoreResponse get400Response() {
        DataRobotCarQuotePropensityScoreResponse response = new DataRobotCarQuotePropensityScoreResponse();
        response.setStatus("Bad JSON Format");
        response.setCode(400);
        response.setVersion("v1");
        return response;
    }

    private Data getTransactionDetails(final boolean returnEmptyData, final boolean partialData) {
        Data transactionDetailsInXmlData = new Data();
        if(returnEmptyData) return transactionDetailsInXmlData;

        transactionDetailsInXmlData.put(QUOTE_DRIVERS_REGULAR_DOB, "05/05/1979");
        transactionDetailsInXmlData.put(QUOTE_CONTACT_EMAIL, "test@gmail.com");
        transactionDetailsInXmlData.put(QUOTE_OPTIONS_COMMENCEMENT_DATE, "20/11/2017");
        transactionDetailsInXmlData.put(QUOTE_CONTACT_PHONE, "0000000");
        transactionDetailsInXmlData.put(QUOTE_CONTACT_PHONEINPUT, "");
        transactionDetailsInXmlData.put(QUOTE_CLIENT_USER_AGENT, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36");

        if(partialData) return transactionDetailsInXmlData;
        transactionDetailsInXmlData.put(QUOTE_DRIVERS_REGULAR_CLAIMS, "N");
        transactionDetailsInXmlData.put(QUOTE_DRIVERS_REGULAR_NCD, "5");
        transactionDetailsInXmlData.put(QUOTE_DRIVERS_REGULAR_EMPLOYMENT_STATUS, "E");
        transactionDetailsInXmlData.put(QUOTE_RISK_ADDRESS_STATE, "QLD");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_BODY, "4SED");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_COLOUR, "Black");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_FINANCE, "HP");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_ANNUAL_KILOMETRES, "10000");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_USE, "02");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_MARKET_VALUE, "5000");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_FACTORY_OPTIONS, "Y");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_MAKE_DES, "Mazda");
        transactionDetailsInXmlData.put(QUOTE_VEHICLE_DAMAGE, "N");
        return transactionDetailsInXmlData;
    }

    @Test
    public void buildAge() throws Exception {
        //Given
        final java.time.LocalDate fromDate = java.time.LocalDate.parse("27/11/2017", DateTimeFormatter.ofPattern(DD_MM_YYYY));
        //When
        final Long age = service.buildAge(fromDate, "05/05/1979");
        //Then
        assertEquals(38, age.intValue());
    }

    @Test(expected = NullPointerException.class)
    public void buildAge_null(){
        //Given
        final java.time.LocalDate fromDate = java.time.LocalDate.parse("27/11/2017", DateTimeFormatter.ofPattern(DD_MM_YYYY));
        //When
        final Long age = service.buildAge(fromDate, null);
        //Then
        assertEquals(38, age.intValue());
    }

    @Test
    public void buildEmailFlag() throws Exception {
        //Given
        //When
        YesNo emailFlag = service.buildEmailFlag("test@gmail.com");
        //Then
        assertEquals(YesNo.Y, emailFlag);
    }

    @Test
    public void buildEmailFlag_null() throws Exception {
        //Given
        //When
        YesNo emailFlag = service.buildEmailFlag(null);
        //Then
        assertEquals(YesNo.N, emailFlag);
    }

    @Test
    public void daysBetween() throws Exception {
        //Given
        final java.time.LocalDate fromDate = java.time.LocalDate.parse("27/11/2017", DateTimeFormatter.ofPattern(DD_MM_YYYY));
        //when
        Long days = service.daysBetween(fromDate, "20/11/2017");
        //then
        assertEquals(7, days.intValue());
    }

    @Test(expected = NullPointerException.class)
    public void daysBetween_null(){
        //Given
        final java.time.LocalDate fromDate = java.time.LocalDate.parse("27/11/2017", DateTimeFormatter.ofPattern(DD_MM_YYYY));
        //when
        Long days = service.daysBetween(fromDate, null);
        //then
        assertEquals(7, days.intValue());
    }

    @Test
    public void buildPhoneFlag() {
        //Given
        //when
        YesNo phoneFlag = service.buildPhoneFlag("0000", "1111");
        //Then
        assertEquals(YesNo.Y, phoneFlag);
    }

    @Test
    public void buildPhoneFlag_null() {
        //Given
        //when
        YesNo phoneFlag = service.buildPhoneFlag(" ", null);
        //Then
        assertEquals(YesNo.N, phoneFlag);
    }
}
