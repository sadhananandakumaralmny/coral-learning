public class TestDataGenerator {
    
    public static void generateTestData() {
        try {
            // Generate Corporate Clients first
            List<Corporate_Client__c> clients = createCorporateClients();
            insert clients;
            System.debug('Created ' + clients.size() + ' Corporate Clients');
            
            // Generate Students
            List<Student__c> students = createStudents();
            insert students;
            System.debug('Created ' + students.size() + ' Students');
            
            // Generate Learning Courses
            List<Learning_Course__c> courses = createLearningCourses();
            insert courses;
            System.debug('Created ' + courses.size() + ' Learning Courses');
            
            // Generate Course Enrollments
            List<Course_Enrollment__c> enrollments = createCourseEnrollments(students, courses, clients);
            insert enrollments;
            System.debug('Created ' + enrollments.size() + ' Course Enrollments');
            
            // Generate AI Insights            List<AI_Insights__c> insights = createAIInsights();
            insert insights;
            System.debug('Created ' + insights.size() + ' AI Insights');
            
            System.debug('Test data generation completed successfully!');
            
        } catch (Exception e) {
            System.debug('Error generating test data: ' + e.getMessage());
            throw e;
        }
    }
    
    private static List<Corporate_Client__c> createCorporateClients() {
        List<Corporate_Client__c> clients = new List<Corporate_Client__c>();
        
        List<String> companyNames = new List<String>{
            'TechCorp Solutions', 'Global Innovations Inc', 'Future Systems Ltd', 
            'Digital Dynamics', 'Smart Solutions Co', 'Innovation Hub', 
            'NextGen Technologies', 'Digital Transformers', 'Tech Leaders Corp',
            'Future Forward Inc'
        };
        
        List<String> industries = new List<String>{'Technology', 'Healthcare', 'Finance', 'Education', 'Manufacturing'};
        List<String> contactNames = new List<String>{'John Smith', 'Sarah Johnson', 'Mike Davis', 'Lisa Wilson', 'David Brown'};
        List<String> companySizes = new List<String>{'Small (10-99 employees)', 'Medium (100-999 employees)', 'Large (1000+ employees)', 'Enterprise (10000+ employees)'};
        List<String> revenueRanges = new List<String>{'$1M-10M', '$10M-25M', '$25M-50M', '$50M-100M', '$100M-500M', '$500M+'};
        
        for (Integer i = 0; i < 10; i++) {
            Corporate_Client__c client = new Corporate_Client__c(
                Company_Name__c = companyNames[i],
                Company_Industry__c = industries[Math.mod(i, industries.size())],
                Contact_Person__c = contactNames[Math.mod(i, contactNames.size())],
                Contact_Email__c = 'contact@' + companyNames[i].toLowerCase().replace(' ', '').replace(',', '') + '.com',
                Contact_Phone__c = '+1-555-' + String.valueOf(1000 + i),
                Annual_Revenue__c = revenueRanges[Math.mod(i, revenueRanges.size())],
                Company_Size__c = companySizes[Math.mod(i, companySizes.size())],
                Partnership_Start_Date__c = Date.today().addDays(-30 - i * 10),
                Status__c = 'Active'
            );
            clients.add(client);
        }
        
        return clients;
    }
    
    private static List<Student__c> createStudents() {
        List<Student__c> students = new List<Student__c>();
        
        List<String> firstNames = new List<String>{
            'Alex', 'Jordan', 'Taylor', 'Morgan', 'Casey', 'Riley', 'Quinn', 'Avery', 'Blake', 'Cameron',
            'Dakota', 'Emery', 'Finley', 'Gray', 'Harper', 'Indigo', 'Jules', 'Kai', 'Lane', 'Mason'
        };
        
        List<String> lastNames = new List<String>{
            'Johnson', 'Smith', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
            'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'
        };
        
        List<String> departments = new List<String>{'Computer Science', 'Business Administration', 'Engineering', 'Arts', 'Sciences'};
        List<String> jobTitles = new List<String>{'Software Engineer', 'Data Analyst', 'Project Manager', 'Designer', 'Researcher'};
        
        for (Integer i = 0; i < 20; i++) {
            Student__c student = new Student__c(
                First_Name__c = firstNames[i],
                Last_Name__c = lastNames[i],
                Email__c = firstNames[i].toLowerCase() + '.' + lastNames[i].toLowerCase() + '@university.edu',
                Phone__c = '+1-555-' + String.valueOf(2000 + i),
                Department__c = departments[Math.mod(i, departments.size())],
                Job_Title__c = jobTitles[Math.mod(i, jobTitles.size())],
                Status__c = 'Active'
            );
            students.add(student);
        }
        
        return students;
    }
    
    private static List<Learning_Course__c> createLearningCourses() {
        List<Learning_Course__c> courses = new List<Learning_Course__c>();
        
        List<String> courseNames = new List<String>{
            'Introduction to Programming', 'Advanced Data Structures', 'Web Development Fundamentals',
            'Machine Learning Basics', 'Database Management Systems', 'Software Engineering Principles',
            'Cloud Computing', 'Cybersecurity Fundamentals', 'Mobile App Development', 'Artificial Intelligence',
            'Data Science Essentials', 'DevOps Practices', 'UI/UX Design', 'Blockchain Technology',
            'Internet of Things', 'Natural Language Processing', 'Computer Vision', 'Robotics', 'Game Development',
            'Digital Marketing'
        };
        
        List<String> levels = new List<String>{'Beginner', 'Intermediate', 'Advanced'};
        List<String> statuses = new List<String>{'Active', 'Inactive', 'Draft'};
        
        for (Integer i = 0; i < 20; i++) {
            Learning_Course__c course = new Learning_Course__c(
                Course_Description__c = 'Comprehensive course covering ' + courseNames[i].toLowerCase() + ' with hands-on projects and real-world applications.',
                Course_Duration__c = 40 + (Math.mod(i, 20) * 5),
                Course_Level__c = levels[Math.mod(i, levels.size())],
                Course_Status__c = statuses[Math.mod(i, statuses.size())]
            );
            courses.add(course);
        }
        
        return courses;
    }
    
    private static List<Course_Enrollment__c> createCourseEnrollments(List<Student__c> students, List<Learning_Course__c> courses, List<Corporate_Client__c> clients) {
        List<Course_Enrollment__c> enrollments = new List<Course_Enrollment__c>();
        
        List<String> statuses = new List<String>{'Enrolled', 'In Progress', 'Completed', 'Dropped'};
        
        // Create enrollments for each student in multiple courses
        for (Integer i = 0; i < students.size(); i++) {
            // Each student enrolls in 2-4 courses
            Integer numEnrollments = 2 + Math.mod(i, 3);
            
            for (Integer j = 0; j < numEnrollments; j++) {
                Integer courseIndex = Math.mod(i + j, courses.size());
                Integer clientIndex = Math.mod(i + j, clients.size());
                
                Course_Enrollment__c enrollment = new Course_Enrollment__c(
                    Student__c = students[i].Id,
                    Course__c = courses[courseIndex].Id,
                    Corporate_Client__c = clients[clientIndex].Id,
                    Enrollment_Date__c = Date.today().addDays(-30 - i * 5),
                    Completion_Date__c = Math.mod(i, 3) == 0 ? Date.today().addDays(-10) : null,
                    Status__c = statuses[Math.mod(i + j, statuses.size())],
                    Progress_Percentage__c = 25 + (Math.mod(i + j, 75)),
                    Certificate_Issued__c = Math.mod(i + j, 3) == 0,
                    Student_Name__c = students[i].First_Name__c + ' ' + students[i].Last_Name__c,
                    Student_Email__c = students[i].Email__c,
                    Student_Phone__c = students[i].Phone__c
                );
                enrollments.add(enrollment);
            }
        }
        
        return enrollments;
    }
    
    private static List<AI_Insights__c> createAIInsights() {
        List<AI_Insights__c> insights = new List<AI_Insights__c>();
        
        List<String> insightTypes = new List<String>{'Learner Engagement', 'Client Relationship', 'Growth Opportunity', 'Course Optimization', 'Market Trend'};
        
        // Create insights
        for (Integer i = 0; i < 20; i++) {
            AI_Insights__c insight = new AI_Insights__c(
                Insight_Type__c = insightTypes[Math.mod(i, insightTypes.size())],
                AI_Confidence_Score__c = 0.7 + (Math.mod(i, 30) * 0.01)
            );
            insights.add(insight);
        }
        
        return insights;
    }
}
