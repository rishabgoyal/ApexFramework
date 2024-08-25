# Salesforce Apex Framework with Bypass Settings

Download the Code from this repository to your local.

## Understanding Apex Framework

### Introduction
Salesforce Apex are essential for automating tasks and ensuring data integrity. This guide emphasizes the best practice of having one trigger per object, utilizing a handler to control trigger logic, employing helpers for additional functionality, and leveraging Bypass Settings to manage trigger control.

**Please Note:-** Apex Framework and Bypass Trigger Settings are explained seperately to keep it simple however the Trigger Framework and Bypass Setting goes hand in hand to be most effective.


### Objectives
Ensure maintainable and scalable trigger code.
Enhance readability and simplify debugging.
Promote reusability and separation of concerns.
Provide a mechanism to enable/disable triggers and control helper method execution via Custom Metadata Types.

### Best Practices Overview
**1. One Trigger per Object**<br/>
**2. Trigger Handler for Control Logic**<br/>
**3. Trigger Helper Classes for Business Logic**<br/>
**3. Do more with Domain/Object Service Classes for Common Business Logic**(Optional)<br/>
**4. Bypass Settings for Trigger Control**<br/>
**5. Apex Controllers for LWC / Aura / Batch**<br/>

#### 1. One Trigger per Object
Create a single trigger for each object. This approach ensures that all operations (before insert, after insert, before update, etc.) are managed within a unified structure, reducing the risk of conflicting triggers.

**Implementation Example:**

```
trigger SampleAccountTrigger on Account (after insert) {
    SampleAccountsTriggerHandler.handle(Trigger.new, Trigger.oldMap, Trigger.operationType, Trigger.isBefore, Trigger.isAfter);
}
```


#### 2. Trigger Handler for Control Logic
Delegate the logic of the trigger to a handler class. This class determines which operations to perform based on the trigger context.


**Implementation Example:**

```
public class SampleAccountsTriggerHandler {

    
    public static BypassSettings bypassSetting;

    
    /**
    * @description Check if a specific method is disabled
    * @author rishab.goyal | 08-25-2024 
    * @param methodName 
    * @return Boolean 
    **/
    public static Boolean isMethodDisabled(String methodName) {
        return bypassSetting!=null && bypassSetting.disabledMethods != null && bypassSetting.disabledMethods.contains(methodName);   
    }

    
    /**
    * @description Check if a specific event is disabled
    * @author rishab.goyal | 08-25-2024 
    * @param eventName 
    * @return Boolean 
    **/
    public static Boolean isEventDisabled(String eventName){
        return bypassSetting!=null && bypassSetting.disabledEvents != null && bypassSetting.disabledEvents.contains(eventName);
    }
    


    
    /** Handle the trigger logic based on the trigger operation
    * @description 
    * @author rishab.goyal | 08-25-2024 
    * @param newList 
    * @param oldMap 
    * @param operation 
    * @param isBefore 
    * @param isAfter 
    **/
    public static void handle(List<Account> newList, Map<Id, Account> oldMap, System.TriggerOperation operation, Boolean isBefore, Boolean isAfter) {
        bypassSetting = BypassSettings.getApplicableBypassSettingForTrigger('SampleTrigger');
        // Check if the trigger is enabled and the event is not disabled
        if (bypassSetting!=null && (!bypassSetting.isTriggerEnabled || isEventDisabled(String.valueOf(operation)))) {
            return;
        }
        
        // Perform specific actions based on the trigger operation
        if (operation == System.TriggerOperation.BEFORE_INSERT) {
            beforeInsert(newList);
        } else if (operation == System.TriggerOperation.BEFORE_UPDATE) {
            beforeUpdate(newList, oldMap);
        } else if (operation == System.TriggerOperation.AFTER_INSERT) {
            afterInsert(newList);
        } else if (operation == System.TriggerOperation.AFTER_UPDATE) {
            afterUpdate(newList, oldMap);
        } else if (operation == System.TriggerOperation.BEFORE_DELETE) {
            beforeDelete(oldMap);
        } else if (operation == System.TriggerOperation.AFTER_DELETE) {
            afterDelete(oldMap);
        } else if (operation == System.TriggerOperation.AFTER_UNDELETE) {
            afterUndelete(newList);
        }
    }

    // Perform actions before inserting accounts
    private static void beforeInsert(List<Account> newList) {
       
    }

    // Perform actions before updating accounts
    private static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {
     
        SampleAccountHelper.updateAccountStatus(newList);
        SampleAccountHelper.validateAccountData(newList);
    }

    // Perform actions after inserting accounts
    private static void afterInsert(List<Account> newList) {
    }

    // Perform actions after updating accounts
    private static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        // Add your logic here
    }

    // Perform actions before deleting accounts
    private static void beforeDelete(Map<Id, Account> oldMap) {
        // Add your logic here
    }

    // Perform actions after deleting accounts
    private static void afterDelete(Map<Id, Account> oldMap) {
        // Add your logic here
    }

    // Perform actions after undeleting accounts
    private static void afterUndelete(List<Account> newList) {
        // Add your logic here
    }

}
```




#### 3. Helper Classes for Business Logic
Encapsulate reusable business logic in helper classes. This promotes code reuse and clean separation of trigger control flow from business rules.


**Implementation Example:**


```
public class SampleAccountsHelper {
    
    /**
     * Validates the account data by checking if the account name is empty.
     * If the 'validateAccountData' method is disabled, the validation is skipped.
     * @param accounts The list of accounts to validate.
     */
    public static void validateAccountData(List<Account> accounts) {
        if (SampleAccountsTriggerHandler.isMethodDisabled('validateAccountData')) {
            return;
        }

        for (Account acc : accounts) {
            if (String.isEmpty(acc.Name)) {
                acc.addError('Account Name cannot be empty.');
            }
        }
    }

    /**
     * Updates the account status to 'High Value' for accounts with annual revenue greater than 1,000,000.
     * If the 'updateAccountStatus' method is disabled, the update is skipped.
     * @param accounts The list of accounts to update.
     */
    public static void updateAccountStatus(List<Account> accounts) {
        if (SampleAccountsTriggerHandler.isMethodDisabled('updateAccountStatus')) {
            return;
        }

        for (Account acc : accounts) {
            if (acc.AnnualRevenue > 1000000) {
                acc.Status__c = 'High Value';
            }
        }
    }
}
```

#### 4. Do more with Domain/Object Service Classes for Common Business Logic
Serivce Clsses can be used for the common use case from HelperClass. Helper classes can utlize code from Service Class for the trigger functionality.
Naming Conventions for these Service Classes should always be in format **[Domain/Object]Controller** where [Domain/Object] could be Object alias or name. eg- ***AccountsService***

**Implementation Example:**
```
public class ContactsService{
    public static void sendEmailToContactsOnBirthday(set<Id> ContactIds>){
        //Logic to Send Email 
    }
}
```

#### 5. Bypass Settings for Trigger Control

Bypass Settings Uses a main class - **BypassSettings**. *BypassSettings* uses combination of two Custom Metadata
- Trigger_Configuratons (There should always be one record per Trigger for bypass Settings)
- Bypass_Trigger_Settings (There is the child record of Trigger_Configurations and can be of Type - *Default* or *Custom Permission*. Custom Permission type will enable combinations of bypass scenario for the users with custom permissions enabled

Deploy Bypass Setting Framework in your sandbox/developer org to check it in action. 


#### 6. Seperate Apex Controllers for LWC / Aura

There should be seperate controllers for LWC, Aura and should always be in format **[FunctionalContext]Controller** where Function [FunctionalContext] could be LWC Name. eg- ***CustomLookupLWCController*** 
Controllers can further use the code from Service Classes to reuse existingcode. 

**Implementation Example:**
```
public class CustomLookupLWCController{
    @AuraEnabled
    public static List<sObject> fetchRecords(String query){
        //Logic here
        //Call Service Method (if possible)
    }
}
```



# Deploy Bypass Setting Framework

- Use package.xml to deploy (Do not uncomment the files for Sample Code as you may already have account trigger in your org)


