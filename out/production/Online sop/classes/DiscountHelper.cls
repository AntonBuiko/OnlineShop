/**
 * Created by a2.buyko on 6.11.18.
 */

public with sharing class DiscountHelper {
    public static Discount__c discount  = new Discount__c();

    public static Discount__c findDiscount(String code)
    {
        System.debug(discount);
        List<Discount__c> discounts = [SELECT Id, Discount_Code__c, Account__c, Percentes_of_discount__c,
                                        Static_discount__c FROM Discount__c WHERE Discount_Code__c =: code];
        System.debug(discount.Discount_Code__c);
        System.debug(discounts);
        if (discounts.size() > 0) {
            discount = discounts[0];
        }
            return discount;
    }

    public static Decimal CalculateDiscount(Discount__c discount, Product__c product){
        Decimal newPrice = product.Cost__c;
        System.debug(newPrice);
        if (discount.Percentes_of_discount__c != null){
            newPrice = newPrice * (1 - discount.Percentes_of_discount__c / 100);
        }
        System.debug(newPrice);
        if (discount.Static_discount__c != null){
            newPrice = newPrice - discount.Static_discount__c;
        }
        System.debug(newPrice);
        return newPrice;
    }

    public static Map<Id, Decimal> BestDiscount(List<Discount__c> discounts, Product__c product){
        Map<Id, Decimal> mapBestPrice = new Map<Id, Decimal>();
        for (Discount__c discount : discounts){
            Decimal discountPrice = product.Cost__c;
            Decimal newPrice = DiscountHelper.CalculateDiscount(discount, product);
            if (newPrice < discountPrice) {
                discountPrice = newPrice;
                mapBestPrice.put(discount.Id, discountPrice);
            }
        }
        System.debug(mapBestPrice);
        return mapBestPrice;
    }
}