/* eslint-disable no-console */
import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import findBrewStepsByBrewSchedule from '@salesforce/apex/BrewStepController.findBrewStepsByBrewSchedule';
export default class BrewStepsList extends NavigationMixin(LightningElement) {
	
	@track brewSteps = [];
    @track error;

	@wire(CurrentPageReference) pageRef;
	connectedCallback() {
		registerListener('viewStepsEvent', this.handleViewSteps, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	handleViewSteps(scheduleId) {
		findBrewStepsByBrewSchedule({scheduleId})
			.then(result => {
				this.brewSteps = result;
                this.error = undefined;
			})
			.catch(error => {
				this.error = error;
				this.brewSteps = undefined;
			});
	}
}