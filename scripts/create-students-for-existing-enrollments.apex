// Create students for existing enrollments
System.debug('Creating students for existing enrollments...');

try {
    // Get unique student names from existing enrollments
    List<AggregateResult> uniqueStudentNames = [
        SELECT Student_Name__c, Student_Email__c
        FROM Course_Enrollment__c 
        WHERE Student_Name__c != null 
        AND Student__c = null
        GROUP BY Student_Name__c, Student_Email__c
    ];
    
    System.debug('Found ' + uniqueStudentNames.size() + ' unique student names to create');
    
    if (uniqueStudentNames.isEmpty()) {
        System.debug('No new students to create.');
        return;
    }
    
    // Create students
    List<Student__c> newStudents = new List<Student__c>();
    
    for (AggregateResult ar : uniqueStudentNames) {
        String fullName = (String) ar.get('Student_Name__c');
        String email = (String) ar.get('Student_Email__c');
        
        // Split full name into first and last
        List<String> nameParts = fullName.split(' ', 2);
        String firstName = nameParts.size() > 0 ? nameParts[0] : fullName;
        String lastName = nameParts.size() > 1 ? nameParts[1] : '';
        
        // Generate email if none exists
        if (String.isBlank(email)) {
            email = firstName.toLowerCase() + '.' + lastName.toLowerCase() + '@example.com';
        }
        
        Student__c newStudent = new Student__c(
            First_Name__c = firstName,
            Last_Name__c = lastName,
            Email__c = email
        );
        
        newStudents.add(newStudent);
        
        System.debug('Creating student: ' + firstName + ' ' + lastName + ' (' + email + ')');
    }
    
    // Insert students
    insert newStudents;
    System.debug('✅ Successfully created ' + newStudents.size() + ' new students');
    
    // Now update enrollments to use these new students
    System.debug('Now updating enrollments to use new students...');
    
    // Get all enrollments that need updating
    List<Course_Enrollment__c> enrollmentsToUpdate = [
        SELECT Id, Name, Student_Name__c, Student_Email__c
        FROM Course_Enrollment__c 
        WHERE Student__c = null 
        AND Student_Name__c != null
    ];
    
    // Create a map for quick student lookup
    Map<String, Student__c> studentNameMap = new Map<String, Student__c>();
    for (Student__c student : newStudents) {
        String fullName = (student.First_Name__c + ' ' + student.Last_Name__c).toLowerCase().trim();
        studentNameMap.put(fullName, student);
    }
    
    // Update enrollments
    List<Course_Enrollment__c> updatedEnrollments = new List<Course_Enrollment__c>();
    
    for (Course_Enrollment__c enrollment : enrollmentsToUpdate) {
        String enrollmentStudentName = enrollment.Student_Name__c.toLowerCase().trim();
        
        if (studentNameMap.containsKey(enrollmentStudentName)) {
            Student__c matchingStudent = studentNameMap.get(enrollmentStudentName);
            enrollment.Student__c = matchingStudent.Id;
            updatedEnrollments.add(enrollment);
            
            System.debug('✅ Linking enrollment ' + enrollment.Name + ' to student: ' + 
                        matchingStudent.First_Name__c + ' ' + matchingStudent.Last_Name__c);
        }
    }
    
    // Update the enrollments
    if (!updatedEnrollments.isEmpty()) {
        update updatedEnrollments;
        System.debug('✅ Successfully updated ' + updatedEnrollments.size() + ' enrollments');
    }
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
