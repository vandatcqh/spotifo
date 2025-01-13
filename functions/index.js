const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

// 1. Tìm kiếm bài hát theo songName và genre
exports.searchSongs = functions.https.onRequest(async (req, res) => {
  // Get parameters from URL
  const songName = decodeURIComponent(req.query.songName || "").trim();
  const genre = decodeURIComponent(req.query.genre || "").trim().toLowerCase();

  console.log("Search Songs Params:", {songName, genre});

  // Check if there are no search parameters
  if (!songName && !genre) {
    res.status(400).send({error: "Missing query parameters"});
    return;
  }

  try {
    // Start with base query
    const query = db.collection("Songs");
    const songsSnapshot = await query.get();
    const results = [];

    console.log("Fetched Songs Count:", songsSnapshot.size);

    songsSnapshot.forEach((doc) => {
      const song = doc.data();
      let matches = true;

      try {
        // Check song name if provided
        if (songName) {
          if (
            !song.songName ||
            !song.songName.toLowerCase().includes(songName.toLowerCase())
          ) {
            matches = false;
          }
        }

        // Check for exact genre match if genre is provided
        if (genre && matches) {
          if (!song.genre || song.genre.toLowerCase() !== genre) {
            matches = false;
          }
        }

        if (matches) {
          results.push({
            id: doc.id,
            ...song,
          });
        }
      } catch (docError) {
        console.error("Error processing document:", doc.id, docError);
        // Continue processing other documents
      }
    });

    console.log("Final Filtered Songs Count:", results.length);
    res.status(200).send(results);
  } catch (error) {
    console.error("Error searching songs:", error);
    res.status(500).send({error: "Internal Server Error"});
  }
});
// 2. Tìm kiếm album theo albumName
exports.searchAlbums = functions.https.onRequest(async (req, res) => {
  try {
    const albumName = decodeURIComponent(req.query.albumName || "");

    console.log("Search Album Params:", {albumName});

    if (!albumName) {
      res.status(400).send({
        error: "Missing query parameter: albumName",
      });
      return;
    }

    const albumsSnapshot = await db.collection("Album").get();
    const results = [];

    console.log("Fetched Albums Count:", albumsSnapshot.size);

    albumsSnapshot.forEach((doc) => {
      const album = doc.data();
      if (
        album.albumName &&
        album.albumName.toLowerCase().includes(albumName.toLowerCase())
      ) {
        results.push({
          id: doc.id,
          ...album,
        });
      }
    });

    console.log("Filtered Albums Count:", results.length);

    res.status(200).send(results);
  } catch (error) {
    console.error("Error in searchAlbums:", error);
    res.status(500).send({error: "Internal Server Error"});
  }
});

// 3. Tìm kiếm nghệ sĩ theo artistName
exports.searchArtists = functions.https.onRequest(async (req, res) => {
  try {
    const artistName = decodeURIComponent(req.query.artistName || "");

    console.log("Search Artist Params:", {artistName});

    if (!artistName) {
      res.status(400).send({
        error: "Missing query parameter: artistName",
      });
      return;
    }

    const artistsSnapshot = await db.collection("Artists").get();
    const results = [];

    console.log("Fetched Artists Count:", artistsSnapshot.size);

    artistsSnapshot.forEach((doc) => {
      const artist = doc.data();
      if (
        artist.artistName &&
        artist.artistName.toLowerCase().includes(artistName.toLowerCase())
      ) {
        results.push({
          id: doc.id,
          ...artist,
        });
      }
    });

    console.log("Filtered Artists Count:", results.length);

    res.status(200).send(results);
  } catch (error) {
    console.error("Error in searchArtists:", error);
    res.status(500).send({error: "Internal Server Error"});
  }
});
