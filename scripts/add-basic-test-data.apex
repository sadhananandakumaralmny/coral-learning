// Add basic test data using only existing fields
System.debug('🚀 Adding basic test data...');

try {
    // Step 1: Create more students
    System.debug('👥 Step 1: Creating more students...');
    
    List<Student__c> newStudents = new List<Student__c>();
    
    // Add more diverse students
    List<String> firstNames = new List<String>{'Alex', 'Maria', 'James', 'Sophia', 'Robert', 'Emma', 'William', 'Olivia', 'Christopher', 'Ava'};
    List<String> lastNames = new List<String>{'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall'};
    List<String> companies = new List<String>{'techcorp.com', 'innovatesoft.com', 'dataflow.com', 'cloudtech.com', 'digitalsolutions.com'};
    
    for (Integer i = 0; i < 10; i++) {
        Student__c student = new Student__c(
            First_Name__c = firstNames[i],
            Last_Name__c = lastNames[i],
            Email__c = firstNames[i].toLowerCase() + '.' + lastNames[i].toLowerCase() + '@' + companies[Math.mod(i, companies.size())]
        );
        newStudents.add(student);
    }
    
    insert newStudents;
    System.debug('✅ Created ' + newStudents.size() + ' new students');
    
    // Step 2: Create more courses (just basic ones)
    System.debug('📚 Step 2: Creating more courses...');
    
    List<Learning_Course__c> newCourses = new List<Learning_Course__c>();
    
    for (Integer i = 0; i < 10; i++) {
        Learning_Course__c course = new Learning_Course__c();
        newCourses.add(course);
    }
    
    insert newCourses;
    System.debug('✅ Created ' + newCourses.size() + ' new courses');
    
    // Step 3: Create more corporate clients (just basic ones)
    System.debug('🏢 Step 3: Creating more corporate clients...');
    
    List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();
    
    for (Integer i = 0; i < 10; i++) {
        Corporate_Client__c client = new Corporate_Client__c();
        newClients.add(client);
    }
    
    insert newClients;
    System.debug('✅ Created ' + newClients.size() + ' new corporate clients');
    
    // Step 4: Assign new students to clients
    System.debug('🔗 Step 4: Assigning new students to clients...');
    
    List<Student__c> allStudents = [SELECT Id, Corporate_Client__c FROM Student__c WHERE Corporate_Client__c = null];
    List<Corporate_Client__c> allClients = [SELECT Id FROM Corporate_Client__c];
    
    for (Integer i = 0; i < allStudents.size(); i++) {
        allStudents[i].Corporate_Client__c = allClients[Math.mod(i, allClients.size())].Id;
    }
    
    update allStudents;
    System.debug('✅ Assigned all students to corporate clients');
    
    // Step 5: Create enrollments
    System.debug('📚 Step 5: Creating enrollments...');
    
    List<Course_Enrollment__c> newEnrollments = new List<Course_Enrollment__c>();
    
    // Get all students and courses
    List<Student__c> allStudentsWithClients = [
        SELECT Id, First_Name__c, Last_Name__c, Email__c, Corporate_Client__c
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    List<Learning_Course__c> allCourses = [
        SELECT Id, Name
        FROM Learning_Course__c 
        ORDER BY Name
    ];
    
    // Create multiple enrollments per student
    for (Student__c student : allStudentsWithClients) {
        // Enroll each student in 2-4 courses
        Integer numEnrollments = Math.round(Math.random() * 3) + 2;
        
        for (Integer j = 0; j < numEnrollments; j++) {
            Learning_Course__c course = allCourses[Math.round(Math.random() * (allCourses.size() - 1))];
            
            Course_Enrollment__c enrollment = new Course_Enrollment__c(
                Student__c = student.Id,
                Course__c = course.Id,
                Student_Email__c = student.Email__c,
                Student_Name__c = student.First_Name__c + ' ' + student.Last_Name__c
            );
            
            newEnrollments.add(enrollment);
        }
    }
    
    insert newEnrollments;
    System.debug('✅ Created ' + newEnrollments.size() + ' new enrollments');
    
    // Step 6: Show final summary
    System.debug('📊 Step 6: Final data summary...');
    
    Integer totalStudents = [SELECT COUNT() FROM Student__c];
    Integer totalClients = [SELECT COUNT() FROM Corporate_Client__c];
    Integer totalCourses = [SELECT COUNT() FROM Learning_Course__c];
    Integer totalEnrollments = [SELECT COUNT() FROM Course_Enrollment__c];
    
    System.debug('=====================================');
    System.debug('🎯 FINAL DATA SUMMARY:');
    System.debug('   Total Students: ' + totalStudents);
    System.debug('   Total Corporate Clients: ' + totalClients);
    System.debug('   Total Learning Courses: ' + totalCourses);
    System.debug('   Total Course Enrollments: ' + totalEnrollments);
    System.debug('=====================================');
    
    // Step 7: Show sample enrollments with simulated progress
    System.debug('📚 Sample enrollments with simulated progress:');
    
    List<Course_Enrollment__c> sampleEnrollments = [
        SELECT Id, Name, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Course__r.Name, Student_Email__c, Student_Name__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
        LIMIT 20
    ];
    
    for (Course_Enrollment__c enrollment : sampleEnrollments) {
        // Simulate progress percentage (since we don't have the field yet)
        Integer simulatedProgress = Math.round(Math.random() * 100);
        String progressBar = createProgressBar(simulatedProgress);
        
        System.debug('📚 ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c + 
                    ' → ' + enrollment.Course__r.Name);
        System.debug('   Progress: ' + simulatedProgress + '% ' + progressBar);
        System.debug('   ---');
    }
    
    System.debug('🎉 Data enhancement completed successfully!');
    System.debug('💡 Note: Progress percentage is simulated since the field doesn\'t exist yet');
    System.debug('🔧 To add real progress tracking, create a Progress_Percentage__c field on Course_Enrollment__c');
    
} catch (Exception e) {
    System.debug('❌ Error enhancing data: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}

// Helper method to create a visual progress bar
private static String createProgressBar(Integer percentage) {
    Integer bars = Math.round(percentage / 10);
    String progressBar = '[';
    
    for (Integer i = 0; i < 10; i++) {
        if (i < bars) {
            progressBar += '█';
        } else {
            progressBar += '░';
        }
    }
    
    progressBar += ']';
    return progressBar;
}
