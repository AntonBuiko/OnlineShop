// detailsJs
jQuery.noConflict();

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};

jQuery(function() {
    var productsModel = new SObjectModel.product();
    var id = getUrlParameter('id');
    productsModel.retrieve(
        {
        where: {
            Id:
            {
            eq: id
            }
        }
        },
         function(error, result, event) {
             jQuery.each(result, function (index, product) {
             console.log(product);
                   html =
                   `
                   <div id="${product.get('Id')}">
                       <div class="slds-col slds-align_absolute-center">
                           <image class="productImg" src="${product.get('onlineStore__Img_Url__c')}"/>
                       </div>
                       <div class="slds-grid slds-gutters">
                           <div class="slds-col slds-align_absolute-center">
                               <span>${product.get('Name')} </span>
                           </div>
                           <div class="slds-col slds-align_absolute-center">
                           `
                              + product.get('onlineStore__Description__c') +
                           `
                           </div>
                           <div class="slds-col slds-align_absolute-center">
                               <label>Price: </label>
                               <span>  ${product.get('onlineStore__Cost__c')}$</span>
                           </div>
                       </div>
                   </div>
                    `
                    jQuery('#detailProduct').html(html);
          })
          });
})


