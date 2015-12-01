package com.ctm.web.car.leadfeed.router;

import com.ctm.web.car.leadfeed.services.CarLeadFeedService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.leadfeed.router.BestPriceLeadsRouter;
import com.ctm.web.core.leadfeed.services.LeadFeedService;

import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {
        "/cron/leadfeed/car/triggerBestPriceLeads.json"
})
public class CarBestPriceLeadsRouter extends BestPriceLeadsRouter {
    @Override
    protected LeadFeedService getLeadFeedService() {
        return new CarLeadFeedService(new BestPriceLeadsDao());
    }

    @Override
    protected String getVerticalCode() {
        return Vertical.VerticalType.CAR.getCode();
    }
}