import { LightningElement, track, wire } from 'lwc';
import getReviews from '@salesforce/apex/CourseReviewController.getReviews';
import createReview from '@salesforce/apex/CourseReviewController.createReview';

export default class CourseReview extends LightningElement {
    @track reviews;
    @track rating;
    @track reviewText;

    @wire(getReviews, { courseId: 'YOUR_COURSE_ID' }) // Replace with actual course ID
    wiredReviews({ error, data }) {
        if (data) {
            this.reviews = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleSubmit() {
        const review = {
            Course__c: 'YOUR_COURSE_ID', // Replace with actual course ID
            Rating__c: this.rating,
            Review__c: this.reviewText,
            Reviewer__c: UserInfo.getUserId() // Assuming you have a way to get the current user's ID
        };

        createReview({ review })
            .then(() => {
                this.rating = '';
                this.reviewText = '';
                return getReviews({ courseId: 'YOUR_COURSE_ID' }); // Refresh reviews
            })
            .catch(error => {
                console.error(error);
            });
    }
}
