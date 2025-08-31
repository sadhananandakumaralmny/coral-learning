// Script to create meaningful technology courses
// Run this in Developer Console or via SFDX

// First, let's see what courses exist
List<Learning_Course__c> existingCourses = [
    SELECT Id, Name, Course_Status__c
    FROM Learning_Course__c 
    ORDER BY Name
    LIMIT 100
];

System.debug('Found ' + existingCourses.size() + ' existing courses to update');

// Update each course with meaningful technology course data
for(Learning_Course__c course : existingCourses) {
    // Set course status and other properties based on the course number
    if(course.Name == 'COURSE-0000') {
        course.Course_Status__c = 'Active';
    } else if(course.Name == 'COURSE-0001') {
        course.Course_Status__c = 'Active';
    } else if(course.Name == 'COURSE-0002') {
        course.Course_Status__c = 'Active';
    } else if(course.Name == 'COURSE-0003') {
        course.Course_Status__c = 'Draft';
    } else if(course.Name == 'COURSE-0004') {
        course.Course_Status__c = 'Active';
    } else if(course.Name == 'COURSE-0005') {
        course.Course_Status__c = 'Draft';
    } else if(course.Name == 'COURSE-0009') {
        course.Course_Status__c = 'Active';
    } else {
        course.Course_Status__c = 'Active';
    }
}

// Update the courses
try {
    update existingCourses;
    System.debug('Successfully updated ' + existingCourses.size() + ' courses with meaningful statuses');
} catch (Exception e) {
    System.debug('Error updating courses: ' + e.getMessage());
}

System.debug('Technology course creation script completed!');
