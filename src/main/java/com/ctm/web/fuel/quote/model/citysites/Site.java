package com.ctm.web.fuel.quote.model.citysites;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Site {
    @JsonProperty(value = "id", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Long id;

    @JsonProperty(value = "brandId", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Long brandId;

    @JsonProperty(value = "name", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private String name;

    @JsonProperty(value = "address", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private String address;

    @JsonProperty(value = "lat", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Float lat;

    @JsonProperty(value = "lng", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Float lng;

    @JsonProperty(value = "bandId", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Long bandId;

    @JsonProperty(value = "cityId", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private Long cityId;

    @JsonProperty(value = "lastUpdated", access = JsonProperty.Access.WRITE_ONLY) // This is to deserialize back in web_ctm. For informedsources, setter is used
    private String lastUpdated;

    /* Jackson serialization */
    private Site() {
    }

    private Site(Builder builder) {
        setAddress(builder.address);
        setId(builder.id);
        setBrandId(builder.brandId);
        setName(builder.name);
        setLat(builder.lat);
        setLng(builder.lng);
        setBandId(builder.bandId);
        setCityId(builder.cityId);
        setLastUpdated(builder.lastUpdated);
    }

    @JsonIgnore
    public static Builder newBuilder() {
        return new Builder();
    }

    @JsonIgnore
    public static Builder newBuilder(Site site) {
        return new Builder(site);
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Long getId() {
        return id;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public String getAddress() {
        return address;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public String getName() {
        return name;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Long getBrandId() {
        return brandId;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Float getLat() {
        return lat;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Float getLng() {
        return lng;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Long getBandId() {
        return bandId;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Long getCityId() {
        return  cityId;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public String getLastUpdated() {
        return lastUpdated;
    }

    @JsonProperty(value = "S", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setId(Long id) {
        this.id = id;
    }

    @JsonProperty(value = "B", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setBrandId(Long brandId) {
        this.brandId = brandId;
    }

    @JsonProperty(value = "N", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setName(String name) {
        this.name = name;
    }

    @JsonProperty(value = "A", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setAddress(String address) {
        this.address = address;
    }

    @JsonProperty(value = "Lat", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setLat(Float lat) {
        this.lat = lat;
    }

    @JsonProperty(value = "Lng", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setLng(Float lng) {
        this.lng = lng;
    }

    @JsonProperty(value = "C", access = JsonProperty.Access.WRITE_ONLY) // Setter is used to deserialize from informedsources. For wet_ctm, property is used
    private void setCityId(Long cityId) {
        this.cityId = cityId;
    }

    private void setBandId(Long bandId) {
        this.bandId = bandId;
    }

    private void setLastUpdated(String lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Site site = (Site) o;

        if (id != null ? !id.equals(site.id) : site.id != null) return false;
        if (brandId != null ? !brandId.equals(site.brandId) : site.brandId != null) return false;
        if (name != null ? !name.equals(site.name) : site.name != null) return false;
        if (address != null ? !address.equals(site.address) : site.address != null) return false;
        if (lat != null ? !lat.equals(site.lat) : site.lat != null) return false;
        if (lng != null ? !lng.equals(site.lng) : site.lng != null) return false;
        if (bandId != null ? !bandId.equals(site.bandId) : site.bandId != null) return false;
        return cityId != null ? cityId.equals(site.cityId) : site.cityId == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (brandId != null ? brandId.hashCode() : 0);
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (address != null ? address.hashCode() : 0);
        result = 31 * result + (lat != null ? lat.hashCode() : 0);
        result = 31 * result + (lng != null ? lng.hashCode() : 0);
        result = 31 * result + (bandId != null ? bandId.hashCode() : 0);
        result = 31 * result + (cityId != null ? cityId.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "Site{" +
                "address='" + address + '\'' +
                ", id=" + id +
                ", brandId=" + brandId +
                ", name='" + name + '\'' +
                ", lat=" + lat +
                ", lng=" + lng +
                ", bandId=" + bandId +
                ", cityId=" + cityId +
                '}';
    }

    public static final class Builder {
        private String address;
        private Long id;
        private Long brandId;
        private String name;
        private Float lat;
        private Float lng;
        private Long bandId;
        private Long cityId;
        private String lastUpdated;

        private Builder() {
        }

        public Builder(Site copy) {
            this.address = copy.address;
            this.id = copy.id;
            this.brandId = copy.brandId;
            this.name = copy.name;
            this.lat = copy.lat;
            this.lng = copy.lng;
            this.bandId = copy.bandId;
            this.cityId = copy.cityId;
            this.lastUpdated = copy.lastUpdated;
        }

        public Builder address(String val) {
            address = val;
            return this;
        }

        public Builder id(Long val) {
            id = val;
            return this;
        }

        public Builder brandId(Long val) {
            brandId = val;
            return this;
        }

        public Builder name(String val) {
            name = val;
            return this;
        }

        public Builder lat(Float val) {
            lat = val;
            return this;
        }

        public Builder lng(Float val) {
            lng = val;
            return this;
        }

        public Builder bandId(Long val) {
            bandId = val;
            return this;
        }

        public Builder cityId(Long val) {
            cityId = val;
            return this;
        }

        public Builder lastUpdated(String val) {
            lastUpdated = val;
            return this;
        }

        public Site build() {
            return new Site(this);
        }
    }
}
