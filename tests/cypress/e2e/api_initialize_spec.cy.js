import { apiUrl } from '../../../frontend/script/config.js';

// To run this test properly, one have to manually delete Item with id: 'visitor' from the DynamoDB table

describe('CRC API - initialize item', () => {
  it('should initialize item "visitor" with value = 0 and increment it', () => {
    cy.request({
      method: 'POST',
      url: apiUrl,
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.have.property('previous_count');
      expect(response.body).to.have.property('count');
      expect(response.body.previous_count).to.eq(0);
      expect(response.body.count).to.eq(1);
    });
  });
});
