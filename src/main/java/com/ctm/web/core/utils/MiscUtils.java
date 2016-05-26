package com.ctm.web.core.utils;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.health.services.HealthApplicationService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Optional;
import java.util.Random;
import java.util.function.Supplier;


public class MiscUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(MiscUtils.class);
    /**
     * Receives a Content Model, randomises the order and returns the new Content Model.
     *
     * @param Content
     * @return Content
     */
    public static Content randomiseContent(Content contentList) {

        ArrayList contentArray = contentList.getSupplementary();

        // Get length of list
        int arrayLength = contentArray.size();

        // create array with ints of list length to zero.
        ArrayList<Integer> indexesToIterate = new ArrayList<Integer>();

        while (arrayLength > 0) {
        	arrayLength--;
        	indexesToIterate.add(arrayLength);
        }

        // Create a new empty ArrayList
        ArrayList randomArrayList = new ArrayList();

		while (contentArray.size() > 0) {
		     // Select random index
			int indexOfIndex = indexesToIterate.indexOf(indexesToIterate.get(new Random().nextInt(indexesToIterate.size())));
			// Add Content value to new randomArray with random index.
			randomArrayList.add(contentArray.get(indexOfIndex));
			// Remove those indexes from the indexes and content list.
			indexesToIterate.remove(indexOfIndex);
			contentArray.remove(indexOfIndex);
		}

        // Create a new ContentList to contain the new random ArrayList
		Content randomContentList = new Content();

		randomContentList.setSupplementary(randomArrayList);

        return randomContentList;
    }

    /**
     * Helper method to prevent NPE's when referencing nested object tree fields.
     * @param resolver
     * @param <T>
     * @return
     */
    public static <T> Optional<T> resolve(Supplier<T> resolver) {
        try {
            T result = resolver.get();
            return Optional.ofNullable(result);
        }
        catch (NullPointerException e) {
            return Optional.empty();
        }
    }

    public static String convertToJson(Object object) {
        try {
            return ObjectMapperUtil.getObjectMapper().writeValueAsString(object);
        } catch (JsonProcessingException e) {
            LOGGER.warn("Unable to convert to JSON", e);
            return "";
        }
    }

}
