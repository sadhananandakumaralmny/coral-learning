// Check for existing corporate clients
System.debug('Checking for existing corporate clients...');

try {
    List<Corporate_Client__c> clients = [
        SELECT Id, Name 
        FROM Corporate_Client__c 
        LIMIT 5
    ];
    
    System.debug('Found ' + clients.size() + ' corporate clients:');
    
    if (clients.isEmpty()) {
        System.debug('No corporate clients found. Creating a sample one...');
        
        Corporate_Client__c sampleClient = new Corporate_Client__c(
            Name = 'TechCorp Solutions'
        );
        insert sampleClient;
        
        System.debug('Created sample client: ' + sampleClient.Id + ' - ' + sampleClient.Name);
    } else {
        for (Corporate_Client__c client : clients) {
            System.debug('Client: ' + client.Id + ' - ' + client.Name);
        }
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
