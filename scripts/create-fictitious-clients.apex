// Create corporate clients with proper fictitious company names
// Delete existing clients first
List<Corporate_Client__c> existingClients = [
    SELECT Id 
    FROM Corporate_Client__c 
    LIMIT 20
];

if(!existingClients.isEmpty()) {
    delete existingClients;
    System.debug('Deleted ' + existingClients.size() + ' existing clients');
}

// Create new clients with realistic fictitious names
List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();

List<String> companyNames = new List<String>{
    'NexusTech Solutions',
    'MediCare Innovations',
    'Global Finance Partners',
    'SteelWorks Manufacturing',
    'Retail Dynamics Corp',
    'EduTech Academy',
    'Strategic Consulting Group',
    'RealEstate Ventures Ltd',
    'Digital Innovations Co',
    'Green Energy Systems',
    'Smart Logistics Solutions',
    'Creative Marketing Pro',
    'Data Analytics Corp',
    'Cloud Computing Plus',
    'Mobile App Studios',
    'AI Research Labs',
    'Blockchain Ventures',
    'CyberSecurity Shield',
    'IoT Solutions Hub',
    'Quantum Computing Co'
};

for(Integer i = 0; i < companyNames.size(); i++) {
    Corporate_Client__c newClient = new Corporate_Client__c();
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
        System.debug('New Client: ' + client.Name + ' | Created: ' + client.CreatedDate);
    }
    
} catch(Exception e) {
    System.debug('Error creating clients: ' + e.getMessage());
}
