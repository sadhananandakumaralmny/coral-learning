// Test Field Population Step by Step
System.debug('🧪 Testing Field Population Step by Step...');

try {
    // Step 1: Create a test corporate client
    System.debug('📋 Step 1: Creating test corporate client...');
    
    Corporate_Client__c testClient = new Corporate_Client__c(
        Company_Name__c = 'Test Company ABC',
        Company_Industry__c = 'Technology',
        Company_Size__c = '100-500',
        Status__c = 'Active'
    );
    
    insert testClient;
    System.debug('✅ Created test client:');
    System.debug('   ID: ' + testClient.Id);
    System.debug('   Company_Name__c: ' + testClient.Company_Name__c);
    System.debug('   Industry: ' + testClient.Company_Industry__c);
    
    // Step 2: Create a test student
    System.debug('📋 Step 2: Creating test student...');
    
    Student__c testStudent = new Student__c(
        First_Name__c = 'Test',
        Last_Name__c = 'Student',
        Department__c = 'Engineering',
        Email__c = 'test.student@test.com',
        Status__c = 'Active'
    );
    
    insert testStudent;
    System.debug('✅ Created test student:');
    System.debug('   ID: ' + testStudent.Id);
    System.debug('   Name: ' + testStudent.First_Name__c + ' ' + testStudent.Last_Name__c);
    System.debug('   Department: ' + testStudent.Department__c);
    System.debug('   Corporate_Client__c: ' + testStudent.Corporate_Client__c);
    
    // Step 3: Update student with client assignment
    System.debug('📋 Step 3: Assigning client to student...');
    
    testStudent.Corporate_Client__c = testClient.Id;
    testStudent.Department__c = 'Updated Engineering Department';
    
    update testStudent;
    System.debug('✅ Updated student with client assignment');
    
    // Step 4: Verify the update
    System.debug('📋 Step 4: Verifying the update...');
    
    Student__c updatedStudent = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Department__c, 
               Corporate_Client__c, Corporate_Client__r.Company_Name__c, Corporate_Client__r.Company_Industry__c
        FROM Student__c 
        WHERE Id = :testStudent.Id
    ];
    
    System.debug('🔍 Verification Results:');
    System.debug('   Student ID: ' + updatedStudent.Id);
    System.debug('   Student Name: ' + updatedStudent.Name);
    System.debug('   Department: ' + updatedStudent.Department__c);
    System.debug('   Corporate Client ID: ' + updatedStudent.Corporate_Client__c);
    System.debug('   Corporate Client Name: ' + updatedStudent.Corporate_Client__r?.Company_Name__c);
    System.debug('   Corporate Client Industry: ' + updatedStudent.Corporate_Client__r?.Company_Industry__c);
    
    // Step 5: Test querying the relationship
    System.debug('📋 Step 5: Testing relationship queries...');
    
    List<Student__c> studentsWithClients = [
        SELECT Id, Name, Department__c, 
               Corporate_Client__r.Company_Name__c, Corporate_Client__r.Company_Industry__c
        FROM Student__c 
        WHERE Corporate_Client__c = :testClient.Id
    ];
    
    System.debug('🔗 Students assigned to ' + testClient.Company_Name__c + ':');
    for (Student__c student : studentsWithClients) {
        System.debug('   👤 ' + student.Name + ' - ' + student.Department__c + ' → ' + 
                    student.Corporate_Client__r.Company_Name__c);
    }
    
    System.debug('🎉 Field population test completed successfully!');
    
} catch (Exception e) {
    System.debug('❌ Error in field population test: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
