import { createElement } from 'lwc';
import EnrollmentProgress from '../enrollmentProgress';

describe('c-enrollment-progress', () => {
    let element;

    beforeEach(() => {
        element = createElement('c-enrollment-progress', {
            is: EnrollmentProgress
        });
    });

    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should create the component', () => {
        document.body.appendChild(element);
        expect(element).toBeTruthy();
    });

    it('should display progress percentage correctly', () => {
        element.progressPercentage = 75;
        document.body.appendChild(element);
        
        const percentageElement = element.shadowRoot.querySelector('.percentage');
        expect(percentageElement.textContent).toBe('75%');
    });

    it('should apply correct status class', () => {
        element.enrollmentStatus = 'Completed';
        document.body.appendChild(element);
        
        const statusBadge = element.shadowRoot.querySelector('.status-badge');
        expect(statusBadge.className).toContain('status-completed');
    });

    it('should handle missing progress data gracefully', () => {
        element.progressPercentage = null;
        element.enrollmentStatus = '';
        document.body.appendChild(element);
        
        const percentageElement = element.shadowRoot.querySelector('.percentage');
        expect(percentageElement.textContent).toBe('0%');
        
        const statusBadge = element.shadowRoot.querySelector('.status-badge');
        expect(statusBadge.className).toContain('status-enrolled');
    });

    it('should show admin action buttons', () => {
        element.enrollmentId = 'test-id';
        element.enrollmentDate = '2024-01-01';
        element.progressPercentage = 50;
        element.enrollmentStatus = 'In Progress';
        document.body.appendChild(element);
        
        // Debug: log the HTML to see what's actually rendered
        console.log('Component HTML:', element.shadowRoot.innerHTML);
        
        const editButton = element.shadowRoot.querySelector('lightning-button-icon[title="Edit Progress"]');
        const viewButton = element.shadowRoot.querySelector('lightning-button-icon[title="View Details"]');
        
        console.log('Edit button found:', editButton);
        console.log('View button found:', viewButton);
        
        expect(editButton).toBeTruthy();
        expect(viewButton).toBeTruthy();
    });

    it('should show stuck progress warning when applicable', () => {
        element.enrollmentId = 'test-id';
        element.lastActivityDate = '2024-01-01';
        element.progressPercentage = 50;
        element.enrollmentStatus = 'In Progress';
        document.body.appendChild(element);
        
        // Mock current date to be 10 days after last activity
        const originalDate = global.Date;
        global.Date = class extends Date {
            constructor() {
                super('2024-01-11');
            }
        };
        
        const warningButton = element.shadowRoot.querySelector('.warning-icon');
        expect(warningButton).toBeTruthy();
        
        global.Date = originalDate;
    });

    it('should dispatch edit progress event', () => {
        element.enrollmentId = 'test-id';
        element.enrollmentDate = '2024-01-01';
        element.progressPercentage = 75;
        element.enrollmentStatus = 'In Progress';
        document.body.appendChild(element);
        
        const editButton = element.shadowRoot.querySelector('lightning-button-icon[title="Edit Progress"]');
        
        const mockHandler = jest.fn();
        element.addEventListener('editprogress', mockHandler);
        
        editButton.click();
        
        expect(mockHandler).toHaveBeenCalledWith(
            expect.objectContaining({
                detail: {
                    enrollmentId: 'test-id',
                    currentProgress: 75,
                    currentStatus: 'In Progress'
                }
            })
        );
    });
});
