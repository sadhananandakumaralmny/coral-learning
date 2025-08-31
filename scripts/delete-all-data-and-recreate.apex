// Delete all data and recreate (handling dependencies correctly)
System.debug('🗑️  Starting complete data deletion and recreation process...');

try {
    // Step 1: Check existing data
    System.debug('📊 Step 1: Checking existing data...');
    
    Integer totalEnrollments = [SELECT COUNT() FROM Course_Enrollment__c];
    Integer totalStudents = [SELECT COUNT() FROM Student__c];
    Integer totalClients = [SELECT COUNT() FROM Corporate_Client__c];
    Integer totalCourses = [SELECT COUNT() FROM Learning_Course__c];
    
    System.debug('Found:');
    System.debug('   - Course Enrollments: ' + totalEnrollments);
    System.debug('   - Students: ' + totalStudents);
    System.debug('   - Corporate Clients: ' + totalClients);
    System.debug('   - Learning Courses: ' + totalCourses);
    
    // Step 2: Delete data in correct order (respecting dependencies)
    System.debug('🗑️  Step 2: Deleting data in dependency order...');
    
    // 2a: Delete course enrollments first (they reference students and courses)
    if (totalEnrollments > 0) {
        System.debug('🗑️  Deleting ' + totalEnrollments + ' course enrollments...');
        List<Course_Enrollment__c> enrollmentsToDelete = [SELECT Id FROM Course_Enrollment__c];
        delete enrollmentsToDelete;
        System.debug('✅ Successfully deleted all course enrollments');
    }
    
    // 2b: Delete students
    if (totalStudents > 0) {
        System.debug('🗑️  Deleting ' + totalStudents + ' students...');
        List<Student__c> studentsToDelete = [SELECT Id FROM Student__c];
        delete studentsToDelete;
        System.debug('✅ Successfully deleted all students');
    }
    
    // 2c: Delete learning courses
    if (totalCourses > 0) {
        System.debug('🗑️  Deleting ' + totalCourses + ' learning courses...');
        List<Learning_Course__c> coursesToDelete = [SELECT Id FROM Learning_Course__c];
        delete coursesToDelete;
        System.debug('✅ Successfully deleted all learning courses');
    }
    
    // 2d: Delete corporate clients
    if (totalClients > 0) {
        System.debug('🗑️  Deleting ' + totalClients + ' corporate clients...');
        List<Corporate_Client__c> clientsToDelete = [SELECT Id FROM Corporate_Client__c];
        delete clientsToDelete;
        System.debug('✅ Successfully deleted all corporate clients');
    }
    
    System.debug('✅ All existing data has been deleted');
    
    // Step 3: Create new corporate clients
    System.debug('🏢 Step 3: Creating new corporate clients...');
    
    List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();
    
    // Create 3 clients (Name field will be auto-generated)
    for (Integer i = 0; i < 3; i++) {
        newClients.add(new Corporate_Client__c());
    }
    
    insert newClients;
    System.debug('✅ Created ' + newClients.size() + ' new corporate clients');
    
    // Show the generated names
    for (Corporate_Client__c client : newClients) {
        System.debug('   - Created client: ' + client.Name + ' (ID: ' + client.Id + ')');
    }
    
    // Step 4: Create new students
    System.debug('👥 Step 4: Creating new students...');
    
    List<Student__c> newStudents = new List<Student__c>();
    
    // Student 1
    newStudents.add(new Student__c(
        First_Name__c = 'John',
        Last_Name__c = 'Smith',
        Email__c = 'john.smith@techcorp.com'
    ));
    
    // Student 2
    newStudents.add(new Student__c(
        First_Name__c = 'Sarah',
        Last_Name__c = 'Johnson',
        Email__c = 'sarah.johnson@innovatesoft.com'
    ));
    
    // Student 3
    newStudents.add(new Student__c(
        First_Name__c = 'Michael',
        Last_Name__c = 'Chen',
        Email__c = 'michael.chen@dataflow.com'
    ));
    
    // Student 4
    newStudents.add(new Student__c(
        First_Name__c = 'Emily',
        Last_Name__c = 'Davis',
        Email__c = 'emily.davis@techcorp.com'
    ));
    
    // Student 5
    newStudents.add(new Student__c(
        First_Name__c = 'David',
        Last_Name__c = 'Wilson',
        Email__c = 'david.wilson@innovatesoft.com'
    ));
    
    // Student 6
    newStudents.add(new Student__c(
        First_Name__c = 'Lisa',
        Last_Name__c = 'Brown',
        Email__c = 'lisa.brown@dataflow.com'
    ));
    
    insert newStudents;
    System.debug('✅ Successfully created ' + newStudents.size() + ' new students');
    
    // Step 5: Create new learning courses
    System.debug('📚 Step 5: Creating new learning courses...');
    
    List<Learning_Course__c> newCourses = new List<Learning_Course__c>();
    
    // Create 3 courses (Name field will be auto-generated)
    for (Integer i = 0; i < 3; i++) {
        newCourses.add(new Learning_Course__c());
    }
    
    insert newCourses;
    System.debug('✅ Successfully created ' + newCourses.size() + ' new learning courses');
    
    // Show the generated names
    for (Learning_Course__c course : newCourses) {
        System.debug('   - Created course: ' + course.Name + ' (ID: ' + course.Id + ')');
    }
    
    // Step 6: Note about client assignment
    System.debug('⚠️  Step 6: Client assignment skipped');
    System.debug('⚠️  The Corporate_Client__c lookup field is not available in the org');
    System.debug('⚠️  Students cannot be assigned to clients until this field is properly deployed');
    
    // Step 7: Verify the results
    System.debug('🔍 Step 7: Verifying results...');
    
    List<Student__c> finalStudents = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    List<Corporate_Client__c> finalClients = [
        SELECT Id, Name
        FROM Corporate_Client__c 
        ORDER BY Name
    ];
    
    List<Learning_Course__c> finalCourses = [
        SELECT Id, Name
        FROM Learning_Course__c 
        ORDER BY Name
    ];
    
    System.debug('📊 Final Results:');
    System.debug('Total Students: ' + finalStudents.size());
    System.debug('Total Corporate Clients: ' + finalClients.size());
    System.debug('Total Learning Courses: ' + finalCourses.size());
    
    System.debug('👥 Student Details:');
    for (Student__c student : finalStudents) {
        System.debug('   - ' + student.First_Name__c + ' ' + student.Last_Name__c + ' - ' + student.Email__c);
        System.debug('     Student ID: ' + student.Name);
    }
    
    System.debug('🏢 Corporate Client Details:');
    for (Corporate_Client__c client : finalClients) {
        System.debug('   - ' + client.Name + ' (ID: ' + client.Id + ')');
    }
    
    System.debug('📚 Learning Course Details:');
    for (Learning_Course__c course : finalCourses) {
        System.debug('   - ' + course.Name + ' (ID: ' + course.Id + ')');
    }
    
    System.debug('🎉 Complete data deletion and recreation process completed successfully!');
    System.debug('⚠️  IMPORTANT: Students are NOT assigned to clients because the Corporate_Client__c field is missing');
    System.debug('💡 To fix this, the custom fields need to be properly deployed to the org');
    
} catch (Exception e) {
    System.debug('❌ Error in data deletion and recreation process: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
