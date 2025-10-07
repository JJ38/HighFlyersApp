import 'package:flutter/material.dart';

class FilterSettings extends StatefulWidget {

  final void Function() onFilterTap;

  const FilterSettings({super.key, required this.onFilterTap});

  @override
  State<FilterSettings> createState() => _FilterSettingsState();
}

class _FilterSettingsState extends State<FilterSettings> {



  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20.0, horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Row(
              children:[
                Expanded(
                  flex: 8,
                  child: TextField(
                    // controller: TextEditingController(text: value),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hint: const Text("Search filter"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0, 
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (input) {},
                    
                  )
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: widget.onFilterTap,
                    child: const Icon(       
                        Icons.filter_alt_rounded,
                        color: Colors.black, // icon color
                        size: 28,
                      ),
                    )
                  )
              ]
            )
            
          ]
        )
      )
    );
  }
}