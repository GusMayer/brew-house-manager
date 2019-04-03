public class BrewScheduleController {

    @AuraEnabled(Cacheable=true)
    public static List<Brew_Schedule__c> getBrewSchedules() {
        BrewStepService brewStepService = new BrewStepService();
        BrewScheduleService brewScheduleService = new BrewScheduleService(brewStepService);
        return brewScheduleService.getBrewSchedules();
    }
}