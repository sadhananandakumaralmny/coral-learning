// Basic test to see what fields are available
System.debug('Testing basic record creation...');

try {
    // Test 1: Try to create a corporate client with just the name field
    System.debug('Creating corporate client...');
    
    Corporate_Client__c testClient = new Corporate_Client__c();
    
    // Try to set some fields and see what's available
    System.debug('Available fields on Corporate_Client__c:');
    Schema.DescribeSObjectResult describeResult = Corporate_Client__c.SObjectType.getDescribe();
    Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
    
    for (String fieldName : fieldMap.keySet()) {
        Schema.SObjectField field = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('Field: ' + fieldName + ' - Type: ' + fieldDescribe.getType() + ' - Writeable: ' + fieldDescribe.isUpdateable());
    }
    
    // Try to insert with just the required fields
    insert testClient;
    System.debug('✅ Created client with ID: ' + testClient.Id);
    
    // Test 2: Try to create a student
    System.debug('Creating student...');
    
    Student__c testStudent = new Student__c(
        First_Name__c = 'Test',
        Last_Name__c = 'Student',
        Email__c = 'test@example.com'
    );
    
    insert testStudent;
    System.debug('✅ Created student with ID: ' + testStudent.Id);
    
    // Test 3: Try to query the student to see what fields are available
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
    System.debug('❌ Error: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
