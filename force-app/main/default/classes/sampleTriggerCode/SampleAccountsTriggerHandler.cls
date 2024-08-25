/**
 * @description       : 
 * @author            : rishab.goyal
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : rishab.goyal
**/
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
     
    }

    // Perform actions after inserting accounts
    private static void afterInsert(List<Account> newList) {
        SampleAccountHelper.processAccounts(newList);
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