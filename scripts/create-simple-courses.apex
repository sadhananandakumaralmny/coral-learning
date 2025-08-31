// Simple script to create learning courses with available fields
// Run this in Developer Console or via SFDX

// Create some basic learning courses
List<Learning_Course__c> courses = new List<Learning_Course__c>();

// Course 1
Learning_Course__c course1 = new Learning_Course__c(
    Course_Status__c = 'Active'
);
courses.add(course1);

// Course 2
Learning_Course__c course2 = new Learning_Course__c(
    Course_Status__c = 'Active'
);
courses.add(course2);

// Course 3
Learning_Course__c course3 = new Learning_Course__c(
    Course_Status__c = 'Draft'
);
courses.add(course3);

// Course 4
Learning_Course__c course4 = new Learning_Course__c(
    Course_Status__c = 'Active'
);
courses.add(course4);

// Insert courses
try {
    insert courses;
    System.debug('Successfully created ' + courses.size() + ' learning courses');
    
    // Display the created courses
    for(Learning_Course__c course : courses) {
        System.debug('Course ID: ' + course.Id + ', Name: ' + course.Name + ', Status: ' + course.Course_Status__c);
    }
} catch (Exception e) {
    System.debug('Error creating courses: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Simple course creation script completed!');
