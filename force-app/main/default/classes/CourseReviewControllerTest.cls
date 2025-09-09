@isTest
public class CourseReviewControllerTest {
    @isTest
    static void testCreateReview() {
        Course_Review__c review = new Course_Review__c(
            Course__c = 'YOUR_COURSE_ID', // Replace with actual course ID
            Rating__c = 5,
            Review__c = 'This course was fantastic!',
            Reviewer__c = UserInfo.getUserId()
        );

        Test.startTest();
        CourseReviewController.createReview(review);
        Test.stopTest();

        // Assert that the review was created
        Course_Review__c createdReview = [SELECT Id, Rating__c, Review__c FROM Course_Review__c WHERE Id = :review.Id];
        System.assertEquals(5, createdReview.Rating__c);
        System.assertEquals('This course was fantastic!', createdReview.Review__c);
    }

    @isTest
    static void testGetReviews() {
        // Setup test data
        Course_Review__c review = new Course_Review__c(
            Course__c = 'YOUR_COURSE_ID', // Replace with actual course ID
            Rating__c = 4,
            Review__c = 'Good course, but could use more examples.',
            Reviewer__c = UserInfo.getUserId()
        );
        insert review;

        Test.startTest();
        List<Course_Review__c> reviews = CourseReviewController.getReviews('YOUR_COURSE_ID'); // Replace with actual course ID
        Test.stopTest();

        // Assert that the reviews are fetched
        System.assertEquals(1, reviews.size());
        System.assertEquals('Good course, but could use more examples.', reviews[0].Review__c);
    }
}
