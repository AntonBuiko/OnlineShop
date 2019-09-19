// autorizationJs
jQuery(function() {
    var loginHandler = function(result, event){
        if(result != undefined){
            jQuery.session.set("auth", "true");
            jQuery.session.set('contact', result.Id);
            jQuery.session.set('name', result.LastName);
            window.location.replace("../Product_list");
        }
        else{
            if(jQuery('#validateLogin').length == 0){
            jQuery("#loginElementControl").prepend(
                `
                <div class="slds-form-element__help" id="validateLogin">Wrong login or password</div>
                `
                );
            jQuery("#loginElementControl").addClass("slds-has-error");
            jQuery("#passwordElementControl").addClass("slds-has-error");
            }
        }
    }

    var registerHandler = function(result, event){
        if(event.status){
            window.location.replace("../Product_list");
        }
        else{
            jQuery("#emailElementControl").append(
                `
                <div class="slds-form-element__help" id="validateEmail">${event.message}</div>
                `
            )
            jQuery("#emailElementControl").addClass('slds-has-error')
        }
    }


      jQuery("#loginButton").on('click',function(e) {
        e.preventDefault();
        var email = jQuery("#email").val();
        var password = jQuery("#password").val();
        Visualforce.remoting.Manager.invokeAction(
            'onlineStore.CustomLoginController.postLogin',
            email, password,
            loginHandler,
            {escape: true}
        );
    });

      jQuery("#registerButton").on('click',function(e) {
        e.preventDefault();
        jQuery("#register").toggle("slow");
    });

     jQuery("#signupButton").on('click',function(e) {
        e.preventDefault();
        var name = jQuery("#nameRegister").val();
        var email = jQuery("#emailRegister").val();
        var password = jQuery("#passwordRegister").val();
        Visualforce.remoting.Manager.invokeAction(
            'CustomLoginController.postRegister',
            email, password, name,
            registerHandler,
            {escape: true}
        );
    });

})