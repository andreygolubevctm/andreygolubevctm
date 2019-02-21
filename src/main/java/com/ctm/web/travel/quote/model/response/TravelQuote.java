package com.ctm.web.travel.quote.model.response;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * The response model from calling CtM's travel-quote application.
 *
 * This data model holds an individual quote for a product.
 */
public class TravelQuote {


    private String service;
    private String productId;
    private int trackCode;
    private boolean available;
    private BigDecimal price;
    private String priceText;
    private String quoteUrl;
    private String methodType;
    private Map<String, String> quoteData;
    private boolean encodeQuoteUrl;
    private Offer offer;
    private Product product;
    private List<Benefit> benefits;
    private Boolean isDomestic;

    public TravelQuote(){
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public int getTrackCode() {
        return trackCode;
    }

    public void setTrackCode(int trackCode) {
        this.trackCode = trackCode;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getPriceText() {
        return priceText;
    }

    public void setPriceText(String priceText) {
        this.priceText = priceText;
    }

    public String getQuoteUrl() {
        return quoteUrl;
    }

    public void setQuoteUrl(String quoteUrl) {
        this.quoteUrl = quoteUrl;
    }

    public String getMethodType() {
        return methodType;
    }

    public void setMethodType(String methodType) {
        this.methodType = methodType;
    }

    public Map<String, String> getQuoteData() {
        return quoteData;
    }

    public void setQuoteData(Map<String, String> quoteData) {
        this.quoteData = quoteData;
    }

    public boolean isEncodeQuoteUrl() {
        return encodeQuoteUrl;
    }

    public void setEncodeQuoteUrl(boolean encodeQuoteUrl) {
        this.encodeQuoteUrl = encodeQuoteUrl;
    }

    public Offer getOffer() {
        return offer;
    }

    public void setOffer(Offer offer) {
        this.offer = offer;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public List<Benefit> getBenefits() {
        return benefits;
    }

    public String getBenefit(String type){
        for(Benefit benefit : benefits){
            if(benefit.getType().equalsIgnoreCase(type)){
                return benefit.getText();
            }
        }
        return "";
    }

    public String getBenefitByLabel(String label) {
        for(Benefit benefit : benefits){
            if(benefit.getLabel() != null && benefit.getLabel().equalsIgnoreCase(label)){
                return benefit.getText();
            }
        }
        return "$0";
    }

    public String getBenefitByLabelArray(String[] labels) {
        for (String label : labels) {
            for(Benefit benefit : benefits){
                if(benefit.getLabel() != null && benefit.getLabel().equalsIgnoreCase(label)){
                    return benefit.getText();
                }
            }
        }

        return "$0";
    }

    public BigDecimal getBenefitValue(String type){
        for(Benefit benefit : benefits){
            if(benefit.getType().equalsIgnoreCase(type)){
                return benefit.getValue();
            }
        }
        return new BigDecimal(0);
    }

    public BigDecimal getBenefitValueByLabel(String label){
        for(Benefit benefit : benefits){
            if(benefit.getLabel() != null && benefit.getLabel().equalsIgnoreCase(label)){
                return benefit.getValue();
            }
        }
        return new BigDecimal(0);
    }

    public BigDecimal getBenefitValueByLabelArray(String[] labels){
        for (String label : labels) {
            for(Benefit benefit : benefits){
                if(benefit.getLabel() != null && benefit.getLabel().equalsIgnoreCase(label)){
                    return benefit.getValue();
                }
            }
        }
        return new BigDecimal(0);
    }

    public void setBenefits(List<Benefit> benefits) {
        this.benefits = benefits;
    }

    public Boolean getIsDomestic() { return isDomestic; }

    public void setIsDomestic(Boolean isDomestic) {
        this.isDomestic = isDomestic;
    }
}
