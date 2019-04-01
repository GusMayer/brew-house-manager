public with sharing class BrewScheduleController {

    @AuraEnabled(Cacheable=true)
    public static Brew_Schedule__c[] getBrewSchedules() {
        return 
        [
            SELECT Id, Name,Brew_Date__c,Brew_Batch__r.Name,Brew_Batch__r.Style__c 
            FROM Brew_Schedule__c
            ORDER BY Brew_Date__c ASC
        ];
    }
}