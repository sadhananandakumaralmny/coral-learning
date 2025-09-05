public with sharing class CourseReviewController {
    
    @AuraEnabled(cacheable=true)
    public static List<Course_Review__c> getCourseReviews(Id courseId) {
        try {
            return [
                SELECT Id, Name, Course__c, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c,
                       Rating__c, Review_Text__c, Review_Date__c, Status__c, CreatedDate
                FROM Course_Review__c 
                WHERE Course__c = :courseId 
                AND Status__c = 'Published'
                ORDER BY Review_Date__c DESC, CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving course reviews: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static CourseReviewSummary getCourseReviewSummary(Id courseId) {
        try {
            List<AggregateResult> results = [
                SELECT COUNT(Id) reviewCount, AVG(Rating__c) averageRating
                FROM Course_Review__c 
                WHERE Course__c = :courseId 
                AND Status__c = 'Published'
            ];
            
            CourseReviewSummary summary = new CourseReviewSummary();
            if (!results.isEmpty()) {
                summary.reviewCount = (Integer) results[0].get('reviewCount');
                summary.averageRating = (Decimal) results[0].get('averageRating');
            } else {
                summary.reviewCount = 0;
                summary.averageRating = 0;
            }
            
            return summary;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving course review summary: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Course_Review__c createCourseReview(String reviewData) {
        try {
            Map<String, Object> reviewMap = (Map<String, Object>) JSON.deserializeUntyped(reviewData);
            
            Course_Review__c newReview = new Course_Review__c();
            newReview.Course__c = (Id) reviewMap.get('courseId');
            newReview.Student__c = (Id) reviewMap.get('studentId');
            newReview.Rating__c = (Decimal) reviewMap.get('rating');
            newReview.Review_Text__c = (String) reviewMap.get('reviewText');
            newReview.Review_Date__c = Date.today();
            newReview.Status__c = 'Published';
            
            insert newReview;
            return newReview;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating course review: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Course_Review__c updateCourseReview(Id reviewId, String reviewData) {
        try {
            Map<String, Object> reviewMap = (Map<String, Object>) JSON.deserializeUntyped(reviewData);
            
            Course_Review__c reviewToUpdate = [
                SELECT Id, Course__c, Student__c, Rating__c, Review_Text__c, Review_Date__c, Status__c
                FROM Course_Review__c 
                WHERE Id = :reviewId
                LIMIT 1
            ];
            
            reviewToUpdate.Rating__c = (Decimal) reviewMap.get('rating');
            reviewToUpdate.Review_Text__c = (String) reviewMap.get('reviewText');
            
            update reviewToUpdate;
            return reviewToUpdate;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error updating course review: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteCourseReview(Id reviewId) {
        try {
            Course_Review__c reviewToDelete = [
                SELECT Id FROM Course_Review__c WHERE Id = :reviewId LIMIT 1
            ];
            delete reviewToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting course review: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudentsForCourse(Id courseId) {
        try {
            return [
                SELECT Id, First_Name__c, Last_Name__c, Email__c
                FROM Student__c 
                WHERE Id IN (
                    SELECT Student__c 
                    FROM Course_Enrollment__c 
                    WHERE Course__c = :courseId
                )
                ORDER BY First_Name__c, Last_Name__c
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving students for course: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean hasStudentReviewedCourse(Id courseId, Id studentId) {
        try {
            List<Course_Review__c> existingReviews = [
                SELECT Id 
                FROM Course_Review__c 
                WHERE Course__c = :courseId 
                AND Student__c = :studentId
                LIMIT 1
            ];
            return !existingReviews.isEmpty();
        } catch (Exception e) {
            throw new AuraHandledException('Error checking existing review: ' + e.getMessage());
        }
    }
    
    public class CourseReviewSummary {
        @AuraEnabled public Integer reviewCount { get; set; }
        @AuraEnabled public Decimal averageRating { get; set; }
    }
}
