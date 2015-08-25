package com.ctm.utils;

import java.util.ArrayList;
import java.util.Random;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import com.ctm.model.content.Content;

public class MiscUtils {

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
}
