// Script to create sample Corporate Clients
// Run this in Developer Console or via SFDX

// Create sample Corporate Clients
List<Corporate_Client__c> clients = new List<Corporate_Client__c>();

Corporate_Client__c client1 = new Corporate_Client__c(
    Name = 'TechCorp Solutions',
    Company_Industry__c = 'Technology',
    Company_Size__c = 'Large (1000+ employees)',
    Annual_Revenue__c = '$100M+',
    Contact_Person__c = 'Sarah Johnson',
    Contact_Email__c = 'sarah.johnson@techcorp.com',
    Contact_Phone__c = '+1-555-0101',
    Partnership_Start_Date__c = Date.today().addDays(-180),
    Status__c = 'Active'
);
clients.add(client1);

Corporate_Client__c client2 = new Corporate_Client__c(
    Name = 'Global Manufacturing Inc',
    Company_Industry__c = 'Manufacturing',
    Company_Size__c = 'Medium (100-999 employees)',
    Annual_Revenue__c = '$50M-100M',
    Contact_Person__c = 'Michael Chen',
    Contact_Email__c = 'mchen@globalmfg.com',
    Contact_Phone__c = '+1-555-0102',
    Partnership_Start_Date__c = Date.today().addDays(-120),
    Status__c = 'Active'
);
clients.add(client2);

Corporate_Client__c client3 = new Corporate_Client__c(
    Name = 'Financial Services Group',
    Company_Industry__c = 'Finance',
    Company_Size__c = 'Large (1000+ employees)',
    Annual_Revenue__c = '$500M+',
    Contact_Person__c = 'Emily Rodriguez',
    Contact_Email__c = 'erodriguez@fsg.com',
    Contact_Phone__c = '+1-555-0103',
    Partnership_Start_Date__c = Date.today().addDays(-90),
    Status__c = 'Active'
);
clients.add(client3);

Corporate_Client__c client4 = new Corporate_Client__c(
    Name = 'HealthTech Innovations',
    Company_Industry__c = 'Healthcare',
    Company_Size__c = 'Medium (100-999 employees)',
    Annual_Revenue__c = '$25M-50M',
    Contact_Person__c = 'David Kim',
    Contact_Email__c = 'dkim@healthtech.com',
    Contact_Phone__c = '+1-555-0104',
    Partnership_Start_Date__c = Date.today().addDays(-60),
    Status__c = 'Active'
);
clients.add(client4);

Corporate_Client__c client5 = new Corporate_Client__c(
    Name = 'Retail Dynamics',
    Company_Industry__c = 'Retail',
    Company_Size__c = 'Small (10-99 employees)',
    Annual_Revenue__c = '$10M-25M',
    Contact_Person__c = 'Lisa Thompson',
    Contact_Email__c = 'lthompson@retaildynamics.com',
    Contact_Phone__c = '+1-555-0105',
    Partnership_Start_Date__c = Date.today().addDays(-30),
    Status__c = 'Active'
);
clients.add(client5);

Corporate_Client__c client6 = new Corporate_Client__c(
    Name = 'EduTech Solutions',
    Company_Industry__c = 'Education',
    Company_Size__c = 'Medium (100-999 employees)',
    Annual_Revenue__c = '$25M-50M',
    Contact_Person__c = 'Robert Wilson',
    Contact_Email__c = 'rwilson@edutech.com',
    Contact_Phone__c = '+1-555-0106',
    Partnership_Start_Date__c = Date.today().addDays(-15),
    Status__c = 'Prospect'
);
clients.add(client6);

// Insert clients
try {
    insert clients;
    System.debug('Successfully created ' + clients.size() + ' corporate clients');
    
    // Display the created clients
    for(Corporate_Client__c client : clients) {
        System.debug('Client: ' + client.Name + ' - Industry: ' + client.Company_Industry__c + ' - Status: ' + client.Status__c);
    }
} catch (Exception e) {
    System.debug('Error creating clients: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Corporate client creation script completed!');
