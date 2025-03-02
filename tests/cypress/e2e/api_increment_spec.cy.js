import { APIURL } from '../../../frontend/script/config.js';

/* 
 Disclaimer: Probably it would be better to first send GET request to retrieve current value of count. However, I have created the API to handle only POST requests on purpose.
 POST request is also retrieving the current value of count to check if item exist before incrementing it, so for this test purposes, I've added a 'previous_count' value
 to response body aswell.
*/

describe('CRC API - Increment counter in database', () => {
  it('should increment the value of count in DynamoDB', () => {
    cy.request({
      method: 'POST',
      url: APIURL,
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.have.property('previous_count');
      expect(response.body).to.have.property('count');
      expect(response.body.count).to.be.greaterThan(
        response.body.previous_count
      );
    });
  });
});
