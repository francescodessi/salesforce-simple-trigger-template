trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new AccountTriggerHandler('Account_Trigger_Settings').run();
    //new AccountTriggerHandler().run();
}