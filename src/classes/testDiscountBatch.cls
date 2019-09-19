/**
 * Created by a2.buyko on 16.1.19.
 */

@IsTest
private class testDiscountBatch {
    @IsTest
    static void testBatch() {
        List<Discount__c> listDiscounts = new List<Discount__c>();
        for (Integer i = 0; i < 50; i++){
            Discount__c discount = new Discount__c();
            discount.Name = 'Discount' + i;
            discount.onlineStore__Start_Discount_Date__c = Datetime.now() - 10;
            discount.onlineStore__End_Discount_Data__c = Datetime.now() + 10;
            listDiscounts.add(discount);
        }

        for (Integer i = 0; i < 50; i++){
            Discount__c discount = new Discount__c();
            discount.Name = 'Discount' + i + i + i;
            discount.onlineStore__Start_Discount_Date__c = Datetime.now() - 20;
            discount.onlineStore__End_Discount_Data__c = Datetime.now() - 10;
            listDiscounts.add(discount);
        }

        for (Integer i = 0; i < 50; i++){
            Discount__c discount = new Discount__c();
            discount.Name = 'Discount' + i + i;
            discount.onlineStore__Start_Discount_Date__c = Datetime.now() +20;
            discount.onlineStore__End_Discount_Data__c = Datetime.now() + 30;
            listDiscounts.add(discount);
        }
        insert listDiscounts;
        Test.startTest();
        DiscountBatchClass discountBatchClass = new DiscountBatchClass();
        Database.executeBatch(discountBatchClass);
        Test.stopTest();
        System.assert([SELECT Id, Name, Status__c FROM Discount__c WHERE Status__c = 'Active'].size() == 50);
        System.assert([SELECT Id, Name, Status__c FROM Discount__c WHERE Status__c = 'Ended'].size() == 50);
        System.assert([SELECT Id, Name, Status__c FROM Discount__c WHERE Status__c = 'Not Started'].size() == 50);
        System.assert([SELECT Id, Name, Status__c FROM Discount__c].size() == 150);
    }
}