import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getEnrollments from '@salesforce/apex/EnrollmentController.getEnrollments';
import getLearningCourses from '@salesforce/apex/LearningCourseController.getLearningCourses';
import getCorporateClients from '@salesforce/apex/CorporateClientController.getCorporateClients';
import getStudents from '@salesforce/apex/StudentController.getStudents';

// Note: EnrollmentProgress component is used in the HTML template

export default class CoralCourseEnrollments extends NavigationMixin(LightningElement) {
    @track enrollments = [];
    @track filteredEnrollments = [];
    @track showNewEnrollmentModal = false;
    @track searchTerm = '';
    @track error;
    @track isLoading = true;
    @track currentPage = 1;
    @track pageSize = 6; // Show 6 enrollments per page (2 rows of 3)
    @track viewMode = 'list'; // 'cards' or 'list'
    
    // Available courses and clients for dropdowns
    @track courses = [];
    @track clients = [];
    @track students = [];
    
    newEnrollment = {
        Student_Name__c: '',
        Student_Email__c: '',
        Course__c: ''
    };

    get currentDate() {
        return new Date().toLocaleDateString();
    }

    get totalEnrollments() {
        return this.enrollments.length;
    }

    get inProgressCount() {
        return this.enrollments.filter(enrollment => {
            const progress = enrollment.Progress_Percentage__c || 0;
            return progress > 0 && progress < 100;
        }).length;
    }

    get completedCount() {
        return this.enrollments.filter(enrollment => {
            const progress = enrollment.Progress_Percentage__c || 0;
            return progress === 100;
        }).length;
    }

    get averageProgress() {
        if (this.enrollments.length === 0) return 0;
        const totalProgress = this.enrollments.reduce((sum, enrollment) => 
            sum + (enrollment.Progress_Percentage__c || 0), 0
        );
        return Math.round(totalProgress / this.enrollments.length);
    }





    @wire(getEnrollments)
    wiredEnrollments({ error, data }) {
        this.isLoading = false;
        if (data) {
            // Process the data to add computed properties and handle missing data
            this.enrollments = data.map(enrollment => {
                return {
                    ...enrollment,
                    // Ensure related objects exist
                    Course__r: enrollment.Course__r || { Name: 'Unknown Course' },
                    Student__r: enrollment.Student__r || { First_Name__c: 'Unknown', Last_Name__c: 'Student', Email__c: '' },
                    // Handle both old and new field structures
                    fullName: this.getStudentName(enrollment),
                    studentEmail: this.getStudentEmail(enrollment),
                    // Format dates safely
                    formattedCreatedDate: this.formatDate(enrollment.CreatedDate),
                    // Use real progress data from database
                    Progress_Percentage__c: enrollment.Progress_Percentage__c || 0
                };
            });
            this.filteredEnrollments = this.enrollments;
            this.currentPage = 1; // Reset to first page when data loads
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.enrollments = [];
            this.filteredEnrollments = [];
        }
    }

    @wire(getLearningCourses)
    wiredCourses({ error, data }) {
        if (data) {
            this.courses = data.map(course => ({
                label: course.Name,
                value: course.Id
            }));
        }
    }

    @wire(getCorporateClients)
    wiredClients({ error, data }) {
        if (data) {
            this.clients = data.map(client => ({
                label: client.Name,
                value: client.Id
            }));
        }
    }

    @wire(getStudents)
    wiredStudents({ error, data }) {
        if (data) {
            this.students = data.map(student => ({
                label: `${student.First_Name__c} ${student.Last_Name__c} (${student.Email__c})`,
                value: student.Id
            }));
        }
    }

    handleNewEnrollment() {
        this.showNewEnrollmentModal = true;
    }

    handleCloseModal() {
        this.showNewEnrollmentModal = false;
        this.resetNewEnrollment();
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this.newEnrollment[name] = value;
    }

    handleSaveEnrollment() {
        // TODO: Implement save functionality with Apex
        this.showNewEnrollmentModal = false;
        this.resetNewEnrollment();
    }

    resetNewEnrollment() {
        this.newEnrollment = {
            Student__c: '',
            Course__c: ''
        };
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.currentPage = 1; // Reset to first page when searching
        this.filterEnrollments();
    }

    filterEnrollments() {
        if (!this.searchTerm) {
            this.filteredEnrollments = this.enrollments;
        } else {
            this.filteredEnrollments = this.enrollments.filter(enrollment => {
                const searchLower = this.searchTerm.toLowerCase();
                
                // Safely check student name
                const fullName = enrollment.fullName || '';
                if (fullName.toLowerCase().includes(searchLower)) return true;
                
                // Safely check student email
                const studentEmail = enrollment.studentEmail || '';
                if (studentEmail.toLowerCase().includes(searchLower)) return true;
                
                // Safely check course name
                const courseName = enrollment.Course__r?.Name || '';
                if (courseName.toLowerCase().includes(searchLower)) return true;
                
                return false;
            });
        }
    }

    // Pagination functionality
    get totalPages() {
        return Math.ceil(this.filteredEnrollments.length / this.pageSize);
    }

    get paginatedEnrollments() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.filteredEnrollments.slice(start, end);
    }

    get hasNextPage() {
        return this.currentPage < this.totalPages;
    }

    get hasPreviousPage() {
        return this.currentPage > 1;
    }

    get isPreviousDisabled() {
        return !this.hasPreviousPage;
    }

    get isNextDisabled() {
        return !this.hasNextPage;
    }

    get pageInfo() {
        const start = (this.currentPage - 1) * this.pageSize + 1;
        const end = Math.min(this.currentPage * this.pageSize, this.filteredEnrollments.length);
        const total = this.filteredEnrollments.length;
        return `Showing ${start}-${end} of ${total} enrollments`;
    }

    get pageOptions() {
        const options = [];
        for (let i = 1; i <= this.totalPages; i++) {
            options.push({
                label: `Page ${i}`,
                value: i
            });
        }
        return options;
    }

    handlePreviousPage() {
        if (this.hasPreviousPage) {
            this.currentPage--;
        }
    }

    handleNextPage() {
        if (this.hasNextPage) {
            this.currentPage++;
        }
    }

    handlePageChange(event) {
        const page = parseInt(event.target.value);
        if (page >= 1 && page <= this.totalPages) {
            this.currentPage = page;
        }
    }

    handleEnrollmentClick(event) {
        // Prevent event bubbling
        event.preventDefault();
        event.stopPropagation();
        
        // Get the enrollment ID from the clicked element or its parent
        let enrollmentId = event.currentTarget.dataset.id;
        
        // If no ID found, try to find it in parent elements
        if (!enrollmentId) {
            const parentWithId = event.target.closest('[data-id]');
            if (parentWithId) {
                enrollmentId = parentWithId.dataset.id;
            }
        }
        
        if (enrollmentId) {
            console.log('✅ Navigating to enrollment:', enrollmentId);
            
            // Navigate to the enrollment record detail page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: enrollmentId,
                    objectApiName: 'Course_Enrollment__c',
                    actionName: 'view'
                }
            });
        } else {
            console.error('❌ No enrollment ID found for click event');
            console.log('❌ Event target:', event.target);
            console.log('❌ Current target:', event.currentTarget);
        }
    }



    get hasEnrollments() {
        return this.filteredEnrollments && this.filteredEnrollments.length > 0;
    }

    get enrollmentCount() {
        return this.filteredEnrollments ? this.filteredEnrollments.length : 0;
    }

    get searchResultsInfo() {
        if (this.searchTerm && this.enrollments.length !== this.filteredEnrollments.length) {
            return `Showing ${this.filteredEnrollments.length} of ${this.enrollments.length} enrollments`;
        }
        return '';
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString();
    }

    getStudentName(enrollment) {
        // Try new Student__c relationship first
        if (enrollment.Student__r?.First_Name__c && enrollment.Student__r?.Last_Name__c) {
            return `${enrollment.Student__r.First_Name__c} ${enrollment.Student__r.Last_Name__c}`.trim();
        }
        // Fall back to old Student_Name__c field
        if (enrollment.Student_Name__c) {
            return enrollment.Student_Name__c;
        }
        return 'Unknown Student';
    }

    getStudentEmail(enrollment) {
        // Try new Student__c relationship first
        if (enrollment.Student__r?.Email__c) {
            return enrollment.Student__r.Email__c;
        }
        // Fall back to old Student_Email__c field
        if (enrollment.Student_Email__c) {
            return enrollment.Student_Email__c;
        }
        return 'No Email';
    }

    handleStudentClick(event) {
        event.preventDefault();
        event.stopPropagation();
        
        const studentId = event.currentTarget.dataset.studentId;
        if (studentId) {
            console.log('✅ Navigating to student:', studentId);
            
            // Navigate to the student record detail page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: studentId,
                    objectApiName: 'Student__c',
                    actionName: 'view'
                }
            });
        }
    }
}
