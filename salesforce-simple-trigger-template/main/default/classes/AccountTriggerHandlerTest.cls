@IsTest
private class AccountTriggerHandlerTest {
    @IsTest
    private static void accountTriggerHandlerTest1() {
        try {
            Test.startTest();
            new AccountTriggerHandler().run();
            Test.stopTest();
            Assert.fail('The expected error did not happen');
        }
        catch (Exception ex) {
            Assert.isInstanceOfType(ex, TriggerHandler.TriggerHandlerException.class);
        }
    }

    @IsTest
    private static void accountTriggerHandlerTest2() {
        Account account = new Account(Name = 'Account Test');

        Test.startTest();
        insert account;
        update account;
        delete account;
        undelete account;
        Test.stopTest();

        Assert.isFalse([SELECT IsDeleted FROM Account WHERE Id = :account.Id].IsDeleted);
    }
}