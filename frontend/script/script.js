'use strict';
import { APIURL } from './config.js';

const visitorCount = document.querySelector('.visitor-count');
const downloadButton = document.querySelector('.download');

// Handling download
async function downloadResume() {
  try {
    const response = await fetch(
      'https://mycrcstaticwebsite.s3.eu-central-1.amazonaws.com/public/cv.pdf',
    );
    if (!response.ok) {
      throw new Error(
        `An error occured during download: ${response.status} ${response.statusText}`,
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
    visitorCount.innerHTML = `Visits: ${countValue} (most of them are probably mine)`;
  } catch (error) {
    console.error(error);
  }
}

fetchData();

// --- Typewriter Effect ---
const textElement = document.getElementById('typewriter');

const phrases = [
  'Automating Infrastructure',
  'Building Cloud-Native Systems',
  'Troubleshooting complex issues',
];

// helper function
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const writeLoop = async () => {
  let currentPhraseIndex = 0;

  while (true) {
    let currentWord = phrases[currentPhraseIndex];

    // Typing letter by letter
    for (let i = 0; i < currentWord.length; i++) {
      textElement.innerText = currentWord.substring(0, i + 1);
      await sleep(75); // typing speed
    }

    // Wait after typing full word
    await sleep(2000);

    // Removing letter by letter
    for (let i = currentWord.length; i > 0; i--) {
      textElement.innerText = currentWord.substring(0, i - 1);
      await sleep(40); // removing speed
    }

    await sleep(500);

    // next phrase
    currentPhraseIndex++;
    if (currentPhraseIndex === phrases.length) {
      currentPhraseIndex = 0;
    }
  }
};

// animation start
writeLoop();

// --- projects accordion ---
const projectCards = document.querySelectorAll('.project-card');

projectCards.forEach((card) => {
  card.addEventListener('click', () => {
    const details = card.querySelector('.project-details');
    const chevron = card.querySelector('.chevron');

    details.classList.toggle('hidden');

    chevron.classList.toggle('rotate-180');
  });
});
