import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/widgets/search_bar.dart';

class AlchemyScreen extends StatefulWidget {
  const AlchemyScreen({super.key});

  @override
  State<AlchemyScreen> createState() => _AlchemyScreenState();
}

class _AlchemyScreenState extends State<AlchemyScreen> {
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => searching = false),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: kWhite,
          title: Row(
            children: [
              if (!searching)
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: kLightGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Tiến độ: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: kBlack,
                        ),
                      ),
                      Text(
                        '136/580',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => searching = true),
                  child: SearchBar(
                    height: 40,
                    hintText: searching ? 'Tìm nguyên tố' : '...',
                  ),
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 76,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      Text(
                        index.toString(),
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: kBlack,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: kDefaultPadding,
              right: kDefaultPadding,
              child: Container(
                height: 80,
                width: 280,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
