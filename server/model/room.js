const mongoose = require("mongoose");
const playerSchema = require("./player");
const roomSchema = new mongoose.Schema({
  occupancy: {
    type: Number,
    default: 4,
  },
  
  password: String,
  players: [playerSchema],
  isJoin: {
    type: Boolean,
    default: 1,
  },
  gameStarted: {
    type: Boolean,
    default: 0,
  },
}
);
findByPassword = async function (password) {
  return this.findOne({ password: new RegExp(password, 'i') }).exec();
};

module.exports = mongoose.model("Room", roomSchema);

