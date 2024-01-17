// randomWords.js
const subjects = require('./subjects'); // Assurez-vous que le chemin est correct

function getRandomSubject() {
  const randomIndex = Math.floor(Math.random() * subjects.length);
  return subjects[randomIndex];
}

function getRandomWords(subject) {
  const randomIndex1 = Math.floor(Math.random() * subject.words.length);
  let randomIndex2;
  do {
    randomIndex2 = Math.floor(Math.random() * subject.words.length);
  } while (randomIndex2 === randomIndex1); // Assurez-vous d'obtenir deux mots différents

  const word1 = subject.words[randomIndex1];
  const word2 = subject.words[randomIndex2];

  return [word1, word2];
}

module.exports = { getRandomSubject, getRandomWords };
