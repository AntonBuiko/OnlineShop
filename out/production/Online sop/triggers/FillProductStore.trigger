trigger FillProductStore on Product__c (before insert) {
    SObjectFillStore.Fill(Trigger.New);
}