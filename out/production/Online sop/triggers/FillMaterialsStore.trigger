
trigger FillMaterialsStore on Raw_materials__c (before insert) {
    SObjectFillStore.Fill(Trigger.New);
}