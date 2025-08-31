// Simple test script to create basic records
System.debug('Testing simple record creation...');

try {
    // Test 1: Create a simple corporate client
    System.debug('Creating corporate client...');
    
    Corporate_Client__c testClient = new Corporate_Client__c(
        Company_Name__c = 'Test Company'
    );
    
    insert testClient;
    System.debug('✅ Created client: ' + testClient.Id + ' - Company Name: ' + testClient.Company_Name__c);
    
    // Test 2: Create a simple student
    System.debug('Creating student...');
    
    Student__c testStudent = new Student__c(
        First_Name__c = 'Test',
        Last_Name__c = 'Student',
        Email__c = 'test@example.com'
    );
    
    insert testStudent;
    System.debug('✅ Created student: ' + testStudent.Id + ' - Name: ' + testStudent.First_Name__c + ' ' + testStudent.Last_Name__c);
    
    // Test 3: Try to assign client to student
    System.debug('Testing client assignment...');
    
    testStudent.Corporate_Client__c = testClient.Id;
    update testStudent;
    
    System.debug('✅ Successfully assigned student to client');
    
    // Test 4: Query to verify relationship
    Student__c updatedStudent = [
        SELECT Id, First_Name__c, Last_Name__c, Corporate_Client__c, Corporate_Client__r.Company_Name__c
        FROM Student__c 
        WHERE Id = :testStudent.Id
    ];
    
    System.debug('🔍 Verification:');
    System.debug('   Student: ' + updatedStudent.First_Name__c + ' ' + updatedStudent.Last_Name__c);
    System.debug('   Client ID: ' + updatedStudent.Corporate_Client__c);
    System.debug('   Client Company Name: ' + updatedStudent.Corporate_Client__r?.Company_Name__c);
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
