// Create a simple corporate client to test the fields
System.debug('Creating a simple corporate client...');

try {
    Corporate_Client__c client = new Corporate_Client__c();
    client.Status__c = 'Active';
    client.Company_Industry__c = 'Technology';
    client.Company_Size__c = 'Medium (100-999 employees)';
    client.Annual_Revenue__c = '$25M-50M';
    client.Contact_Person__c = 'John Smith';
    client.Contact_Email__c = 'john.smith@techcorp.com';
    client.Contact_Phone__c = '+1-555-0101';
    client.Partnership_Start_Date__c = Date.today();
    
    insert client;
    System.debug('Successfully created corporate client: ' + client.Id + ' - Name: ' + client.Name);
    
} catch (Exception e) {
    System.debug('Error creating corporate client: ' + e.getMessage());
}
