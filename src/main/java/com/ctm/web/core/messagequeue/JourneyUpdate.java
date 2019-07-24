package com.ctm.web.core.messagequeue;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class JourneyUpdate {

    @JsonProperty
    public List<String> sources;
    @JsonProperty
    public String sessionId;
    @JsonProperty
    public String userId;
}
