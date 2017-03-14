package com.ctm.web.core.content.services;

import com.ctm.web.core.connectivity.SimpleConnection;
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

import java.net.URL;
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
    private RandomNumberGenerator randomNumberGenerator;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        randomNumberGenerator = PowerMockito.mock(RandomNumberGenerator.class);
        PowerMockito.whenNew(RandomNumberGenerator.class).withNoArguments().thenReturn(randomNumberGenerator);

    }

    @Test
    public void init() throws Exception {
        ArrayList<ContentSupplement> supplementary = new ArrayList<>();
        String contentKey = setupContents(supplementary);
        RandomContentService randomContentService = new RandomContentService();
        randomContentService.init( contentService,  request,  contentKey);
    }

    @Test
    public void initWithValue() throws Exception {
        when(randomNumberGenerator.getRandomNumber(0)).thenReturn(0);
        String value = "supplementaryValue";
        ArrayList<ContentSupplement> supplementary = new ArrayList<>();
        ContentSupplement contentSupplement = new ContentSupplement();
        contentSupplement.setSupplementaryValue(value);
        supplementary.add(contentSupplement);

        String contentKey = setupContents(supplementary);
        RandomContentService randomContentService = new RandomContentService();
        randomContentService.init( contentService,  request,  contentKey);
        assertEquals(value, randomContentService.getSupplementaryValue());
    }

    @Test
    public void initWithValues() throws Exception {
        when(randomNumberGenerator.getRandomNumber(1)).thenReturn(1);
        ArrayList<ContentSupplement> supplementary = new ArrayList<>();
        String value = "supplementaryValue";
        ContentSupplement contentSupplement = new ContentSupplement();
        contentSupplement.setSupplementaryValue(value);
        supplementary.add(contentSupplement);
        String value2 = "supplementaryValue2";
        ContentSupplement contentSupplement2 = new ContentSupplement();
        contentSupplement2.setSupplementaryValue(value2);
        supplementary.add(contentSupplement2);

        String contentKey = setupContents(supplementary);
        RandomContentService randomContentService = new RandomContentService();
        randomContentService.init( contentService,  request,  contentKey);
        assertEquals(value, randomContentService.getSupplementaryValue());
    }

    private String setupContents(ArrayList<ContentSupplement> supplementary) throws DaoException, ConfigSettingException {
        String contentKey = "test";
        Content contents = new Content();
        contents.setSupplementary(supplementary);
        when(contentService.getContentWithSupplementaryNonStatic(request, contentKey)).thenReturn(contents);
        return contentKey;
    }
}