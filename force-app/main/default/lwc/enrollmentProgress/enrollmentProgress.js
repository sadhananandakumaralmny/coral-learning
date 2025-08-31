import { LightningElement, api } from 'lwc';

export default class EnrollmentProgress extends LightningElement {
    @api progressPercentage = 0;

    get progressBarStyle() {
        return `width: ${this.computedProgressPercentage}%`;
    }

    get computedProgressPercentage() {
        // Ensure the percentage is a valid number and within bounds
        const percentage = parseFloat(this.progressPercentage) || 0;
        return Math.min(Math.max(percentage, 0), 100);
    }
}
