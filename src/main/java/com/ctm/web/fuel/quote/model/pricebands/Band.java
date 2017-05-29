package com.ctm.web.fuel.quote.model.pricebands;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Band {
    @JsonProperty(value = "id", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Long id;

    @JsonProperty(value = "fromPrice", access = JsonProperty.Access.WRITE_ONLY)  // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Float fromPrice;

    @JsonProperty(value = "toPrice", access = JsonProperty.Access.WRITE_ONLY)  // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Float toPrice;

    /* Jackson serialization */
    private Band() {
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Long getId() {
        return id;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Float getFromPrice() {
        return fromPrice;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Float getToPrice() {
        return toPrice;
    }

    @JsonProperty(value = "I", access = JsonProperty.Access.WRITE_ONLY)  // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    public void setId(Long id) {
        this.id = id;
    }

    @JsonProperty(value = "B", access = JsonProperty.Access.WRITE_ONLY)  // Setter is used to deserializefrom informedsources. For wet_ctm, property is used
    public void setFromPrice(Float fromPrice) {
        this.fromPrice = fromPrice;
    }

    @JsonProperty(value = "E", access = JsonProperty.Access.WRITE_ONLY)  // Setter is used to deserializefrom informedsources. For wet_ctm, property is used
    public void setToPrice(Float toPrice) {
        this.toPrice = toPrice;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Band band = (Band) o;

        if (id != null ? !id.equals(band.id) : band.id != null) return false;
        if (fromPrice != null ? !fromPrice.equals(band.fromPrice) : band.fromPrice != null) return false;
        return toPrice != null ? toPrice.equals(band.toPrice) : band.toPrice == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (fromPrice != null ? fromPrice.hashCode() : 0);
        result = 31 * result + (toPrice != null ? toPrice.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "Band{" +
                "id=" + id +
                ", fromPrice=" + fromPrice +
                ", toPrice=" + toPrice +
                '}';
    }
}
