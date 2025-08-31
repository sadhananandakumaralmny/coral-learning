// Minimal script to create a corporate client with no custom fields
// Run this in Developer Console or via SFDX

try {
    // Create a basic corporate client
    Corporate_Client__c newClient = new Corporate_Client__c();
    
    // Insert the record (Name will be auto-generated)
    insert newClient;
    
    System.debug('Successfully created corporate client with ID: ' + newClient.Id);
    System.debug('Client Name: ' + newClient.Name);
    
    // Query the record back to see what fields are available
    Corporate_Client__c queriedClient = [
        SELECT Id, Name 
        FROM Corporate_Client__c 
        WHERE Id = :newClient.Id
        LIMIT 1
    ];
    
    System.debug('Queried client: ' + queriedClient);
    
} catch (Exception e) {
    System.debug('Error creating client: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Minimal corporate client creation script completed!');
