// Test the relationship between students and course enrollments
System.debug('Testing student-enrollment relationship...');

try {
    // Get the students we just created
    List<Student__c> students = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        LIMIT 3
    ];
    
    System.debug('Found ' + students.size() + ' students:');
    for (Student__c student : students) {
        System.debug('Student: ' + student.Id + ' - ' + student.First_Name__c + ' ' + student.Last_Name__c);
    }
    
    // Get some courses
    List<Learning_Course__c> courses = [
        SELECT Id, Name 
        FROM Learning_Course__c 
        LIMIT 2
    ];
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Creating a sample course...');
        
        Learning_Course__c sampleCourse = new Learning_Course__c(
            Name = 'Introduction to Learning Management'
        );
        insert sampleCourse;
        courses.add(sampleCourse);
        System.debug('Created sample course: ' + sampleCourse.Name);
    }
    
    // Create a course enrollment linking a student to a course
    Course_Enrollment__c enrollment = new Course_Enrollment__c(
        Student__c = students[0].Id,
        Course__c = courses[0].Id
    );
    
    insert enrollment;
    
    System.debug('✅ Created enrollment: ' + enrollment.Id);
    
    // Now query the enrollment to see if the relationship works
    Course_Enrollment__c testEnrollment = [
        SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Student__r.Email__c, Course__c, Course__r.Name, CreatedDate
        FROM Course_Enrollment__c 
        WHERE Id = :enrollment.Id
    ];
    
    System.debug('=== Test Enrollment Query ===');
    System.debug('Enrollment ID: ' + testEnrollment.Name);
    System.debug('Student: ' + testEnrollment.Student__r.First_Name__c + ' ' + testEnrollment.Student__r.Last_Name__c);
    System.debug('Student Email: ' + testEnrollment.Student__r.Email__c);
    System.debug('Course: ' + testEnrollment.Course__r.Name);
    System.debug('Created: ' + testEnrollment.CreatedDate);
    
} catch (Exception e) {
    System.debug('❌ Error testing relationship: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
