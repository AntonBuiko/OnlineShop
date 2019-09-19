/**
 * Created by a2.buyko on 8.11.18.
 */

public with sharing class SuccesOrderController {
    public Id productId {get;set;}
    public Product__c product {get;set;}
    public Decimal newPrice {get;set;}

    public SuccesOrderController()
    {
        productId = ApexPages.currentPage().getParameters().get('productId');
        String priceParam = ApexPages.currentPage().getParameters().get('newPrice');
        if (priceParam != null) {
            newPrice = Decimal.valueOf(priceParam);
        }
        product = [SELECT Id, Name, Img_Url__c, Description__c, Amount__c, Number_of_purchase__c,
                Date_of_purchase__c, Date_of_receipt__c, Title__c,
                Cost__c FROM Product__c WHERE Id = :productId];
        System.debug(product);
    }

    public String getUser(){
        return UserInfo.getName();
    }

}