import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getEnrollmentsByStudent from '@salesforce/apex/EnrollmentController.getEnrollmentsByStudent';

export default class CoralStudentEnrollments extends NavigationMixin(LightningElement) {
    @api recordId; // Student record ID
    @track enrollments = [];
    @track isLoading = true;
    @track error;

    @wire(getEnrollmentsByStudent, { studentId: '$recordId' })
    wiredEnrollments({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.enrollments = data.map(enrollment => ({
                ...enrollment,
                fullName: this.getStudentName(enrollment),
                studentEmail: this.getStudentEmail(enrollment),
                formattedCreatedDate: this.formatDate(enrollment.CreatedDate)
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.enrollments = [];
        }
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

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString();
    }

    handleEnrollmentClick(event) {
        const enrollmentId = event.currentTarget.dataset.id;
        if (enrollmentId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: enrollmentId,
                    objectApiName: 'Course_Enrollment__c',
                    actionName: 'view'
                }
            });
        }
    }

    handleCourseClick(event) {
        event.preventDefault();
        event.stopPropagation();
        
        const courseId = event.currentTarget.dataset.courseId;
        if (courseId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: courseId,
                    objectApiName: 'Learning_Course__c',
                    actionName: 'view'
                }
            });
        }
    }

    get hasEnrollments() {
        return this.enrollments && this.enrollments.length > 0;
    }

    get enrollmentCount() {
        return this.enrollments ? this.enrollments.length : 0;
    }
}
