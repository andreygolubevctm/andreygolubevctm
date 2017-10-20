package com.ctm.web.health.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.dao.HealthProductsSalesSynchronizationDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {
        "/cron/database/productSales/sync.json"
})
public class HealthProductSalesSyncController extends HttpServlet{

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthProductSalesSyncController.class);

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try{
            HealthProductsSalesSynchronizationDao healthProductsSalesSynchronizationDao = new HealthProductsSalesSynchronizationDao();
            String lastSyncPeriod = healthProductsSalesSynchronizationDao.getLastProductSalesSyncPeriod();
            LOGGER.info("adding new health product sales  from the sync period :"+ lastSyncPeriod);
            healthProductsSalesSynchronizationDao.addNewProductSalesFromLastSync(lastSyncPeriod);
            LOGGER.info("successfully completed adding new sales record to the table aggregator.product_sales");
        } catch(DaoException exception){
            LOGGER.error("Error in running the cron job to sync health product sales", exception);
        }

    }
}
