// Sample Data Creation Script for Coral Learning
// Run this in Developer Console or via SFDX

// Create sample Learning Courses
List<Learning_Course__c> courses = new List<Learning_Course__c>();

Learning_Course__c course1 = new Learning_Course__c(
    Course_Description__c = 'Introduction to Salesforce Development',
    Course_Duration__c = 8.0,
    Course_Level__c = 'Beginner',
    Course_Status__c = 'Active'
);
courses.add(course1);

Learning_Course__c course2 = new Learning_Course__c(
    Course_Description__c = 'Advanced Apex Programming',
    Course_Duration__c = 12.0,
    Course_Level__c = 'Advanced',
    Course_Status__c = 'Active'
);
courses.add(course2);

Learning_Course__c course3 = new Learning_Course__c(
    Course_Description__c = 'Lightning Web Components Fundamentals',
    Course_Duration__c = 6.0,
    Course_Level__c = 'Intermediate',
    Course_Status__c = 'Active'
);
courses.add(course3);

Learning_Course__c course4 = new Learning_Course__c(
    Course_Description__c = 'Salesforce Integration Patterns',
    Course_Duration__c = 10.0,
    Course_Level__c = 'Expert',
    Course_Status__c = 'Draft'
);
courses.add(course4);

// Insert courses
try {
    insert courses;
    System.debug('Successfully created ' + courses.size() + ' learning courses');
} catch (Exception e) {
    System.debug('Error creating courses: ' + e.getMessage());
}

// Create sample Corporate Clients
List<Corporate_Client__c> clients = new List<Corporate_Client__c>();

Corporate_Client__c client1 = new Corporate_Client__c(
    Name = 'TechCorp Solutions',
    Company_Industry__c = 'Technology'
);
clients.add(client1);

Corporate_Client__c client2 = new Corporate_Client__c(
    Name = 'Global Manufacturing Inc',
    Company_Industry__c = 'Manufacturing'
);
clients.add(client2);

Corporate_Client__c client3 = new Corporate_Client__c(
    Name = 'Financial Services Group',
    Company_Industry__c = 'Financial Services'
);
clients.add(client3);

// Insert clients
try {
    insert clients;
    System.debug('Successfully created ' + clients.size() + ' corporate clients');
} catch (Exception e) {
    System.debug('Error creating clients: ' + e.getMessage());
}

// Create sample AI Insights
List<AI_Insights__c> insights = new List<AI_Insights__c>();

AI_Insights__c insight1 = new AI_Insights__c(
    Name = 'High Engagement in Beginner Courses',
    Insight_Type__c = 'Learning Pattern',
    AI_Confidence_Score__c = 0.92
);
insights.add(insight1);

AI_Insights__c insight2 = new AI_Insights__c(
    Name = 'Technology Industry Growth Trend',
    Insight_Type__c = 'Market Analysis',
    AI_Confidence_Score__c = 0.87
);
insights.add(insight2);

AI_Insights__c insight3 = new AI_Insights__c(
    Name = 'Advanced Course Completion Rate',
    Insight_Type__c = 'Performance Metric',
    AI_Confidence_Score__c = 0.78
);
insights.add(insight3);

// Insert insights
try {
    insert insights;
    System.debug('Successfully created ' + insights.size() + ' AI insights');
} catch (Exception e) {
    System.debug('Error creating insights: ' + e.getMessage());
}

System.debug('Sample data creation complete!');
