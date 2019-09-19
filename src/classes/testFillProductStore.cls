/**
 * Created by a2.buyko on 26.10.18.
 */

@IsTest
private class testFillProductStore {
    @IsTest
    static void testBehavior() {
        Reporting_period__c reportDate = new Reporting_period__c();
        reportDate.Name = 'Reporting_week';
        reportDate.onlineStore__Reporting_Date__c = Date.today().addDays(7);
        insert  reportDate;
        Product__c product = new Product__c();
        product.Name = 'product';
        product.onlineStore__Number_of_purchase__c = 1;
        product.onlineStore__Date_of_receipt__c = Date.today() + 1;
        Database.SaveResult result = Database.insert(product);
        System.debug(result);
        System.debug([SELECT id FROM Store__c].size());
        System.assert([SELECT id FROM Store__c].size() == 1);
        System.assert(result.isSuccess());
    }
}