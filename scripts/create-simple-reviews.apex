// Quick script to create course reviews for demo
System.debug('Creating course reviews for demo...');

try {
    // First, let's verify the course exists
    List<Learning_Course__c> courses = [
        SELECT Id, Name 
        FROM Learning_Course__c 
        WHERE Id = 'a04TC0000006DdhYAE'
        LIMIT 1
    ];
    
    if (courses.isEmpty()) {
        System.debug('❌ Course with ID a04TC0000006DdhYAE not found!');
        return;
    }
    
    System.debug('✅ Found course: ' + courses[0].Name);
    
    // Get some students to create reviews for
    List<Student__c> students = [
        SELECT Id, First_Name__c, Last_Name__c, Email__c
        FROM Student__c 
        LIMIT 3
    ];
    
    if (students.isEmpty()) {
        System.debug('❌ No students found!');
        return;
    }
    
    System.debug('✅ Found ' + students.size() + ' students for reviews');
    
    // Create course reviews with 3.5 star ratings
    List<Course_Review__c> reviews = new List<Course_Review__c>();
    
    // Review 1
    reviews.add(new Course_Review__c(
        Course__c = 'a04TC0000006DdhYAE',
        Student__c = students[0].Id,
        Rating__c = 3.5,
        Review_Date__c = Date.today() - 5,
        Status__c = 'Published'
    ));
    
    // Review 2
    if (students.size() > 1) {
        reviews.add(new Course_Review__c(
            Course__c = 'a04TC0000006DdhYAE',
            Student__c = students[1].Id,
            Rating__c = 3.5,
            Review_Date__c = Date.today() - 3,
            Status__c = 'Published'
        ));
    }
    
    // Review 3
    if (students.size() > 2) {
        reviews.add(new Course_Review__c(
            Course__c = 'a04TC0000006DdhYAE',
            Student__c = students[2].Id,
            Rating__c = 3.5,
            Review_Date__c = Date.today() - 1,
            Status__c = 'Published'
        ));
    }
    
    // Insert all reviews
    insert reviews;
    
    System.debug('✅ Successfully created ' + reviews.size() + ' course reviews');
    
    // Verify the average rating
    List<AggregateResult> avgResult = [
        SELECT AVG(Rating__c) averageRating, COUNT(Id) reviewCount
        FROM Course_Review__c 
        WHERE Course__c = 'a04TC0000006DdhYAE'
        AND Status__c = 'Published'
    ];
    
    if (!avgResult.isEmpty()) {
        Decimal avgRating = (Decimal) avgResult[0].get('averageRating');
        Integer reviewCount = (Integer) avgResult[0].get('reviewCount');
        System.debug('✅ Course now has ' + reviewCount + ' reviews with average rating: ' + avgRating);
    }
    
} catch (Exception e) {
    System.debug('❌ Error creating course reviews: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
