// Create course enrollments with working fields
System.debug('Creating course enrollments...');

try {
    // First, get existing courses and clients
    List<Learning_Course__c> courses = [SELECT Id, Name FROM Learning_Course__c LIMIT 5];
    List<Corporate_Client__c> clients = [SELECT Id, Name FROM Corporate_Client__c LIMIT 3];
    
    System.debug('Found ' + courses.size() + ' courses and ' + clients.size() + ' clients');
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Creating some basic courses first...');
        // Create some basic courses
        List<Learning_Course__c> newCourses = new List<Learning_Course__c>();
        for (Integer i = 0; i < 3; i++) {
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
    
    // Create enrollments
    for (Integer i = 0; i < 12; i++) {
        Course_Enrollment__c enrollment = new Course_Enrollment__c();
        
        // Assign course
        enrollment.Course__c = courses[Math.mod(i, courses.size())].Id;
        
        // Student details
        enrollment.Student_Name__c = studentNames[Math.mod(i, studentNames.size())];
        enrollment.Student_Email__c = studentEmails[Math.mod(i, studentEmails.size())];
        
        // Try to assign corporate client if available
        if (!clients.isEmpty()) {
            enrollment.Corporate_Client__c = clients[Math.mod(i, clients.size())].Id;
        }
        
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
