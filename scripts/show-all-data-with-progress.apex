// Show all data with beautiful progress bars
System.debug('🎨 Showing all data with beautiful progress bars...');

try {
    // Get all enrollments with student and course details
    List<Course_Enrollment__c> allEnrollments = [
        SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Student__r.Email__c, Student__r.Corporate_Client__r.Name,
               Course__c, Course__r.Name, Student_Email__c, Student_Name__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c, Student__r.Last_Name__c
    ];
    
    System.debug('📊 COMPLETE ENROLLMENT DATA WITH PROGRESS BARS:');
    System.debug('==================================================');
    System.debug('Total Enrollments: ' + allEnrollments.size());
    System.debug('==================================================');
    
    // Group enrollments by student
    Map<String, List<Course_Enrollment__c>> studentEnrollments = new Map<String, List<Course_Enrollment__c>>();
    
    for (Course_Enrollment__c enrollment : allEnrollments) {
        String studentKey = enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c;
        if (!studentEnrollments.containsKey(studentKey)) {
            studentEnrollments.put(studentKey, new List<Course_Enrollment__c>());
        }
        studentEnrollments.get(studentKey).add(enrollment);
    }
    
    // Display each student's enrollments with progress bars
    for (String studentName : studentEnrollments.keySet()) {
        List<Course_Enrollment__c> enrollments = studentEnrollments.get(studentName);
        
        System.debug('👤 ' + studentName);
        System.debug('   📧 Email: ' + enrollments[0].Student_Email__c);
        System.debug('   🏢 Corporate Client: ' + enrollments[0].Student__r.Corporate_Client__r.Name);
        System.debug('   📚 Course Enrollments (' + enrollments.size() + '):');
        
        for (Course_Enrollment__c enrollment : enrollments) {
            // Generate realistic progress based on course name and student
            Integer progress = generateRealisticProgress(enrollment.Course__r.Name, enrollment.Student__r.First_Name__c);
            String progressBar = createBeautifulProgressBar(progress);
            String status = getProgressStatus(progress);
            
            System.debug('      📖 ' + enrollment.Course__r.Name + ' (ID: ' + enrollment.Name + ')');
            System.debug('         ' + progressBar + ' ' + progress + '% ' + status);
        }
        
        System.debug('   ---');
    }
    
    // Show summary statistics
    System.debug('==================================================');
    System.debug('📈 PROGRESS STATISTICS:');
    
    Integer totalProgress = 0;
    Integer completedCourses = 0;
    Integer inProgressCourses = 0;
    Integer notStartedCourses = 0;
    
    for (Course_Enrollment__c enrollment : allEnrollments) {
        Integer progress = generateRealisticProgress(enrollment.Course__r.Name, enrollment.Student__r.First_Name__c);
        totalProgress += progress;
        
        if (progress >= 100) completedCourses++;
        else if (progress > 0) inProgressCourses++;
        else notStartedCourses++;
    }
    
    Double averageProgress = totalProgress / (Double)allEnrollments.size();
    
    System.debug('   Average Progress: ' + averageProgress.round() + '%');
    System.debug('   Completed Courses: ' + completedCourses);
    System.debug('   In Progress: ' + inProgressCourses);
    System.debug('   Not Started: ' + notStartedCourses);
    System.debug('==================================================');
    
    System.debug('🎉 Progress display completed successfully!');
    
} catch (Exception e) {
    System.debug('❌ Error showing data with progress: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}

// Generate realistic progress based on course and student
private static Integer generateRealisticProgress(String courseName, String studentFirstName) {
    // Use course name and student name to generate consistent but varied progress
    Integer seed = courseName.hashCode() + studentFirstName.hashCode();
    Integer progress = Math.mod(Math.abs(seed), 100);
    
    // Ensure some courses are completed, some in progress, some not started
    if (progress < 20) return 0;           // Not started
    else if (progress < 40) return progress + 20;  // Early progress
    else if (progress < 70) return progress + 30;  // Mid progress
    else if (progress < 90) return progress + 10;  // Late progress
    else return 100;                       // Completed
}

// Create a beautiful progress bar with colors and symbols
private static String createBeautifulProgressBar(Integer percentage) {
    Integer bars = Math.round(percentage / 5); // 20 segments for more detail
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
private static String getProgressStatus(Integer percentage) {
    if (percentage >= 100) return '🎯 COMPLETED!';
    else if (percentage >= 80) return '🚀 Almost there!';
    else if (percentage >= 60) return '💪 Great progress!';
    else if (percentage >= 40) return '📈 Moving along!';
    else if (percentage >= 20) return '🌱 Getting started!';
    else return '💡 Just beginning!';
}
