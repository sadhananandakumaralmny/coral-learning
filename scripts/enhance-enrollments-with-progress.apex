// Enhance enrollments with progress percentage and add more test data
System.debug('🚀 Enhancing enrollments with progress percentage and adding more test data...');

try {
    // Step 1: Create more students
    System.debug('👥 Step 1: Creating more students...');
    
    List<Student__c> newStudents = new List<Student__c>();
    
    // Add more diverse students
    List<String> firstNames = new List<String>{'Alex', 'Maria', 'James', 'Sophia', 'Robert', 'Emma', 'William', 'Olivia', 'Christopher', 'Ava'};
    List<String> lastNames = new List<String>{'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall'};
    List<String> companies = new List<String>{'techcorp.com', 'innovatesoft.com', 'dataflow.com', 'cloudtech.com', 'digitalsolutions.com'};
    List<String> departments = new List<String>{'Engineering', 'Marketing', 'Sales', 'HR', 'Finance', 'Operations', 'Product', 'Design'};
    
    for (Integer i = 0; i < 10; i++) {
        Student__c student = new Student__c(
            First_Name__c = firstNames[i],
            Last_Name__c = lastNames[i],
            Email__c = firstNames[i].toLowerCase() + '.' + lastNames[i].toLowerCase() + '@' + companies[Math.mod(i, companies.size())],
            Department__c = departments[Math.mod(i, departments.size())],
            Job_Title__c = 'Professional',
            Phone__c = '+1-555-' + String.valueOf(1000 + i)
        );
        newStudents.add(student);
    }
    
    insert newStudents;
    System.debug('✅ Created ' + newStudents.size() + ' new students');
    
    // Step 2: Create more courses
    System.debug('📚 Step 2: Creating more courses...');
    
    List<Learning_Course__c> newCourses = new List<Learning_Course__c>();
    
    List<String> courseNames = new List<String>{'Advanced JavaScript', 'Python for Data Science', 'Cloud Architecture', 'DevOps Fundamentals', 'Machine Learning Basics', 'Web Development', 'Database Design', 'API Development', 'Mobile App Development', 'Cybersecurity Essentials'};
    List<String> courseDescriptions = new List<String>{'Master modern JavaScript frameworks', 'Learn Python for data analysis', 'Design scalable cloud solutions', 'Implement DevOps practices', 'Introduction to ML algorithms', 'Build responsive web applications', 'Design efficient databases', 'Create RESTful APIs', 'Develop mobile applications', 'Secure your applications'};
    
    for (Integer i = 0; i < 10; i++) {
        Learning_Course__c course = new Learning_Course__c(
            Course_Description__c = courseDescriptions[i],
            Duration_Hours__c = Math.round(Math.random() * 40) + 10,
            Difficulty_Level__c = 'Intermediate',
            Category__c = 'Technology'
        );
        newCourses.add(course);
    }
    
    insert newCourses;
    System.debug('✅ Created ' + newCourses.size() + ' new courses');
    
    // Step 3: Create more corporate clients
    System.debug('🏢 Step 3: Creating more corporate clients...');
    
    List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();
    
    List<String> companyNames = new List<String>{'TechVision Inc', 'DataDynamics Corp', 'CloudFirst Solutions', 'InnovateTech Group', 'DigitalEdge Systems', 'SmartSolutions Ltd', 'FutureTech Partners', 'EliteCorp International', 'NextGen Technologies', 'PeakPerformance Corp'};
    List<String> industries = new List<String>{'Technology', 'Healthcare', 'Finance', 'Education', 'Manufacturing', 'Retail', 'Consulting', 'Energy', 'Transportation', 'Media'};
    
    for (Integer i = 0; i < 10; i++) {
        Corporate_Client__c client = new Corporate_Client__c(
            Company_Industry__c = industries[i],
            Status__c = 'Active'
        );
        newClients.add(client);
    }
    
    insert newClients;
    System.debug('✅ Created ' + newClients.size() + ' new corporate clients');
    
    // Step 4: Assign new students to clients
    System.debug('🔗 Step 4: Assigning new students to clients...');
    
    List<Student__c> allStudents = [SELECT Id, Corporate_Client__c FROM Student__c WHERE Corporate_Client__c = null];
    List<Corporate_Client__c> allClients = [SELECT Id FROM Corporate_Client__c];
    
    for (Integer i = 0; i < allStudents.size(); i++) {
        allStudents[i].Corporate_Client__c = allClients[Math.mod(i, allClients.size())].Id;
    }
    
    update allStudents;
    System.debug('✅ Assigned all students to corporate clients');
    
    // Step 5: Create enrollments with progress (we'll simulate progress since the field doesn't exist yet)
    System.debug('📚 Step 5: Creating enrollments with simulated progress...');
    
    List<Course_Enrollment__c> newEnrollments = new List<Course_Enrollment__c>();
    
    // Get all students and courses
    List<Student__c> allStudentsWithClients = [
        SELECT Id, First_Name__c, Last_Name__c, Email__c, Corporate_Client__c
        FROM Student__c 
        ORDER BY First_Name__c
    ];
    
    List<Learning_Course__c> allCourses = [
        SELECT Id, Name
        FROM Learning_Course__c 
        ORDER BY Name
    ];
    
    // Create multiple enrollments per student with different progress levels
    for (Student__c student : allStudentsWithClients) {
        // Enroll each student in 2-4 courses
        Integer numEnrollments = Math.round(Math.random() * 3) + 2;
        
        for (Integer j = 0; j < numEnrollments; j++) {
            Learning_Course__c course = allCourses[Math.round(Math.random() * (allCourses.size() - 1))];
            
            Course_Enrollment__c enrollment = new Course_Enrollment__c(
                Student__c = student.Id,
                Course__c = course.Id,
                Student_Email__c = student.Email__c,
                Student_Name__c = student.First_Name__c + ' ' + student.Last_Name__c
            );
            
            newEnrollments.add(enrollment);
        }
    }
    
    insert newEnrollments;
    System.debug('✅ Created ' + newEnrollments.size() + ' new enrollments');
    
    // Step 6: Show final summary
    System.debug('📊 Step 6: Final data summary...');
    
    Integer totalStudents = [SELECT COUNT() FROM Student__c];
    Integer totalClients = [SELECT COUNT() FROM Corporate_Client__c];
    Integer totalCourses = [SELECT COUNT() FROM Learning_Course__c];
    Integer totalEnrollments = [SELECT COUNT() FROM Course_Enrollment__c];
    
    System.debug('=====================================');
    System.debug('🎯 FINAL DATA SUMMARY:');
    System.debug('   Total Students: ' + totalStudents);
    System.debug('   Total Corporate Clients: ' + totalClients);
    System.debug('   Total Learning Courses: ' + totalCourses);
    System.debug('   Total Course Enrollments: ' + totalEnrollments);
    System.debug('=====================================');
    
    // Step 7: Show sample enrollments with progress simulation
    System.debug('📚 Sample enrollments with progress simulation:');
    
    List<Course_Enrollment__c> sampleEnrollments = [
        SELECT Id, Name, Student__r.First_Name__c, Student__r.Last_Name__c, 
               Course__r.Name, Student_Email__c, Student_Name__c
        FROM Course_Enrollment__c 
        ORDER BY Student__r.First_Name__c
        LIMIT 20
    ];
    
    for (Course_Enrollment__c enrollment : sampleEnrollments) {
        // Simulate progress percentage (since we don't have the field yet)
        Integer simulatedProgress = Math.round(Math.random() * 100);
        String progressBar = createProgressBar(simulatedProgress);
        
        System.debug('📚 ' + enrollment.Student__r.First_Name__c + ' ' + enrollment.Student__r.Last_Name__c + 
                    ' → ' + enrollment.Course__r.Name);
        System.debug('   Progress: ' + simulatedProgress + '% ' + progressBar);
        System.debug('   ---');
    }
    
    System.debug('🎉 Data enhancement completed successfully!');
    System.debug('💡 Note: Progress percentage is simulated since the field doesn\'t exist yet');
    System.debug('🔧 To add real progress tracking, create a Progress_Percentage__c field on Course_Enrollment__c');
    
} catch (Exception e) {
    System.debug('❌ Error enhancing data: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}

// Helper method to create a visual progress bar
private static String createProgressBar(Integer percentage) {
    Integer bars = Math.round(percentage / 10);
    String progressBar = '[';
    
    for (Integer i = 0; i < 10; i++) {
        if (i < bars) {
            progressBar += '█';
        } else {
            progressBar += '░';
        }
    }
    
    progressBar += ']';
    return progressBar;
}
