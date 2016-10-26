package com.ctm.web.health.voucherAuthorisation.services;

import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.health.voucherAuthorisation.dao.VoucherAuthorisationDao;
import com.ctm.web.core.exceptions.DaoException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by msmerdon on 5/10/2016.
 */
@Service
public class VoucherAuthorisationService {

    @Resource
    private VoucherAuthorisationDao voucherAuthorisationDao;

    public VoucherAuthorisation getAuthorisation(HttpServletRequest request, String code) throws DaoException {
        com.ctm.web.health.voucherAuthorisation.dao.VoucherAuthorisation voucherAuthorisationData = voucherAuthorisationDao.getAuthorisation(code, ApplicationService.getApplicationDate(request));
        VoucherAuthorisation voucherAuthorisation = new VoucherAuthorisation(
            voucherAuthorisationData.getUsername(),
            voucherAuthorisationData.getCode(),
            voucherAuthorisationData.getEffectiveEnd(),
            voucherAuthorisationData.getIsAuthorised()
		);
        return voucherAuthorisation;
    }
}
