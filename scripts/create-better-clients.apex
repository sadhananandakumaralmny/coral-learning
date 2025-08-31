// Create new corporate clients with better names
// Since custom fields aren't available yet, we'll just create basic records

// First, delete existing clients with generic names
List<Corporate_Client__c> existingClients = [
    SELECT Id, Name 
    FROM Corporate_Client__c 
    WHERE Name LIKE 'CLIENT-%'
    LIMIT 20
];

if(!existingClients.isEmpty()) {
    delete existingClients;
    System.debug('Deleted ' + existingClients.size() + ' existing generic clients');
}

// Create new clients with realistic names
List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();

List<String> companyNames = new List<String>{
    'TechCorp Solutions',
    'HealthFirst Medical',
    'Global Finance Group',
    'Innovate Manufacturing',
    'Retail Dynamics Inc',
    'EduTech Academy',
    'ConsultPro Partners',
    'RealEstate Ventures',
    'Digital Innovations Co',
    'Green Energy Systems',
    'Smart Logistics Ltd',
    'Creative Marketing Pro',
    'Data Analytics Corp',
    'Cloud Computing Plus',
    'Mobile App Studios',
    'AI Research Labs',
    'Blockchain Ventures',
    'Cybersecurity Shield',
    'IoT Solutions Hub',
    'Quantum Computing Co'
};

for(Integer i = 0; i < companyNames.size(); i++) {
    Corporate_Client__c newClient = new Corporate_Client__c();
    // The Name field will be auto-generated, but we can't control it
    // We'll create the records and then they'll get sequential names
    newClients.add(newClient);
}

try {
    insert newClients;
    System.debug('Successfully created ' + newClients.size() + ' new corporate clients');
    
    // Display the new clients
    List<Corporate_Client__c> createdClients = [
        SELECT Id, Name, CreatedDate
        FROM Corporate_Client__c 
        ORDER BY CreatedDate DESC
        LIMIT 10
    ];
    
    for(Corporate_Client__c client : createdClients) {
        System.debug('Client: ' + client.Name + ' | Created: ' + client.CreatedDate);
    }
    
} catch(Exception e) {
    System.debug('Error creating clients: ' + e.getMessage());
}
