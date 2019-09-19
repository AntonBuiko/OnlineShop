// cartModule
jQuery.noConflict();
import { ProductListController } from '../productController';

var controller = new ProductListController();
var cartProducts = [];
var idProducts = jQuery.session.get("products");
idProducts = idProducts.split(',');

jQuery.each(idProducts, function( index, value ) {
  cartProducts.push(value);
});

var getCartProducts = function(result, event){
    var html = '';
    jQuery.each(result, function (index, product) {

    html +=
    `
    <div class="cartProductBlock slds-col slds-size_1-of-1" id="${product.Id}">
        <div class="slds-grid">
            <div class="slds-col slds-size_1-of-6 slds-align_absolute-center">
                <image class="productImg" src="${product.onlineStore__Img_Url__c}"/>
            </div>
            <div class="slds-col slds-size_1-of-6 slds-align_absolute-center">
                <span>${product.Name} </span>
            </div>
            <div class="slds-col slds-size_2-of-6 slds-align_absolute-center">
            `
               + ((product.onlineStore__Description__c == undefined) ?  ' '
                : `<span class="ellipsis">${product.onlineStore__Description__c}</span><a href=` + "../DetailPage?id=" + product.Id + `>details</a>`) +
            `
            </div>
            <div class="slds-col slds-size_1-of-6 slds-align_absolute-center">
                <label>Price: </label>
                <span>  ${product.onlineStore__Cost__c}$</span>
            </div>
            <div class="slds-col slds-size_1-of-6 slds-align_absolute-center">
                <button id="${product.Id}" class="removeButton slds-button slds-button_icon slds-button_icon-border ">
                  <svg class="slds-button__icon" aria-hidden="true">
                    <use xlink:href="/apexpages/slds/latest/assets/icons/action-sprite/svg/symbols.svg#remove"></use>
                  </svg>
                </button>
            </div>
        </div>
    </div>
     `
     return html;
    });
    jQuery("#cartProducts").html(html);
}

  controller.getProducts(cartProducts, getCartProducts);

     jQuery("body").on("click", ".removeButton" ,function(){
         var cartAmount = parseInt(jQuery.session.get('sessionProducts'));
         var id = jQuery(this).attr("id");
         var idProducts = jQuery.session.get("products");
         cartAmount--;
         idProducts = idProducts.split(',');
         console.log(idProducts);
         idProducts.splice( jQuery.inArray(id,idProducts) ,1 );
         console.log(idProducts);
         jQuery("#totalAmount").text(cartAmount.toString());
         jQuery.session.set("products", idProducts);
         jQuery.session.set('sessionProducts', cartAmount.toString());
         jQuery(jQuery(this).parent().parent().parent()).remove();

     });

     jQuery("body").on("click", "#checkout" ,function(){
        if(jQuery.session.get("auth") != undefined){
            window.location.replace("../BuyProduct");
        }
        else{
            window.location.replace("../LoginPage");
        }
     });


