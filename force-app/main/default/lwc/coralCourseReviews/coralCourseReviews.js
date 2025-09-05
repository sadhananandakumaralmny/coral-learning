import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCourseReviews from '@salesforce/apex/CourseReviewController.getCourseReviews';
import getCourseReviewSummary from '@salesforce/apex/CourseReviewController.getCourseReviewSummary';
import createCourseReview from '@salesforce/apex/CourseReviewController.createCourseReview';
import getStudentsForCourse from '@salesforce/apex/CourseReviewController.getStudentsForCourse';
import hasStudentReviewedCourse from '@salesforce/apex/CourseReviewController.hasStudentReviewedCourse';

const FIELDS = ['Learning_Course__c.Name'];

export default class CoralCourseReviews extends LightningElement {
    @api recordId;
    @track reviews = [];
    @track reviewSummary = {};
    @track students = [];
    @track showAddReviewModal = false;
    @track newReview = {
        courseId: '',
        studentId: '',
        rating: 5,
        reviewText: ''
    };
    @track isLoading = false;
    @track error = undefined;
    @track hasExistingReview = false;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCourse({ error, data }) {
        if (data) {
            this.newReview.courseId = this.recordId;
        } else if (error) {
            this.error = error.body?.message || error.message || 'An error occurred while loading course data.';
        }
    }

    @wire(getCourseReviews, { courseId: '$recordId' })
    wiredReviews({ error, data }) {
        if (data) {
            this.reviews = data.map(review => ({
                ...review,
                studentName: `${review.Student__r?.First_Name__c || ''} ${review.Student__r?.Last_Name__c || ''}`.trim(),
                formattedReviewDate: this.formatDate(review.Review_Date__c),
                starRating: this.generateStarRating(review.Rating__c)
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || error.message || 'An error occurred while loading reviews.';
            this.reviews = [];
        }
    }

    @wire(getCourseReviewSummary, { courseId: '$recordId' })
    wiredReviewSummary({ error, data }) {
        if (data) {
            this.reviewSummary = {
                ...data,
                averageRating: data.averageRating ? data.averageRating.toFixed(1) : '0.0',
                starRating: this.generateStarRating(data.averageRating || 0)
            };
        } else if (error) {
            this.error = error.body?.message || error.message || 'An error occurred while loading review summary.';
        }
    }

    @wire(getStudentsForCourse, { courseId: '$recordId' })
    wiredStudents({ error, data }) {
        if (data) {
            this.students = data.map(student => ({
                label: `${student.First_Name__c} ${student.Last_Name__c}`,
                value: student.Id
            }));
        } else if (error) {
            this.error = error.body?.message || error.message || 'An error occurred while loading students.';
        }
    }

    handleAddReview() {
        this.showAddReviewModal = true;
    }

    handleCloseModal() {
        this.showAddReviewModal = false;
        this.resetNewReview();
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this.newReview[name] = value;
    }

    handleStudentChange(event) {
        this.newReview.studentId = event.detail.value;
        this.checkExistingReview();
    }

    async checkExistingReview() {
        if (this.newReview.studentId && this.recordId) {
            try {
                this.hasExistingReview = await hasStudentReviewedCourse({
                    courseId: this.recordId,
                    studentId: this.newReview.studentId
                });
            } catch (error) {
                console.error('Error checking existing review:', error);
            }
        }
    }

    async handleSaveReview() {
        if (!this.newReview.studentId || !this.newReview.rating || !this.newReview.reviewText) {
            this.error = 'Please fill in all required fields.';
            return;
        }

        if (this.hasExistingReview) {
            this.error = 'This student has already reviewed this course.';
            return;
        }

        this.isLoading = true;
        this.error = undefined;

        try {
            await createCourseReview({ reviewData: JSON.stringify(this.newReview) });
            this.showAddReviewModal = false;
            this.resetNewReview();
            // Refresh the data
            this.dispatchEvent(new CustomEvent('refresh'));
        } catch (error) {
            this.error = error.body?.message || error.message || 'An error occurred while saving the review.';
        } finally {
            this.isLoading = false;
        }
    }

    resetNewReview() {
        this.newReview = {
            courseId: this.recordId,
            studentId: '',
            rating: 5,
            reviewText: ''
        };
        this.hasExistingReview = false;
        this.error = undefined;
    }

    generateStarRating(rating) {
        const fullStars = Math.floor(rating);
        const hasHalfStar = rating % 1 >= 0.5;
        const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
        
        let stars = '';
        for (let i = 0; i < fullStars; i++) {
            stars += '★';
        }
        if (hasHalfStar) {
            stars += '☆';
        }
        for (let i = 0; i < emptyStars; i++) {
            stars += '☆';
        }
        return stars;
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }

    get hasReviews() {
        return this.reviews && this.reviews.length > 0;
    }

    get hasStudents() {
        return this.students && this.students.length > 0;
    }

    get ratingOptions() {
        return [
            { label: '5 Stars - Excellent', value: 5 },
            { label: '4 Stars - Good', value: 4 },
            { label: '3 Stars - Average', value: 3 },
            { label: '2 Stars - Poor', value: 2 },
            { label: '1 Star - Very Poor', value: 1 }
        ];
    }

    get canAddReview() {
        return this.hasStudents && !this.isLoading;
    }

    get canAddReviewDisabled() {
        return !this.hasStudents || this.isLoading;
    }

    get reviewCountText() {
        return this.reviewSummary && this.reviewSummary.reviewCount !== 1 ? 's' : '';
    }
}
