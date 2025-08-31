// Create simple course enrollments for students
System.debug('📚 Creating simple course enrollments for students...');

try {
    // Step 1: Get existing students and courses
    System.debug('📊 Step 1: Getting existing students and courses...');
    
    List<Student__c> students = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    List<Learning_Course__c> courses = [
        SELECT Id, Name
        FROM Learning_Course__c 
        ORDER BY Name
    ];
    
    System.debug('Found ' + students.size() + ' students and ' + courses.size() + ' courses');
    
    if (students.isEmpty() || courses.isEmpty()) {
        System.debug('❌ Need both students and courses to create enrollments');
        return;
    }
    
    // Step 2: Create simple course enrollments
    System.debug('📚 Step 2: Creating simple course enrollments...');
    
    List<Course_Enrollment__c> newEnrollments = new List<Course_Enrollment__c>();
    
    // Enroll each student in different courses
    for (Integer i = 0; i < students.size(); i++) {
        Student__c student = students[i];
        Learning_Course__c course = courses[Math.mod(i, courses.size())];
        
        // Create enrollment with only the fields we know exist
        Course_Enrollment__c enrollment = new Course_Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id,
            Student_Email__c = student.Email__c,
            Student_Name__c = student.First_Name__c + ' ' + student.Last_Name__c
        );
        
        newEnrollments.add(enrollment);
        
        System.debug('📚 Enrolling ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                    ' in course: ' + course.Name);
    }
    
    // Insert enrollments
    insert newEnrollments;
    System.debug('✅ Successfully created ' + newEnrollments.size() + ' course enrollments');
    
    // Step 3: Verify the results
    System.debug('🔍 Step 3: Verifying enrollments...');
    
    List<Course_Enrollment__c> finalEnrollments = [
        SELECT Id, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c,
               Course__c, Course__r.Name
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
    ];
    
    System.debug('📊 Final Enrollment Results:');
    System.debug('Total Enrollments: ' + finalEnrollments.size());
    
    for (Course_Enrollment__c enrollment : finalEnrollments) {
        System.debug('   📚 ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c + 
                    ' → ' + enrollment.Course__r.Name);
        System.debug('      ---');
    }
    
    System.debug('🎉 Simple course enrollment creation completed successfully!');
    
} catch (Exception e) {
    System.debug('❌ Error creating course enrollments: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
