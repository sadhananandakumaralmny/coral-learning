// Create sample course enrollments
// This script will create sample enrollments to demonstrate the Course Enrollments tab

// First, let's get some existing courses and clients
List<Learning_Course__c> courses = [SELECT Id, Name FROM Learning_Course__c LIMIT 5];
List<Corporate_Client__c> clients = [SELECT Id, Name FROM Corporate_Client__c LIMIT 3];

if (courses.isEmpty()) {
    System.debug('No courses found. Please create some courses first.');
    return;
}

if (clients.isEmpty()) {
    System.debug('No corporate clients found. Please create some clients first.');
    return;
}

// Create sample enrollments
List<Course_Enrollment__c> enrollments = new List<Course_Enrollment__c>();

// Sample student data
List<String> studentNames = new List<String>{
    'Alice Johnson', 'Bob Smith', 'Carol Davis', 'David Wilson', 'Eva Brown',
    'Frank Miller', 'Grace Lee', 'Henry Taylor', 'Ivy Chen', 'Jack Anderson'
};

List<String> studentEmails = new List<String>{
    'alice.johnson@email.com', 'bob.smith@email.com', 'carol.davis@email.com',
    'david.wilson@email.com', 'eva.brown@email.com', 'frank.miller@email.com',
    'grace.lee@email.com', 'henry.taylor@email.com', 'ivy.chen@email.com',
    'jack.anderson@email.com'
};

List<String> studentPhones = new List<String>{
    '+1-555-0101', '+1-555-0102', '+1-555-0103', '+1-555-0104', '+1-555-0105',
    '+1-555-0106', '+1-555-0107', '+1-555-0108', '+1-555-0109', '+1-555-0110'
};

List<String> statuses = new List<String>{'Enrolled', 'In Progress', 'Completed', 'Dropped'};

// Create enrollments
for (Integer i = 0; i < 15; i++) {
    Course_Enrollment__c enrollment = new Course_Enrollment__c();
    
    // Assign random course
    enrollment.Course__c = courses[Math.mod(i, courses.size())].Id;
    
    // Assign random client (some enrollments might not have a client)
    if (Math.mod(i, 3) != 0) { // 2/3 of enrollments will have clients
        enrollment.Corporate_Client__c = clients[Math.mod(i, clients.size())].Id;
    }
    
    // Student details
    enrollment.Student_Name__c = studentNames[Math.mod(i, studentNames.size())];
    enrollment.Student_Email__c = studentEmails[Math.mod(i, studentEmails.size())];
    enrollment.Student_Phone__c = studentPhones[Math.mod(i, studentPhones.size())];
    
    // Enrollment details
    enrollment.Enrollment_Date__c = Date.today().addDays(-Math.mod(i, 30)); // Random dates within last 30 days
    enrollment.Status__c = statuses[Math.mod(i, statuses.size())];
    enrollment.Progress_Percentage__c = Math.mod(i, 101); // Random progress 0-100
    
    // Completion details for completed enrollments
    if (enrollment.Status__c == 'Completed') {
        enrollment.Completion_Date__c = enrollment.Enrollment_Date__c.addDays(Math.mod(i, 30) + 7);
        enrollment.Certificate_Issued__c = true;
    } else {
        enrollment.Certificate_Issued__c = false;
    }
    
    enrollments.add(enrollment);
}

// Insert enrollments
try {
    insert enrollments;
    System.debug('Successfully created ' + enrollments.size() + ' course enrollments');
    
    // Display some details
    for (Course_Enrollment__c e : enrollments) {
        System.debug('Created enrollment: ' + e.Name + ' for ' + e.Student_Name__c + 
                    ' in course ' + e.Course__c + ' with status ' + e.Status__c);
    }
    
} catch (Exception e) {
    System.debug('Error creating enrollments: ' + e.getMessage());
}

