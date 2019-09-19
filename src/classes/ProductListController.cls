global with sharing class ProductListController {
    @RemoteAction
    global static List<Product__c> getProducts(List<String> listId)
    {
        if (listId != null) {
        List<Product__c> products = new List<Product__c>();
            for(String id : listId){
                products.add([
                        SELECT Id, Name, Img_Url__c, Description__c, Amount__c, Number_of_purchase__c,
                                Date_of_purchase__c, Date_of_receipt__c, Title__c, Cost__c, RecordTypeId
                        FROM Product__c
                        WHERE RecordType.Name = 'Made' AND Id = :id
                ]);
            }
            return products;
        }
        else {
            return [
                    SELECT Id, Name, Img_Url__c, Description__c, Amount__c, Number_of_purchase__c,
                            Date_of_purchase__c, Date_of_receipt__c, Title__c, Cost__c, RecordTypeId
                    FROM Product__c
                    WHERE RecordType.Name = 'Made'
            ];
        }
    }

    @RemoteAction
    global static Boolean getAccountDiscount(String contactId)
    {
        List<Account> account = [
                SELECT Id
                FROM Account
                WHERE Id IN (SELECT AccountId FROM Contact WHERE Id = :contactId)
        ];
        if (account.size() > 0) {
            if ([SELECT Id FROM Discount__c WHERE Account__c in :account AND Status__c = 'Active'].size() > 0) {
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }

    @RemoteAction
    global static Discount__c findDiscount(String code)
    {
        List<Discount__c> discounts = [
                SELECT Id, Discount_Code__c, Percentes_of_discount__c, Static_discount__c, Account__c
                FROM Discount__c
                WHERE Discount_Code__c = :code AND Status__c = 'Active'
        ];
        if (discounts.size() > 0) {
            return discounts.get(0);
        }
        else{
            return null;
        }
    }

    @RemoteAction
    global static Messaging.SendEmailResult[] sendEmailAndFeed(Contact existingContact, List<Map<String, Object>> products){
        System.debug(existingContact);
        System.debug(products);
        String productsHtml = ' ';
        for (Map<String, Object> product : products){
            productsHtml += product.get('onlineStore__Name') + '</p><p>Your order: '+
                    product.get('onlineStore__Name') + ' Description: ' + product.get('onlineStore__Description__c') + ' Cost: ' + product.get('onlineStore__Cost__c') + '$</p><p>';
        }
        String html = 'Hi ' + existingContact.get('LastName') + '<p>Thank you for purchase ' + productsHtml;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setCcAddresses(new String[]{'noreply@magaz.com'} );
        System.debug(existingContact.get('onlineStore__Email__c'));
        email.setToAddresses(new String[]{existingContact.get('onlineStore__Email__c').toString()});
        email.setSubject('Thank you for purchase!');
        email.setHtmlBody(html);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        if (results[0].success) {
            System.debug('The email was sent successfully.');
            return results;
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
            return results;
        }
//        for (Map<String, Object> product : products) {
//            sObject fItem = (sObject) System.Type.forName('FeedItem').newInstance();
//            fItem.put('NetworkScope', 'AllNetworks');
//            fItem.put('Visibility', 'AllUsers');
//            fItem.put('ParentId', existingContact.get('Id'));
//            fItem.put('Body', Label.SuccessOrder + ': ' + product.get('Name') + ' ' + Label.Amount + ': '
//                    + product.get('Amount__c') + ' ' + Label.Cost + ': ' + product.get('Cost__c'));
//            insert fItem;
//        }
    }
}