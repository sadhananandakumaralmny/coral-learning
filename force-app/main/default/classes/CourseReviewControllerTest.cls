@isTest
public class CourseReviewControllerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test corporate client
        Corporate_Client__c client = new Corporate_Client__c(
            Company_Name__c = 'Test Company',
            Company_Industry__c = 'Technology',
            Company_Size__c = 'Medium',
            Contact_Person__c = 'John Doe',
            Contact_Email__c = 'john@testcompany.com',
            Contact_Phone__c = '555-0123',
            Status__c = 'Active'
        );
        insert client;
        
        // Create test student
        Student__c student = new Student__c(
            First_Name__c = 'Jane',
            Last_Name__c = 'Smith',
            Email__c = 'jane@testcompany.com',
            Phone__c = '555-0124',
            Corporate_Client__c = client.Id,
            Department__c = 'Engineering',
            Job_Title__c = 'Developer',
            Status__c = 'Active'
        );
        insert student;
        
        // Create test course
        Learning_Course__c course = new Learning_Course__c(
            Course_Description__c = 'Test Course Description',
            Course_Duration__c = 8.0,
            Course_Level__c = 'Beginner',
            Course_Status__c = 'Active'
        );
        insert course;
        
        // Create test enrollment
        Course_Enrollment__c enrollment = new Course_Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id,
            Corporate_Client__c = client.Id,
            Student_Name__c = 'Jane Smith',
            Student_Email__c = 'jane@testcompany.com',
            Student_Phone__c = '555-0124',
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled',
            Progress_Percentage__c = 0
        );
        insert enrollment;
    }
    
    @isTest
    static void testGetCourseReviews() {
        Learning_Course__c course = [SELECT Id FROM Learning_Course__c LIMIT 1];
        Student__c student = [SELECT Id FROM Student__c LIMIT 1];
        
        // Create test review
        Course_Review__c review = new Course_Review__c(
            Course__c = course.Id,
            Student__c = student.Id,
            Rating__c = 5.0,
            Review_Text__c = 'Great course!',
            Review_Date__c = Date.today(),
            Status__c = 'Published'
        );
        insert review;
        
        Test.startTest();
        List<Course_Review__c> reviews = CourseReviewController.getCourseReviews(course.Id);
        Test.stopTest();
        
        System.assertEquals(1, reviews.size());
        System.assertEquals(5.0, reviews[0].Rating__c);
        System.assertEquals('Great course!', reviews[0].Review_Text__c);
    }
    
    @isTest
    static void testGetCourseReviewSummary() {
        Learning_Course__c course = [SELECT Id FROM Learning_Course__c LIMIT 1];
        Student__c student = [SELECT Id FROM Student__c LIMIT 1];
        
        // Create test reviews
        List<Course_Review__c> reviews = new List<Course_Review__c>();
        reviews.add(new Course_Review__c(
            Course__c = course.Id,
            Student__c = student.Id,
            Rating__c = 5.0,
            Review_Text__c = 'Excellent!',
            Review_Date__c = Date.today(),
            Status__c = 'Published'
        ));
        reviews.add(new Course_Review__c(
            Course__c = course.Id,
            Student__c = student.Id,
            Rating__c = 4.0,
            Review_Text__c = 'Good course',
            Review_Date__c = Date.today(),
            Status__c = 'Published'
        ));
        insert reviews;
        
        Test.startTest();
        CourseReviewController.CourseReviewSummary summary = CourseReviewController.getCourseReviewSummary(course.Id);
        Test.stopTest();
        
        System.assertEquals(2, summary.reviewCount);
        System.assertEquals(4.5, summary.averageRating);
    }
    
    @isTest
    static void testCreateCourseReview() {
        Learning_Course__c course = [SELECT Id FROM Learning_Course__c LIMIT 1];
        Student__c student = [SELECT Id FROM Student__c LIMIT 1];
        
        Map<String, Object> reviewData = new Map<String, Object>{
            'courseId' => course.Id,
            'studentId' => student.Id,
            'rating' => 4.0,
            'reviewText' => 'Good course content'
        };
        
        Test.startTest();
        Course_Review__c newReview = CourseReviewController.createCourseReview(JSON.serialize(reviewData));
        Test.stopTest();
        
        System.assertNotEquals(null, newReview.Id);
        System.assertEquals(course.Id, newReview.Course__c);
        System.assertEquals(student.Id, newReview.Student__c);
        System.assertEquals(4.0, newReview.Rating__c);
        System.assertEquals('Good course content', newReview.Review_Text__c);
        System.assertEquals('Published', newReview.Status__c);
    }
    
    @isTest
    static void testGetStudentsForCourse() {
        Learning_Course__c course = [SELECT Id FROM Learning_Course__c LIMIT 1];
        
        Test.startTest();
        List<Student__c> students = CourseReviewController.getStudentsForCourse(course.Id);
        Test.stopTest();
        
        System.assertEquals(1, students.size());
        System.assertEquals('Jane', students[0].First_Name__c);
        System.assertEquals('Smith', students[0].Last_Name__c);
    }
    
    @isTest
    static void testHasStudentReviewedCourse() {
        Learning_Course__c course = [SELECT Id FROM Learning_Course__c LIMIT 1];
        Student__c student = [SELECT Id FROM Student__c LIMIT 1];
        
        // Create test review
        Course_Review__c review = new Course_Review__c(
            Course__c = course.Id,
            Student__c = student.Id,
            Rating__c = 5.0,
            Review_Text__c = 'Great course!',
            Review_Date__c = Date.today(),
            Status__c = 'Published'
        );
        insert review;
        
        Test.startTest();
        Boolean hasReviewed = CourseReviewController.hasStudentReviewedCourse(course.Id, student.Id);
        Test.stopTest();
        
        System.assertEquals(true, hasReviewed);
    }
}
