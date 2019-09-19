/**
 * Created by a2.buyko on 9.1.19.
 */

global class AddRawMaterialsBatchClass implements Database.Batchable<sObject> {
    global List<Raw_materials__c> newRawMaterials {get;set;}
    global Integer records = 0;

    global AddRawMaterialsBatchClass(List<Raw_materials__c> rawMaterials){
        newRawMaterials = rawMaterials;
    }

    global List<Raw_materials__c> start(Database.BatchableContext bc) {
        return newRawMaterials;
    }


    global void execute(Database.BatchableContext bc, List<Raw_materials__c> listRaw){
        insert listRaw;
    }

    global void finish(Database.BatchableContext bc){
    }
}