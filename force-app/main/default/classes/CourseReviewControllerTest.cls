@isTest
public class CourseReviewControllerTest {

    @isTest
    static void testGetReviews() {
        // Setup test data
        Course_Review__c review = new Course_Review__c(
            Course__c = 'a1B3j0000001XYZ', // Example course ID
            Rating__c = 4,
            Review__c = 'Good course, but could use more examples.',
            Reviewer__c = UserInfo.getUserId(),
            Company_Size__c = null // Valid picklist value
        );
        insert review;

        Test.startTest();
        List<Course_Review__c> reviews = CourseReviewController.getReviews('a1B3j0000001XYZ'); // Example course ID
        Test.stopTest();

        // Assert that the reviews are fetched
        System.assertEquals(1, reviews.size());
        System.assertEquals('Good course, but could use more examples.', reviews[0].Review__c);
    }
}
