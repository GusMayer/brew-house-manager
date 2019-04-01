/* eslint-disable no-console */
import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import findBrewStepsByBrewSchedule from '@salesforce/apex/BrewStepController.findBrewStepsByBrewSchedule';
export default class BrewStepsList extends LightningElement {
	
	@track brewSteps = [];
    @track error;
	// @wire(findBrewStepsByBrewSchedule, { scheduleId: '$scheduleId' }) brewSteps;

	@wire(CurrentPageReference) pageRef;
	connectedCallback() {
		registerListener('viewStepsEvent', this.handleBearListUpdate, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	handleBearListUpdate(scheduleId) {
		console.log("SCHEDULE ID ARRIVED " + scheduleId);
		
		findBrewStepsByBrewSchedule({scheduleId})
			.then(result => {
				console.log(JSON.stringify(result));
				this.brewSteps = result;
                this.error = undefined;
			})
			.catch(error => {
				this.error = error;
				this.brewSteps = undefined;
			});
	}
}