import 'package:flutter_firebase/model/common_state.dart';
import 'package:flutter_firebase/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../services/post_service.dart';

final defaultState = CommonState(
  errMessage: '',
  isError: false,
  isLoad: false,
  isSuccess: false,
);

final postProvider = StateNotifierProvider<PostProvider, CommonState>((ref) => PostProvider(defaultState));

class PostProvider extends StateNotifier<CommonState> {
  PostProvider(super.state);

  Future<void> postAdd({
    required String title,
    required String detail,
    required String userId,
    required XFile image,
  }) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final responce = await PostService.postAdd(title: title, detail: detail, userId: userId, image: image);
    responce.fold(
            (l){
              state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
            },
            (r){
              state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: 'post added');
            }
    );
  }

  //post update
  Future<void> postUpdate({
    required  String title,
    required String detail,
    required String postId,
    String? imageId,
    XFile? image
  }) async{
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.postUpdate(title: title, detail: detail, postId: postId, image: image, imageId: imageId);
    response.fold(
            (l) {
          state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
        },
            (r) {
          state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: 'post updated');
        }
    );
  }

  //post delete
  Future<void> deletePost({
    required String postId,
    required String imageId
    })async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.postRemove(postId, imageId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
    },
            (r) {
      state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: 'post deleted');
    }
    );
  }

  //add likes
  Future<void> addLikes({
    required List<String> usernames,
    required String postId,
    required int like
})async{
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.addLike(usernames, postId, like);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
    },
            (r) {
          state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: '');
        }
    );
  }

  //add comments
  Future<void> addComment(List<Comment> comments, String postId) async{
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.addComment(comments, postId);
    response.fold(
            (l) {
          state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
        },
            (r) {
          state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: '');
        }
    );
  }


}
