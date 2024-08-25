/** // Trigger file: SampleAccountTrigger.trigger
 * @description       : 
 * @author            : rishab.goyal
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : rishab.goyal
**/
trigger SampleAccountTrigger on Account (after insert) {
    SampleAccountsTriggerHandler.handle(Trigger.new, Trigger.oldMap, Trigger.operationType, Trigger.isBefore, Trigger.isAfter);
}
