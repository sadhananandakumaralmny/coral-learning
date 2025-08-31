// Create sample course enrollments using the new Student object structure
System.debug('Creating sample course enrollments with students...');

try {
    // Get existing students
    List<Student__c> students = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        LIMIT 5
    ];
    
    if (students.isEmpty()) {
        System.debug('No students found. Please run the create-sample-students.apex script first.');
        return;
    }
    
    // Get existing courses
    List<Learning_Course__c> courses = [
        SELECT Id, Name 
        FROM Learning_Course__c 
        LIMIT 3
    ];
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Please create some courses first.');
        return;
    }
    
    System.debug('Found ' + students.size() + ' students and ' + courses.size() + ' courses');
    
    // Create sample enrollments
    List<Course_Enrollment__c> enrollments = new List<Course_Enrollment__c>();
    
    // Enroll each student in different courses
    for (Integer i = 0; i < students.size(); i++) {
        Student__c student = students[i];
        Learning_Course__c course = courses[Math.mod(i, courses.size())];
        
        Course_Enrollment__c enrollment = new Course_Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id
        );
        
        enrollments.add(enrollment);
        
        System.debug('Creating enrollment: ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                    ' -> ' + course.Name);
    }
    
    // Insert all enrollments
    insert enrollments;
    
    System.debug('✅ Successfully created ' + enrollments.size() + ' course enrollments:');
    
    // Query and display the created enrollments with related data
    List<Course_Enrollment__c> createdEnrollments = [
        SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Student__r.Email__c, Course__c, Course__r.Name, CreatedDate
        FROM Course_Enrollment__c 
        WHERE Id IN :enrollments
        ORDER BY CreatedDate DESC
    ];
    
    for (Course_Enrollment__c enrollment : createdEnrollments) {
        System.debug('=== Enrollment: ' + enrollment.Name + ' ===');
        System.debug('Student: ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c);
        System.debug('Email: ' + enrollment.Student__r.Email__c);
        System.debug('Course: ' + enrollment.Course__r.Name);
        System.debug('Created: ' + enrollment.CreatedDate);
        System.debug('---');
    }
    
} catch (Exception e) {
    System.debug('❌ Error creating course enrollments: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
