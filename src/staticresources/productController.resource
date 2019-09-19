// productController
export class ProductListController{
     getProducts (listId=[], handler){
        Visualforce.remoting.Manager.invokeAction(
            'onlineStore.ProductListController.getProducts',
            listId,
            handler,
            {escape: true}
        );
    }
    getAccountDiscount( idContact , handler){
       Visualforce.remoting.Manager.invokeAction(
           'onlineStore.ProductListController.getAccountDiscount',
           idContact,
           handler,
           {escape: true}
       );
    }

    sendEmailAndFeed(contact, products){
       Visualforce.remoting.Manager.invokeAction(
           'onlineStore.ProductListController.sendEmailAndFeed',
           contact,
           products,
           function(result, event){
               console.log('result: ' + result);
               console.log('event: ' + event.message);
           },
           {escape: false}
       );
    }
}
