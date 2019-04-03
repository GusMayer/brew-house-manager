public class BrewScheduleService {
    
    private BrewStepService brewStepService;
    
    public BrewScheduleService(BrewStepService brewStepService){
        this.brewStepService = brewStepService;
    }
    
    public List<Brew_Schedule__c> getBrewSchedules(){
        return [SELECT Id, Name,Brew_Date__c,Brew_Batch__r.Name,Brew_Batch__r.Style__c 
                FROM Brew_Schedule__c
                ORDER BY Brew_Date__c ASC];
    }
    
    public Boolean validateCreate(Brew_Schedule__c brewSchedule){
        Boolean isScheduleAvailable = isScheduleDateAvailable(brewSchedule.Brew_Date__c);
        if(!isScheduleAvailable){
            brewSchedule.Id.addError(brewSchedule.Brew_Date__c.format() + ' is already assigned to another schedule, please pick another date.');
            return false;
        }
        return true;
    }
    
    public Boolean validateUpdate(Brew_Schedule__c updatedSchedule, Brew_Schedule__c oldSchedule){
        
        Boolean isUpdatingDateOnSchedule = updatedSchedule.Brew_Date__c != oldSchedule.Brew_Date__c;
        
        if(isUpdatingDateOnSchedule){
            Boolean isScheduleAvailable = isScheduleDateAvailable(updatedSchedule.Brew_Date__c);
            if(!isScheduleAvailable){
                updatedSchedule.Id.addError(updatedSchedule.Brew_Date__c.format() 
                                            + ' is already assigned to another schedule, please pick another date.');
                return false;
            }
            Boolean isPreparationStepInProgress = brewStepService.isPreparationStepInProgress(updatedSchedule.Id);
            if(isPreparationStepInProgress){
                updatedSchedule.Id.addError('Unable to update schedule, Preparation step is in Progress or has been Completed');
                return false;
            }
        }
        return true;
    }
    
    private Boolean isScheduleDateAvailable(Date scheduleDate){
        return [SELECT Name FROM Brew_Schedule__c 
                WHERE Brew_Date__c = :scheduleDate].isEmpty();
    }
}