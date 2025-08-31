// Test if the custom fields are actually working
System.debug('Testing custom field creation...');

try {
    Corporate_Client__c client = new Corporate_Client__c();
    
    // Try to set custom fields
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
    System.debug('Status: ' + client.Status__c);
    System.debug('Industry: ' + client.Company_Industry__c);
    
} catch (Exception e) {
    System.debug('Error creating corporate client: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
