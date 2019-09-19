/**
 * Created by a2.buyko on 17.1.19.
 */

@IsTest
private class testRawMaterialsBatch {
    @IsTest
    static void testAddRawMaterials() {
        List<Raw_materials__c> listMaterials = new List<Raw_materials__c>();
        Reporting_period__c reportDate = new Reporting_period__c();
        reportDate.Name = 'Reporting_week';
        reportDate.onlineStore__Reporting_Date__c = Date.today().addDays(7);
        insert  reportDate;
        for (Integer i = 0; i < 100; i++){
            Raw_materials__c rawMaterials = new Raw_materials__c();
            rawMaterials.Name = 'Name' + i;
            rawMaterials.onlineStore__Quality__c = '1';
            rawMaterials.onlineStore__Amount__c = 1;
            rawMaterials.onlineStore__Date_of_purchase__c = Date.today() -1;
            rawMaterials.onlineStore__Date_of_receipt__c = Date.today() + 1;
            listMaterials.add(rawMaterials);
        }
        AddRawMaterialsBatchClass batchClass = new AddRawMaterialsBatchClass(listMaterials);
        Test.startTest();
        Database.executeBatch(batchClass);
        Test.stopTest();
        System.assertEquals(100, [SELECT count() FROM Raw_materials__c]);
    }
}