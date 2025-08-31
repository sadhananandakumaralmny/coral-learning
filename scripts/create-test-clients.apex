// Create a few test corporate clients to demonstrate the tab
// Delete existing clients first
List<Corporate_Client__c> existingClients = [
    SELECT Id 
    FROM Corporate_Client__c 
    LIMIT 10
];

if(!existingClients.isEmpty()) {
    delete existingClients;
    System.debug('Deleted ' + existingClients.size() + ' existing clients');
}

// Create 5 new test clients
List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();

for(Integer i = 0; i < 5; i++) {
    Corporate_Client__c newClient = new Corporate_Client__c();
    newClients.add(newClient);
}

try {
    insert newClients;
    System.debug('Successfully created ' + newClients.size() + ' test clients');
    
    // Display the new clients
    List<Corporate_Client__c> createdClients = [
        SELECT Id, Name, CreatedDate
        FROM Corporate_Client__c 
        ORDER BY CreatedDate DESC
        LIMIT 5
    ];
    
    for(Corporate_Client__c client : createdClients) {
        System.debug('Test Client: ' + client.Name + ' | Created: ' + client.CreatedDate);
    }
    
} catch(Exception e) {
    System.debug('Error creating test clients: ' + e.getMessage());
}
