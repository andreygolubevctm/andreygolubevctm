package com.ctm.web.car.leadfeed.router;

import com.ctm.web.car.leadfeed.services.CarLeadFeedService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.router.LeadFeedRouter;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.model.settings.Vertical;

import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {
        "/leadfeed/car/getacall.json"
})
public class CarLeadFeedRouter extends LeadFeedRouter {

    @Override
    protected String getVerticalCode() {
        return Vertical.VerticalType.CAR.getCode();
    }

    @Override
    protected LeadFeedService getLeadFeedService() {
        return new CarLeadFeedService(new BestPriceLeadsDao());
    }
}
