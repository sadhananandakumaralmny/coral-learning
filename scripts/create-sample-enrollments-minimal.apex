// Minimal script to create sample Course Enrollments with required fields only
// Run this in Developer Console or via SFDX

try {
    // First, get existing courses
    List<Learning_Course__c> courses = [SELECT Id, Name FROM Learning_Course__c LIMIT 3];
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Please create courses first.');
        return;
    }
    
    // Create sample enrollments with just the required fields
    List<Course_Enrollment__c> enrollments = new List<Course_Enrollment__c>();
    
    for (Integer i = 0; i < 3; i++) {
        Course_Enrollment__c enrollment = new Course_Enrollment__c();
        enrollment.Student_Name__c = 'Student ' + (i + 1);
        enrollment.Student_Email__c = 'student' + (i + 1) + '@email.com';
        enrollment.Course__c = courses[Math.mod(i, courses.size())].Id;
        
        enrollments.add(enrollment);
    }
    
    // Insert enrollments
    insert enrollments;
    
    System.debug('Successfully created ' + enrollments.size() + ' course enrollments');
    
    // Display the created enrollments
    for(Course_Enrollment__c enrollment : enrollments) {
        System.debug('Enrollment: ' + enrollment.Name + ' - Student: ' + enrollment.Student_Name__c + ' - Course: ' + enrollment.Course__c);
    }
    
} catch (Exception e) {
    System.debug('Error creating enrollments: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Minimal enrollment creation script completed!');
