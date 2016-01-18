package com.ctm.web.simples.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.dao.ChangeOverRebatesDao;
import com.ctm.web.simples.model.ChangeOverRebate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by voba on 15/09/2015.
 */
public class ChangeOverRebatesService {
    private static final Logger logger = LoggerFactory.getLogger(ChangeOverRebatesService.class.getName());

    private static SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    public ChangeOverRebate getChangeOverRebate(String commencementDate) {
        ChangeOverRebatesDao dao = new ChangeOverRebatesDao();

        try {
            if(commencementDate != null && !commencementDate.isEmpty()) {
                return dao.getChangeOverRebates(dateFormat.parse(commencementDate));
            } else {
                return dao.getChangeOverRebates(new Date());
            }
        } catch (DaoException e) {
            logger.error("Error getting change over rebates", e);
        } catch (ParseException e) {
            logger.error("Error getting change over rebates", e);
        }

        // 2013-04-01
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, 2013);
        calendar.set(Calendar.MONTH, 03);
        calendar.set(Calendar.DAY_OF_MONTH, 01);

        return new ChangeOverRebate(new BigDecimal(1), new BigDecimal(1), calendar.getTime());
    }
}
