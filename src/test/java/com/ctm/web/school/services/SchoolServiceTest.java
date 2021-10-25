package com.ctm.web.school.services;

import com.ctm.httpclient.Client;
import com.ctm.web.school.model.School;
import com.ctm.web.school.model.Schools;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import rx.Observable;

import java.util.Arrays;

import static org.junit.Assert.assertNotNull;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.util.ReflectionTestUtils.setField;

@RunWith(MockitoJUnitRunner.class)
public class SchoolServiceTest {

    @Mock
    private Client<String, Schools> client;

    @InjectMocks
    private SchoolService schoolService;

    @Before
    public void setup() {

    }

    @Test
    public void testMockService() {
        // Given
        setField(schoolService, "mockService", true);
        // When
        String response = schoolService.getSchoolsAsHtmlOptions();
        // Then
        assertNotNull(response);
    }

    @Test
    public void testSchoolRestRequest() {
        // Given
        School school1 = new School();
        school1.setCodeDescription("Desc1");
        school1.setCode("d1");
        School school2 = new School();
        school2.setCodeDescription("Desc1");
        school2.setCode("d1");
        School school3 = new School();
        school3.setCodeDescription("Desc1");
        school3.setCode("d1");
        Schools schools = new Schools();
        schools.setData(Arrays.asList(school1, school2, school3));
        setField(schoolService, "mockService", false);
        setField(schoolService, "requestUrl", "http://nowhere.com");


        when(client.get(any())).thenReturn(Observable.just(schools));
        // When
        String response = schoolService.getSchoolsAsHtmlOptions();
        // Then
        assertNotNull(response);
        // verify
        verify(client).get(any());

    }
}