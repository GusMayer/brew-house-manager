trigger BrewScheduleTrigger on Brew_Schedule__c (before insert, before update, after insert, after update) {
    BrewStepService brewStepService = new BrewStepService();
    BrewScheduleService brewScheduleService = new BrewScheduleService(brewStepService);
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            for(Brew_Schedule__c newSchedule : Trigger.New){
                brewScheduleService.validateCreate(newSchedule);
            }
        } else if (Trigger.isAfter) {
            for(Brew_Schedule__c newSchedule : Trigger.New){
                brewStepService.generateStepsForSchedule(newSchedule);
            }
        }
    } else if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            for(Brew_Schedule__c updatedSchedule : Trigger.New){
                Brew_Schedule__c oldSchedule = Trigger.oldMap.get(updatedSchedule.Id);
                brewScheduleService.validateUpdate(updatedSchedule, oldSchedule);
            }
        } else if (Trigger.isAfter) {
            for(Brew_Schedule__c updatedSchedule : Trigger.New){
                Date newBrewDate = updatedSchedule.Brew_Date__c;
                Date oldBrewDate = Trigger.oldMap.get(updatedSchedule.Id).Brew_Date__c;
                Boolean isUpdatingDateOnSchedule = newBrewDate != oldBrewDate;
                if(isUpdatingDateOnSchedule){
                    brewStepService.updateStepsForSchedule(updatedSchedule);
                }
            }
        }
    }
}