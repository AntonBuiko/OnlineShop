trigger FillProductStore on Product__c (before insert) {
    SObjectFillStore.fill(Trigger.New);
}