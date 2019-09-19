// productListModule
jQuery.noConflict();
import { ProductListController } from '../onlineStore__productController';


var paginationBlocks = [];

var productsOnPage = 5;

var paginationFunc = async function(paginationProducts){
    console.log(paginationBlocks[0]);
         jQuery('#pagination-container').pagination(
            {
            dataSource: paginationProducts,
            pageSize: productsOnPage,
            showPrevious: false,
            showNext: false,
            callback: function(data, pagination) {
                jQuery("#products").html(data);
            }
        })
    }

var ascSort = async function(searchBlocks){
        var comparableArray = Promise.all(searchBlocks.sort(function(a, b){
        var aObject = jQuery.parseHTML(a);
        var bObject = jQuery.parseHTML(b);
        var aPrice = jQuery(aObject).find(".productPrice").text();
        var bPrice = jQuery(bObject).find(".productPrice").text();
            if(parseInt(aPrice) > parseInt(bPrice)){
               return 1;
            }
            if(parseInt(aPrice) < parseInt(bPrice)){
               return -1;
            }
            return 0;
            }));
        return comparableArray;
};

var controller = new ProductListController();
var handler = function(result, event){
    var html = '';
    jQuery.each(result, function (index, product) {
      var productBlock = `<div class="slds-col slds-size_1-of-2 slds-align_absolute-center slds-m-bottom--x-large">
                                     <div class="productBlock" id="${product.Id}" style="background-image: url(${product.onlineStore__Img_Url__c})">
                                             <div class="hiddenProduct" >
                                                 <div class="productName">${product.Name}</div>
                                                 <span class="productPrice">${product.onlineStore__Cost__c}</span>
                                                 <button id="${product.Id}" class="productButton add slds-button--neutral slds-m-top--xx-large slds-m-bottom--x-large">Add to cart</button>
                                                 <button id="${product.Id}" class="productButton buy slds-button--neutral ">Buy it now</button>
                                             </div>
                                     </div>
                              </div>`
    html += productBlock;
    paginationBlocks.push(productBlock);
    });
    paginationFunc(paginationBlocks);
}
  controller.getProducts(null, handler);


  jQuery(".productsRadiobutton").change(function(){
     productsOnPage = this.value;
     paginationFunc(paginationBlocks);
  })

  jQuery("#buttonSearch").click(function(){
     var searchText = jQuery('#searchInput').val();
     let searchBlocks = [];
     if(searchText.length === 0){
       paginationFunc(paginationBlocks);
     }
     else{
         jQuery.each(paginationBlocks, function(index, value){
             var htmlObject = jQuery.parseHTML(value);
             var name = jQuery(htmlObject).find(".productName").text();
             if(name.toLowerCase().includes(searchText.toLowerCase())){
                 searchBlocks.push(value);
             }
         })
         paginationFunc(searchBlocks);
     }
  });

    jQuery(".sortRadiobutton").click(async function(){
       var sortType = this.value;
       let searchBlocks = [];
       searchBlocks = paginationBlocks;
       switch (sortType) {
          case 'Asc':
            searchBlocks = paginationBlocks;
            await paginationFunc(await ascSort(searchBlocks));
            break;
          case 'Desc':
            searchBlocks = paginationBlocks;
            paginationFunc(searchBlocks.sort(function(a, b){
                var aObject = jQuery.parseHTML(a);
                var bObject = jQuery.parseHTML(b);
                var aPrice = jQuery(aObject).find(".productPrice").text();
                var bPrice = jQuery(bObject).find(".productPrice").text();
                if(parseInt(aPrice) < parseInt(bPrice)){
                   return 1;
                }
                if(parseInt(aPrice) > parseInt(bPrice)){
                   return -1;
                }
                return 0;
                }));
            break;
          case 'Name':
            paginationFunc(searchBlocks.sort(function(a, b){
                var aObject = jQuery.parseHTML(a);
                var bObject = jQuery.parseHTML(b);
                var aPrice = jQuery(aObject).find(".productName").text();
                var bPrice = jQuery(bObject).find(".productName").text();
                if(aPrice > bPrice){
                   return 1;
                }
                if(aPrice < bPrice){
                   return -1;
                }
                return 0;
                }));
            break;
          default:
            alert('undefined sort');
        }
    });




