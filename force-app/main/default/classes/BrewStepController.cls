public class BrewStepController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Brew_Step__c> findBrewStepsByBrewSchedule(Id scheduleId) {
        BrewStepService brewStepService = new BrewStepService();
        return brewStepService.findBrewStepsByBrewSchedule(scheduleId);
    }
    
}