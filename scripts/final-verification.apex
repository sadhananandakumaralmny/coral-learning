// Final verification of complete student-client-course relationships
System.debug('🎯 Final verification of complete student-client-course relationships...');

try {
    // Get all students with their client and enrollment information
    List<Student__c> students = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Corporate_Client__c,
               Corporate_Client__r.Name,
               (SELECT Id, Name, Course__r.Name, Student_Email__c, Student_Name__c 
                FROM Course_Enrollments__r)
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    System.debug('📊 Complete Student-Client-Course Relationships:');
    System.debug('==================================================');
    
    for (Student__c student : students) {
        System.debug('👤 ' + student.First_Name__c + ' ' + student.Last_Name__c);
        System.debug('   Student ID: ' + student.Name);
        System.debug('   Email: ' + student.Email__c);
        
        if (student.Corporate_Client__c != null) {
            System.debug('   🏢 Corporate Client: ' + student.Corporate_Client__r.Name);
        } else {
            System.debug('   ❌ Corporate Client: NOT ASSIGNED');
        }
        
        if (!student.Course_Enrollments__r.isEmpty()) {
            System.debug('   📚 Course Enrollments:');
            for (Course_Enrollment__c enrollment : student.Course_Enrollments__r) {
                System.debug('      - ' + enrollment.Course__r.Name + ' (ID: ' + enrollment.Name + ')');
            }
        } else {
            System.debug('   📚 Course Enrollments: NONE');
        }
        
        System.debug('   ---');
    }
    
    // Summary counts
    Integer totalStudents = students.size();
    Integer studentsWithClients = 0;
    Integer studentsWithEnrollments = 0;
    Integer totalEnrollments = 0;
    
    for (Student__c student : students) {
        if (student.Corporate_Client__c != null) studentsWithClients++;
        if (!student.Course_Enrollments__r.isEmpty()) {
            studentsWithEnrollments++;
            totalEnrollments += student.Course_Enrollments__r.size();
        }
    }
    
    System.debug('==================================================');
    System.debug('📈 SUMMARY:');
    System.debug('   Total Students: ' + totalStudents);
    System.debug('   Students with Clients: ' + studentsWithClients + '/' + totalStudents);
    System.debug('   Students with Enrollments: ' + studentsWithEnrollments + '/' + totalStudents);
    System.debug('   Total Course Enrollments: ' + totalEnrollments);
    
    if (studentsWithClients == totalStudents) {
        System.debug('✅ SUCCESS: All students have corporate clients assigned!');
    } else {
        System.debug('⚠️  WARNING: Some students are missing corporate clients');
    }
    
    if (studentsWithEnrollments == totalStudents) {
        System.debug('✅ SUCCESS: All students are enrolled in courses!');
    } else {
        System.debug('⚠️  WARNING: Some students are not enrolled in courses');
    }
    
    System.debug('==================================================');
    System.debug('🎉 Final verification completed successfully!');
    
} catch (Exception e) {
    System.debug('❌ Error during final verification: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
