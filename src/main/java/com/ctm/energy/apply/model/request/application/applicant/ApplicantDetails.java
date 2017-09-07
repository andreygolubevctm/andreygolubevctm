package com.ctm.energy.apply.model.request.application.applicant;

import com.fasterxml.jackson.annotation.JsonFormat;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;

public class ApplicantDetails  {

    @NotNull
    private String title;
    @NotNull
    private String firstName;
    @NotNull
    private String lastName;

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
    @NotNull
    private LocalDate dateOfBirth;

    private ApplicantDetails() {
    }

    private ApplicantDetails(Builder builder) {
        title = builder.title;
        firstName = builder.firstName;
        lastName = builder.lastName;
        dateOfBirth = builder.dateOfBirth;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getTitle() {
        return title;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }


    public static final class Builder {
        private String title;
        private String firstName;
        private String lastName;
        private LocalDate dateOfBirth;

        private Builder() {
        }

        public Builder title(String val) {
            title = val;
            return this;
        }

        public Builder firstName(String val) {
            firstName = val;
            return this;
        }

        public Builder lastName(String val) {
            lastName = val;
            return this;
        }

        public Builder dateOfBirth(LocalDate val) {
            dateOfBirth = val;
            return this;
        }

        public ApplicantDetails build() {
            return new ApplicantDetails(this);
        }
    }
}
