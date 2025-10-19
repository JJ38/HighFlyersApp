import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/icon_label.dart';

class UserCard extends StatelessWidget {

  final dynamic user;
  final void Function(BuildContext, dynamic) onDeleteUserTap;
  final void Function(BuildContext, dynamic) onChangeUserPasswordTap;

  const UserCard({super.key, required this.user, required this.onDeleteUserTap, required this.onChangeUserPasswordTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconLabel(icon: Icons.person_outline_outlined, child: Text(user['username'].toString().replaceAll("@placeholder.com", ""), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15))),
              IconLabel(icon: Icons.home_repair_service_outlined, child: Text(user['role'].toString(), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500))),
            ]
          ),
          Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: (){onChangeUserPasswordTap(context, user);},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).colorScheme.secondary,
                      blurRadius: 7,
                      spreadRadius: -3
                      )],
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(3),
                    border: BoxBorder.all(color: Theme.of(context).colorScheme.secondary, width: 1)
                  ),
                  child: Icon(Icons.lock_outline_sharp, size: 30, color: Colors.white,),
                ),
              ),
              GestureDetector(
                onTap: (){onDeleteUserTap(context, user);},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Colors.red[400]!,
                      blurRadius: 7,
                      spreadRadius: -3
                      )],
                    color: Colors.red[400]!,
                    borderRadius: BorderRadius.circular(3),
                    border: BoxBorder.all(color: Colors.red[500]!, width: 1)
                  ),
                  child: Icon(Icons.delete_forever_rounded, size: 30, color: Colors.white,),
                ),
              ),

            ],
          ),
          
          // IconLabel(icon: Icons.card_travel_outlined, child: Text(order['boxes'].toString())),
          // Text(user['role'])
        ],
      ),
    );
  }
}