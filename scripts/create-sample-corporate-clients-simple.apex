// Simple script to create sample Corporate Clients with just the Name field
// Run this in Developer Console or via SFDX

// Create sample Corporate Clients
List<Corporate_Client__c> clients = new List<Corporate_Client__c>();

Corporate_Client__c client1 = new Corporate_Client__c();
clients.add(client1);

Corporate_Client__c client2 = new Corporate_Client__c();
clients.add(client2);

Corporate_Client__c client3 = new Corporate_Client__c();
clients.add(client3);

Corporate_Client__c client4 = new Corporate_Client__c();
clients.add(client4);

Corporate_Client__c client5 = new Corporate_Client__c();
clients.add(client5);

Corporate_Client__c client6 = new Corporate_Client__c();
clients.add(client6);

// Insert clients
try {
    insert clients;
    System.debug('Successfully created ' + clients.size() + ' corporate clients');
    
    // Display the created clients
    for(Corporate_Client__c client : clients) {
        System.debug('Client: ' + client.Name + ' - ID: ' + client.Id);
    }
} catch (Exception e) {
    System.debug('Error creating clients: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Simple corporate client creation script completed!');
