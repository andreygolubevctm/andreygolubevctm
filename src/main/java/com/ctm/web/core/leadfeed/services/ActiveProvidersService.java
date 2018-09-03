package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.model.ContentSupplement;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.DaoException;

import java.util.ArrayList;
import java.util.Date;

/**
 * Retrieval and caching of provider flags for leads
 */
public class ActiveProvidersService {

    private ArrayList<ContentSupplement> providersContent = null;
    private boolean cached = false;

    /**
     * For a given vertical, get providers who are able to pass leads.
     *
     * If this information has already been supplied to `providersContent` in a given instance, skip the retrieval and
     * return the details we already have.
     *
     * @param verticalId
     * @param serverDate
     * @return
     * @throws DaoException
     */
    public ArrayList<ContentSupplement> getActiveProviders(Integer verticalId, Date serverDate) throws DaoException {
        if (providersContent == null && !cached) {
            try {
                ContentService contentService = new ContentService();
                Content content = contentService.getContent("bestPriceProviders", 0, verticalId, serverDate, true);
                ArrayList<ContentSupplement> providersContent = content.getSupplementary();
                cached = true;
                return providersContent;
            } catch (DaoException e) {
                throw new DaoException(e);
            }
        }
        return providersContent;

    }

    /**
     * Wrapper to return a pipe separated string of active providers without externally having to call two methods.
     *
     * @param verticalId
     * @param serverDate
     * @return
     * @throws DaoException
     */
    public String getActiveProvidersString(Integer verticalId, Date serverDate) throws DaoException {
        getActiveProviders(verticalId, serverDate);
        return toString();
    }

    /**
     * Validate and convert active providers into a pipe separated string of names.
     *
     * @return
     */
    public String toString(){
        if(providersContent == null || providersContent.size() == 0){
            return null;
        }
        StringBuilder providers = new StringBuilder();
        for (ContentSupplement provider : providersContent) {
            if(provider.getSupplementaryValue().equalsIgnoreCase("Y")) {
                if(!providers.toString().isEmpty()) {
                    providers.append("|");
                }
                providers.append(provider.getSupplementaryKey());
            }
        }
        return providers.toString();

    }
}
