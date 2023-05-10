public with sharing class AccountTriggerHandler extends TriggerHandler {

    private static final WithoutSharingHelper withoutSharingHelper = new WithoutSharingHelper();

    public AccountTriggerHandler() {
        this(null);
    }

    public AccountTriggerHandler(String triggerSettings) {
        super(triggerSettings);
    }

    protected override void beforeInsert() {}
    protected override void beforeUpdate() {}
    protected override void beforeDelete() {}
    protected override void afterInsert() {}
    protected override void afterUpdate() {}
    protected override void afterDelete() {}
    protected override void afterUndelete() {}

    private without sharing class WithoutSharingHelper {}
}