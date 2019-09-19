/**
 * Created by a2.buyko on 2.11.18.
 */

public class DetailPageController {
    public String productId {get; set;}
    public DetailPageController(){
        productId = ApexPages.currentPage().getParameters().get('productId');
    }

    public Product__c getProduct(){
        return [SELECT Id, Title__c, Name, Amount__c, Description__c, Img_Url__c FROM Product__c WHERE Id = :productId];
    }

    public PageReference toProductList()
    {
        PageReference pr = Page.Product_list;
        return pr;
    }

    public void estMethod(){}


    public void estMethod2(){}
}