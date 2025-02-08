'use strict';
import { apiUrl } from './config.js';

const visitorCount = document.querySelector('.visitor-count');

let countValue = 0;

const requestOptions = {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
};

async function fetchData() {
  try {
    const response = await fetch(apiUrl, requestOptions);
    if (!response.ok) {
      throw new Error('Response was not ok!');
    }
    const data = await response.json();
    countValue = data.count;
    visitorCount.innerHTML = `Visitor count: ${countValue}`;
  } catch (error) {
    console.error(error);
  }
}

fetchData();
