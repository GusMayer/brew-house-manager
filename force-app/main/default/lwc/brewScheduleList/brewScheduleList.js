/* eslint-disable no-console */
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';
import { LightningElement, wire } from 'lwc';
import getBrewSchedules from '@salesforce/apex/BrewScheduleController.getBrewSchedules';
export default class BrewScheduleList extends NavigationMixin(LightningElement) {
	@wire(getBrewSchedules) brewSchedules;
	@wire(CurrentPageReference) pageRef;
	
	handleViewSteps(event) {
		const scheduleId = event.target.dataset.recordid;
		fireEvent(this.pageRef, 'viewStepsEvent', scheduleId);
	}
}