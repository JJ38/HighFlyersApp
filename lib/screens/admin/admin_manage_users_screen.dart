import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/user_card.dart';
import 'package:high_flyers_app/controllers/admin_manage_users_screen_controller.dart';

class AdminManageUsersScreen extends StatefulWidget {
  const AdminManageUsersScreen({super.key});

  @override
  State<AdminManageUsersScreen> createState() => _AdminManageUsersScreenState();
}

class _AdminManageUsersScreenState extends State<AdminManageUsersScreen> {

  late final AdminManageUsersScreenController adminManageUsersScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminManageUsersScreenController = AdminManageUsersScreenController(updateState: updateState);
    adminManageUsersScreenController.loadUsers();
  }

  void updateState(){

    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 220, 220, 220), width: 1))
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20.0, horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[            
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size(screenWidth * 0.1, screenWidth * 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: (){ adminManageUsersScreenController.onAddUserTap(context);},
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          Text("Add", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ]
                      )
                    ),               
                  ]                 
                )
              )
            ),
            adminManageUsersScreenController.model.isLoading ? 
                Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                )
              )
              :
                Expanded(
                child: ListView.builder(
                  // controller: adminManageUsersScreenController.listViewScrollController,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  itemCount: adminManageUsersScreenController.model.users.length,
                  itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsetsGeometry.only(top: 10),
                        child: UserCard(user: adminManageUsersScreenController.model.users[i], onDeleteUserTap: adminManageUsersScreenController.onDeleteUserTap, onChangeUserPasswordTap: adminManageUsersScreenController.onChangeUserPasswordTap)
                      );
                    }
                )
              )
          ]
        )
      )
    );
  }
}
