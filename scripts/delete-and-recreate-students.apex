// Delete all student records and recreate them
System.debug('🗑️  Starting student deletion and recreation process...');

try {
    // Step 1: Check existing students
    System.debug('📊 Step 1: Checking existing students...');
    List<Student__c> existingStudents = [SELECT Id, Name, First_Name__c, Last_Name__c FROM Student__c];
    System.debug('Found ' + existingStudents.size() + ' existing students');
    
    if (!existingStudents.isEmpty()) {
        // Step 2: Delete all existing students
        System.debug('🗑️  Step 2: Deleting ' + existingStudents.size() + ' existing students...');
        delete existingStudents;
        System.debug('✅ Successfully deleted all existing students');
    } else {
        System.debug('ℹ️  No existing students to delete');
    }
    
    // Step 3: Check if we have corporate clients
    System.debug('🏢 Step 3: Checking corporate clients...');
    List<Corporate_Client__c> existingClients = [SELECT Id, Name FROM Corporate_Client__c];
    System.debug('Found ' + existingClients.size() + ' existing clients');
    
    // Step 4: Create new corporate clients if none exist
    if (existingClients.isEmpty()) {
        System.debug('🏢 Step 4: Creating sample corporate clients...');
        
        List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();
        
        // Create clients (Name field will be auto-generated)
        newClients.add(new Corporate_Client__c());
        newClients.add(new Corporate_Client__c());
        newClients.add(new Corporate_Client__c());
        
        insert newClients;
        existingClients = newClients;
        System.debug('✅ Created ' + newClients.size() + ' new corporate clients');
        
        // Show the generated names
        for (Corporate_Client__c client : existingClients) {
            System.debug('   - Created client: ' + client.Name + ' (ID: ' + client.Id + ')');
        }
    }
    
    // Step 5: Create new students
    System.debug('👥 Step 5: Creating new students...');
    
    List<Student__c> newStudents = new List<Student__c>();
    
    // Student 1
    newStudents.add(new Student__c(
        First_Name__c = 'John',
        Last_Name__c = 'Smith',
        Email__c = 'john.smith@techcorp.com',
        Phone__c = '+1-555-0101',
        Department__c = 'Engineering',
        Job_Title__c = 'Software Developer',
        Status__c = 'Active'
    ));
    
    // Student 2
    newStudents.add(new Student__c(
        First_Name__c = 'Sarah',
        Last_Name__c = 'Johnson',
        Email__c = 'sarah.johnson@innovatesoft.com',
        Phone__c = '+1-555-0102',
        Department__c = 'Product Management',
        Job_Title__c = 'Product Manager',
        Status__c = 'Active'
    ));
    
    // Student 3
    newStudents.add(new Student__c(
        First_Name__c = 'Michael',
        Last_Name__c = 'Chen',
        Email__c = 'michael.chen@dataflow.com',
        Phone__c = '+1-555-0103',
        Department__c = 'Design',
        Job_Title__c = 'UX Designer',
        Status__c = 'Active'
    ));
    
    // Student 4
    newStudents.add(new Student__c(
        First_Name__c = 'Emily',
        Last_Name__c = 'Davis',
        Email__c = 'emily.davis@techcorp.com',
        Phone__c = '+1-555-0104',
        Department__c = 'Marketing',
        Job_Title__c = 'Marketing Specialist',
        Status__c = 'Active'
    ));
    
    // Student 5
    newStudents.add(new Student__c(
        First_Name__c = 'David',
        Last_Name__c = 'Wilson',
        Email__c = 'david.wilson@innovatesoft.com',
        Phone__c = '+1-555-0105',
        Department__c = 'Sales',
        Job_Title__c = 'Sales Representative',
        Status__c = 'Active'
    ));
    
    // Student 6
    newStudents.add(new Student__c(
        First_Name__c = 'Lisa',
        Last_Name__c = 'Brown',
        Email__c = 'lisa.brown@dataflow.com',
        Phone__c = '+1-555-0106',
        Department__c = 'Human Resources',
        Job_Title__c = 'HR Coordinator',
        Status__c = 'Active'
    ));
    
    // Insert all students
    insert newStudents;
    System.debug('✅ Successfully created ' + newStudents.size() + ' new students');
    
    // Step 6: Note about client assignment
    System.debug('⚠️  Step 6: Client assignment skipped');
    System.debug('⚠️  The Corporate_Client__c lookup field is not available in the org');
    System.debug('⚠️  Students cannot be assigned to clients until this field is properly deployed');
    
    // Step 7: Verify the results
    System.debug('🔍 Step 7: Verifying results...');
    
    List<Student__c> finalStudents = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Department__c, Job_Title__c, Status__c
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    System.debug('📊 Final Results:');
    System.debug('Total Students: ' + finalStudents.size());
    System.debug('Total Corporate Clients: ' + existingClients.size());
    
    System.debug('👥 Student Details:');
    for (Student__c student : finalStudents) {
        System.debug('   - ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                    ' (' + student.Department__c + ') - ' + student.Email__c);
        System.debug('     Student ID: ' + student.Name + ', Status: ' + student.Status__c);
    }
    
    System.debug('🏢 Corporate Client Details:');
    for (Corporate_Client__c client : existingClients) {
        System.debug('   - ' + client.Name + ' (ID: ' + client.Id + ')');
    }
    
    System.debug('🎉 Student deletion and recreation process completed successfully!');
    System.debug('⚠️  IMPORTANT: Students are NOT assigned to clients because the Corporate_Client__c field is missing');
    System.debug('💡 To fix this, the custom fields need to be properly deployed to the org');
    
} catch (Exception e) {
    System.debug('❌ Error in student deletion and recreation process: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
