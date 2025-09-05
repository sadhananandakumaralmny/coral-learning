// Create course reviews for course a04TC0000006DdhYAE with 3.5 star ratings
System.debug('Creating course reviews for course a04TC0000006DdhYAE...');

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
        LIMIT 5
    ];
    
    if (students.isEmpty()) {
        System.debug('❌ No active students found!');
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
        Review_Text__c = 'This course provided a solid foundation in the subject matter. The content was well-structured and the instructor was knowledgeable. However, I felt some sections could have been more detailed, and the practical exercises were somewhat limited. Overall, a good learning experience that met most of my expectations.',
        Review_Date__c = Date.today() - 5,
        Status__c = 'Published'
    ));
    
    // Review 2
    if (students.size() > 1) {
        reviews.add(new Course_Review__c(
            Course__c = 'a04TC0000006DdhYAE',
            Student__c = students[1].Id,
            Rating__c = 3.5,
            Review_Text__c = 'The course material was comprehensive and the pace was appropriate for my skill level. I appreciated the real-world examples and case studies. The only downside was that some of the advanced topics felt rushed. The instructor was responsive to questions, which helped clarify difficult concepts.',
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
            Review_Text__c = 'Good course overall with practical insights. The curriculum covered the essential topics well, and I found the interactive elements engaging. Some modules could benefit from more hands-on practice, but the theoretical foundation was solid. Would recommend to colleagues looking to understand the basics.',
            Review_Date__c = Date.today() - 7,
            Status__c = 'Published'
        ));
    }
    
    // Review 4
    if (students.size() > 3) {
        reviews.add(new Course_Review__c(
            Course__c = 'a04TC0000006DdhYAE',
            Student__c = students[3].Id,
            Rating__c = 3.5,
            Review_Text__c = 'The course delivered on its promises and provided valuable knowledge. The instructor was clear and the materials were well-organized. I would have liked to see more advanced scenarios and deeper dives into complex topics, but for an introductory course, it was quite effective.',
            Review_Date__c = Date.today() - 2,
            Status__c = 'Published'
        ));
    }
    
    // Review 5
    if (students.size() > 4) {
        reviews.add(new Course_Review__c(
            Course__c = 'a04TC0000006DdhYAE',
            Student__c = students[4].Id,
            Rating__c = 3.5,
            Review_Text__c = 'Solid course with good content structure. The learning objectives were clear and mostly achieved. The practical components were helpful, though I felt some sections needed more depth. The instructor was knowledgeable and approachable. Overall, a worthwhile learning experience.',
            Review_Date__c = Date.today() - 1,
            Status__c = 'Published'
        ));
    }
    
    // Insert all reviews
    insert reviews;
    
    System.debug('✅ Successfully created ' + reviews.size() + ' course reviews:');
    for (Course_Review__c review : reviews) {
        System.debug('  - Review by: ' + review.Student__c);
        System.debug('    Rating: ' + review.Rating__c + ' stars');
        System.debug('    Review Date: ' + review.Review_Date__c);
        System.debug('    Status: ' + review.Status__c);
        System.debug('    Review Text: ' + review.Review_Text__c.substring(0, Math.min(100, review.Review_Text__c.length())) + '...');
        System.debug('    ---');
    }
    
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
