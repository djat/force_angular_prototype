trigger AcceptOfferUpdateCounts on Offer_Acceptance__c (before delete, after insert) {
	
	
			List<Offer_Acceptance__c> acceptances;
	
			if (Trigger.isInsert) {
			acceptances = Trigger.new;
			} else if (Trigger.isDelete) {
				acceptances = Trigger.old;
			}
		
			
			List<Id> contactIds = new List<Id>();
			List<Id> offerIds = new List<Id>();
			
			
			Map<Id,Offer__c> updateOffers = new Map<Id,Offer__c>();
			Map<Id,Contact> updateContacts = new Map<Id,Contact>();
			
			
			for (Offer_Acceptance__c acceptance:acceptances) {
				
				contactIds.add(acceptance.contact__c);
				offerIds.add(acceptance.offer__c);
				
				
			}
			
			Map<Id,Offer__c> offerMap = new Map<Id,Offer__c>([select id,acceptances__c, current_units_available__c,original_units_available__c from Offer__c where id in:offerIds]);
			
			Map<Id,Contact> contactMap = new Map<Id,Contact>([select id,offers_accepted__c from Contact where id in:contactIds]);
			
			
			
			for (Offer_Acceptance__c acceptance:acceptances) {
				
				
				Offer__c offer = offerMap.get(acceptance.offer__c);
				
				Contact contact = contactMap.get(acceptance.contact__c);
					
					if (Trigger.isInsert) {
				
						
						if (offer.acceptances__c==null) {
						
							offer.acceptances__c = 0;
							
						}
						
						offer.acceptances__c = offer.acceptances__c + 1;
						
						offer.current_units_available__c = offer.current_units_available__c - 1;
						
						if (contact.offers_accepted__c==null) {
							
							
							contact.offers_accepted__c=0;
							
						}
						
						contact.offers_accepted__c = contact.offers_accepted__c + 1;
						
						
						
						
					} else if (Trigger.isDelete) {
						
						offer.acceptances__c = offer.acceptances__c - 1;
						
						offer.current_units_available__c = offer.current_units_available__c + 1;
						
						
						contact.offers_accepted__c = contact.offers_accepted__c - 1;
						
						
					}
					
				updateOffers.put(offer.id,offer);
				
				updateContacts.put(contact.id,contact);
						
				
			}
			
			update updateOffers.values();
			
			update updateContacts.values();
			
			
	
	
	
	

}