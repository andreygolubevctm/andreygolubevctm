package com.ctm.web.creditcards.model;

import com.ctm.web.core.model.Product;
import com.ctm.web.core.model.Provider;
import com.ctm.web.creditcards.model.Views.ComparisonView;
import com.ctm.web.creditcards.model.Views.DetailedView;
import com.ctm.web.creditcards.model.Views.MapView;
import com.ctm.web.creditcards.model.Views.SummaryView;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonView;

public class CreditCardProduct  {

	private int id;
	private String code;
	private String handoverUrl;
	@JsonView(MapView.class) private String slug;
	private Provider provider;
	@JsonView(DetailedView.class) @JsonProperty private Meta meta;

	@JsonView(SummaryView.class) private String shortDescription;
	@JsonView(SummaryView.class) private String type;
	@JsonView(SummaryView.class) private String cardClass;
	@JsonView(SummaryView.class) private Data data;
	@JsonView(ComparisonView.class) private Features features;
	@JsonView(DetailedView.class) private Information information;
	@JsonView(SummaryView.class) private String specialOffer;
	@JsonView(ComparisonView.class) private String otherFeatures;
	@JsonView(ComparisonView.class) private String rewardsDescription;
	@JsonIgnore private String otherFeaturesAsString;
	@JsonIgnore private String rewardsDescriptionAsString;

	public CreditCardProduct(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getSlug() {
		return slug;
	}

	public void setSlug(String slug) {
		this.slug = slug;
	}

	public Provider getProvider() {
		return provider;
	}

	public void setProvider(Provider provider) {
		this.provider = provider;
	}

	public Meta getMeta() {
		return meta;
	}

	public void setMeta(Meta meta) {
		this.meta = meta;
	}

	public String getShortDescription() {
		return shortDescription;
	}

	public void setShortDescription(String shortDescription) {
		this.shortDescription = shortDescription;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getCardClass() {
		return cardClass;
	}

	public void setCardClass(String cardClass) {
		this.cardClass = cardClass;
	}

	public Data getData() {
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

	public Features getFeatures() {
		return features;
	}

	public void setFeatures(Features features) {
		this.features = features;
	}

	public Information getInformation() {
		return information;
	}

	public void setInformation(Information information) {
		this.information = information;
	}

	public String getSpecialOffer() {
		return specialOffer;
	}

	public void setSpecialOffer(String specialOffer) {
		this.specialOffer = specialOffer;
	}

	@JsonView(ComparisonView.class)
	public String[] getRewardsDescription(){
		if(rewardsDescriptionAsString == null) return null;
		return rewardsDescriptionAsString.split("\n");
	}

	public void setRewardsDescriptionAsString(String rewardsDescription) {
		this.rewardsDescriptionAsString = rewardsDescription;
	}

	public String getRewardsDescriptionAsString() {
		return rewardsDescriptionAsString;
	}

	@JsonView(ComparisonView.class)
	public String[] getOtherFeatures(){
		if(otherFeaturesAsString == null) return null;
		return otherFeaturesAsString.split("\n");
	}

	public void setOtherFeaturesAsString(String otherFeatures) {
		this.otherFeaturesAsString = otherFeatures;
	}

	public String getOtherFeaturesAsString() {
		return otherFeaturesAsString;
	}

	public void importFromProduct(Product product){

		setId(product.getId());
		setCode(product.getCode());
		setHandoverUrl(product.getPropertyAsString("handover-url"));
		setProvider(product.getProvider());
		setCardClass(product.getPropertyAsString("card-class"));
		setShortDescription(product.getLongTitle());
		setSlug(product.getPropertyAsString("slug"));
		setSpecialOffer(product.getPropertyAsString("special-offer"));
		setRewardsDescriptionAsString(product.getPropertyAsLongText("rewards-desc"));
		setOtherFeaturesAsString(product.getPropertyAsLongText("other-features"));
		setType(product.getPropertyAsString("type"));

		Data data = new Data();
		data.importFromProduct(product);
		setData(data);

		Features features = new Features();
		features.importFromProduct(product);
		setFeatures(features);

		Information information = new Information();
		information.importFromProduct(product);
		setInformation(information);

		Meta meta = new Meta();
		meta.importFromProduct(product);
		setMeta(meta);

	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getHandoverUrl() {
		return handoverUrl;
	}

	public void setHandoverUrl(String handoverUrl) {
		this.handoverUrl = handoverUrl;
	}

}
