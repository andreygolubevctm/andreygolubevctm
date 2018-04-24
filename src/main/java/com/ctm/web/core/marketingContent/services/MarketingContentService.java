package com.ctm.web.core.marketingContent.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.marketingContent.dao.MarketingContentDao;
import com.ctm.web.core.marketingContent.model.MarketingContent;
import com.ctm.web.core.marketingContent.model.request.MarketingContentRequest;

public class MarketingContentService {
    private MarketingContentDao marketingContentDao = new MarketingContentDao();

    public MarketingContent getMarketingContent(MarketingContentRequest marketingContentRequest) throws DaoException {
        return marketingContentDao.getMarketingContent(marketingContentRequest);
    }
}
