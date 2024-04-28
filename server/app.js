//import module
require("dotenv").config();
// require('express-async-errors');
const express = require("express");
const http = require("http");
const { getRandomSubject, getRandomWords } = require("./model/randomWords");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);
const io = require("socket.io")(server);
let gameStarted = false;

//conntect to db
const connectDb = require("./db/mongoose");

//middlewere
app.use(express.json());

//model
const Room = require("./model/room");
const playerSchema = require("./model/player");

io.on("connection", (socket) => {
  console.log("connect sockett");

  //create a room
  socket.on("createRoom", async ({ nickname, password }) => {
    console.log(nickname);
    try {
      let room = new Room();
      room.password = password;
      let player = {
        socketID: socket.id,
        nickName: nickname,
        isReady: false,
      };
      room.players.push(player);

      room = await room.save();
      const roomId = room._id.toString();

      console.log(room);

      socket.join(roomId);

      io.to(roomId).emit("createRoomSuccess", room);
      io.to(roomId).emit("updatePlayers", room.players);
      io.to(roomId).emit("updateRoom", room);
    } catch (ex) {
      console.log(ex);
    }
  });

  //join room
  socket.on("joinRoom", async ({ nickname, roomId }) => {
    console.log(`nickname : ${nickname} , roomId : ${roomId}`);
    try {
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("errorOccurred", "Please enter a valid room ID.");
        return;
      }
      let room = await Room.findById(roomId);
      if (room.occupancy == room.players.length) {
        room.isJoin = 0;
      }
      if (room.isJoin) {
        let player = {
          socketID: socket.id,
          nickName: nickname,
          isReady: false,
        };
        room.players.push(player);

        room = await room.save();

        socket.join(roomId);

        console.log(room);

        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        io.to(roomId).emit("updateRoom", room);
      } else {
        socket.emit(
          "errorOccurred",
          "The game is in progress, try again later."
        );
      }
    } catch (ex) {
      console.log(ex);
    }
  });

  socket.on("updatePlayer", async ({ roomId, player }) => {
    let room = await Room.findById(roomId);

    // Trouvez l'index du joueur dans la liste
    const playerIndex = room.players.findIndex(
      (p) => p.nickName === player.nickName
    );
    console.log(player.nickName);
    console.log(playerIndex);
    // Mettez à jour le joueur si trouvé
    if (playerIndex !== -1) {
      room.players[playerIndex] = player;
    }
    room = await room.save();
    socket.join(roomId);
    console.log(room.players);
    // Émettez un événement pour informer les autres joueurs de la mise à jour
    io.to(roomId).emit("updateRoom", room);
    io.to(roomId).emit("updatePlayers", room.players);
  });

  socket.on("checkReadyPlayer", async ({ roomId }) => {
    let room = await Room.findById(roomId);

    // Vérifiez si tous les joueurs sont prêts
    console.log(
      "Current player states:",
      room.players.map((player) => player.isReady)
    );
    const allPlayersReady = room.players.every(
      (player) => player.isReady == true
    );
    console.log(allPlayersReady);
    if (allPlayersReady) {
      console.log("hell");
      // Mettez à jour le statut ou effectuez toute autre action nécessaire

      // Émettez un événement pour informer les autres joueurs de la mise à jour

      io.to(roomId).emit("updateRoom", room);
      io.to(roomId).emit("checkReadyPlayerSuccess", room);
      io.to(roomId).emit("updatePlayers", room.players);
    }
  });

  socket.on("startgame", async (data) => {
    try {
      const roomId = data.roomId; // Récupérez l'ID de la salle à partir des données reçues
      const room = await Room.findById(roomId);

      if (!room) {
        console.error("La salle n'existe pas.");
        return;
      }
      room.isJoin = 0;

      if (!room.gameStarted) {
        console.log("Salle avant le démarrage du jeu :", room);

        // Choix aléatoire d'un sujet (vous devrez remplacer ceci par la logique appropriée)
        const randomTopic = getRandomSubject();
        console.log("Sujet choisi :", randomTopic);

        // Choix aléatoire de deux mots dans le sujet
        const words = getRandomWords(randomTopic); // À implémenter
        console.log("Mots choisis :", words);

        // Choix aléatoire d'un joueur pour recevoir le premier mot
        const mrWhite = getRandomUser(room);
        console.log("Joueur Mr. White choisi :", mrWhite);

        // Distribution des mots aux joueurs
        room.players.forEach((player) => {
          player.word = player === mrWhite ? words[0] : words[1];
          player.isMrWhite = player === mrWhite;
        });

        room.gameStarted = 1;
        console.log("Salle après la distribution des mots :", room);
        // Enregistrement des changements dans la base de données
        await room.save();
        socket.join(roomId);

        // Émettre un événement pour informer les joueurs du démarrage du jeu et leur assigner les mots

        io.to(roomId).emit("gameStarted", room);
        io.to(roomId).emit("updateRoom", room);
        io.to(roomId).emit("updatePlayers", room.players);
      } else console.log("le jeu a commencer");

      //io.to(roomId).emit("updatePlayers", room.players);
    } catch (error) {
      console.error("Erreur lors du démarrage du jeu :", error);
    }
  });

  socket.on("resultat", async (roomId) => {
    try {
      const room = await Room.findById(roomId);

      if (!room) {
        console.error("La salle n'existe pas.");
        return;
      }

      // Récupérez le joueur cible (Mr. White)
      const targetPlayer = room.players.find((player) => player.isMrWhite);

      // Comptez les votes pour et contre le joueur cible
      const votesForTarget = room.players.filter(
        (player) => player.votes === targetPlayer.nickName
      ).length;
      const votesAgainstTarget = room.players.filter(
        (player) => player.votes !== targetPlayer.nickName
      ).length;

      let resultMessage = "";

      // Déterminez le résultat en fonction de la majorité
      if (votesForTarget > votesAgainstTarget) {
        resultMessage = `${targetPlayer.nickName} perd`;
      } else {
        resultMessage = `${targetPlayer.nickName} gagne`;
      }

      // Enregistrez le résultat dans la base de données ou effectuez d'autres actions nécessaires

      // Émettez un événement pour informer les clients du résultat
      io.to(roomId).emit("resultat", resultMessage);
      io.to(roomId).emit("updateRoom", room);
      io.to(roomId).emit("updatePlayers", room.players);
    } catch (error) {
      console.error("Erreur lors du calcul du résultat :", error);
    }
  });
});
function getRandomUser(room) {
  if (room.players.length === 0) {
    return null; // Aucun utilisateur connecté
  }

  const randomIndex = Math.floor(Math.random() * room.players.length);
  const randomUser = room.players[randomIndex];

  return randomUser;
}

const start = async () => {
  try {
    await connectDb(process.env.MONGO_URI);
    server.listen(port, () =>
      console.log(`Server is listening on port ${port}...`)
    );
  } catch (error) {
    console.log(error);
  }
};

start();
