/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAcceptOfferUpdateCounts_trg {

    static testMethod void myUnitTest() {
        
        Account a = new Account();
        a.name = 'Test Method Account';
        insert a;
        
        Contact c = new Contact();
        c.firstName = 'Test';
        c.lastName = 'Method ';
        c.accountid = a.id;
        insert c;
        
        
        Offer__c offer = new Offer__c();
        offer.description__c = 'Test Method Offer';
        offer.original_units_available__c = 50;
        
        insert offer;
        
        Offer_Acceptance__c acceptance = new Offer_Acceptance__c();
        acceptance.offer__c = offer.id;
        acceptance.contact__c = c.id;
        
        insert acceptance;
        
        
        
        offer = [select id,current_units_available__c,acceptances__c from Offer__c where id=:offer.id limit 1];
        
        Test.startTest();
        
        
        System.assertEquals(offer.acceptances__c, 1);
        
        c = [select id,offers_accepted__c from Contact where id=:c.id limit 1];
        
        System.assertEquals(1,c.offers_accepted__c);
        
        offer = [select id,current_units_available__c from Offer__c where id=:offer.id limit 1];
        
        System.assertEquals(49,offer.current_units_available__c);
        
        
        delete acceptance;
        
        c = [select id,offers_accepted__c from Contact where id=:c.id limit 1];
        
        System.assertEquals(0,c.offers_accepted__c);
        
        
        offer = [select id,current_units_available__c from Offer__c where id=:offer.id limit 1];
        
        System.assertEquals(50,offer.current_units_available__c);
        
        Test.StopTest();
        
        
        
    }
}