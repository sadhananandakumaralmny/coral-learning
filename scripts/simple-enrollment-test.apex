// Simple enrollment test
System.debug('Simple enrollment test...');

try {
    // Get existing student and course
    Student__c student = [SELECT Id FROM Student__c LIMIT 1];
    System.debug('Found student: ' + student.Id);
    
    // Try to create enrollment with just the required fields
    Course_Enrollment__c enrollment = new Course_Enrollment__c(
        Student__c = student.Id
    );
    
    insert enrollment;
    System.debug('✅ Created enrollment: ' + enrollment.Id);
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
}
