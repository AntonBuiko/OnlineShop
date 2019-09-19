/**
 * Created by a2.buyko on 27.11.18.
 */
    global class CheckDiscountSchedule implements Schedulable {
        global void execute(SchedulableContext ctx) {
            DiscountBatchClass batch = new DiscountBatchClass();
            Database.executeBatch(batch);
        }
    }