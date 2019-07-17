import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier{
    String _token;
    DateTime expirationTime;
    String _userId;


    Future<void> signup(String email, String password) async{
        const url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCCUD2wpf817Kddp4dQewdXaJxNVFqeLmo";
        try{
            final response =  await http.post(url, body: json.encode({
                'email' : email,
                'password': password,
                'returnSecureToken': true
            }));
            final responseData = json.decode(response.body);
            if (responseData['error'] != null){
                throw Exception(responseData['error']['message']);
            }
        } catch(e){
            throw e;
        }
    }

    Future<void> login(String email, String password) async{
        const url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCCUD2wpf817Kddp4dQewdXaJxNVFqeLmo";
        try{
            final response = await http.post(url, body: json.encode({
                'email':email,
                'password':password,
                'returnSecureToken':true
            }));
            final responseData = json.decode(response.body);
            if (responseData['error'] != null){
                throw Exception(responseData['error']['message']);
            }
        }catch(e){
            throw e;
        }

    }
}