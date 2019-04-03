public class BrewStepService {
    
    private final static String PREPARATION = 'Preparation';
    private final static String BREWING = 'Brewing';
    private final static String FERMENTATION = 'Fermentation';
    private final static String MATURATION = 'Maturation';
    private final static String PACKAGING = 'Packaging';
    
    private final static String NOT_STARTED = 'Not Started';
    
    public List<Brew_Step__c> findBrewStepsByBrewSchedule(Id scheduleId) {
        return 
            [SELECT Id, Name, Planned_Date__c, Status__c, Brew_Schedule__c
             FROM Brew_Step__c
             WHERE Brew_Schedule__c = :scheduleId
             ORDER BY Planned_Date__c ASC];
    }
    
    public List<Brew_Step__c> generateStepsForSchedule(Brew_Schedule__c newSchedule){
        
        List<Brew_Step__c> steps = new List<Brew_Step__c>();
        if(newSchedule.Brew_Date__c == null){
            return steps;
        }
        
        Brew_Batch__c batch = [SELECT Name, Style__c FROM Brew_Batch__c 
                               WHERE Id = :newSchedule.Brew_Batch__c];
        Date brewDate = newSchedule.Brew_Date__c;
        
        Brew_Step__c step1 = new Brew_Step__c(Name=PREPARATION, Planned_Date__c=brewDate-5, 
                                              Status__c=NOT_STARTED, Brew_Schedule__c=newSchedule.Id);
        insert step1;
        
        Brew_Step__c step2 = new Brew_Step__c(Name=BREWING, Planned_Date__c=brewDate, 
                                              Status__c=NOT_STARTED, Brew_Schedule__c=newSchedule.Id);
        insert step2;
        
        Brew_Step__c step3 = new Brew_Step__c(Name=FERMENTATION, Planned_Date__c=brewDate, 
                                              Status__c=NOT_STARTED, Brew_Schedule__c=newSchedule.Id);
        insert step3;
        
        Brew_Step__c step4 = new Brew_Step__c(Name=MATURATION, Planned_Date__c=brewDate.addDays(14), 
                                              Status__c=NOT_STARTED, Brew_Schedule__c=newSchedule.Id);
        insert step4;
        
        Brew_Step__c step5 = new Brew_Step__c(Name=PACKAGING, Planned_Date__c=brewDate.addDays(28), 
                                              Status__c=NOT_STARTED, Brew_Schedule__c=newSchedule.Id);
        insert step5;
        
        Brew_Step__c[] stepsArray = new Brew_Step__c[]{step1,step2,step3,step4,step5};
            steps.addAll(stepsArray);
        
        return steps;
    }
    
    public List<Brew_Step__c> updateStepsForSchedule(Brew_Schedule__c newSchedule){
        
        if(newSchedule.Brew_Date__c == null){
            return new List<Brew_Step__c>();
        }
        
        List<Brew_Step__c> existingSteps = [SELECT Name, Planned_Date__c, Status__c FROM Brew_Step__c 
                                            WHERE Brew_Schedule__c = :newSchedule.Id];
        if(!existingSteps.isEmpty()){
            Date brewDate = newSchedule.Brew_Date__c;
            for(Brew_Step__c step : existingSteps){
                if(PREPARATION.equals(step.Name)){
                    step.Planned_Date__c = brewDate-5;
                } else if(BREWING.equals(step.Name) || FERMENTATION.equals(step.Name)){
                    step.Planned_Date__c = brewDate;
                } else if(MATURATION.equals(step.Name)){
                    step.Planned_Date__c = brewDate.addDays(14);
                } else if(PACKAGING.equals(step.Name)){
                    step.Planned_Date__c = brewDate.addDays(28);
                }
                update step;
            }
        }
        return existingSteps;
    }
    
    public Boolean isPreparationStepInProgress(Id scheduleId){
        return [SELECT Id FROM Brew_Step__c 
                WHERE Name =: PREPARATION
                AND Status__c =: NOT_STARTED
                AND Brew_Schedule__c = :scheduleId].isEmpty();
    }
}