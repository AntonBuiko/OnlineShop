/**
 * Created by a2.buyko on 22.11.18.
 */

public with sharing class GoogleMapExtension {
    private final Contact contact;

    public GoogleMapExtension(ApexPages.StandardController stdController){
        this.contact = (Contact)stdController.getRecord();
        System.debug(contact);
    }
}