// Test the CorporateClientController to see if it's working
try {
    System.debug('Testing CorporateClientController...');
    
    // Test the getCorporateClients method
    List<Corporate_Client__c> clients = CorporateClientController.getCorporateClients();
    System.debug('Retrieved ' + clients.size() + ' clients');
    
    if(clients.size() > 0) {
        System.debug('First client: ' + clients[0].Name);
        System.debug('All clients:');
        for(Corporate_Client__c client : clients) {
            System.debug('  - ' + client.Name + ' (ID: ' + client.Id + ')');
        }
    } else {
        System.debug('No clients found');
    }
    
} catch(Exception e) {
    System.debug('Error testing controller: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
