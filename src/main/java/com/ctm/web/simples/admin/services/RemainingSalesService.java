package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.simples.model.RemainingSale;
import com.ctm.web.simples.admin.dao.RemainingSalesDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class RemainingSalesService {

    @Autowired
    private RemainingSalesDao remainingSalesDao;

    public List<RemainingSale> getRemainingSales() {
        try {
            return remainingSalesDao.getRemainingSales();
        } catch (final DaoException e) {
            throw new ServiceException("Error while calling getRemainingSales", e);
        }
    }

}
