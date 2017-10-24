package com.ctm.web.travel.utils;

import com.ctm.web.core.dao.ProductPropertiesDao;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

public class RatesImporter {

    private static final Logger LOGGER = LoggerFactory.getLogger(RatesImporter.class.getName());

    private String fileName;
    private int sequenceNo = 1;
    private String webCtmHomeDir;

    public String processWebCTMHomeDir() {
        if(webCtmHomeDir == null) {
            return "C:/dev/web_ctm/";
        }
        else {
            return webCtmHomeDir;
        }
    }

    public BufferedReader getReader() throws FileNotFoundException {
        String fileLocation = processWebCTMHomeDir()+"src/main/webapp/rating/travel_rates_generator/travel_rates_"+ fileName +".csv";
        FileReader freader = null;
        try {
            freader = new FileReader(fileLocation);
        } catch(FileNotFoundException fe) {
            fe.printStackTrace();
            LOGGER.debug("exception " + fe.getMessage());
        }
        return  new BufferedReader(freader);
    }

    public void init(HttpServletRequest request) {
        fileName = request.getParameter("file");
        webCtmHomeDir = request.getParameter("web_home");
        LOGGER.debug("the fileName is:" + fileName);
    }

    public String getFileName() {
        return fileName;
    }

    public int map(int productId, int prevProductId, HashMap<String, Integer> map) {
        // Reset the sequence number on change of product
        if (productId != prevProductId){
            sequenceNo = 1;
            prevProductId = productId;
        } else {
            sequenceNo++;
        }

        map.clear();
        map.put("durMin",2);
        map.put("durMax",4);
        map.put("ageMin",6);
        map.put("ageMax",7);

        map.put("R1_SIN",8);
        map.put("R1_DUO",9);
        map.put("R1_FAM",10);

        map.put("R2_SIN",11);
        map.put("R2_DUO",12);
        map.put("R2_FAM",13);

        map.put("R3_SIN",14);
        map.put("R3_DUO",15);
        map.put("R3_FAM",16);

        map.put("R4_SIN",17);
        map.put("R4_DUO",18);
        map.put("R4_FAM",19);

        map.put("R5_SIN",20);
        map.put("R5_DUO",21);
        map.put("R5_FAM",22);

        map.put("R6_SIN",23);
        map.put("R6_DUO",24);
        map.put("R6_FAM",25);

        map.put("R7_SIN",26);
        map.put("R7_DUO",27);
        map.put("R7_FAM",28);

        map.put("R8_SIN",29);
        map.put("R8_DUO",30);
        map.put("R8_FAM",31);

        map.put("R9_SIN",32);
        map.put("R9_DUO",33);
        map.put("R9_FAM",34);

        map.put("R10_SIN",35);
        map.put("R10_DUO",36);
        map.put("R10_FAM",37);

        map.put("R11_SIN",38);
        map.put("R11_DUO",39);
        map.put("R11_FAM",40);

        int sizeOfMap = map.size();
        LOGGER.debug("the size of the map is:" + sizeOfMap);
        return prevProductId;
    }

    public int getSequenceNo() {
        return sequenceNo;
    }

    public BufferedReader getMetaDoc() throws IOException {
        // Get data from meta file

        String fileLocation = processWebCTMHomeDir()+"src/main/webapp/rating/travel_rates_generator/travel_rates_"+ fileName +"_meta.csv";

        LOGGER.debug("the metaFileLocation is:" + fileLocation);
        BufferedReader metaDoc = null;
        FileReader fr = null;
        try {
            fr = new FileReader(fileLocation);
        } catch (FileNotFoundException fe) {
            fe.printStackTrace();
            LOGGER.debug("exception.. " + fe.getMessage() + " lets try again ");

        }
        try {
            metaDoc = new BufferedReader(fr);
        } catch(Exception ioe) {
            LOGGER.debug("failed.. " + ioe);
        }
        LOGGER.debug("we have a metaDoc***" + metaDoc.ready());
        return metaDoc;
    }

    public Long getToProductPropertiesCount(ArrayList<String> productIds) throws DaoException {
        ProductPropertiesDao productPropertiesDao = new ProductPropertiesDao();
        return productPropertiesDao.getProductPropertiesCount(productIds);
    }

    public void handleCount(long newResultCount, long initialResultCount) {
        if(newResultCount <= initialResultCount - 1) {
            LOGGER.debug(newResultCount + " " + initialResultCount);
        }
    }
}
