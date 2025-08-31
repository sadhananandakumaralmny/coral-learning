// Create course enrollments for students
System.debug('📚 Creating course enrollments for students...');

try {
    // Step 1: Get existing students and courses
    System.debug('📊 Step 1: Getting existing students and courses...');
    
    List<Student__c> students = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    List<Learning_Course__c> courses = [
        SELECT Id, Name
        FROM Learning_Course__c 
        ORDER BY Name
    ];
    
    System.debug('Found ' + students.size() + ' students and ' + courses.size() + ' courses');
    
    if (students.isEmpty() || courses.isEmpty()) {
        System.debug('❌ Need both students and courses to create enrollments');
        return;
    }
    
    // Step 2: Create course enrollments
    System.debug('📚 Step 2: Creating course enrollments...');
    
    List<Course_Enrollment__c> newEnrollments = new List<Course_Enrollment__c>();
    
    // Enroll each student in different courses
    for (Integer i = 0; i < students.size(); i++) {
        Student__c student = students[i];
        Learning_Course__c course = courses[Math.mod(i, courses.size())];
        
        // Create enrollment
        Course_Enrollment__c enrollment = new Course_Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Active',
            Progress_Percentage__c = Math.random() * 100
        );
        
        newEnrollments.add(enrollment);
        
        System.debug('📚 Enrolling ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                    ' in course: ' + course.Name);
    }
    
    // Insert enrollments
    insert newEnrollments;
    System.debug('✅ Successfully created ' + newEnrollments.size() + ' course enrollments');
    
    // Step 3: Verify the results
    System.debug('🔍 Step 3: Verifying enrollments...');
    
    List<Course_Enrollment__c> finalEnrollments = [
        SELECT Id, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c,
               Course__c, Course__r.Name, Status__c, Progress_Percentage__c, Enrollment_Date__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
    ];
    
    System.debug('📊 Final Enrollment Results:');
    System.debug('Total Enrollments: ' + finalEnrollments.size());
    
    for (Course_Enrollment__c enrollment : finalEnrollments) {
        System.debug('   📚 ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c + 
                    ' → ' + enrollment.Course__r.Name);
        System.debug('      Status: ' + enrollment.Status__c + 
                    ', Progress: ' + enrollment.Progress_Percentage__c + '%' +
                    ', Date: ' + enrollment.Enrollment_Date__c);
        System.debug('      ---');
    }
    
    // Step 4: Check if we can assign corporate clients
    System.debug('🔍 Step 4: Checking corporate client assignment capability...');
    
    try {
        // Try to query the Corporate_Client__c field
        List<Student__c> testQuery = [
            SELECT Id, Corporate_Client__c
            FROM Student__c 
            LIMIT 1
        ];
        System.debug('✅ Corporate_Client__c field EXISTS - students can be assigned to clients');
        
        // Try to assign students to clients
        System.debug('🔗 Attempting to assign students to corporate clients...');
        
        List<Corporate_Client__c> clients = [SELECT Id, Name FROM Corporate_Client__c];
        
        if (!clients.isEmpty()) {
            List<Student__c> studentsToUpdate = new List<Student__c>();
            
            for (Integer i = 0; i < students.size(); i++) {
                Student__c student = students[i];
                Corporate_Client__c client = clients[Math.mod(i, clients.size())];
                
                student.Corporate_Client__c = client.Id;
                studentsToUpdate.add(student);
                
                System.debug('🔗 Assigning ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                            ' to client: ' + client.Name);
            }
            
            update studentsToUpdate;
            System.debug('✅ Successfully assigned students to corporate clients');
            
        } else {
            System.debug('⚠️  No corporate clients available for assignment');
        }
        
    } catch (Exception fieldError) {
        System.debug('❌ Corporate_Client__c field does NOT exist - students cannot be assigned to clients');
        System.debug('Error: ' + fieldError.getMessage());
    }
    
    System.debug('🎉 Course enrollment creation completed successfully!');
    
} catch (Exception e) {
    System.debug('❌ Error creating course enrollments: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
