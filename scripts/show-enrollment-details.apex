// Show detailed enrollment information
System.debug('📚 Showing detailed enrollment information...');

try {
    // Get all enrollments with student and course details
    List<Course_Enrollment__c> enrollments = [
        SELECT Id, Name, 
               Student__c, Student__r.Name, Student__r.First_Name__c, Student__r.Last_Name__c, Student__r.Email__c,
               Course__c, Course__r.Name,
               Student_Email__c, Student_Name__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
    ];
    
    System.debug('📊 Enrollment Details:');
    System.debug('=====================================');
    System.debug('Total Enrollments: ' + enrollments.size());
    System.debug('=====================================');
    
    for (Course_Enrollment__c enrollment : enrollments) {
        System.debug('📚 Enrollment: ' + enrollment.Name);
        System.debug('   Student: ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c);
        System.debug('   Student ID: ' + enrollment.Student__r.Name);
        System.debug('   Student Email: ' + enrollment.Student__r.Email__c);
        System.debug('   Course: ' + enrollment.Course__r.Name);
        System.debug('   Course ID: ' + enrollment.Course__r.Name);
        System.debug('   Stored Email: ' + enrollment.Student_Email__c);
        System.debug('   Stored Name: ' + enrollment.Student_Name__c);
        System.debug('   ---');
    }
    
    System.debug('=====================================');
    System.debug('✅ Enrollment details displayed successfully');
    
} catch (Exception e) {
    System.debug('❌ Error showing enrollment details: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
