import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getDashboardStats from '@salesforce/apex/DashboardController.getDashboardStats';
import getRecentEnrollments from '@salesforce/apex/DashboardController.getRecentEnrollments';
import getTopCourses from '@salesforce/apex/DashboardController.getTopCourses';

export default class CoralDashboard extends NavigationMixin(LightningElement) {
    @track dashboardStats = {};
    @track recentEnrollments = [];
    @track topCourses = [];
    @track isLoading = true;
    @track error;

    @wire(getDashboardStats)
    wiredDashboardStats({ error, data }) {
        if (data) {
            this.dashboardStats = data;
            this.error = undefined;
            console.log('📊 Dashboard stats loaded:', data);
        } else if (error) {
            this.error = error;
            console.error('❌ Error loading dashboard stats:', error);
        }
    }

    @wire(getRecentEnrollments)
    wiredRecentEnrollments({ error, data }) {
        if (data) {
            this.recentEnrollments = data.map(enrollment => ({
                ...enrollment,
                fullName: this.getStudentName(enrollment),
                formattedDate: this.formatDate(enrollment.CreatedDate)
            }));
            this.error = undefined;
            console.log('📊 Recent enrollments loaded:', data);
        } else if (error) {
            this.error = error;
            console.error('❌ Error loading recent enrollments:', error);
        }
    }

    @wire(getTopCourses)
    wiredTopCourses({ error, data }) {
        if (data) {
            this.topCourses = data;
            this.error = undefined;
            console.log('📊 Top courses loaded:', data);
            this.isLoading = false;
        } else if (error) {
            this.error = error;
            console.error('❌ Error loading top courses:', error);
            this.isLoading = false;
        }
    }

    getStudentName(enrollment) {
        if (enrollment.Student__r?.First_Name__c && enrollment.Student__r?.Last_Name__c) {
            return `${enrollment.Student__r.First_Name__c} ${enrollment.Student__r.Last_Name__c}`;
        }
        if (enrollment.Student_Name__c) {
            return enrollment.Student_Name__c;
        }
        return 'Unknown Student';
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString();
    }

    handleNavigation(event) {
        const tabName = event.currentTarget.dataset.tab;
        if (tabName) {
            this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: tabName
                }
            });
        }
    }

    handleStudentClick(event) {
        event.preventDefault();
        event.stopPropagation();
        
        const studentId = event.currentTarget.dataset.studentId;
        if (studentId) {
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

    get hasRecentEnrollments() {
        return this.recentEnrollments && this.recentEnrollments.length > 0;
    }

    get hasTopCourses() {
        return this.topCourses && this.topCourses.length > 0;
    }

    get enrollmentCount() {
        return this.recentEnrollments ? this.recentEnrollments.length : 0;
    }

    get courseCount() {
        return this.topCourses ? this.topCourses.length : 0;
    }
}
