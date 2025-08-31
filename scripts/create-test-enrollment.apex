// Create a test enrollment to verify the student relationship works
System.debug('Creating test enrollment...');

try {
    // Get the first student
    Student__c student = [SELECT Id, First_Name__c, Last_Name__c FROM Student__c LIMIT 1];
    System.debug('Using student: ' + student.First_Name__c + ' ' + student.Last_Name__c);
    
    // Create a simple course enrollment
    Course_Enrollment__c enrollment = new Course_Enrollment__c(
        Student__c = student.Id
    );
    
    insert enrollment;
    System.debug('✅ Created enrollment: ' + enrollment.Id);
    
    // Now query it back to see if the relationship works
    Course_Enrollment__c testEnrollment = [
        SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c
        FROM Course_Enrollment__c 
        WHERE Id = :enrollment.Id
    ];
    
    System.debug('=== Test Query Result ===');
    System.debug('Enrollment: ' + testEnrollment.Name);
    System.debug('Student: ' + testEnrollment.Student__r.First_Name__c + ' ' + testEnrollment.Student__r.Last_Name__c);
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
}
