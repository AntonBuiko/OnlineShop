/**
 * Created by a2.buyko on 16.1.19.
 */

@IsTest
private class testFileUploadWebService {
    @IsTest
    static void testGetRawMaterials() {

        Store__c store = new Store__c();
        store.Name = 'Name';
        insert store;

        Raw_materials__c rawMaterials = new Raw_materials__c();
        rawMaterials.Name = 'Raw';
        rawMaterials.onlineStore__Quality__c = '1';
        rawMaterials.onlineStore__Amount__c = 1;
        rawMaterials.onlineStore__Store__c = store.Id;
        insert  rawMaterials;

        System.assert(FileUploadWebService.getRawMaterials(store.Id).size() > 0);
    }

    @IsTest
    static void testPostFileData() {
        Store__c store = new Store__c();
        store.Name = 'Name';
        insert store;

        List<String> listRaw = new List<String>();
        listRaw.add('Name,Quality,Amount,Made in,Date of receipt');
        listRaw.add('Name 1, 0.9236339707003108,1,3,2014-02-22 00:00:00');
        listRaw.add('Name 5, 0.5568824472576236, 5, 2, 2014-02-22 00:00:00');
        listRaw.add('Name 3, 0.5568824472576236, 5, 2, 2014-02-22 00:00:00');
        listRaw.add('Name 2, 0.5568824472576236, 5, 2,');
        Test.startTest();
        FileUploadWebService.postFileData(listRaw, store.Id);
        Test.stopTest();
        System.debug([SELECT Id FROM Raw_materials__c]);
        System.assertEquals(4, [SELECT count() FROM Raw_materials__c]);
    }

}