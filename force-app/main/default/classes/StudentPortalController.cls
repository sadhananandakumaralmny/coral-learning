public with sharing class StudentPortalController {
    
    // Properties for the student portal
    public String studentName { get; set; }
    public List<Course_Enrollment__c> enrollments { get; set; }
    public Boolean isLoading { get; set; }
    public Boolean hasEnrollments { get; set; }
    
    // Statistics properties
    public Integer totalEnrollments { get; set; }
    public Integer inProgressCount { get; set; }
    public Integer completedCount { get; set; }
    public Integer averageProgress { get; set; }
    
    // Constructor
    public StudentPortalController() {
        this.isLoading = true;
        this.hasEnrollments = false;
        initializeStudentData();
    }
    
    // Initialize student data
    private void initializeStudentData() {
        try {
            // Get current user (student)
            User currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            this.studentName = currentUser.Name;
            
            // Get student record by email
            if (currentUser.Email != null) {
                Student__c student = [SELECT Id, First_Name__c, Last_Name__c, Email__c FROM Student__c WHERE Email__c = :currentUser.Email LIMIT 1];
                
                if (student != null) {
                    // Load enrollments for this student
                    loadStudentEnrollments(student.Id);
                } else {
                    // No student record found
                    this.enrollments = new List<Course_Enrollment__c>();
                    this.hasEnrollments = false;
                }
            } else {
                // No email associated with user
                this.enrollments = new List<Course_Enrollment__c>();
                this.hasEnrollments = false;
            }
            
        } catch (Exception e) {
            // Handle errors gracefully
            System.debug('Error initializing student data: ' + e.getMessage());
            this.enrollments = new List<Course_Enrollment__c>();
            this.hasEnrollments = false;
        } finally {
            this.isLoading = false;
        }
    }
    
    // Load student enrollments
    private void loadStudentEnrollments(Id studentId) {
        try {
            // Query enrollments for the student
            this.enrollments = [
                SELECT Id, Name, Course__c,
                       Student__c, Student__r.First_Name__c, Student__r.Last_Name__c,
                       Progress_Percentage__c, Status__c, Enrollment_Date__c,
                       Completion_Date__c, Certificate_Issued__c, CreatedDate
                FROM Course_Enrollment__c 
                WHERE Student__c = :studentId
                ORDER BY CreatedDate DESC
            ];
            
            this.hasEnrollments = !this.enrollments.isEmpty();
            
            // Calculate statistics
            calculateStatistics();
            
        } catch (Exception e) {
            System.debug('Error loading student enrollments: ' + e.getMessage());
            this.enrollments = new List<Course_Enrollment__c>();
            this.hasEnrollments = false;
        }
    }
    
    // Calculate enrollment statistics
    private void calculateStatistics() {
        if (this.enrollments == null || this.enrollments.isEmpty()) {
            this.totalEnrollments = 0;
            this.inProgressCount = 0;
            this.completedCount = 0;
            this.averageProgress = 0;
            return;
        }
        
        this.totalEnrollments = this.enrollments.size();
        
        // Count in progress and completed enrollments
        this.inProgressCount = 0;
        this.completedCount = 0;
        Integer totalProgress = 0;
        
        for (Course_Enrollment__c enrollment : this.enrollments) {
            Decimal progress = enrollment.Progress_Percentage__c != null ? enrollment.Progress_Percentage__c : 0;
            totalProgress += Integer.valueOf(progress);
            
            if (progress == 100) {
                this.completedCount++;
            } else if (progress > 0) {
                this.inProgressCount++;
            }
        }
        
        // Calculate average progress
        this.averageProgress = this.totalEnrollments > 0 ? Math.round(totalProgress / this.totalEnrollments) : 0;
    }
    
    // Logout action
    public PageReference logout() {
        try {
            // Logout the user
            PageReference logoutPage = new PageReference('/secur/logout.jsp');
            logoutPage.setRedirect(true);
            return logoutPage;
        } catch (Exception e) {
            System.debug('Error during logout: ' + e.getMessage());
            return null;
        }
    }
    
    // Get formatted date
    public String getFormattedDate(DateTime dt) {
        if (dt == null) return '';
        return dt.format('MMM dd, yyyy');
    }
    
    // Get formatted date only
    public String getFormattedDateOnly(Date dateOnly) {
        if (dateOnly == null) return '';
        return dateOnly.format();
    }
}
