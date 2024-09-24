import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/Models/character_model.dart';
import 'package:think/Features/Home/characters/bloc/characters_bloc.dart';
import 'package:think/Features/Home/characters/bloc/characters_event.dart';
import 'package:think/Features/Home/characters/bloc/characters_state.dart';
import 'package:think/Features/Home/widgets/search_bar.dart';

// ignore: must_be_immutable
class CharactersTab extends StatelessWidget {
  CharactersTab({super.key});
  // List<Result> characters = [];
  // List<Result> searchedCharacters = [];
  // bool isSearching = false;
  // final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return BlocProvider(
      create: (context) => CharactersBloc()..add(GetCharacters()),
      child: BlocListener<CharactersBloc, CharactersState>(
        listener: (context, state) {
          // if (state.status == CharactersStatus.error) {
          //   return Center(
          //     child: Card(
          //       margin: const EdgeInsets.symmetric(
          //         horizontal: 20,
          //         vertical: 25,
          //       ),
          //       color: Theme.of(context).primaryColor,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(15),
          //         side: const BorderSide(width: 1, color: Color(0xff495D75)),
          //       ),
          //       child: const Padding(
          //         padding: EdgeInsets.all(20.0),
          //         child: Text(
          //           'Failed to load Characters',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   );
          // }
        },
        child: BlocBuilder<CharactersBloc, CharactersState>(
          builder: (context, state) {
            if (state.status == CharactersStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == CharactersStatus.error) {
              return Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(width: 1, color: Color(0xff495D75)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Failed to load Characters',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
            List<Result> characters =
                (state.status == CharactersStatus.searching)
                    ? (state.searchedCharacters ?? [])
                    : (state.characters?.results ?? []);
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SearchTextField(
                        // searchTextController: searchTextController,
                        onChanged: (character) {
                          if (character.trim().isNotEmpty) {
                            context.read<CharactersBloc>().add(
                                  SearchForCharacters(
                                    searchedCharacter: character,
                                  ),
                                );
                          } else {
                            context
                                .read<CharactersBloc>()
                                .add(ClearCharacters());
                          }
                        },
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: characters.length,
                          itemBuilder: (context, index) {
                            final character = characters[index];
                            return SizedBox(
                              height: height * 0.2,
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: character.image,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            character.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(fontSize: 18),
                                          ),
                                          Text(
                                            "Gender : ${character.gender.name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            "Status : ${character.status.name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            "Species : ${character.species.name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                //   Positioned(
                //     bottom: 16.0,
                //     right: 16.0,
                //     child: FloatingActionButton(
                //       child: const Icon(Icons.search),
                //       onPressed: () {
                //         context.read<CharactersBloc>().add(
                //               SearchForCharacters(
                //                 searchedCharacter: '',
                //               ),
                //             );
                //       },
                //     ),
                //   ),
                // ],
              ),
            );
          },
        ),
      ),
    );
  }
}
