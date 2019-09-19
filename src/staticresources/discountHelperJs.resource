// discountHelperJs
export class DiscountHelper{
    static сalculateDiscount(discount, product){
        var newPrice = product.onlineStore__Cost__c;
        if (discount.get('onlineStore__Percentes_of_discount__c') != null){
            newPrice = newPrice * (1 - discount.get('onlineStore__Percentes_of_discount__c') / 100);
        }
        if (discount.get('Static_discount__c') != null){
            newPrice = newPrice - discount.get('onlineStore__Static_discount__c');
        }
        return newPrice;
    }

    static bestDiscount(discounts, product){
        var discountPrice;
        jQuery.each(discounts, function( index, discount) {
            discountPrice = product.onlineStore__Cost__c;
            let newPrice = DiscountHelper.сalculateDiscount(discount, product);
            if (newPrice < discountPrice) {
                discountPrice = newPrice;
            }
        })
        return discountPrice;
    }
}
