package com.ctm.soap;

import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.apache.cxf.jaxrs.ext.MessageContextImpl;
import org.apache.cxf.jaxrs.impl.MetadataMap;
import org.apache.cxf.jaxrs.utils.FormUtils;
import org.apache.cxf.jaxrs.utils.HttpUtils;
import org.apache.cxf.message.Message;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;
import org.apache.cxf.transport.http.AbstractHTTPDestination;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import java.io.InputStream;

public class FormParamMapInInterceptor extends AbstractPhaseInterceptor<Message> {

    public FormParamMapInInterceptor() {
        super(Phase.PRE_UNMARSHAL);
    }

    @Override
    public void handleMessage(Message message) throws Fault {
        MessageContext mc = new MessageContextImpl(message);
        MediaType mt = mc.getHttpHeaders().getMediaType();

        String enc = HttpUtils.getEncoding(mt, "UTF-8");
        String body = FormUtils.readBody(message.getContent(InputStream.class), enc);
        HttpServletRequest request = (HttpServletRequest)message.get(AbstractHTTPDestination.HTTP_REQUEST);

        MultivaluedMap<String, String> params = new MetadataMap<String, String>();

        FormUtils.populateMapFromString(params, message, body, enc, true, request);
        MultivaluedMap<String, String> newParams = new MetadataMap<String, String>();

        for (String key : params.keySet()) {
            String newKey = StringUtils.replace(key, "_", ".");
            newParams.put(newKey, params.get(key));
        }
        message.put(FormUtils.FORM_PARAM_MAP, newParams);
    }
}
