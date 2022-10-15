import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/widgets/search_bar.dart';

class AlchemyScreen extends StatelessWidget {
  const AlchemyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: kWhite,
        title: Row(
          children: [
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
                      fontSize: 16,
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
            const SizedBox(width: kDefaultPadding),
            const Expanded(
              child: SearchBar(height: 40, hintText: 'Tìm nguyên tố'),
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
    );
  }
}
