/**
 * Created by a2.buyko on 30.10.18.
 */

public with sharing class BuyProductController {
    public String productId;
    public Decimal newPrice {get;set;}
    public String endDiscount{get;set;}

    public Discount__c discount {get;set;}
    public User currentUser {get;set;}
    private final Product__c product{get;set;}
    public RecordType soldRecordType{get;set;}
    public Contacts__c contact {get;set;}
    public Contacts__c existingContact;
    public Product__c soldProduct;

    public BuyProductController(){
        currentUser = [SELECT Id, Username, isDiscount__c FROM User WHERE Username = :UserInfo.getUserName()];
        contact = new Contacts__c();
        soldRecordType = new RecordType();
        productId =  ApexPages.currentPage().getParameters().get('productId');
        product = [SELECT Id, Name, Img_Url__c, Description__c, Amount__c, Number_of_purchase__c,
                Date_of_purchase__c, Date_of_receipt__c, Title__c,
                Cost__c  FROM Product__c WHERE Id = :productId];
        if (currentUser.isDiscount__c == true) {
            discount =  [SELECT Id, End_Discount_Data__c, Static_discount__c, Percentes_of_discount__c, Status__c, Discount_Code__c
                         FROM Discount__c
                         WHERE Id = :ApexPages.currentPage().getParameters().get('discountId')];
            newPrice = DiscountHelper.CalculateDiscount(discount, product);
            endDiscount = Label.Days + ': ' + String.valueOf(discount.End_Discount_Data__c.day() - Datetime.now().day()) + ' '
                    + Label.Hours + ': '
                    + (discount.End_Discount_Data__c.hour() > Datetime.now().hour() ? String.valueOf(discount.End_Discount_Data__c.hour() - Datetime.now().hour()) :
                    String.valueOf( Datetime.now().hour() - discount.End_Discount_Data__c.hour() ))
                    + ' ' + Label.Minutes + ': '
                    + (discount.End_Discount_Data__c.minute() > Datetime.now().minute() ? String.valueOf(discount.End_Discount_Data__c.minute() - Datetime.now().minute()) :
                    String.valueOf( Datetime.now().minute() - discount.End_Discount_Data__c.minute() ));
        }
        else discount = new Discount__c();
        System.debug(newPrice);
    }

    public Product__c getProduct(){
        return product;
    }

    public PageReference SubmitOrder(){
        System.debug(contact);
            if (product.Amount__c > 0) {
                PageReference pr = Page.SuccessOrder;
                UpsertContact();
                CreateSoldProduct();
                SendEmail();
                pr.getParameters().put('productId', soldProduct.Id);
                pr.getParameters().put('newPrice', String.valueOf(newPrice));
                SendFeed();
                return pr;
            }
            else{
                return toProductList(product.Name + ' --> Out of a stock');
            }
        }

    public PageReference toProductList(String errorMsg)
    {
        PageReference pr = Page.Product_list;
        if (errorMsg != null) {
            pr.getParameters().put('errorMsg' , errorMsg);
        }
        System.debug(pr);
        return pr;
    }

    public void CreateSoldProduct()
    {
        System.debug(DiscountHelper.findDiscount(discount.Discount_Code__c));
        Discount__c discount = DiscountHelper.findDiscount(discount.Discount_Code__c);
        soldProduct = new Product__c();
        product.Amount__c--;
        update product;
        if (soldRecordType.Name != 'Sold') {
            soldRecordType = [SELECT Id, Name FROM RecordType WHERE Name='Sold'];
        }
        System.debug(soldRecordType);
        soldProduct = product.clone(false,true);
        soldProduct.Amount__c = 1;
        soldProduct.RecordTypeId = soldRecordType.Id;
        soldProduct.Sale_Status__c = 'Completed';
        soldProduct.Contacts__c = existingContact.Id;
        soldProduct.Date_of_purchase__c = Date.today();
        if (discount != null) {
            soldProduct.Cost__c =  DiscountHelper.CalculateDiscount(discount, soldProduct);
        }
        if (newPrice != null && newPrice != soldProduct.Cost__c) {
            soldProduct.Cost__c = newPrice;
        }
        System.debug(existingContact);
        System.debug(soldProduct);
        insert soldProduct;
    }

    public void UpsertContact()
    {
        try {
           existingContact = [SELECT Id, Name, Description__c, Phone__c, Address__c FROM Contacts__c WHERE Email__c = :contact.Email__c];
        }
        catch (Exception ex){
            existingContact = new Contacts__c();
        }
        System.debug(contact);
        existingContact.Email__c = contact.Email__c;
        existingContact.Name = contact.Name;
        existingContact.Phone__c = contact.Phone__c;
        existingContact.Address__c = contact.Address__c;
        System.debug(existingContact);
        upsert existingContact;
    }

    public void SendEmail(){
        String html = 'Hi ' + existingContact.Name + '<p>Thank you for purchase ' + product.Name + '</p><p>Your order: '+
                product.Name + ' Description: ' + product.Description__c + ' Cost: ' + soldProduct.Cost__c + '$</p>';
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setCcAddresses(new String[]{'noreply@magaz.com'} );
        email.setToAddresses(new String[]{existingContact.Email__c});
        email.setSubject('Thank you for purchase!');
        email.setHtmlBody(html);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }

    public void SendFeed(){
        if (Schema.SObjectType.User.isFeedEnabled())
        {
            sObject fItem = (sObject)System.Type.forName('FeedItem').newInstance();
            fitem.put('ParentId' ,UserInfo.getUserId()); // or Account or Contact or Opportunity Id
            fItem.put('Body' , Label.SuccessOrder + ': ' + soldProduct.Name + ' ' + Label.Amount + ': '
                    + soldProduct.Amount__c + ' ' + Label.Cost + ': ' + soldProduct.Cost__c);
            insert fItem;
        }
    }
}