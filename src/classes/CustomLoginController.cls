/**
 * Created by a2.buyko on 18.12.18.
 */

global with sharing class CustomLoginController {

    @RemoteAction
    global static Contact postLogin(String contactEmail, String password){
        System.debug([SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()]);
        List<Contact> contacts = [
                SELECT Id, LastName, Email__c, Password__c
                FROM Contact
                WHERE Email__c =:contactEmail AND Password__c = :password
        ];
        if (contacts.size() > 0) {
            return contacts.get(0);
        }
        else{
            return null;
        }
    }

    @RemoteAction
    global static void postRegister(String contactEmail, String password, String name){
        try{
            Contact newContact = new Contact();
            newContact.RecordTypeId = '0126F000001KBbLQAW';
            newContact.LastName = name;
            newContact.Email__c = contactEmail;
            newContact.Password__c = password;
            newContact.AccountId = '0016F00002yp9c1QAA';
            insert newContact;
            postLogin(contactEmail, password);
        }
        catch (Exception dmlEx){
            //dmlEx.setMessage('Email already exists');
            throw dmlEx;
        }
    }
}