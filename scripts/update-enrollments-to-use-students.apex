// Update existing enrollments to use the new Student__c relationship
System.debug('Updating enrollments to use new Student__c relationship...');

try {
    // Get all enrollments that don't have Student__c populated but have Student_Name__c
    List<Course_Enrollment__c> enrollmentsToUpdate = [
        SELECT Id, Name, Student_Name__c, Student_Email__c, Student__c
        FROM Course_Enrollment__c 
        WHERE Student__c = null 
        AND Student_Name__c != null
        LIMIT 100
    ];
    
    System.debug('Found ' + enrollmentsToUpdate.size() + ' enrollments to update');
    
    if (enrollmentsToUpdate.isEmpty()) {
        System.debug('No enrollments need updating. All enrollments already use the new Student__c relationship.');
        return;
    }
    
    // Get all students to match by name
    List<Student__c> allStudents = [
        SELECT Id, First_Name__c, Last_Name__c, Email__c
        FROM Student__c
    ];
    
    System.debug('Found ' + allStudents.size() + ' students to match against');
    
    // Create a map for quick student lookup by full name
    Map<String, Student__c> studentNameMap = new Map<String, Student__c>();
    for (Student__c student : allStudents) {
        String fullName = (student.First_Name__c + ' ' + student.Last_Name__c).toLowerCase().trim();
        studentNameMap.put(fullName, student);
    }
    
    // Update enrollments
    List<Course_Enrollment__c> updatedEnrollments = new List<Course_Enrollment__c>();
    Integer updatedCount = 0;
    Integer skippedCount = 0;
    
    for (Course_Enrollment__c enrollment : enrollmentsToUpdate) {
        String enrollmentStudentName = enrollment.Student_Name__c.toLowerCase().trim();
        
        if (studentNameMap.containsKey(enrollmentStudentName)) {
            Student__c matchingStudent = studentNameMap.get(enrollmentStudentName);
            enrollment.Student__c = matchingStudent.Id;
            updatedEnrollments.add(enrollment);
            updatedCount++;
            
            System.debug('✅ Matched enrollment ' + enrollment.Name + ' to student: ' + 
                        matchingStudent.First_Name__c + ' ' + matchingStudent.Last_Name__c);
        } else {
            System.debug('⚠️  No student match found for: ' + enrollment.Student_Name__c);
            skippedCount++;
        }
    }
    
    // Update the enrollments
    if (!updatedEnrollments.isEmpty()) {
        update updatedEnrollments;
        System.debug('✅ Successfully updated ' + updatedCount + ' enrollments');
    }
    
    System.debug('📊 Summary:');
    System.debug('  - Total enrollments processed: ' + enrollmentsToUpdate.size());
    System.debug('  - Successfully updated: ' + updatedCount);
    System.debug('  - Skipped (no match): ' + skippedCount);
    
} catch (Exception e) {
    System.debug('❌ Error updating enrollments: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
