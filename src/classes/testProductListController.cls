/**
 * Created by a2.buyko on 15.1.19.
 */

@IsTest
private class testProductListController {

    @IsTest
    static void testGetProductsOnNull() {
        System.assert(ProductListController.getProducts(null).size() == 0);
    }

    @IsTest
    static void testGetProductsOnListProducts() {
        Reporting_period__c reportDate = new Reporting_period__c();
        reportDate.Name = 'Reporting_week';
        reportDate.onlineStore__Reporting_Date__c = Date.today().addDays(7);
        insert  reportDate;
        Product__c newProduct = new Product__c();
        newProduct.Name = 'RandomProduct';
        newProduct.onlineStore__Number_of_purchase__c = 1;
        newProduct.onlineStore__Date_of_receipt__c = Date.today() + 1;
        insert newProduct;
        List<Product__c> listProducts = [SELECT Id FROM Product__c];
        System.debug(listProducts);
        List<String> listIds = new List<String>();
        for (Product__c product : listProducts){
            listIds.add(product.Id);
        }
        System.assert(ProductListController.getProducts(listIds).size() > 0);
    }

    @IsTest
    static void testGetAccountDiscount() {
        Account account = new Account();
        Contact contact = new Contact();
        Discount__c discount = new Discount__c();
        account.Name = 'AccountName';
        insert account;
        contact.FirstName = 'Anton';
        contact.LastName = 'Buiko';
        contact.AccountId = account.Id;
        contact.Password__c = '123';
        contact.Email__c = 'buianton@yandex.ru';
        insert contact;

        discount.Name = 'TestDiscount';
        discount.Percentes_of_discount__c = 10;
        discount.Status__c = 'Active';
        discount.Account__c = account.Id;
        discount.Static_discount__c = 10;
        insert discount;
        System.assert(ProductListController.getAccountDiscount(contact.Id) == true);
        System.assert(ProductListController.getAccountDiscount(account.Id) == false);
    }

    @IsTest
    static void testFindDiscount() {
        Discount__c discount = new Discount__c();
        discount.Name = 'TestDiscount';
        discount.onlineStore__Percentes_of_discount__c = 10;
        discount.onlineStore__Status__c = 'Active';
        discount.onlineStore__Static_discount__c = 10;
        discount.onlineStore__Discount_Code__c = '123';
        insert discount;

        System.assert(ProductListController.findDiscount('123').onlineStore__Discount_Code__c == discount.onlineStore__Discount_Code__c);
    }

    @IsTest
    static void testSendEmailAndFeed() {
        Account account = new Account();
        Contact contact = new Contact();
        account.Name = 'AccountName';
        insert account;
        contact.FirstName = 'Anton';
        contact.LastName = 'Buiko';
        contact.AccountId = account.Id;
        contact.onlineStore__Password__c = '123';
        contact.onlineStore__Email__c = 'buianton@yandex.ru';
        insert contact;
        List<Map<String, Object>> testList = new List<Map<String, Object>>();
        Map<String, Object> mapProduct = new Map<String, Object>();
        mapProduct.put('Name', 'RandomProduct');
        mapProduct.put('onlineStore__Number_of_purchase__c', '1');
        mapProduct.put('onlineStore__Cost__c', '100');
        mapProduct.put('onlineStore__Description__c', 'Description');
        testList.add(mapProduct);
        Messaging.SendEmailResult[] results = ProductListController.sendEmailAndFeed(contact, testList);
        for (Messaging.SendEmailResult result : results){
            System.assert(result.success == true);
        }
    }

}