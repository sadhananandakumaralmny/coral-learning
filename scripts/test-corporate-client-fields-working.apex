// Test script to verify Corporate Client custom fields are working
// Run this in Developer Console or via SFDX

try {
    // Create a corporate client with custom fields
    Corporate_Client__c testClient = new Corporate_Client__c();
    testClient.Company_Industry__c = 'Technology';
    testClient.Company_Size__c = 'Large (1000+ employees)';
    testClient.Annual_Revenue__c = '$100M+';
    testClient.Contact_Person__c = 'John Smith';
    testClient.Contact_Email__c = 'john.smith@techcorp.com';
    testClient.Contact_Phone__c = '+1-555-0123';
    testClient.Partnership_Start_Date__c = Date.today();
    testClient.Status__c = 'Active';
    
    insert testClient;
    
    System.debug('Successfully created corporate client with ID: ' + testClient.Id);
    System.debug('Client Name: ' + testClient.Name);
    System.debug('Company Industry: ' + testClient.Company_Industry__c);
    System.debug('Company Size: ' + testClient.Company_Size__c);
    System.debug('Annual Revenue: ' + testClient.Annual_Revenue__c);
    System.debug('Contact Person: ' + testClient.Contact_Person__c);
    System.debug('Contact Email: ' + testClient.Contact_Email__c);
    System.debug('Contact Phone: ' + testClient.Contact_Phone__c);
    System.debug('Partnership Start Date: ' + testClient.Partnership_Start_Date__c);
    System.debug('Status: ' + testClient.Status__c);
    
    // Query the record back to verify all fields
    Corporate_Client__c queriedClient = [
        SELECT Id, Name, Company_Industry__c, Company_Size__c, Annual_Revenue__c,
               Contact_Person__c, Contact_Email__c, Contact_Phone__c,
               Partnership_Start_Date__c, Status__c
        FROM Corporate_Client__c 
        WHERE Id = :testClient.Id
        LIMIT 1
    ];
    
    System.debug('Queried client: ' + queriedClient);
    
} catch (Exception e) {
    System.debug('Error creating client: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Corporate client field test completed!');
