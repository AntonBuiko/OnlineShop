/**
 * Created by a2.buyko on 22.11.18.
 */

public with sharing class GoogleMapExtension {
    private final Contacts__c contact;

    public GoogleMapExtension(ApexPages.StandardController stdController){
        this.contact = (Contacts__c)stdController.getRecord();
        System.debug(contact);
    }
}