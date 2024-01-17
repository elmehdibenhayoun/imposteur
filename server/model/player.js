const mongoose = require("mongoose");

const playerSchema = new mongoose.Schema({
  nickName: {
    type: String,
    required: [true, "please provide nickname"],
    trim: true,
  },
  socketID: {
    type: String,
  },
  isMrWhite: false,
  word: String,
  votes: String,
  isReady: false,
});

module.exports = playerSchema;
