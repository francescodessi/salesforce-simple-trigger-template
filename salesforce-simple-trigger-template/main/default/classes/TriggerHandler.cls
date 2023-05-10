public with sharing virtual class TriggerHandler {

    private final Boolean triggerIsExecuting;
    private final TriggerOperation triggerOperation;
    private final String triggerSettings;
    private final String triggerHandlerName = String.valueOf(this).substringBefore(':'); //If the class overrides the toString() it may not work

    public TriggerHandler() {
        this(null);
    }

    public TriggerHandler(String triggerSettings) {
        this(Trigger.isExecuting, Trigger.operationType, triggerSettings);
    }

    @TestVisible
    private TriggerHandler(Boolean triggerIsExecuting, TriggerOperation triggerOperation, String triggerSettings) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSettings = triggerSettings;
        this.triggerOperation = triggerOperation;
    }

    public void run() {
        if(triggerIsExecuting == true && triggerOperation != null) {
            Boolean areTriggersDisabled = Trigger_Setting__mdt.getInstance(triggerSettings)?.get(triggerOperation + '_DISABLED__c') == true;

            if(areTriggersDisabled) {
                System.debug(this.triggerHandlerName + ': ' + triggerOperation + ' disabled - Check Trigger_Setting__mdt.' + triggerSettings + ' Custom Metadata');
            }

            if(!areTriggersDisabled) {
                switch on triggerOperation {
                    when BEFORE_INSERT {
                        beforeInsert();
                    }
                    when BEFORE_UPDATE {
                        beforeUpdate();
                    }
                    when BEFORE_DELETE {
                        beforeDelete();
                    }
                    when AFTER_INSERT {
                        afterInsert();
                    }
                    when AFTER_UPDATE {
                        afterUpdate();
                    }
                    when AFTER_DELETE {
                        afterDelete();
                    }
                    when AFTER_UNDELETE {
                        afterUndelete();
                    }
                }
            }
        }
        else {
            throw new TriggerHandlerException('It is not a Trigger context');
        }
    }

    public class TriggerHandlerException extends Exception {}

    public static List<SObject> filterRecordsByFieldValue(List<SObject> sObjects, String fieldName, Object fieldValue) {
        List<SObject> filteredSObject = new List<SObject>();

        if(sObjects?.isEmpty() == false && String.isNotBlank(fieldName)) {
            for(SObject obj : sObjects) {
                if(obj != null && obj.get(fieldName) == fieldValue) {
                    filteredSObject.add(obj);
                }
            }
        }

        return filteredSObject;
    }

    public static List<SObject> filterRecordsByRecordTypeId(List<SObject> sObjects, Id recordTypeId) {
        return filterRecordsByFieldValue(sObjects, 'RecordTypeId', recordTypeId);
    }

    public static Map<Object, List<SObject>> groupRecordsByFieldValue(List<SObject> sObjects, String fieldName) {
        Map<Object, List<SObject>> fieldValueMap = new Map<Object, List<SObject>>();

        if(sObjects?.isEmpty() == false && String.isNotBlank(fieldName)) {
            for(SObject obj : sObjects) {
                Object key = obj.get(fieldName);

                if(fieldValueMap.get(key) == null) {
                    fieldValueMap.put(key, new List<SObject>());
                }

                fieldValueMap.get(key).add(obj);
            }
        }

        return fieldValueMap;
    }

    public static Map<Id, List<SObject>> groupRecordsByRecordTypeId(List<SObject> sObjects) {
        Map<Id, List<SObject>> recordTypeIdMap = new Map<Id, List<SObject>>();
        Map<Object, List<SObject>> fieldValueMap = groupRecordsByFieldValue(sObjects, 'RecordTypeId');

        for(Object fieldValue : fieldValueMap.keySet()) {
            recordTypeIdMap.put((Id) fieldValue, fieldValueMap.get(fieldValue));
        }

        return recordTypeIdMap;
    }

    @TestVisible protected virtual void beforeInsert() {}
    @TestVisible protected virtual void beforeUpdate() {}
    @TestVisible protected virtual void beforeDelete() {}
    @TestVisible protected virtual void afterInsert() {}
    @TestVisible protected virtual void afterUpdate() {}
    @TestVisible protected virtual void afterDelete() {}
    @TestVisible protected virtual void afterUndelete() {}
}