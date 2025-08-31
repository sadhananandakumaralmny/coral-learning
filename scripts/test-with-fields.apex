// Test adding custom fields to Learning_Course__c
System.debug('Testing custom fields...');

try {
    // Try to create a record with custom fields
    Learning_Course__c testCourse = new Learning_Course__c(
        Course_Description__c = 'Test Description'
    );
    insert testCourse;
    System.debug('Successfully created course with description: ' + testCourse.Id);
    
} catch (Exception e) {
    System.debug('Error with Course_Description__c: ' + e.getMessage());
    
    // Try without custom fields
    try {
        Learning_Course__c basicCourse = new Learning_Course__c();
        insert basicCourse;
        System.debug('Created basic course: ' + basicCourse.Id);
        
        // Try to update with custom field
        basicCourse.Course_Description__c = 'Updated Description';
        update basicCourse;
        System.debug('Successfully updated with custom field');
        
    } catch (Exception e2) {
        System.debug('Error updating: ' + e2.getMessage());
    }
}
