// Debug Student-Client Mapping Issues
System.debug('🔍 Debugging Student-Client Mapping Issues...');

try {
    // Step 1: Check what fields actually exist on Corporate_Client__c
    System.debug('📋 Step 1: Checking Corporate_Client__c object structure...');
    
    Schema.DescribeSObjectResult clientDescribe = Corporate_Client__c.SObjectType.getDescribe();
    Map<String, Schema.SObjectField> clientFields = clientDescribe.fields.getMap();
    
    System.debug('🏢 Corporate_Client__c fields:');
    for (String fieldName : clientFields.keySet()) {
        Schema.SObjectField field = clientFields.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('   ' + fieldName + ' (' + fieldDescribe.getType() + ') - Label: ' + fieldDescribe.getLabel());
    }
    
    // Step 2: Check what fields actually exist on Student__c
    System.debug('📋 Step 2: Checking Student__c object structure...');
    
    Schema.DescribeSObjectResult studentDescribe = Student__c.SObjectType.getDescribe();
    Map<String, Schema.SObjectField> studentFields = studentDescribe.fields.getMap();
    
    System.debug('👥 Student__c fields:');
    for (String fieldName : studentFields.keySet()) {
        Schema.SObjectField field = studentFields.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('   ' + fieldName + ' (' + fieldDescribe.getType() + ') - Label: ' + fieldDescribe.getLabel());
    }
    
    // Step 3: Check existing data
    System.debug('📋 Step 3: Checking existing data...');
    
    List<Corporate_Client__c> existingClients = [
        SELECT Id, Name, Company_Name__c, Company_Industry__c, Company_Size__c
        FROM Corporate_Client__c 
        LIMIT 5
    ];
    
    System.debug('🏢 Existing Corporate Clients:');
    for (Corporate_Client__c client : existingClients) {
        System.debug('   ID: ' + client.Id + ', Name: ' + client.Name + ', Company_Name__c: ' + client.Company_Name__c);
    }
    
    List<Student__c> existingStudents = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Department__c, Corporate_Client__c
        FROM Student__c 
        LIMIT 5
    ];
    
    System.debug('👥 Existing Students:');
    for (Student__c student : existingStudents) {
        System.debug('   ID: ' + student.Id + ', Name: ' + student.Name + ', Department: ' + student.Department__c + ', Client: ' + student.Corporate_Client__c);
    }
    
    // Step 4: Try to create a test client and student
    System.debug('📋 Step 4: Testing field population...');
    
    if (existingClients.isEmpty()) {
        System.debug('🏢 Creating test corporate client...');
        
        Corporate_Client__c testClient = new Corporate_Client__c(
            Company_Name__c = 'Test Company',
            Company_Industry__c = 'Technology',
            Company_Size__c = '100-500',
            Status__c = 'Active'
        );
        
        insert testClient;
        System.debug('✅ Created test client: ' + testClient.Id + ' - Company_Name__c: ' + testClient.Company_Name__c);
        
        existingClients.add(testClient);
    }
    
    if (existingStudents.isEmpty()) {
        System.debug('👥 Creating test student...');
        
        Student__c testStudent = new Student__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Student',
            Department__c = 'Engineering',
            Email__c = 'test.student@test.com',
            Status__c = 'Active'
        );
        
        insert testStudent;
        System.debug('✅ Created test student: ' + testStudent.Id + ' - Department: ' + testStudent.Department__c);
        
        existingStudents.add(testStudent);
    }
    
    // Step 5: Try to assign client to student
    System.debug('📋 Step 5: Testing client assignment...');
    
    if (!existingClients.isEmpty() && !existingStudents.isEmpty()) {
        Student__c studentToUpdate = existingStudents[0];
        Corporate_Client__c clientToAssign = existingClients[0];
        
        System.debug('🔗 Attempting to assign student ' + studentToUpdate.Name + ' to client ' + clientToAssign.Company_Name__c);
        System.debug('   Student ID: ' + studentToUpdate.Id);
        System.debug('   Client ID: ' + clientToAssign.Id);
        
        // Try to update the student
        studentToUpdate.Corporate_Client__c = clientToAssign.Id;
        studentToUpdate.Department__c = 'Updated Department';
        
        try {
            update studentToUpdate;
            System.debug('✅ Successfully updated student with client assignment');
            
            // Verify the update
            Student__c updatedStudent = [
                SELECT Id, Name, Department__c, Corporate_Client__c, Corporate_Client__r.Company_Name__c
                FROM Student__c 
                WHERE Id = :studentToUpdate.Id
            ];
            
            System.debug('🔍 Verification - Student: ' + updatedStudent.Name);
            System.debug('   Department: ' + updatedStudent.Department__c);
            System.debug('   Client ID: ' + updatedStudent.Corporate_Client__c);
            System.debug('   Client Name: ' + updatedStudent.Corporate_Client__r?.Company_Name__c);
            
        } catch (Exception updateError) {
            System.debug('❌ Error updating student: ' + updateError.getMessage());
            System.debug('❌ Stack trace: ' + updateError.getStackTraceString());
        }
    }
    
} catch (Exception e) {
    System.debug('❌ Error in debug script: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
