/**
 * @description       : 
 * @author            : rishab.goyal
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : rishab.goyal
**/
// Trigger Helper file: SampleAccountHelper.cls
public with sharing class SampleAccountHelper {

    /**
    * @description 
    * @author rishab.goyal | 08-25-2024 
    * @param newAccounts 
    **/
    public static void processAccounts(List<Account> newAccounts) {
         if (SampleAccountsTriggerHandler.isMethodDisabled('processAccounts')) {
            return;
        }

       //Custom Logic To Handle
    }
}