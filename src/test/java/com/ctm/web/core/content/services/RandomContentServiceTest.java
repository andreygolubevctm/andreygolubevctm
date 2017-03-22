package com.ctm.web.core.content.services;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.model.ContentSupplement;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.RandomNumberGenerator;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

import static org.junit.Assert.*;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;


@RunWith(PowerMockRunner.class)
@PrepareForTest(RandomContentService.class)
public class RandomContentServiceTest {

    @Mock
    private ContentService contentService;
    @Mock
    private HttpServletRequest request;
    @Mock
    private RandomNumberGenerator randomNumberGenerator;
    private RandomContentService randomContentService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        PowerMockito.whenNew(RandomNumberGenerator.class).withNoArguments()
                .thenReturn(randomNumberGenerator);
        randomContentService = new RandomContentService();

    }

    @Test
    public void iniWithNoValue() throws Exception {
        ArrayList<ContentSupplement> supplementary = new ArrayList<>();
        String contentKey = setupContents(supplementary);
        randomContentService.init( contentService,  request,  contentKey);
        assertFalse(randomContentService.hasSupplementaryValue());
    }

    @Test
    public void initWithValue() throws Exception {
        when(randomNumberGenerator.getRandomNumber(1)).thenReturn(0);
        String value = "supplementaryValue";
        ArrayList<ContentSupplement> supplementary = new ArrayList<>();
        createContentSupplement(supplementary, value);

        String contentKey = setupContents(supplementary);
        randomContentService.init( contentService,  request,  contentKey);
        assertTrue(randomContentService.hasSupplementaryValue());
        assertEquals(value, randomContentService.getSupplementaryValue());
    }

    @Test
    public void initWithValues() throws Exception {
        when(randomNumberGenerator.getRandomNumber(3)).thenReturn(1);
        ArrayList<ContentSupplement> supplementary = new ArrayList<>();
        String value = "supplementaryValue";
        createContentSupplement(supplementary, value);
        String value2 = "supplementaryValue2";
        createContentSupplement(supplementary,value2);
        String value3 = "supplementaryValue3";
        createContentSupplement(supplementary,value3);

        String contentKey = setupContents(supplementary);
        randomContentService.init( contentService,  request,  contentKey);
        assertTrue(randomContentService.hasSupplementaryValue());
        assertEquals(value2, randomContentService.getSupplementaryValue());

        when(randomNumberGenerator.getRandomNumber(3)).thenReturn(2);
        randomContentService.init( contentService,  request,  contentKey);
        assertTrue(randomContentService.hasSupplementaryValue());
        assertEquals(value3, randomContentService.getSupplementaryValue());
    }

    private void createContentSupplement(ArrayList<ContentSupplement> supplementary, String value) {
        ContentSupplement contentSupplement2 = new ContentSupplement();
        contentSupplement2.setSupplementaryValue(value);
        supplementary.add(contentSupplement2);
    }

    private String setupContents(ArrayList<ContentSupplement> supplementary) throws DaoException, ConfigSettingException {
        String contentKey = "test";
        Content contents = new Content();
        contents.setSupplementary(supplementary);
        when(contentService.getContentWithSupplementaryNonStatic(request, contentKey)).thenReturn(contents);
        return contentKey;
    }
}