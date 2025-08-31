// Test enrollment creation with Course and Student fields
System.debug('Testing enrollment creation...');

try {
    // Get the first student
    Student__c student = [SELECT Id, First_Name__c, Last_Name__c FROM Student__c LIMIT 1];
    System.debug('Using student: ' + student.First_Name__c + ' ' + student.Last_Name__c);
    
    // Create a simple course if none exist
    List<Learning_Course__c> courses = [SELECT Id, Name FROM Learning_Course__c LIMIT 1];
    Id courseId;
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Creating a sample course...');
        Learning_Course__c newCourse = new Learning_Course__c();
        newCourse.Name = 'Test Course';
        insert newCourse;
        courseId = newCourse.Id;
        System.debug('Created course: ' + newCourse.Id);
    } else {
        courseId = courses[0].Id;
        System.debug('Using existing course: ' + courses[0].Id);
    }
    
    // Create the enrollment
    Course_Enrollment__c enrollment = new Course_Enrollment__c(
        Student__c = student.Id,
        Course__c = courseId
    );
    
    insert enrollment;
    System.debug('✅ Created enrollment: ' + enrollment.Id);
    
    // Query it back to verify the relationship
    Course_Enrollment__c testEnrollment = [
        SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c,
               Course__c, Course__r.Name
        FROM Course_Enrollment__c 
        WHERE Id = :enrollment.Id
    ];
    
    System.debug('=== Enrollment Details ===');
    System.debug('ID: ' + testEnrollment.Name);
    System.debug('Student: ' + testEnrollment.Student__r.First_Name__c + ' ' + testEnrollment.Student__r.Last_Name__c);
    System.debug('Course: ' + testEnrollment.Course__r.Name);
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
