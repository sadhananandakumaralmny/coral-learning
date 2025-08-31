// Test if custom fields can be accessed directly
System.debug('Testing custom field access...');

try {
    // Test 1: Try to query Corporate_Client__c with custom fields
    System.debug('Testing Corporate_Client__c custom fields...');
    
    List<Corporate_Client__c> clients = [
        SELECT Id, Name, Company_Name__c, Company_Industry__c, Status__c
        FROM Corporate_Client__c 
        LIMIT 1
    ];
    
    if (!clients.isEmpty()) {
        Corporate_Client__c client = clients[0];
        System.debug('✅ Successfully queried client with custom fields:');
        System.debug('   ID: ' + client.Id);
        System.debug('   Name: ' + client.Name);
        System.debug('   Company Name: ' + client.Company_Name__c);
        System.debug('   Industry: ' + client.Company_Industry__c);
        System.debug('   Status: ' + client.Status__c);
    } else {
        System.debug('⚠️  No clients found to test with');
    }
    
    // Test 2: Try to query Student__c with custom fields
    System.debug('Testing Student__c custom fields...');
    
    List<Student__c> students = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Corporate_Client__c
        FROM Student__c 
        LIMIT 1
    ];
    
    if (!students.isEmpty()) {
        Student__c student = students[0];
        System.debug('✅ Successfully queried student with custom fields:');
        System.debug('   ID: ' + student.Id);
        System.debug('   Name: ' + student.Name);
        System.debug('   First Name: ' + student.First_Name__c);
        System.debug('   Last Name: ' + student.Last_Name__c);
        System.debug('   Email: ' + student.Email__c);
        System.debug('   Corporate Client: ' + student.Corporate_Client__c);
    } else {
        System.debug('⚠️  No students found to test with');
    }
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
