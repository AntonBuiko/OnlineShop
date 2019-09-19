/**
 * Created by a2.buyko on 10.1.19.
 */

public class DynamicConvert {
    public static Object convert(Schema.SObjectField sobj, String field){
        if (sobj.getDescribe().getType() == DisplayType.INTEGER) {
            return Decimal.valueOf(field);
        }

        if (sobj.getDescribe().getType() == DisplayType.DOUBLE) {
            return Double.valueOf(field);
        }

        if (sobj.getDescribe().getType() == DisplayType.DATE) {
            return Date.valueOf(field);
        }

        if (sobj.getDescribe().getType() == DisplayType.DATETIME) {
            if (field.length() < 10) {
                DateTime dtime = DateTime.newInstance(2018, 1, 1, 0, 0, 0);
                return dtime;
            }
            return Datetime.valueOf(field);
        }

        else{
            return String.valueOf(field);
        }

    }
}