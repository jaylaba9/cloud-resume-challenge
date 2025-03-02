import { APIURL } from '../../../frontend/script/config.js';

describe('CRC API - request with invalid body', () => {
  it('should return 400 when invalid json is passed', () => {
    cy.request({
      method: 'POST',
      url: APIURL,
      body: '{invalid: "json"}',
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(400);
      expect(response.body).to.have.property('error');
    });
  });
});
