public with sharing class BrewStepController {
    
    @AuraEnabled(Cacheable=true)
    public static Brew_Step__c[] findBrewStepsByBrewSchedule(Id scheduleId) {
        return BrewStepService.findBrewStepsByBrewSchedule(scheduleId);
    }
   
}