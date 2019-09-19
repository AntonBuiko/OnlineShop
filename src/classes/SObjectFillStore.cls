public class SObjectFillStore {
    public static void fill(List<SObject> triggerObjects){
        Map<Id, Store__c> mapStore = new Map<Id, Store__c>([SELECT Id, Name, Start_Period__c, End_Period__c FROM Store__c]);
        Reporting_period__c period = Reporting_period__c.getValues('Reporting_week');
        Map<SObject ,Store__c> newStores = new Map<SObject, Store__c>();
        for (SObject sObj : triggerObjects){
            if (sObj.get('Store__c') == null) {
                for (Store__c store : mapStore.values()) {
                    Date dateReceipt = (Date) sObj.get('Date_of_receipt__c');
                    if (store.Start_Period__c <= dateReceipt && store.End_Period__c >= dateReceipt) {
                        sObj.put('Store__c', store.Id);
                        break;
                    }
                }
                if (sObj.get('Store__c') == null) {
                    Store__c newStore = new Store__c();
                    newStore.Name = sObj.get('Name').toString() + 'Store';
                    newStore.Start_Period__c = Date.valueOf(sObj.get('Date_of_receipt__c'));
                    newStore.End_Period__c = period.Reporting_Date__c.addDays(newStore.Start_Period__c.day());
                    newStores.put(sObj, newStore);
                }
            }
        }
        if (newStores.size() > 0) {
            insert  newStores.values();
            for (SObject sObj : newStores.keySet()){
                sObj.put('Store__c', newStores.get(sObj).Id);
            }
        }
    }
}