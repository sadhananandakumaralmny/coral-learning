// Create custom fields via Apex
System.debug('Creating custom fields via Apex...');

try {
    // This is a more direct approach to test field creation
    // Let's try to create a simple test field first
    
    System.debug('Testing field creation approach...');
    
    // First, let's check if we can access the fields in a different way
    // Sometimes fields exist but are not visible in the describe
    
    // Try to create a record with custom fields to see what happens
    System.debug('Attempting to create a corporate client with custom fields...');
    
    Corporate_Client__c testClient = new Corporate_Client__c();
    
    // Try to set custom fields directly
    try {
        // These might work even if the describe doesn't show them
        testClient.put('Company_Name__c', 'Test Company Apex');
        testClient.put('Company_Industry__c', 'Technology');
        testClient.put('Status__c', 'Active');
        
        System.debug('✅ Successfully set custom fields via put() method');
        
        insert testClient;
        System.debug('✅ Successfully created client with custom fields: ' + testClient.Id);
        
        // Now try to query the record to see if the fields are there
        Corporate_Client__c queriedClient = [
            SELECT Id, Name, Company_Name__c, Company_Industry__c, Status__c
            FROM Corporate_Client__c 
            WHERE Id = :testClient.Id
        ];
        
        System.debug('🔍 Queried client with custom fields:');
        System.debug('   ID: ' + queriedClient.Id);
        System.debug('   Name: ' + queriedClient.Name);
        System.debug('   Company Name: ' + queriedClient.get('Company_Name__c'));
        System.debug('   Industry: ' + queriedClient.get('Company_Industry__c'));
        System.debug('   Status: ' + queriedClient.get('Status__c'));
        
    } catch (Exception fieldError) {
        System.debug('❌ Error setting custom fields: ' + fieldError.getMessage());
        
        // If that fails, let's try to create the client without custom fields first
        System.debug('Falling back to basic client creation...');
        insert testClient;
        System.debug('✅ Created basic client: ' + testClient.Id);
    }
    
    // Now let's try to create a student with the Corporate_Client__c field
    System.debug('Attempting to create a student with client assignment...');
    
    Student__c testStudent = new Student__c(
        First_Name__c = 'Test',
        Last_Name__c = 'Student',
        Email__c = 'test.student@example.com'
    );
    
    try {
        // Try to set the corporate client field
        testStudent.put('Corporate_Client__c', testClient.Id);
        System.debug('✅ Successfully set Corporate_Client__c field');
    } catch (Exception clientFieldError) {
        System.debug('❌ Error setting Corporate_Client__c field: ' + clientFieldError.getMessage());
    }
    
    insert testStudent;
    System.debug('✅ Created student: ' + testStudent.Id);
    
    // Query the student to see what fields are available
    Student__c queriedStudent = [
        SELECT Id, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        WHERE Id = :testStudent.Id
    ];
    
    System.debug('🔍 Queried student:');
    System.debug('   ID: ' + queriedStudent.Id);
    System.debug('   First Name: ' + queriedStudent.First_Name__c);
    System.debug('   Last Name: ' + queriedStudent.Last_Name__c);
    System.debug('   Email: ' + queriedStudent.Email__c);
    
} catch (Exception e) {
    System.debug('❌ Error in field creation script: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
