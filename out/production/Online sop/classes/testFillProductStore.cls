/**
 * Created by a2.buyko on 26.10.18.
 */

@IsTest
private class testFillProductStore {
    @IsTest
    static void testBehavior() {
        Reporting_period__c reportDate = new Reporting_period__c();
        reportDate.Name = 'Reporting_week';
        reportDate.Reporting_Date__c = Date.today().addDays(7);
        insert  reportDate;
        Store__c newStore = new Store__c();
        newStore.Name = 'Store';
        newStore.Start_Period__c = Date.today();
        newStore.End_Period__c = reportDate.Reporting_Date__c.addDays(newStore.Start_Period__c.day());
        insert newStore;
        Product__c product = new Product__c();
        product.Name = 'product';
        product.Date_of_receipt__c = Date.today() + 1;
        Test.startTest();
        Database.SaveResult result = Database.insert(product);
        Test.stopTest();
        System.debug([SELECT id FROM Store__c].size());
        System.assert([SELECT id from Store__c].size() == 2);
        System.assert(result.isSuccess());
    }
}