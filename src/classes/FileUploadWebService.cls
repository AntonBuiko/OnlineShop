/**
 * Created by a2.buyko on 9.1.19.
 */

global class FileUploadWebService {
    webservice static void postFileData(List<String> listRaw, String storeId) {
        List<Raw_materials__c> newRaws= convertingDataToRawMaterials(listRaw, storeId);
        AddRawMaterialsBatchClass rawBatch = new AddRawMaterialsBatchClass(newRaws);
        Database.executeBatch(rawBatch);
    }

    webservice static List<Raw_materials__c> getRawMaterials(String storeId) {
        return [SELECT Id, Name, Quality__c, Amount__c, Made_in__c, Date_of_receipt__c FROM Raw_materials__c WHERE Store__c =: storeId];
    }

    static Map<String, Schema.SObjectField> mapFieldAndFileTitle(List<String> labels){
        Map<String, Schema.SObjectField> mapLabelsAndField = new Map<String, Schema.SObjectField>();
        Map<String, Schema.SObjectField> fieldMap = Raw_materials__c.SObjectType.getDescribe().fields.getMap();
        System.debug(labels);
        for (Schema.SObjectField field : fieldMap.values()){

            if (labels.contains(field.getDescribe().getLabel()) || labels.contains(field.getDescribe().getName())) {
                mapLabelsAndField.put(labels.contains(field.getDescribe().getLabel())
                        ? field.getDescribe().getLabel()
                        : field.getDescribe().getName(), field);
            }
        }
        return mapLabelsAndField;
    }

    static List<Raw_materials__c> convertingDataToRawMaterials(List<String> listRaw, String storeId){
        List<String> labels = listRaw.get(0).remove('\n').split(',');
        Map<String, Schema.SObjectField> mapLabels = mapFieldAndFileTitle(labels);
        listRaw.remove(0);
        List<Raw_materials__c> newRaws = new List<Raw_materials__c>();
        for (String stringRaw : listRaw){
            Raw_materials__c rawMaterials = new Raw_materials__c();
            List<String> listFieldsData = stringRaw.remove('\n').split(',');
            for (Integer i = 0; i < listFieldsData.size(); i++){
                rawMaterials.put(mapLabels.get(labels.get(i)), DynamicConvert.convert(mapLabels.get(labels.get(i)), listFieldsData[i]));
                rawMaterials.put('Store__c', storeId);
            }
            newRaws.add(rawMaterials);
        }
        return newRaws;
    }
}