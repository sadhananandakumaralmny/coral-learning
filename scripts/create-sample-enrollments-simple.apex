// Simple script to create sample Course Enrollments with basic fields
// Run this in Developer Console or via SFDX

try {
    // First, get existing courses and clients
    List<Learning_Course__c> courses = [SELECT Id, Name FROM Learning_Course__c LIMIT 5];
    List<Corporate_Client__c> clients = [SELECT Id, Name FROM Corporate_Client__c LIMIT 3];
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Please create courses first.');
        return;
    }
    
    // Create sample enrollments with just the basic fields
    List<Course_Enrollment__c> enrollments = new List<Course_Enrollment__c>();
    
    for (Integer i = 0; i < 5; i++) {
        Course_Enrollment__c enrollment = new Course_Enrollment__c();
        enrollment.Course__c = courses[Math.mod(i, courses.size())].Id;
        
        // Only set fields that are working
        enrollments.add(enrollment);
    }
    
    // Insert enrollments
    insert enrollments;
    
    System.debug('Successfully created ' + enrollments.size() + ' course enrollments');
    
    // Display the created enrollments
    for(Course_Enrollment__c enrollment : enrollments) {
        System.debug('Enrollment: ' + enrollment.Name + ' - Course: ' + enrollment.Course__c);
    }
    
} catch (Exception e) {
    System.debug('Error creating enrollments: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Simple enrollment creation script completed!');
