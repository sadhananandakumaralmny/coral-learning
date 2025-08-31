// Check for existing courses
System.debug('Checking for existing courses...');

try {
    List<Learning_Course__c> courses = [
        SELECT Id, Name 
        FROM Learning_Course__c 
        LIMIT 5
    ];
    
    System.debug('Found ' + courses.size() + ' courses:');
    
    if (courses.isEmpty()) {
        System.debug('No courses found. Creating a sample one...');
        
        Learning_Course__c sampleCourse = new Learning_Course__c(
            Name = 'Introduction to Learning Management'
        );
        insert sampleCourse;
        
        System.debug('Created sample course: ' + sampleCourse.Id + ' - ' + sampleCourse.Name);
    } else {
        for (Learning_Course__c course : courses) {
            System.debug('Course: ' + course.Id + ' - ' + course.Name);
        }
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
