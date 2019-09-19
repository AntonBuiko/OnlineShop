
global class DiscountBatchClass implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Start_Discount_Date__c, End_Discount_Data__c, Status__c FROM Discount__c');
    }
    public Integer count = 0;

    global void execute(Database.BatchableContext bc, List<Discount__c> records){
        for (Discount__c discount : records){
            if (discount.Start_Discount_Date__c < Datetime.now() && Datetime.now() < discount.End_Discount_Data__c) {
                discount.Status__c = 'Active';
                count++;
            }
            else if(discount.Start_Discount_Date__c > Datetime.now()){
              discount.Status__c = 'Ended';
                count++;
            }
            else{
              discount.Status__c = 'Not Started';
                count++;
            }
        }
        update records;
    }

    global void finish(Database.BatchableContext bc){
    }
}