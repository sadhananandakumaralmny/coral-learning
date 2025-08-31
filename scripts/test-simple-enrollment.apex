// Test simple enrollment display
System.debug('Testing simple enrollment display...');

try {
    // Query enrollments with only existing fields
    List<Course_Enrollment__c> enrollments = [
        SELECT Id, Name, Student_Name__c, Student_Email__c, 
               Course__c, Course__r.Name, CreatedDate
        FROM Course_Enrollment__c 
        ORDER BY CreatedDate DESC
        LIMIT 3
    ];
    
    System.debug('Found ' + enrollments.size() + ' enrollments');
    
    for (Course_Enrollment__c e : enrollments) {
        System.debug('=== Enrollment: ' + e.Name + ' ===');
        System.debug('Student: ' + e.Student_Name__c);
        System.debug('Email: ' + e.Student_Email__c);
        System.debug('Course: ' + (e.Course__r != null ? e.Course__r.Name : 'NULL'));
        System.debug('Created: ' + e.CreatedDate);
        System.debug('---');
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
