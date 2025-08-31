// Debug script to check Learning Course records
// Run this in Developer Console or via SFDX

System.debug('=== DEBUGGING LEARNING COURSES ===');

// Check what Learning Course records actually exist
List<Learning_Course__c> allCourses = [
    SELECT Id, Name, Course_Status__c, CreatedDate, OwnerId
    FROM Learning_Course__c 
    ORDER BY Name
];

System.debug('Total Learning Courses found: ' + allCourses.size());

if (allCourses.isEmpty()) {
    System.debug('❌ NO LEARNING COURSES FOUND!');
} else {
    System.debug('✅ Learning Courses found:');
    for (Learning_Course__c course : allCourses) {
        System.debug('Course ID: ' + course.Id);
        System.debug('Course Name: ' + course.Name);
        System.debug('Course Status: ' + course.Course_Status__c);
        System.debug('Created Date: ' + course.CreatedDate);
        System.debug('Owner ID: ' + course.OwnerId);
        System.debug('---');
    }
}

// Check if the object exists and is accessible
Schema.SObjectType courseType = Schema.getGlobalDescribe().get('Learning_Course__c');
if (courseType != null) {
    Schema.DescribeSObjectResult courseDescribe = courseType.getDescribe();
    System.debug('✅ Learning_Course__c object exists');
    System.debug('Object Label: ' + courseDescribe.getLabel());
    System.debug('Object API Name: ' + courseDescribe.getName());
    System.debug('Is Accessible: ' + courseDescribe.isAccessible());
    System.debug('Is Createable: ' + courseDescribe.isCreateable());
    System.debug('Is Updateable: ' + courseDescribe.isUpdateable());
    System.debug('Is Deletable: ' + courseDescribe.isDeletable());
} else {
    System.debug('❌ Learning_Course__c object NOT FOUND!');
}

// Try to create a test course if none exist
if (allCourses.isEmpty()) {
    System.debug('Creating a test course...');
    try {
        Learning_Course__c testCourse = new Learning_Course__c(
            Course_Status__c = 'Active'
        );
        insert testCourse;
        System.debug('✅ Test course created with ID: ' + testCourse.Id);
        System.debug('Test course Name: ' + testCourse.Name);
    } catch (Exception e) {
        System.debug('❌ Error creating test course: ' + e.getMessage());
    }
}

System.debug('=== DEBUG COMPLETE ===');
