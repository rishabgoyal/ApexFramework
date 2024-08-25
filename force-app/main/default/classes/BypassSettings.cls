public class BypassSettings{
    
    public String  key {get;set;}
    public String  disabledEvents {get;set;}
    public String  disabledMethods {get;set;}        
    public Boolean isTriggerEnabled {get;set;}    
    
    public static BypassSettings getApplicableBypassSettingForTrigger(String Key) {
        Map<String, Bypass_Trigger_Settings__mdt> bypassTriggerSettingsMap = Bypass_Trigger_Settings__mdt.getAll();
        Trigger_Configurations__mdt triggerConfig = Trigger_Configurations__mdt.getInstance(key);
        BypassSettings applicableBypassSetting = null;
        if(triggerConfig==null){
            return applicableBypassSetting;
        }       
        for(Bypass_Trigger_Settings__mdt bypassTriggerSetting : bypassTriggerSettingsMap.values()){
            if(bypassTriggerSetting.Trigger_Configurations__c != triggerConfig.Id){
                continue;
            }
            if(bypassTriggerSetting.Type__c=='Default'&&applicableBypassSetting==null){
                applicableBypassSetting = converToBypassSetting(bypassTriggerSetting,key);
            }else if(bypassTriggerSetting.Type__c=='Custom Permission' && (FeatureManagement.checkPermission(bypassTriggerSetting.Permission_Name__c))){
                if(applicableBypassSetting==null){
                    applicableBypassSetting = converToBypassSetting(bypassTriggerSetting,key);                    
                }else{
                    applicableBypassSetting = combineSettings(applicableBypassSetting,bypassTriggerSetting);
                }                
            }
            
        }   
        return applicableBypassSetting;	
    }
                     
    public static BypassSettings combineSettings(BypassSettings applicableBypassSetting,Bypass_Trigger_Settings__mdt bypassTriggerSetting){
        if(applicableBypassSetting.isTriggerEnabled && bypassTriggerSetting.Is_Enabled__c==false){
            applicableBypassSetting.isTriggerEnabled = bypassTriggerSetting.Is_Enabled__c;
        }
        applicableBypassSetting.disabledMethods = applicableBypassSetting.disabledMethods + bypassTriggerSetting.Disabled_Methods__c;
        applicableBypassSetting.disabledEvents  = applicableBypassSetting.disabledEvents  + bypassTriggerSetting.Disabled_Events__c ;
        return applicableBypassSetting;
    }
    
    public static BypassSettings converToBypassSetting(Bypass_Trigger_Settings__mdt bypassTriggerSetting,String key){
        BypassSettings bypasssetting = new BypassSettings();
        bypasssetting.key = key;
        bypasssetting.isTriggerEnabled = bypassTriggerSetting.Is_Enabled__c;
        bypasssetting.disabledMethods = bypassTriggerSetting.Disabled_Methods__c;
        bypasssetting.disabledEvents = bypassTriggerSetting.Disabled_Events__c;
        return bypasssetting;
    }
}