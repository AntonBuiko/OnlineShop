// buyProductModule
jQuery.noConflict();
import { ProductListController } from '../productController';
import { DiscountHelper } from '../discountHelperJs';

var isDiscount;
var controller = new ProductListController();
var cartProducts = [];
var contact;
var idProducts = jQuery.session.get("products");

if(idProducts == undefined || jQuery.session.get("auth") == undefined){
    window.location.replace("../Product_list");
}

idProducts = idProducts.split(',');

jQuery.each(idProducts, function( index, value ) {
  cartProducts.push(value);
});
var products = [];



var productsModel = new SObjectModel.product();
var contactModel = new SObjectModel.Contact();
var discountModel = new SObjectModel.discount();

var changePrice = function(error, discounts, event) {
    if(discounts != undefined && discounts.length > 0){
    var uniqueProducts = [];
    var uniqueId = [];
    jQuery.each(products, function(i, el){
         if(uniqueId.length == 0 || !uniqueId.includes(el.Id)){
             uniqueId.push(el.Id);
             uniqueProducts.push(el);
         }
    });
    jQuery.each(uniqueProducts, function( index, product ){
          product.onlineStore__Cost__c = DiscountHelper.bestDiscount(discounts, product);
          jQuery('#' + product.Id + ' > div > div:nth-child(3) > span').css('text-decoration', 'line-through');
          jQuery('#' + product.Id + ' > div > div:nth-child(3)').append('<div>' + product.onlineStore__Cost__c + '$</div>');
     });
    }
 }

var discountHandler = function(result, event){
        if(result == true){
                 discountModel.retrieve(
                     {
                     where: {
                         Status:
                         {
                         eq: 'Active'
                         }
                     }
                     },
                     changePrice);
            }
        else{
            jQuery('#phoneElementControl').after(
                `
                 <div id="discountElementControl" class="slds-form-element">
                     <label class="slds-form-element__label">Do you have a promocode?</label>
                     <div class="slds-form-element__control">
                         <input id="discount" type="text" required="" class="slds-input" />
                     </div>
                 </div>
                 <button type="button" id="applyCode" class="slds-button slds-button_neutral slds-m-around--large">Apply code</button>
                `
            )
        }
    }
var handler = function(result, event){
    var html = '';
    jQuery.each(result, function (index, product) {
    console.log(product);
    products.push(product);
    html += `
    <div class="cartProductBlock" id="${product.Id}">
        <div class="slds-grid">
            <div class="slds-col slds-align_absolute-center">
                <image class="productImg" src="${product.onlineStore__Img_Url__c}"/>
            </div>
            <div class="slds-col slds-align_absolute-center">
                <span>${product.Name} </span>
            </div>
            <div class="slds-col slds-align_absolute-center">
                <label>Price: </label>
                <span>  ${product.onlineStore__Cost__c}$</span>
            </div>
        </div>
    </div>
     `
     return html;
    });
    jQuery("#orderProducts").html(html);
}
jQuery(function() {
  contactModel.retrieve(
      {
          where:
          {
              Id: {eq: jQuery.session.get('contact').toString() }
          }
      }
      , function(error, results) {
          jQuery.each(results, function(index, value) {
          contact = value;
          jQuery('#email').val(value.get('onlineStore__Email__c'));
          jQuery('#email').attr('disabled', true);
        });
  });
 });

 var today = function(){
      let currentDate = new Date();
      var dd = currentDate.getDate();
      var mm = currentDate.getMonth()+1;
      var yyyy = currentDate.getFullYear();
      currentDate = mm + '/' + dd + '/' + yyyy;
      return currentDate;
  }

  jQuery('#BuyButton').on('click', function(){
      if(jQuery('#address').val().length < 1){
          if(jQuery('#validateAddress').length == 0){
             jQuery("#addressElementControl").append(
                 `
                 <div class="slds-form-element__help" id="validateAddress">Enter address</div>
                 `
             )
             jQuery("#addressElementControl").addClass('slds-has-error')
          }
      }
      if(jQuery('#phone').val().length < 1){
          if(jQuery('#validatePhone').length == 0){
             jQuery("#phoneElementControl").append(
                 `
                 <div class="slds-form-element__help" id="validatePhone">Enter phone</div>
                 `
             )
             jQuery("#phoneElementControl").addClass('slds-has-error')
          }
      }
      else{
          jQuery.each(products, function(index, product) {
          delete product.Id;
          product.RecordTypeId = '0126F000001JvRHQA0';
          product['onlineStore__Amount__c'] = 1;
          product['onlineStore__Number_of_purchase__c'] = 1;
          product['onlineStore__Date_of_purchase__c'] = new Date(product['onlineStore__Date_of_purchase__c']);
          product['onlineStore__Date_of_receipt__c'] = new Date(product['onlineStore__Date_of_receipt__c']);
          console.log(product);
          productsModel.create(product, function(err) {
           if(err) {
                console.log(err);
           }
              });
          })
          jQuery.session.remove('products');
          jQuery.session.set('sessionProducts', '0');
          jQuery("#totalAmount").text(jQuery.session.get('sessionProducts'));
          controller.sendEmailAndFeed(contact._props, products);
          window.location.replace("../SuccessOrder");
      }
 })

   jQuery(document).on('click', '#applyCode' ,function(){
          console.log(this.value);
          discountModel.retrieve(
              {
              where: {
                  Status: { eq: 'Active' },
                  Discount_Code : { eq : jQuery('#discount').val() }
                  }
              },
              changePrice);
          this.remove();
          jQuery('#discount').attr('disabled', true);
   });


 controller.getAccountDiscount(jQuery.session.get("contact"), discountHandler);
 controller.getProducts(cartProducts, handler);