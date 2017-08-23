package com.ctm.web.core.model.formatter;

import com.ctm.web.core.model.AbstractJsonModel;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public abstract class JsonUtils {
	private static final Logger LOGGER = LoggerFactory.getLogger(JsonUtils.class);

	private static final ObjectMapper mapper = new ObjectMapper()
			.registerModule(new Jdk8Module())
			.registerModule(new JavaTimeModule());

	/**
	 * Adds a list of {@link AbstractJsonModel} to a provided JSON Object.
	 *
	 * If the list is empty, a property will be created on the json object with an empty array value.
	 *
	 * If an item in the list has an error (AbstractJsonModel.getErrors), the errors will be collected onto the root of the json object.
	 *
	 * @param json The JSON Object to append the list to.
	 * @param keyName JSON property under which the list will sit. For example, "errors" would produce {"errors":[...]}
	 * @param list A list of {@link AbstractJsonModel}
	 */
	public static <T extends AbstractJsonModel> void addListToJsonObject(JSONObject json, String keyName, List<T> list) {
		try {
			if (list.size() == 0) {
				if (!json.has(keyName)) {
					json.put(keyName, new JSONArray());
				}
			}
			else {
				for (AbstractJsonModel obj : list) {

					json.append(keyName, obj.toJsonObject());

					if (obj.getErrors().size() > 0) {
						JsonUtils.addListToJsonObject(json, "errors", obj.getErrors());
					}
				}
			}
		}
		catch (JSONException e) {
			LOGGER.error("Failed to produce JSON object {}, {}", kv("json", json), kv("keyName", keyName), e);
		}
	}


    /**
     * Helper method to convert a JSON String to an instance of {@link Map}.
     * <p>
     * An empty map is returned if parsing failed
     *
     * @param str the JSON string
     * @return the map
     */
    public static Map<String, Object> convertToMap(final String str) {
        try {
            return mapper.readValue(str, new TypeReference<Map<String, Object>>() {
            });
        } catch (IOException e) {
            LOGGER.error("Failed to read JSON value from string. Reason: " + e.getMessage());
            return Collections.EMPTY_MAP;
        }
    }
}
