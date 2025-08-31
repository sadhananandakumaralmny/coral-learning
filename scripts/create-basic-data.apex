// Create basic data using available fields
System.debug('Creating basic data...');

try {
    // Create a basic course (only using available fields)
    Learning_Course__c course1 = new Learning_Course__c();
    insert course1;
    System.debug('Created course: ' + course1.Id + ' - Name: ' + course1.Name);
    
    // Create another course
    Learning_Course__c course2 = new Learning_Course__c();
    insert course2;
    System.debug('Created course: ' + course2.Id + ' - Name: ' + course2.Name);
    
    // Create a third course
    Learning_Course__c course3 = new Learning_Course__c();
    insert course3;
    System.debug('Created course: ' + course3.Id + ' - Name: ' + course3.Name);
    
    System.debug('Successfully created 3 basic courses');
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
