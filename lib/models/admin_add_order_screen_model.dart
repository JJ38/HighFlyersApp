import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:high_flyers_app/models/Requests/add_order_request.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';
import 'package:high_flyers_app/models/validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AdminAddOrderScreenModel extends OrderModel{

  AddOrderRequest getAddOrderRequest(){
    return AddOrderRequest(order: getOrder());
  }


}