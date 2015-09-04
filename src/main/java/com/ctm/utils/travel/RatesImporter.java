package com.ctm.utils.travel;

import com.ctm.dao.ProductPropertiesDao;
import com.ctm.exceptions.DaoException;
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

    public BufferedReader getReader() throws FileNotFoundException {
        String fileLocation = "C:/dev/web_ctm/src/main/webapp/rating/travel_rates_generator/travel_rates_"+ fileName+".csv";
        String fileLocation2 = "C:/Dev/web_ctm/src/main/webapp/rating/travel_rates_generator/travel_rates_"+ fileName +".csv";
        FileReader freader;
        try {
            freader = new FileReader(fileLocation);
        } catch(FileNotFoundException fe) {
            fe.printStackTrace();
            LOGGER.debug("exception " + fe.getMessage() + " lets try again");
            freader = new FileReader(fileLocation2);
        }
        return  new BufferedReader(freader);
    }

    public void init(HttpServletRequest request) {
        fileName = request.getParameter("file");
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

        int sizeOfMap = map.size();
        LOGGER.debug("the size of the map is:" + sizeOfMap);
        return prevProductId;
    }

    public int getSequenceNo() {
        return sequenceNo;
    }

    public BufferedReader getMetaDoc() throws IOException {
        // Get data from meta file
        String metaFileLocation = "C:/dev/web_ctm/src/main/webapp/rating/travel_rates_generator/travel_rates_" + fileName + "_meta.csv";
        String metaFileLocation2 = "C:/Dev/web_ctm/src/main/webapp/rating/travel_rates_generator/travel_rates_" + fileName + "_meta.csv";

        LOGGER.debug("the metaFileLocation is:" + metaFileLocation);
        BufferedReader metaDoc = null;
        FileReader fr = null;
        try {
            fr = new FileReader(metaFileLocation);
        } catch (FileNotFoundException fe) {
            fe.printStackTrace();
            LOGGER.debug("exception.. " + fe.getMessage() + " lets try again ");
            fr = new FileReader(metaFileLocation2);
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
        return productPropertiesDao.getProductPropertiesCoount(productIds);
    }

    public void handleCount(long newResultCount, long initialResultCount) {
        if(newResultCount <= initialResultCount - 1) {
            LOGGER.debug(newResultCount + " " + initialResultCount);
        }
    }
}
