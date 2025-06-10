'use strict';
import { APIURL } from './config.js';

const visitorCount = document.querySelector('.visitor-count');
const downloadButton = document.querySelector('.download');

// Handling download
async function downloadResume() {
  try {
    const response = await fetch(
      'https://mycrcstaticwebsite.s3.eu-central-1.amazonaws.com/public/cv.pdf'
    );
    if (!response.ok) {
      throw new Error(
        `An error occured during download: ${response.status} ${response.statusText}`
      );
    }

    const blob = await response.blob();
    const url = URL.createObjectURL(blob);

    const link = document.createElement('a');
    link.href = url;
    link.download = 'Jaroslaw_Laba_Resume.pdf';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    URL.revokeObjectURL(url);
  } catch (error) {
    console.error(`An error occured during download: ${error}`);
    alert('Error during downloading. Please try again in a while.');
  }
}

downloadButton.addEventListener('click', downloadResume);

// Handing data fetch
let countValue = 0;

const requestOptions = {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
};

async function fetchData() {
  try {
    const response = await fetch(APIURL, requestOptions);
    if (!response.ok) {
      throw new Error('Response was not ok!');
    }
    const data = await response.json();
    countValue = data.count;
    visitorCount.innerHTML = `Visits: ${countValue}`;
  } catch (error) {
    console.error(error);
  }
}

fetchData();
