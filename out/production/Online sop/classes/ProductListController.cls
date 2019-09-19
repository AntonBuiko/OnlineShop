public with sharing class ProductListController {
    public String productId {get;set;}
    public String errorMsg {get;set;}
    public String searchString {get;set;}
    public Map<Id, Map<Id, Decimal>> discountMap{get;set;}
    private final List<Product__c> products {get;set;}
    public List<Discount__c> discounts {get;set;}
    public User currentUser {get;set;}

    public void init(){
        currentUser = [SELECT Id, Username, isDiscount__c FROM User WHERE Username = :UserInfo.getUserName()];
        discounts = [SELECT Id, Discount_Code__c, Percentes_of_discount__c, Static_discount__c, Account__c
                      FROM Discount__c
                      WHERE Account__c IN (SELECT AccountId FROM User WHERE Username = :currentUser.Username) AND Status__c = 'Active'];
        if (discounts.size() > 0) {
            if (currentUser.isDiscount__c != true) {
                currentUser.isDiscount__c = true;
            }
            BestDiscount(products);
        }
        else{
            if (currentUser.isDiscount__c != false) {
                currentUser.isDiscount__c = false;
            }
        }
        update currentUser;
    }

    public ProductListController(){
        System.debug(searchString);
        discountMap = new Map<Id, Map<Id,Decimal>>();
        products = new List<Product__c>([SELECT Id, Name, Img_Url__c, Description__c, Amount__c, Number_of_purchase__c,
                Date_of_purchase__c, Date_of_receipt__c, Title__c,
                Cost__c   FROM Product__c WHERE RecordType.Name = 'Made']);
        System.debug(products);
        errorMsg = ApexPages.currentPage().getParameters().get('errorMsg');
        if (errorMsg != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
        }
    }

    public PageReference Search(){
        System.debug('Search');
        PageReference pr = Page.Product_list;
        pr.setRedirect(false);
        return pr;
    }

    public List<Product__c> getProducts()
    {
        System.debug(searchString);
        if (searchString != null && searchString.length() > 0) {
            List<Product__c> filterProducts = new List<Product__c>();
            for (Product__c filterProduct : products){
                if (filterProduct.Name.toLowerCase().contains(searchString.toLowerCase())) {
                    filterProducts.add(filterProduct);
                }
            }
            System.debug(filterProducts);
            return filterProducts;
        }
        else return products;
    }

        public PageReference toBuyProduct(){
            productId = ApexPages.currentPage().getParameters().get('productId');
            System.debug(productId);
            PageReference pr = Page.BuyProduct;
            pr.getParameters().put('productId', productId);
            if (currentUser.isDiscount__c == true && discountMap.get(productId) != null){
                Id discountId;
                for (Id id : discountMap.get(productId).keySet()){
                    discountId = id;
                }
                pr.getParameters().put('discountId', discountId);
            }
          return pr;
    }

    public PageReference toDetailPage()
    {
        PageReference pr = Page.DetailPage;
        pr.getParameters().put('productId', productId);
        return pr;
    }

    public void BestDiscount(List<Product__c> products){
                for (Product__c product : products){
                    Map<Id, Decimal> mapBestPrice = DiscountHelper.BestDiscount(discounts, product);
                    discountMap.put(product.Id, mapBestPrice);
                }
            System.debug('discountMap: ' + discountMap);
    }
}