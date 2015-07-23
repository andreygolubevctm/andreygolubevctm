package com.ctm.providers.travel.travelquote.model.response;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public class TravelQuote {


    private String service;
    private String productId;
    private int trackCode;
    private boolean available;
    private BigDecimal price;
    private String priceText;
    private String quoteUrl;
    private QuoteMethodType methodType;
    private Map<String, String> quoteData;
    private boolean encodeQuoteUrl;
    private Product product;
    private List<Benefit> benefits;

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

    public QuoteMethodType getMethodType() {
        return methodType;
    }

    public void setMethodType(QuoteMethodType methodType) {
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

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public List<Benefit> getBenefits() {
        return benefits;
    }

    public void setBenefits(List<Benefit> benefits) {
        this.benefits = benefits;
    }
}
