import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_first_portfolio/Widget/duration.dart';
import 'package:my_first_portfolio/Widget/network_image.dart';
import 'package:my_first_portfolio/Widget/on_nfocused.dart';
import 'package:my_first_portfolio/local/local_store.dart';
import 'package:my_first_portfolio/model/food_model.dart';
import 'package:my_first_portfolio/pages/product_page.dart';

import 'package:my_first_portfolio/repository/get_info.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController change = TextEditingController();
  bool isEmpty = true;
  List<String> listOfSearch = [];
  final _delayed = Delayd(milliseconds: 700);

  getSearchHistory() async {
    listOfSearch = await LocalStore.getSearch();
  }

  @override
  void initState() {
    getSearchHistory();
    print(listOfSearch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OnUnFocusTap(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Search Page',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 295,
                    margin: const EdgeInsets.only(top: 35, left: 20, right: 20),
                    child: TextFormField(
                      maxLines: 1,
                      controller: change,
                      onChanged: (value) {
                        _delayed.run(
                          () {
                            print(change);
                            setState(() {});
                          },
                        );
                      },
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          letterSpacing: 0.7,
                          color: const Color(0xff194B38)),
                      decoration: InputDecoration(
                        suffix: change.text.isEmpty
                            ? const SizedBox.shrink()
                            : InkWell(
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  change.text = "";
                                  setState(() {});
                                },
                              ),
                        filled: true,
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xff4CBB5E)),
                        hintText: "Search fresh groceries",
                        hintStyle: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: const Color(0xff194B38)),
                        fillColor: const Color(0xff194B38).withOpacity(0.06),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: const Color(0xff194B38).withOpacity(0.06)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: const Color(0xff194B38).withOpacity(0.06)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: const Color(0xff194B38).withOpacity(0.06)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 65,
                    height: 65,
                    margin: const EdgeInsets.only(top: 35, left: 5),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        color: const Color(0xff194B38).withOpacity(0.06),
                        image: const DecorationImage(
                          image: AssetImage("assets/Group.png"),
                        )),
                  ),
                ],
              ),
              FutureBuilder(
                future: GetInfo.getInformation(text: change.text),
                builder: (ctx, AsyncSnapshot<FoodModel?> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else if (snapshot.data?.count == 0) {
                    return Column(
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 200),
                            height: 75,
                            width: 75,
                            decoration: const BoxDecoration(
                              color: Color(0xffEBF4F1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(23)),
                            ),
                            child: Center(
                                child: Text(
                              "🤷🏻‍♂",
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w700, fontSize: 30),
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                            child: Text(
                          "No this type of product",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: const Color(0xff194B38),
                              letterSpacing: 0.3),
                        )),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            "Search and see more items.",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: const Color(0xff9C9C9C),
                                letterSpacing: 0.3),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.hits?.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (a) => ProductPage(
                                            info: snapshot.data,
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF1F4F3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(24),
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 15),
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(24)),
                                                child: CustomImageNetwork(
                                                    image: snapshot
                                                        .data
                                                        ?.hits?[index]
                                                        ?.recipe
                                                        ?.image)),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30, top: 32),
                                                  child: Text(
                                                    snapshot.data?.hits?[index]
                                                            ?.recipe?.label ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.raleway(
                                                        color: const Color(
                                                            0xff194B38),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 253,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30, top: 12),
                                                  child: Text(
                                                    snapshot
                                                            .data
                                                            ?.hits?[index]
                                                            ?.recipe
                                                            ?.ingredients?[0]
                                                            ?.text ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.raleway(
                                                        color: const Color(
                                                            0xff194B38),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
