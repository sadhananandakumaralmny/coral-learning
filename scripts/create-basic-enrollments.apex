// Create basic course enrollments with confirmed working fields
System.debug('Creating basic course enrollments...');

try {
    // First, get existing courses
    List<Learning_Course__c> courses = [SELECT Id, Name FROM Learning_Course__c LIMIT 5];
    
    System.debug('Found ' + courses.size() + ' courses');
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Creating some basic courses first...');
        // Create some basic courses
        List<Learning_Course__c> newCourses = new List<Learning_Course__c>();
        for (Integer i = 0; i < 5; i++) {
            Learning_Course__c course = new Learning_Course__c();
            newCourses.add(course);
        }
        insert newCourses;
        courses = newCourses;
        System.debug('Created ' + courses.size() + ' new courses');
    }
    
    // Create sample enrollments
    List<Course_Enrollment__c> enrollments = new List<Course_Enrollment__c>();
    
    // Sample student data
    List<String> studentNames = new List<String>{
        'Alice Johnson', 'Bob Smith', 'Carol Davis', 'David Wilson', 'Eva Brown',
        'Frank Miller', 'Grace Lee', 'Henry Taylor', 'Ivy Chen', 'Jack Anderson'
    };
    
    List<String> studentEmails = new List<String>{
        'alice.johnson@email.com', 'bob.smith@email.com', 'carol.davis@email.com',
        'david.wilson@email.com', 'eva.brown@email.com', 'frank.miller@email.com',
        'grace.lee@email.com', 'henry.taylor@email.com', 'ivy.chen@email.com',
        'jack.anderson@email.com'
    };
    
    // Create enrollments with only working fields
    for (Integer i = 0; i < 12; i++) {
        Course_Enrollment__c enrollment = new Course_Enrollment__c();
        
        // Assign course (this field is confirmed working)
        enrollment.Course__c = courses[Math.mod(i, courses.size())].Id;
        
        // Student details (these fields are confirmed working)
        enrollment.Student_Name__c = studentNames[Math.mod(i, studentNames.size())];
        enrollment.Student_Email__c = studentEmails[Math.mod(i, studentEmails.size())];
        
        enrollments.add(enrollment);
    }
    
    // Insert enrollments
    insert enrollments;
    System.debug('Successfully created ' + enrollments.size() + ' course enrollments');
    
    // Display some details
    for (Course_Enrollment__c e : enrollments) {
        System.debug('Created enrollment: ' + e.Name + ' for ' + e.Student_Name__c + ' in course ' + e.Course__c);
    }
    
} catch (Exception e) {
    System.debug('Error creating enrollments: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
