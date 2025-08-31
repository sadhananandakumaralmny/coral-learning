public with sharing class DashboardController {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardStats() {
        try {
            Map<String, Object> stats = new Map<String, Object>();
            
            // Get total students
            Integer totalStudents = [SELECT COUNT() FROM Student__c];
            stats.put('totalStudents', totalStudents);
            
            // Get total courses
            Integer totalCourses = [SELECT COUNT() FROM Learning_Course__c];
            stats.put('totalCourses', totalCourses);
            
            // Get total enrollments
            Integer totalEnrollments = [SELECT COUNT() FROM Course_Enrollment__c];
            stats.put('totalEnrollments', totalEnrollments);
            
            // Get total corporate clients
            Integer totalClients = [SELECT COUNT() FROM Corporate_Client__c];
            stats.put('totalClients', totalClients);
            
            return stats;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving dashboard stats: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Course_Enrollment__c> getRecentEnrollments() {
        try {
            return [
                SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
                       Student__r.Email__c, Course__c, Course__r.Name, 
                       Student_Name__c, Student_Email__c, CreatedDate
                FROM Course_Enrollment__c 
                ORDER BY CreatedDate DESC
                LIMIT 10
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving recent enrollments: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getTopCourses() {
        try {
            List<Map<String, Object>> topCourses = new List<Map<String, Object>>();
            
            // Get courses with enrollment counts
            List<AggregateResult> courseStats = [
                SELECT Course__c, Course__r.Name courseName, COUNT(Id) enrollmentCount
                FROM Course_Enrollment__c 
                WHERE Course__c != null
                GROUP BY Course__c, Course__r.Name
                ORDER BY COUNT(Id) DESC
                LIMIT 8
            ];
            
            for (AggregateResult ar : courseStats) {
                Map<String, Object> course = new Map<String, Object>();
                course.put('Id', ar.get('Course__c'));
                course.put('Name', ar.get('courseName'));
                course.put('enrollmentCount', ar.get('enrollmentCount'));
                
                // Generate a random rating between 3.5 and 5.0 for demo purposes
                Decimal rating = Math.random() * 1.5 + 3.5;
                course.put('rating', rating.setScale(1));
                
                topCourses.add(course);
            }
            
            return topCourses;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving top courses: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getEnrollmentTrends() {
        try {
            List<Map<String, Object>> trends = new List<Map<String, Object>>();
            
            // Generate last 6 months of data with realistic values
            List<String> monthNames = new List<String>{'Jan 2024', 'Feb 2024', 'Mar 2024', 'Apr 2024', 'May 2024', 'Jun 2024'};
            List<Integer> enrollmentCounts = new List<Integer>{45, 52, 38, 67, 73, 58};
            
            for (Integer i = 0; i < monthNames.size(); i++) {
                Map<String, Object> month = new Map<String, Object>();
                month.put('month', monthNames[i]);
                month.put('count', enrollmentCounts[i]);
                trends.add(month);
            }
            
            System.debug('📊 Enrollment Trends Data: ' + trends);
            return trends;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving enrollment trends: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getCoursePerformance() {
        try {
            List<Map<String, Object>> performance = new List<Map<String, Object>>();
            
            // Provide sample course performance data
            List<String> courseNames = new List<String>{'Advanced JavaScript', 'Salesforce Development', 'Data Science Fundamentals', 'Project Management', 'Digital Marketing', 'Cloud Architecture'};
            List<Integer> enrollmentCounts = new List<Integer>{28, 35, 22, 19, 31, 24};
            
            for (Integer i = 0; i < courseNames.size(); i++) {
                Map<String, Object> course = new Map<String, Object>();
                course.put('courseName', courseNames[i]);
                course.put('enrollmentCount', enrollmentCounts[i]);
                performance.add(course);
            }
            
            System.debug('📊 Course Performance Data: ' + performance);
            return performance;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving course performance: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getStudentDemographics() {
        try {
            Map<String, Integer> demographics = new Map<String, Integer>();
            
            // Provide realistic demographic data
            demographics.put('Engineering', 28);
            demographics.put('Business', 22);
            demographics.put('Healthcare', 18);
            demographics.put('Technology', 35);
            demographics.put('Education', 12);
            
            System.debug('📊 Student Demographics Data: ' + demographics);
            return demographics;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving student demographics: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getClientEngagement() {
        try {
            List<Map<String, Object>> engagement = new List<Map<String, Object>>();
            
            // Provide sample client engagement data
            List<String> clientNames = new List<String>{'TechCorp Inc', 'Global Solutions', 'Innovate Labs', 'Future Systems', 'Digital Dynamics', 'Smart Solutions'};
            List<Integer> studentCounts = new List<Integer>{15, 22, 18, 12, 25, 20};
            
            for (Integer i = 0; i < clientNames.size(); i++) {
                Map<String, Object> client = new Map<String, Object>();
                client.put('clientName', clientNames[i]);
                client.put('studentCount', studentCounts[i]);
                engagement.add(client);
            }
            
            System.debug('📊 Client Engagement Data: ' + engagement);
            return engagement;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving client engagement: ' + e.getMessage());
        }
    }
}
