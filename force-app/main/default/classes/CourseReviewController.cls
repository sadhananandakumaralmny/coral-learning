public with sharing class CourseReviewController {
    @AuraEnabled
    public static void createReview(Course_Review__c review) {
        insert review;
    }

    @AuraEnabled
    public static List<Course_Review__c> getReviews(Id courseId) {
        return [SELECT Id, Rating__c, Review__c, Reviewer__c FROM Course_Review__c WHERE Course__c = :courseId];
    }
}
