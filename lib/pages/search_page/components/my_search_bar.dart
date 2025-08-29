import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/components/project_tag.dart';
import 'package:forty_two_planet/data/project_ids.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({
    super.key,
    this.controller,
    required this.isSearchByProject,
    required this.onSelected,
    required this.onChangeSearchType,
    required this.onProjectClose,
    required this.onSearch,
    required this.isSearchingCadet,
    required this.isProjectLoading,
  });
  final TextEditingController? controller;
  final bool isSearchByProject;
  final void Function(String selection) onSelected;
  final void Function() onChangeSearchType;
  final void Function() onProjectClose;
  final void Function(String) onSearch;
  final bool isSearchingCadet;
  final bool isProjectLoading;

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  late TextEditingController projectController;
  bool _isProjectSelected = false;
  String _projectName = '';

  void onProjectClose() {
    setState(() {
      _isProjectSelected = false;
      _projectName = '';
    });
    widget.onProjectClose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: context.myTheme.intra,
          selectionColor: const Color.fromARGB(101, 33, 149, 243),
        ),
      ),
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
          child: SizedBox(
            height: 35,
            width: double.infinity,
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty ||
                    !widget.isSearchByProject) {
                  return const Iterable<String>.empty();
                }
                return projectsByIds.keys.where((String key) {
                  return key.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                });
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          String x = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              _isProjectSelected = true;
                              _projectName = x;
                              onSelected(x);
                            },
                            child: Padding(
                              padding: index == options.length - 1
                                  ? const EdgeInsets.only(bottom: 600)
                                  : const EdgeInsets.only(bottom: 0),
                              child: Container(
                                padding: const EdgeInsets.only(left: 20),
                                height: 70,
                                decoration: BoxDecoration(
                                  color: context.myTheme.greySecondary,
                                  borderRadius: BorderRadius.only(
                                      topLeft: index == 0
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                      topRight: index == 0
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                      bottomLeft: index == options.length - 1
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                      bottomRight: index == options.length - 1
                                          ? const Radius.circular(10)
                                          : Radius.zero),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    x,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (x) {
                setState(() {
                  projectController.clear();
                });
                widget.onSelected(x);
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                projectController = fieldTextEditingController;
                return Stack(children: [
                  TextField(
                    keyboardType: TextInputType.text,
                    keyboardAppearance:
                        Provider.of<SettingsProvider>(context).isDarkMode
                            ? Brightness.dark
                            : Brightness.light,
                    focusNode: focusNode,
                    onSubmitted: !widget.isSearchByProject &&
                            widget.controller!.text.isNotEmpty
                        ? widget.onSearch
                        : null,
                    readOnly: widget.isSearchByProject && _isProjectSelected,
                    cursorColor: context.myTheme.intra,
                    cursorHeight:
                        Theme.of(context).textTheme.bodyMedium?.fontSize,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    controller: widget.isSearchByProject
                        ? fieldTextEditingController
                        : widget.controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: _isProjectSelected ? '' : 'Search',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: context.myTheme.greyMain,
                              ),
                      prefixIcon: (widget.isSearchingCadet &&
                                  !widget.isSearchByProject) ||
                              (widget.isSearchByProject &&
                                  widget.isProjectLoading)
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: Align(
                                alignment: Alignment.center,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  colors: [context.myTheme.greySecondary],
                                ),
                              ),
                            )
                          : (widget.controller!.text.isNotEmpty &&
                                  !widget.isSearchByProject)
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    widget.controller!.clear();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/x.svg',
                                    fit: BoxFit.none,
                                    colorFilter: ColorFilter.mode(
                                        context.myTheme.greySecondary,
                                        BlendMode.srcIn),
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/icons/searchbar.svg',
                                  fit: BoxFit.none,
                                  colorFilter: ColorFilter.mode(
                                      context.myTheme.greySecondary,
                                      BlendMode.srcIn),
                                ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.isSearchByProject && _isProjectSelected
                          ? Flexible(
                              // Key: Use Flexible to allow expansion
                              child: LayoutBuilder(
                                // Use LayoutBuilder to get available width
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  final ScrollController scrollController =
                                      ScrollController();

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    scrollController.jumpTo(scrollController
                                        .position.maxScrollExtent);
                                  });
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 44),
                                    child: SingleChildScrollView(
                                      // Make it scrollable
                                      controller: scrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        // Constrain width based on available width
                                        constraints: BoxConstraints(
                                            minWidth: constraints.minWidth),
                                        child: ProjectTag(
                                          projectName: _projectName,
                                          onPressed: onProjectClose,
                                        ), // Your widget that might overflow
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            widget.onChangeSearchType();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.isSearchByProject
                                      ? 'by project'
                                      : 'by cadet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
