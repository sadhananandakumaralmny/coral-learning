public with sharing class CorporateClientController {
    
    @AuraEnabled(cacheable=true)
    public static List<Corporate_Client__c> getCorporateClients() {
        try {
            return [
                SELECT Id, Name, CreatedDate
                FROM Corporate_Client__c 
                ORDER BY Name ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving corporate clients: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Corporate_Client__c createCorporateClient(String clientData) {
        try {
            Map<String, Object> clientMap = (Map<String, Object>) JSON.deserializeUntyped(clientData);
            
            Corporate_Client__c newClient = new Corporate_Client__c();
            // Note: Name field is auto-generated, so we don't set it
            // Custom fields will be added when they become available
            // For now, just create the basic record
            
            insert newClient;
            return newClient;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating corporate client: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Corporate_Client__c updateCorporateClient(Id clientId, String clientData) {
        try {
            Map<String, Object> clientMap = (Map<String, Object>) JSON.deserializeUntyped(clientData);
            
            Corporate_Client__c clientToUpdate = [
                SELECT Id, Name
                FROM Corporate_Client__c 
                WHERE Id = :clientId
                LIMIT 1
            ];
            
            // Note: Name field is auto-generated, so we don't update it
            // Custom fields will be updated when they become available
            
            update clientToUpdate;
            return clientToUpdate;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error updating corporate client: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteCorporateClient(Id clientId) {
        try {
            Corporate_Client__c clientToDelete = [
                SELECT Id FROM Corporate_Client__c WHERE Id = :clientId LIMIT 1
            ];
            delete clientToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting corporate client: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Corporate_Client__c> getClientsByIndustry(String industry) {
        try {
            return [
                SELECT Id, Name, CreatedDate
                FROM Corporate_Client__c 
                ORDER BY Name ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving clients by industry: ' + e.getMessage());
        }
    }
}
