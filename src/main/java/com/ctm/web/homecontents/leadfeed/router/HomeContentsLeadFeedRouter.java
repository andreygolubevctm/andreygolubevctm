package com.ctm.web.homecontents.leadfeed.router;

import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.leadfeed.router.LeadFeedRouter;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.homecontents.leadfeed.services.HomeContentsLeadFeedService;

import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {
        "/leadfeed/homecontents/getacall.json"
})
public class HomeContentsLeadFeedRouter extends LeadFeedRouter {


    @Override
    protected String getVerticalCode() {
        return Vertical.VerticalType.HOME.getCode();
    }

    protected LeadFeedService getLeadFeedService() {
        return new HomeContentsLeadFeedService(new BestPriceLeadsDao());
    }
}
