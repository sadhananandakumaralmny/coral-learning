// Test enrollment display and data structure
System.debug('Testing enrollment display...');

try {
    // Query enrollments with related objects
    List<Course_Enrollment__c> enrollments = [
        SELECT Id, Name, Student_Name__c, Student_Email__c, Student_Phone__c, 
               Course__c, Course__r.Name, Enrollment_Date__c, Completion_Date__c,
               Status__c, Progress_Percentage__c, Certificate_Issued__c,
               Corporate_Client__c, Corporate_Client__r.Name, CreatedDate
        FROM Course_Enrollment__c 
        ORDER BY CreatedDate DESC
        LIMIT 5
    ];
    
    System.debug('Found ' + enrollments.size() + ' enrollments');
    
    for (Course_Enrollment__c e : enrollments) {
        System.debug('=== Enrollment: ' + e.Name + ' ===');
        System.debug('Student: ' + e.Student_Name__c);
        System.debug('Email: ' + e.Student_Email__c);
        System.debug('Course: ' + (e.Course__r != null ? e.Course__r.Name : 'NULL'));
        System.debug('Client: ' + (e.Corporate_Client__r != null ? e.Corporate_Client__r.Name : 'NULL'));
        System.debug('Status: ' + e.Status__c);
        System.debug('Progress: ' + e.Progress_Percentage__c + '%');
        System.debug('---');
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
