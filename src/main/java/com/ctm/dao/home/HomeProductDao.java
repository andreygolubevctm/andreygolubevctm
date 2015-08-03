package com.ctm.dao.home;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Feature;
import com.ctm.model.car.AdditionalExcess;
import com.ctm.model.car.ProductDisclosure;
import com.ctm.model.home.CoverTypeEnum;
import com.ctm.model.home.HomeProduct;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class HomeProductDao {

    public Map<String, HomeProduct> getHomeProducts(Date effectiveDate, int styleCodeId) throws DaoException {

        Map<String, HomeProduct> products = new HashMap<>();

        Map<Integer, HomeProduct> productsIds = new HashMap<>();

        try ( SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection(); ) {
            PreparedStatement stmt;


            String query = "SELECT pm.providerCode as brandCode, hp.*, hc.* FROM " +
                    "ctm.provider_master pm JOIN ctm.home_product hp ON  pm.providerId = hp.providerId " +
                    "JOIN ctm.home_product_content hc ON hp.homeProductId = hc.homeProductId " +
                    "WHERE (hc.styleCodeId = ? or hc.styleCodeId = 0) ";

            if (effectiveDate != null) {
                query += " AND ? BETWEEN hp.effectiveStart and hp.effectiveEnd " +
                        " AND ? BETWEEN hc.effectiveStart and hc.effectiveEnd ";
            }
            query += " order by hp.code, styleCodeId desc";

            stmt = dbSource.getConnection().prepareStatement(query);

            stmt.setInt(1, styleCodeId);

            if (effectiveDate != null) {
                stmt.setDate(2, new java.sql.Date(effectiveDate.getTime()));
                stmt.setDate(3, new java.sql.Date(effectiveDate.getTime()));
            }

            ResultSet results = stmt.executeQuery();

            while (results.next()) {
                String productCode = createProductKey(results.getString("code"), results.getString("coverType"));
                if (!products.containsKey(productCode)) {
                    HomeProduct product = createHomeProduct(results);
                    productsIds.put(results.getInt("homeProductContentId"), product);
                    products.put(productCode, product);
                }
            }

            // GET Additional Excesses
            query = "SELECT * FROM ctm.home_product_additional_excesses";
            if (effectiveDate != null) {
                query += " WHERE ? BETWEEN effectiveStart and effectiveEnd";
            }

            stmt = dbSource.getConnection().prepareStatement(query);

            if (effectiveDate != null) {
                stmt.setDate(1, new java.sql.Date(effectiveDate.getTime()));
            }

            results = stmt.executeQuery();

            while (results.next()) {
                Integer productId = results.getInt("homeProductContentId");
                HomeProduct product = productsIds.get(productId);
                if (product != null) {
                    AdditionalExcess additionalExcess = new AdditionalExcess();
                    additionalExcess.setDescription(results.getString("description"));
                    additionalExcess.setAmount(results.getString("amount"));
                    product.getAdditionalExcesses().add(additionalExcess);
                }
            }

            // GET ProductDisclosures
            query = "SELECT * FROM ctm.home_product_disclosure_statements";
            if (effectiveDate != null) {
                query += " WHERE ? BETWEEN effectiveStart and effectiveEnd";
            }

            stmt = dbSource.getConnection().prepareStatement(query);

            if (effectiveDate != null) {
                stmt.setDate(1, new java.sql.Date(effectiveDate.getTime()));
            }

            results = stmt.executeQuery();

            while (results.next()) {
                Integer productId = results.getInt("homeProductContentId");
                HomeProduct product = productsIds.get(productId);
                if (product != null) {
                    ProductDisclosure productDisclosure = new ProductDisclosure();
                    productDisclosure.setCode(results.getString("code"));
                    productDisclosure.setTitle(results.getString("title"));
                    productDisclosure.setUrl(results.getString("url"));
                    product.getProductDisclosures().add(productDisclosure);
                }
            }

            // GET Features
            query = "SELECT * FROM ctm.home_product_features";
            if (effectiveDate != null) {
                query += " WHERE ? BETWEEN effectiveStart and effectiveEnd";
            }

            stmt = dbSource.getConnection().prepareStatement(query);

            if (effectiveDate != null) {
                stmt.setDate(1, new java.sql.Date(effectiveDate.getTime()));
            }

            results = stmt.executeQuery();

            while (results.next()) {
                Integer productId = results.getInt("homeProductContentId");
                HomeProduct product = productsIds.get(productId);
                if (product != null) {
                    Feature feature = new Feature();
                    feature.setCode(results.getString("code"));
                    feature.setValue(results.getString("value"));
                    feature.setLabel(results.getString("name"));
                    feature.setExtra(results.getString("description"));
                    product.getFeatures().add(feature);
                }
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }

        return products;
    }

    public HomeProduct getHomeProduct(Date effectiveDate, String productId, String type, int styleCodeId) throws DaoException {
        try ( SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection(); ) {
            PreparedStatement stmt;


            String query = "SELECT pm.providerCode as brandCode, hp.*, hc.* FROM " +
                    "ctm.provider_master pm JOIN ctm.home_product hp ON  pm.providerId = hp.providerId " +
                    "JOIN ctm.home_product_content hc ON hp.homeProductId = hc.homeProductId " +
                    "WHERE hp.code = ? AND hc.coverType = ? AND (hc.styleCodeId = ? or hc.styleCodeId = 0) ";

            if (effectiveDate != null) {
                query += " AND ? BETWEEN hp.effectiveStart and hp.effectiveEnd " +
                        " AND ? BETWEEN hc.effectiveStart and hc.effectiveEnd ";
            }
            query += " order by hc.styleCodeId";

            stmt = dbSource.getConnection().prepareStatement(query);

            stmt.setString(1, productId);
            stmt.setString(2, type);
            stmt.setInt(3, styleCodeId);

            if (effectiveDate != null) {
                stmt.setDate(4, new java.sql.Date(effectiveDate.getTime()));
                stmt.setDate(5, new java.sql.Date(effectiveDate.getTime()));
            }

            ResultSet results = stmt.executeQuery();

            // Get the first result
            if (results.next()) {
                HomeProduct product = createHomeProduct(results);
                return product;
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }

        return null;
    }

    private String createProductKey(String code, String coverType) {
        return code + "-" + coverType;
    }

    private HomeProduct createHomeProduct(ResultSet results) throws SQLException {
        HomeProduct product = new HomeProduct();
        product.setCode(results.getString("code"));
        product.setProviderProductName(results.getString("providerProductName"));
        product.setBrandCode(results.getString("brandCode"));
        product.setDisclaimer(results.getString("disclaimer"));
        product.setName(results.getString("name"));
        product.setDescription(results.getString("description"));
        product.setDiscountOffer(results.getString("discountOffer"));
        product.setDiscountOfferTerms(results.getString("discountOfferTerms"));
        product.setUnderwriterName(results.getString("underwriterName"));
        product.setUnderwriterABN(results.getString("underwriterABN"));
        product.setUnderwriterACN(results.getString("underwriterACN"));
        product.setUnderwriterAFSLicenceNo(results.getString("underwriterAFSLicenceNo"));
        boolean allowCallMeBack = results.getBoolean("allowCallMeBack");
        if (!results.wasNull()) {
            product.setAllowCallMeBack(allowCallMeBack);
        }
        boolean allowCallDirect = results.getBoolean("allowCallDirect");
        if (!results.wasNull()) {
            product.setAllowCallDirect(allowCallDirect);
        }
        product.setCallCentreHours(results.getString("callCentreHours"));
        product.setPhoneNumber(results.getString("phoneNumber"));
        product.setCoverType(CoverTypeEnum.fromCode(results.getString("coverType")));
        product.setOfflineDiscount(results.getString("offlineDiscount"));
        product.setOnlineDiscount(results.getString("onlineDiscount"));
        product.setBenefits(results.getString("benefits"));
        product.setInclusions(results.getString("inclusions"));
        product.setOptionalExtras(results.getString("optionalExtras"));
        product.setSpecialConditions(results.getString("specialConditions"));
        return product;
    }


}
