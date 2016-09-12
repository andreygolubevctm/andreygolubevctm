package com.ctm.web.bsb.services;

import com.ctm.web.bsb.dao.BSBDetailsDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by akhurana on 8/09/2016.
 */
@Service
public class BSBDetailsService {

    @Resource
    private BSBDetailsDao bsbDetailsDao;

    public BSBDetails getBsbDetailsByBsbNumber(String bsbNumber){
        com.ctm.web.bsb.dao.BSBDetails bsbDetailsData = bsbDetailsDao.getBsbDetailsByBsbNumber(bsbNumber);
        BSBDetails bsbDetails = new BSBDetails(bsbDetailsData.getBsbNumber(),bsbDetailsData.getBranchName(),
                bsbDetailsData.getAddress(),bsbDetailsData.getSuburb(),bsbDetailsData.getPostCode(),
                bsbDetailsData.getBranchState());
        return bsbDetails;
    }
}
