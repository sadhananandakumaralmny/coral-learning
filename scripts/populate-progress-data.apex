// Populate progress indicator field with dummy data for existing enrollments
System.debug('🎯 Populating progress indicator field with dummy data...');

try {
    // Step 1: Get all existing enrollments
    System.debug('📚 Step 1: Getting all existing enrollments...');
    
    List<Course_Enrollment__c> allEnrollments = [
        SELECT Id, Name, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Course__r.Name, progress_percentage__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
    ];
    
    System.debug('Found ' + allEnrollments.size() + ' enrollments to update');
    
    if (allEnrollments.isEmpty()) {
        System.debug('❌ No enrollments found to update');
        return;
    }
    
    // Step 2: Generate realistic progress data for each enrollment
    System.debug('📊 Step 2: Generating realistic progress data...');
    
    List<Course_Enrollment__c> enrollmentsToUpdate = new List<Course_Enrollment__c>();
    
    for (Course_Enrollment__c enrollment : allEnrollments) {
        // Generate realistic progress based on course name and student
        Integer progress = generateRealisticProgress(enrollment.Course__r.Name, enrollment.Student__r.First_Name__c);
        
        // Update the progress percentage field
        enrollment.progress_percentage__c = progress;
        
        enrollmentsToUpdate.add(enrollment);
        
        System.debug('📚 ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c + 
                    ' → ' + enrollment.Course__r.Name + ': ' + progress + '%');
    }
    
    // Step 3: Update all enrollments
    System.debug('💾 Step 3: Updating enrollments with progress data...');
    
    update enrollmentsToUpdate;
    System.debug('✅ Successfully updated ' + enrollmentsToUpdate.size() + ' enrollments');
    
    // Step 4: Verify the updates
    System.debug('🔍 Step 4: Verifying progress data updates...');
    
    List<Course_Enrollment__c> updatedEnrollments = [
        SELECT Id, Name, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Course__r.Name, progress_percentage__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
        LIMIT 20
    ];
    
    System.debug('📊 Sample Updated Enrollments:');
    System.debug('=====================================');
    
    for (Course_Enrollment__c enrollment : updatedEnrollments) {
        String progressBar = createProgressBar(enrollment.progress_percentage__c);
        String status = getProgressStatus(enrollment.progress_percentage__c);
        
        System.debug('📚 ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c + 
                    ' → ' + enrollment.Course__r.Name);
        System.debug('   Progress: ' + enrollment.progress_percentage__c + '% ' + progressBar + ' ' + status);
        System.debug('   ---');
    }
    
    // Step 5: Show summary statistics
    System.debug('=====================================');
    System.debug('📈 PROGRESS SUMMARY STATISTICS:');
    
    Decimal totalProgress = 0;
    Integer completedCourses = 0;
    Integer inProgressCourses = 0;
    Integer notStartedCourses = 0;
    
    for (Course_Enrollment__c enrollment : updatedEnrollments) {
        Decimal progress = enrollment.progress_percentage__c != null ? enrollment.progress_percentage__c : 0;
        totalProgress += progress;
        
        if (progress >= 100) completedCourses++;
        else if (progress > 0) inProgressCourses++;
        else notStartedCourses++;
    }
    
    Double averageProgress = totalProgress / (Double)updatedEnrollments.size();
    
    System.debug('   Average Progress: ' + averageProgress.round() + '%');
    System.debug('   Completed Courses: ' + completedCourses);
    System.debug('   In Progress: ' + inProgressCourses);
    System.debug('   Not Started: ' + notStartedCourses);
    System.debug('=====================================');
    
    System.debug('🎉 Progress data population completed successfully!');
    System.debug('💡 All enrollments now have realistic progress percentages');
    
} catch (Exception e) {
    System.debug('❌ Error populating progress data: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}

// Generate realistic progress based on course name and student
private static Integer generateRealisticProgress(String courseName, String studentFirstName) {
    // Use course name and student name to generate consistent but varied progress
    Integer seed = courseName.hashCode() + studentFirstName.hashCode();
    Integer progress = Math.mod(Math.abs(seed), 100);
    
    // Ensure some courses are completed, some in progress, some not started
    if (progress < 15) return 0;           // Not started
    else if (progress < 35) return progress + 15;  // Early progress
    else if (progress < 65) return progress + 25;  // Mid progress
    else if (progress < 85) return progress + 15;  // Late progress
    else return 100;                       // Completed
}

// Create a visual progress bar
private static String createProgressBar(Decimal percentage) {
    if (percentage == null) percentage = 0;
    
    Integer bars = Math.round(percentage / 5); // 20 segments for detail
    String progressBar = '[';
    
    for (Integer i = 0; i < 20; i++) {
        if (i < bars) {
            if (percentage >= 100) progressBar += '🏆';      // Trophy for completed
            else if (percentage >= 80) progressBar += '⭐';   // Star for near completion
            else if (percentage >= 60) progressBar += '🔥';   // Fire for good progress
            else if (percentage >= 40) progressBar += '⚡';   // Lightning for moderate progress
            else if (percentage >= 20) progressBar += '🌱';   // Seed for early progress
            else progressBar += '💡';                        // Lightbulb for just started
        } else {
            progressBar += '⬜';                             // Empty square for remaining
        }
    }
    
    progressBar += ']';
    return progressBar;
}

// Get a descriptive status for the progress
private static String getProgressStatus(Decimal percentage) {
    if (percentage == null) return '💡 Just beginning!';
    
    if (percentage >= 100) return '🎯 COMPLETED!';
    else if (percentage >= 80) return '🚀 Almost there!';
    else if (percentage >= 60) return '💪 Great progress!';
    else if (percentage >= 40) return '📈 Moving along!';
    else if (percentage >= 20) return '🌱 Getting started!';
    else return '💡 Just beginning!';
}
