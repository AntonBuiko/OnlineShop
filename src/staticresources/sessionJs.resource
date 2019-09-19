// sessionJs
jQuery.noConflict();
 jQuery(document).ready(function() {
     console.log(jQuery.session.get('sessionProducts'));
     console.log(jQuery.session.get('products'));
    if(jQuery.session.get('sessionProducts') == undefined){
       jQuery.session.set('sessionProducts', '0');
    }
    else{
        jQuery("#totalAmount").text(jQuery.session.get('sessionProducts'));
    }
});