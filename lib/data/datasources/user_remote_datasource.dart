// data/datasources/user_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/song_model.dart';
import '../models/artist_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  UserRemoteDataSource({required this.firestore, required this.firebaseAuth});
  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromDocument(doc);
        } else {
          throw Exception("User document does not exist");
        }
      }
      return null;
    } catch (e) {
      throw Exception("Get Current User Failed: $e");
    }
  }
  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Get User Failed: $e");
    }
  }

  Future<void> createUser(UserModel userModel) async {
    try {
      await firestore.collection('users').doc(userModel.id).set(userModel.toDocument());
    } catch (e) {
      throw Exception("Create User Failed: $e");
    }
  }

  Future<UserModel> updateUser(UserModel userModel) async {
    try {
      await firestore.collection('users').doc(userModel.id).update(userModel.toDocument());
      return userModel;
    } catch (e) {
      throw Exception("Update User Failed: $e");
    }
  }
  Future<void> updateFullName(String fullName) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).update({'fullName': fullName});
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Update FullName Failed: $e");
    }
  }
  Future<List<SongModel>> getFavoriteSongs() async {
    try {
      // Lấy thông tin người dùng hiện tại từ FirebaseAuth
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        // Lấy document tương ứng trong Firestore
        DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          // Lấy danh sách ID của favoriteSongs
          List<String> favoriteSongIds = List<String>.from(userData['favoriteSongs'] ?? []);

          // Truy vấn thông tin chi tiết từ collection 'songs'
          if (favoriteSongIds.isNotEmpty) {
            QuerySnapshot songDocs = await firestore
                .collection('Songs')
                .where(FieldPath.documentId, whereIn: favoriteSongIds)
                .get();

            // Map các document sang SongModel
            return songDocs.docs.map((doc) => SongModel.fromDocument(doc)).toList();
          } else {
            // Nếu không có bài hát yêu thích, trả về danh sách rỗng
            return [];
          }
        } else {
          throw Exception("User document does not exist");
        }
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Get Current User Favorite Songs Failed: $e");
    }
  }
  Future<void> addFavoriteSong(String songId) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        // Sử dụng FieldValue.arrayUnion để thêm songId vào favoriteSongs
        await firestore.collection('users').doc(user.uid).update({
          'favoriteSongs': FieldValue.arrayUnion([songId])
        });
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Add Favorite Song Failed: $e");
    }
  }

  Future<void> removeFavoriteSong(String songId) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        // Sử dụng FieldValue.arrayRemove để xóa songId khỏi favoriteSongs
        await firestore.collection('users').doc(user.uid).update({
          'favoriteSongs': FieldValue.arrayRemove([songId])
        });
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Remove Favorite Song Failed: $e");
    }
  }

  Future<List<ArtistModel>> getFavoriteArtists() async {
    try {
      // Lấy thông tin người dùng hiện tại từ FirebaseAuth
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        // Lấy document tương ứng trong Firestore
        DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          // Lấy danh sách ID của favoriteArtists
          List<String> favoriteArtistIds = List<String>.from(userData['favoriteArtists'] ?? []);

          // Truy vấn thông tin chi tiết từ collection 'artists'
          if (favoriteArtistIds.isNotEmpty) {
            QuerySnapshot artistDocs = await firestore
                .collection('Artists') // Collection nghệ sĩ
                .where(FieldPath.documentId, whereIn: favoriteArtistIds)
                .get();

            // Map các document sang ArtistModel
            return artistDocs.docs.map((doc) => ArtistModel.fromDocument(doc)).toList();
          } else {
            // Nếu không có nghệ sĩ yêu thích, trả về danh sách rỗng
            return [];
          }
        } else {
          throw Exception("User document does not exist");
        }
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Get Favorite Artists Failed: $e");
    }
  }


  /// Thêm nghệ sĩ vào danh sách yêu thích
  Future<void> addFavoriteArtist(String artistId) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).update({
          'favoriteArtists': FieldValue.arrayUnion([artistId])
        });
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Add Favorite Artist Failed: $e");
    }
  }

  /// Xóa nghệ sĩ khỏi danh sách yêu thích
  Future<void> removeFavoriteArtist(String artistId) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).update({
          'favoriteArtists': FieldValue.arrayRemove([artistId])
        });
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Remove Favorite Artist Failed: $e");
    }
  }
}
