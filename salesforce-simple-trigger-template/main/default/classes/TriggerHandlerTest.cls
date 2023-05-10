@IsTest
private class TriggerHandlerTest {

    private static final String PHONE_1 = '111-111';
    private static final String PHONE_2 = '222-222';

    @TestSetup
    private static void setup() {
        insert new List<Account>{
                new Account(Name = 'Account 1', Phone = PHONE_1),
                new Account(Name = 'Account 2', Phone = PHONE_1),
                new Account(Name = 'Account 3', Phone = PHONE_2)
        };

        insert new List<Contact>{
                new Contact(LastName = 'Contact 1', Phone = PHONE_1),
                new Contact(LastName = 'Contact 2', Phone = PHONE_2),
                new Contact(LastName = 'Contact 2', Phone = PHONE_2)
        };
    }

    @IsTest
    private static void triggerHandlerTest1() {
        Test.startTest();
        for(TriggerOperation triggerOperation : TriggerOperation.values()) {
            new TriggerHandler(true, triggerOperation, null).run();
        }
        Test.stopTest();
    }

    @IsTest
    private static void triggerHandlerTest2() {
        try {
            Test.startTest();
            new TriggerHandler().run();
            Test.stopTest();
            Assert.fail('The expected error did not happen');
        }
        catch (Exception ex) {
            Assert.isInstanceOfType(ex, TriggerHandler.TriggerHandlerException.class);
        }
    }

    @IsTest
    private static void filterRecordsByFieldValueTest() {
        List<Account> accounts = [SELECT Phone FROM Account];

        Test.startTest();
        List<Account> filteredAccounts = TriggerHandler.filterRecordsByFieldValue(accounts, 'Phone', PHONE_1);
        Test.stopTest();

        Assert.areEqual([SELECT COUNT() FROM Account WHERE Phone = :PHONE_1], filteredAccounts.size());

        for(Account account : filteredAccounts) {
            Assert.areEqual(PHONE_1, account.Phone);
        }
    }

    @IsTest
    private static void filterRecordsByFieldValueTest2() {
        List<SObject> sObjects = new List<SObject>();
        sObjects.addAll([SELECT Phone FROM Account]);
        sObjects.addAll([SELECT Phone FROM Contact]);

        Test.startTest();
        List<SObject> filteredSObjects = TriggerHandler.filterRecordsByFieldValue(sObjects, 'Phone', PHONE_1);
        Test.stopTest();

        Assert.areEqual([SELECT COUNT() FROM Account WHERE Phone = :PHONE_1] + [SELECT COUNT() FROM Contact WHERE Phone = :PHONE_1], filteredSObjects.size());

        for(SObject obj : filteredSObjects) {
            Assert.areEqual(PHONE_1, obj.get('Phone'));
        }
    }

    @IsTest
    private static void filterRecordsByRecordTypeIdTest() {
        Test.startTest();
        List<Account> filteredAccounts = TriggerHandler.filterRecordsByRecordTypeId(new List<Account>(), null);
        Test.stopTest();

        Assert.areEqual(0, filteredAccounts.size());
    }

    @IsTest
    private static void groupRecordsByFieldValueTest() {
        List<Account> accounts = [SELECT Phone FROM Account];

        Test.startTest();
        Map<Object, List<SObject>> fieldValueMap = TriggerHandler.groupRecordsByFieldValue(accounts, 'Phone');
        Test.stopTest();

        Assert.areEqual([SELECT COUNT_DISTINCT(Phone) DISTINCT_PHONE FROM Account][0].get('DISTINCT_PHONE'), fieldValueMap.size());
        Assert.areEqual([SELECT COUNT() FROM Account WHERE Phone = :PHONE_1], fieldValueMap.get(PHONE_1).size());
        Assert.areEqual([SELECT COUNT() FROM Account WHERE Phone = :PHONE_2], fieldValueMap.get(PHONE_2).size());

        for(Object key : fieldValueMap.keySet()) {
            for(SObject obj : fieldValueMap.get(key)) {
                Assert.areEqual(key, obj.get('Phone'));
            }
        }
    }

    @IsTest
    private static void groupRecordsByRecordTypeIdTest() {
        Test.startTest();
        Map<Id, List<SObject>> recordTypeIdMap = TriggerHandler.groupRecordsByRecordTypeId(new List<Account>());
        Test.stopTest();

        Assert.areEqual(0, recordTypeIdMap.size());
    }
}