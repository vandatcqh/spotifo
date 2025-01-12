const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

// 1. Tìm kiếm bài hát theo songName và genre
exports.searchSongs = functions.https.onRequest(async (req, res) => {
  try {
    // Giải mã songName và genres
    const songName = decodeURIComponent(req.query.songName || "").trim();
    const genresQuery = decodeURIComponent(req.query.genre || "").trim();
    const genres = genresQuery
      ? genresQuery.split(",").map((g) => g.trim().toLowerCase())
      : [];

    console.log("Search Songs Params:", {songName, genres});

    if (!songName && genres.length === 0) {
      res.status(400).send({
        error: "Missing query parameters: songName or genre",
      });
      return;
    }

    let query = db.collection("Songs");

    // Thêm điều kiện tìm kiếm theo songName nếu có
    if (songName) {
      // Sử dụng trường phụ songName_lowercase để tìm kiếm không phân biệt chữ hoa chữ thường
      query = query.where(
        "songName_lowercase",
        "==",
        songName.toLowerCase(),
      );
    }

    // Thêm điều kiện tìm kiếm theo genres nếu có
    if (genres.length > 0) {
      // Sử dụng array-contains-any để tìm kiếm bất kỳ thể loại nào trong danh sách
      query = query.where(
        "genre_lowercase",
        "array-contains-any",
        genres,
      );
    }

    const songsSnapshot = await query.get();
    const results = [];

    console.log("Fetched Songs Count:", songsSnapshot.size);

    songsSnapshot.forEach((doc) => {
      const song = doc.data();
      results.push({id: doc.id, ...song});
    });

    console.log("Final Filtered Songs Count:", results.length);

    res.status(200).send(results);
  } catch (error) {
    console.error("Error in searchSongs:", error);
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
