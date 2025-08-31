// Simple test to check Learning_Course__c object
System.debug('Testing Learning_Course__c object...');

// Try to create a simple record
try {
    Learning_Course__c testCourse = new Learning_Course__c(
        Name = 'Test Course'
    );
    insert testCourse;
    System.debug('Successfully created test course with ID: ' + testCourse.Id);
    
    // Query it back to see what fields exist
    Learning_Course__c retrievedCourse = [SELECT Id, Name FROM Learning_Course__c WHERE Id = :testCourse.Id];
    System.debug('Retrieved course: ' + retrievedCourse);
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Error type: ' + e.getTypeName());
}
