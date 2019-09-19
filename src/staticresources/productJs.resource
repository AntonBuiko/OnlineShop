// productJs
      var ids = []

      jQuery("#products").on({
          mouseenter: function() {
                jQuery(this).children().show(1000);
                jQuery(this).css("background-color", "rgba(240, 250, 250, 0.5)");
             },
          mouseleave: function() {
                jQuery(this).children().hide(1000);
                jQuery(this).css("background-color", "rgba(255, 250, 250, 1)");
                }
          }, '.productBlock');

      jQuery("#products").on('click','.add',function(e) {
          e.preventDefault();
          if(jQuery.session.get("products") != undefined){
              ids = jQuery.session.get("products").split(',');
          }
            var cartAmount = parseInt(jQuery.session.get('sessionProducts'));
            var productId = jQuery(this).attr('id');
            cartAmount++;

            ids.push(productId);
            jQuery.session.set("products", ids);
            console.log(jQuery.session.get("products"));
            jQuery.session.set('sessionProducts', cartAmount.toString());
            jQuery("#totalAmount").text(jQuery.session.get('sessionProducts'));
         });

       jQuery("#products").on('click','.buy',function(e) {
           e.preventDefault();
           if(jQuery.session.get("products") != undefined){
               ids = jQuery.session.get("products").split(',');
           }
             var cartAmount = parseInt(jQuery.session.get('sessionProducts'));
             var productId = jQuery(this).attr('id');
             cartAmount++;

             ids.push(productId);
             jQuery.session.set("products", ids);
             console.log(jQuery.session.get("products"));
             jQuery.session.set('sessionProducts', cartAmount.toString());
             jQuery("#totalAmount").text(jQuery.session.get('sessionProducts'));
             window.location.replace("../BuyProduct");
          });


console.log()

