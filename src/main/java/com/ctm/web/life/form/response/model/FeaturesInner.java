package com.ctm.web.life.form.response.model;



import java.util.List;

public class FeaturesInner {

    private List<FeatureWithAvailability> feature;

    public List<FeatureWithAvailability> getFeature() {
        return feature;
    }

    public void setFeature(List<FeatureWithAvailability> feature) {
        this.feature = feature;
    }
}
