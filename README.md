# Salesforce Simple Trigger Template

<!-- SHIELDS -->
[![MIT License][license-shield]][license-url]

This template provides a simple starting point for creating Apex triggers in Salesforce. The template includes a trigger and a corresponding handler class. You can use this template to create new triggers for different objects or modify it to fit your specific needs.

## Getting Started

To use this template, follow these steps:

1. Clone this repository to your local machine.

2. Modify the `AccountTrigger` example class or create a new class extending the `TriggerHandler` class and implement the operations that the trigger will handle.
   The constructor of your class must call the constructor of the `TriggerHandler` superclass. For example:
   ```Apex
   public with sharing class ContactTriggerHandler extends TriggerHandler { 
        private static final WithoutSharingHelper withoutSharingHelper = new WithoutSharingHelper();
    
        public ContactTriggerHandler() {
            this(null);
        }
    
        public ContactTriggerHandler(String triggerSettings) {
            super(triggerSettings);
        }
    
        protected override void beforeInsert() {
            // Insert your BEFORE INSERT logic using the trigger context variables (Trigger.new) and possibly methods of WithoutSharingHelper class for without sharing logic
        }
    
        private without sharing class WithoutSharingHelper {
            // Insert your without sharing logic
        }
    }
    ```

3. Modify the `AccountTrigger` or create a new Trigger to specify the object you want to create the trigger for and the event that should trigger the handler. To execute your logic, use the `run` method of the handler class. Continuing the example from the previous point:
   ```Apex
   trigger ContactTrigger on Contact (before insert) {
        new ContactTriggerHandler().run();
   }
   ```
   If you want, you can use the custom metadata `Trigger Settings` to optionally disable the operations of the trigger. Create a new `Trigger Settings` record, and to use it, pass its `DeveloperName` to the constructor of the handler. Assuming you have the `Contact_Trigger_Settings`, the previous example would become:
   ```Apex
   trigger ContactTrigger on Contact (before insert) {
        new ContactTriggerHandler('Contact_Trigger_Settings').run();
   }
   ```

4. Deploy your class and trigger to your Salesforce environment using your preferred deployment tool.

<!-- MARKDOWN LINKS & IMAGES -->
[license-shield]: https://img.shields.io/github/license/francescodessi/salesforce-simple-trigger-template?&style=for-the-badge
[license-url]: https://github.com/francescodessi/salesforce-simple-trigger-template/blob/main/LICENSE
