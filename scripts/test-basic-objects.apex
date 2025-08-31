// Test if the basic objects can be created
System.debug('Testing basic object creation...');

try {
    // Test Corporate_Client__c
    Corporate_Client__c client = new Corporate_Client__c();
    insert client;
    System.debug('Successfully created Corporate_Client__c: ' + client.Id + ' - Name: ' + client.Name);
    
    // Test Learning_Course__c
    Learning_Course__c course = new Learning_Course__c();
    insert course;
    System.debug('Successfully created Learning_Course__c: ' + course.Id + ' - Name: ' + course.Name);
    
    // Test Course_Enrollment__c
    Course_Enrollment__c enrollment = new Course_Enrollment__c();
    enrollment.Course__c = course.Id;
    enrollment.Student_Name__c = 'Test Student';
    enrollment.Student_Email__c = 'test@email.com';
    enrollment.Enrollment_Date__c = Date.today();
    enrollment.Status__c = 'Enrolled';
    enrollment.Progress_Percentage__c = 0;
    insert enrollment;
    System.debug('Successfully created Course_Enrollment__c: ' + enrollment.Id + ' - Name: ' + enrollment.Name);
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
