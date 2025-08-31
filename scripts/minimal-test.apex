// Minimal test to create a Learning_Course__c record
System.debug('Starting minimal test...');

try {
    // Try to create a record with minimal fields
    Learning_Course__c testCourse = new Learning_Course__c();
    insert testCourse;
    System.debug('Successfully created course with ID: ' + testCourse.Id);
    
    // Query it back
    Learning_Course__c retrieved = [SELECT Id, Name FROM Learning_Course__c WHERE Id = :testCourse.Id];
    System.debug('Retrieved: ' + retrieved);
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
