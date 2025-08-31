// Update Corporate Client Names to be more realistic
// Since Name field is auto-number, we'll delete old records and create new ones

// First, delete existing clients
List<Corporate_Client__c> existingClients = [
    SELECT Id 
    FROM Corporate_Client__c 
    LIMIT 20
];

if(!existingClients.isEmpty()) {
    delete existingClients;
    System.debug('Deleted ' + existingClients.size() + ' existing clients');
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

List<String> industries = new List<String>{
    'Technology',
    'Healthcare', 
    'Finance',
    'Manufacturing',
    'Retail',
    'Education',
    'Consulting',
    'Real Estate',
    'Technology',
    'Energy',
    'Logistics',
    'Marketing',
    'Technology',
    'Technology',
    'Technology',
    'Technology',
    'Technology',
    'Technology',
    'Technology',
    'Technology'
};

List<String> sizes = new List<String>{
    'Medium (100-999 employees)',
    'Large (1000+ employees)',
    'Enterprise (10000+ employees)',
    'Large (1000+ employees)',
    'Medium (100-999 employees)',
    'Small (10-99 employees)',
    'Small (10-99 employees)',
    'Medium (100-999 employees)',
    'Large (1000+ employees)',
    'Medium (100-999 employees)',
    'Large (1000+ employees)',
    'Small (10-99 employees)',
    'Medium (100-999 employees)',
    'Large (1000+ employees)',
    'Small (10-99 employees)',
    'Medium (100-999 employees)',
    'Small (10-99 employees)',
    'Medium (100-999 employees)',
    'Small (10-99 employees)',
    'Small (10-99 employees)'
};

List<String> revenues = new List<String>{
    '$25M-50M',
    '$100M-500M',
    '$500M+',
    '$100M-500M',
    '$25M-50M',
    '$1M-10M',
    '$1M-10M',
    '$25M-50M',
    '$100M-500M',
    '$25M-50M',
    '$100M-500M',
    '$1M-10M',
    '$25M-50M',
    '$100M-500M',
    '$1M-10M',
    '$25M-50M',
    '$1M-10M',
    '$25M-50M',
    '$1M-10M',
    '$1M-10M'
};

List<String> contacts = new List<String>{
    'Sarah Johnson',
    'Dr. Michael Chen',
    'Jennifer Rodriguez',
    'Robert Kim',
    'Amanda Thompson',
    'David Wilson',
    'Lisa Garcia',
    'James Brown',
    'Maria Martinez',
    'Kevin Lee',
    'Rachel Green',
    'Thomas Davis',
    'Emily White',
    'Christopher Taylor',
    'Jessica Anderson',
    'Daniel Miller',
    'Ashley Moore',
    'Matthew Jackson',
    'Nicole Harris',
    'Ryan Clark'
};

List<String> statuses = new List<String>{
    'Active',
    'Active',
    'Active',
    'Active',
    'Active',
    'Active',
    'Prospect',
    'Active',
    'Active',
    'Active',
    'Active',
    'Prospect',
    'Active',
    'Active',
    'Prospect',
    'Active',
    'Prospect',
    'Active',
    'Prospect',
    'Active'
};

for(Integer i = 0; i < companyNames.size(); i++) {
    Corporate_Client__c newClient = new Corporate_Client__c();
    
    // Set all the custom fields
    newClient.Company_Industry__c = industries[i];
    newClient.Company_Size__c = sizes[i];
    newClient.Annual_Revenue__c = revenues[i];
    newClient.Contact_Person__c = contacts[i];
    newClient.Contact_Email__c = contacts[i].toLowerCase().replace(' ', '.') + '@' + companyNames[i].toLowerCase().replace(' ', '').replace('-', '') + '.com';
    newClient.Contact_Phone__c = '+1-555-' + String.valueOf(1000 + i).substring(1);
    newClient.Status__c = statuses[i];
    
    // Set partnership start date to a random date within the last 2 years
    Integer daysAgo = (Integer)(Math.random() * 730);
    newClient.Partnership_Start_Date__c = Date.today().addDays(-daysAgo);
    
    newClients.add(newClient);
}

try {
    insert newClients;
    System.debug('Successfully created ' + newClients.size() + ' new corporate clients');
    
    // Display the new clients
    List<Corporate_Client__c> createdClients = [
        SELECT Id, Name, Company_Industry__c, Company_Size__c, Annual_Revenue__c, 
               Contact_Person__c, Contact_Email__c, Contact_Phone__c, 
               Partnership_Start_Date__c, Status__c
        FROM Corporate_Client__c 
        ORDER BY Name ASC
        LIMIT 10
    ];
    
    for(Corporate_Client__c client : createdClients) {
        System.debug('Client: ' + client.Name + ' | Industry: ' + client.Company_Industry__c + 
                    ' | Size: ' + client.Company_Size__c + ' | Revenue: ' + client.Annual_Revenue__c +
                    ' | Contact: ' + client.Contact_Person__c + ' | Status: ' + client.Status__c);
    }
    
} catch(Exception e) {
    System.debug('Error creating clients: ' + e.getMessage());
}
