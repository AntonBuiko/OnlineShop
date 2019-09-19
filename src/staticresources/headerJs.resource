// headerJs
jQuery(function() {
    if(jQuery.session.get("auth") != undefined && jQuery.session.get("auth") == "true"){
        jQuery("#menu").append
        (`
         <div class="slds-col slds-has-flexi-truncate slds-size_1-of-5 slds-align_absolute-center slds-m-horizontal_xxx-small">
             <a href="#" class="slds-text-link_reset">Hello! ${jQuery.session.get('name')}</a>
         </div>
        `);
    }
    else{
        jQuery("#menu").append
        (`
         <div class="slds-col slds-has-flexi-truncate slds-size_1-of-5 slds-align_absolute-center slds-m-horizontal_xxx-small">
             <a href="/apex/LoginPage" class="slds-text-link_reset">Login/Sign up</a>
         </div>
        `);
    }
console.log(jQuery.session);
})