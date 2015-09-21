package com.ctm.services.email;

import com.ctm.logging.CorrelationIdUtils;
import com.ctm.model.email.ExactTargetEmailModel;
import com.exacttarget.wsdl.partnerapi.*;

import javax.xml.bind.JAXBElement;
import java.util.List;
import java.util.Map;


public class ExactTargetEmailBuilder {

    public static void createPayload(ExactTargetEmailModel exactTargetEmailModel, CreateRequest createRequest) {
        ObjectFactory objectFactory = new com.exacttarget.wsdl.partnerapi.ObjectFactory();

        CreateOptions options = new CreateOptions();
        createRequest.setOptions(options );
        List<APIObject> objects = createRequest.getObjects();

        TriggeredSend triggeredSend = new TriggeredSend();
        //CorrelationID Identifies correlation of objects across several requests
        CorrelationIdUtils.getCorrelationId().ifPresent(correlationId -> {
            triggeredSend.setCorrelationID(correlationId);
        });

        ClientID client = createClient(exactTargetEmailModel);

        triggeredSend.setClient(client);

        TriggeredSendDefinition triggeredSendDefinition = createTriggeredSendDefinition(
                exactTargetEmailModel, objectFactory);

        triggeredSend.setTriggeredSendDefinition(triggeredSendDefinition);

        Subscriber subscriber = createSubscriber(exactTargetEmailModel);
        triggeredSend.getSubscribers().add(subscriber);

        objects.add(triggeredSend);
    }

    private static ClientID createClient(ExactTargetEmailModel exactTargetEmailModel) {
        ClientID clientId = new ClientID();
        clientId.setClientID(exactTargetEmailModel.getClientId());
        return clientId;
    }

    private static TriggeredSendDefinition createTriggeredSendDefinition(
            ExactTargetEmailModel exactTargetEmailModel,
            ObjectFactory objectFactory) {
        TriggeredSendDefinition triggeredSendDefinition = new TriggeredSendDefinition();
        JAXBElement<String> partnerKey = objectFactory.createAPIObjectPartnerKey(null);
        partnerKey.setNil(true);
        triggeredSendDefinition.setPartnerKey(partnerKey);
        JAXBElement<String> objectID = objectFactory.createAPIObjectObjectID(null);
        objectID.setNil(true);
        triggeredSendDefinition.setObjectID(objectID);
        triggeredSendDefinition.setCustomerKey(exactTargetEmailModel.getCustomerKey());
        SendClassification sendClassification = new SendClassification();
        triggeredSendDefinition.setSendClassification(sendClassification);
        return triggeredSendDefinition;
    }

    private  static Subscriber createSubscriber(ExactTargetEmailModel exactTargetEmailModel) {
        Subscriber subscriber = new Subscriber();
        subscriber.setEmailAddress(exactTargetEmailModel.getEmailAddress()); // updating to new email address.
        subscriber.setSubscriberKey(subscriber.getEmailAddress()); //subscriber unique, cannot update

        for(Map.Entry<String, String> attribute: exactTargetEmailModel.getAttributes().entrySet()) {
            String value = attribute.getValue();
            String normalisedValue = value == null ? "" : value;
            Attribute attributeElement = new Attribute();
            attributeElement.setName(attribute.getKey());
            attributeElement.setValue(normalisedValue);
            subscriber.getAttributes().add(attributeElement);
        }
        return subscriber;
    }


}

