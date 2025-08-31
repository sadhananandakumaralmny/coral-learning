// Update existing corporate clients with proper company names
List<Corporate_Client__c> clientsToUpdate = [
    SELECT Id, Name, Company_Name__c
    FROM Corporate_Client__c 
    LIMIT 20
];

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

for(Integer i = 0; i < clientsToUpdate.size() && i < companyNames.size(); i++) {
    Corporate_Client__c client = clientsToUpdate[i];
    client.Company_Name__c = companyNames[i];
}

try {
    update clientsToUpdate;
    System.debug('Successfully updated ' + clientsToUpdate.size() + ' corporate clients with company names');
    
    // Display the updated clients
    List<Corporate_Client__c> updatedClients = [
        SELECT Id, Name, Company_Name__c
        FROM Corporate_Client__c 
        ORDER BY Name ASC
        LIMIT 10
    ];
    
    for(Corporate_Client__c client : updatedClients) {
        System.debug('Client: ' + client.Name + ' | Company Name: ' + client.Company_Name__c);
    }
    
} catch(Exception e) {
    System.debug('Error updating clients: ' + e.getMessage());
}
