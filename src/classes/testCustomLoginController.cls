/**
 * Created by a2.buyko on 17.1.19.
 */

@IsTest
private class testCustomLoginController {
    @IsTest
    static void testRegister() {
        CustomLoginController.postRegister('buianton@yandex.ru', '123', 'Anton');
        System.assertEquals(1, [SELECT count() FROM Contact]);
    }
}