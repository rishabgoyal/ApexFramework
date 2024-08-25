@isTest
public class BypassSettings_Test {
	
    static testMethod void testGetApplicableBypassSettingForTrigger() {
        BypassSettings bypassSetting  = BypassSettings.getApplicableBypassSettingForTrigger('SampleTrigger');
        bypassSetting = BypassSettings.combineSettings(bypassSetting, Bypass_Trigger_Settings__mdt.getInstance('Sample_Trigger_CustomPermissions'));
    }
    
    
    
}