// Simple enrollment test with old fields
System.debug('Simple enrollment test with old fields...');

try {
    // Get existing student and course
    Student__c student = [SELECT Id, First_Name__c, Last_Name__c, Email__c FROM Student__c LIMIT 1];
    System.debug('Found student: ' + student.First_Name__c + ' ' + student.Last_Name__c);
    
    // Get existing course
    List<Learning_Course__c> courses = [SELECT Id FROM Learning_Course__c LIMIT 1];
    if (courses.isEmpty()) {
        System.debug('No courses found. Cannot create enrollment.');
        return;
    }
    
    Id courseId = courses[0].Id;
    System.debug('Using course: ' + courseId);
    
    // Create the enrollment with both new and old field structure
    Course_Enrollment__c enrollment = new Course_Enrollment__c(
        Student__c = student.Id,
        Course__c = courseId,
        Student_Name__c = student.First_Name__c + ' ' + student.Last_Name__c,
        Student_Email__c = student.Email__c
    );
    
    insert enrollment;
    System.debug('✅ Created enrollment: ' + enrollment.Id);
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
}
