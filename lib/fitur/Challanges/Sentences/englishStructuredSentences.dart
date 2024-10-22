import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import '_services.dart';

class ButtonTransfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SwitchModeProvider>(context).themeData;

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await _showBackDialog(context) ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: theme.brightness == Brightness.light
                ? LinearGradient(
                    colors: [
                      Color(0xFF4CB5F5),
                      Colors.lightBlueAccent,
                      Color(0xFFC1E1DC),
                      Color(0xFFD0E1F9),
                      Color(0xFFC4DFE6)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.topRight,
                  )
                : LinearGradient(
                    colors: [
                      Color(0xFF011A27),
                      Color(0xFF003B46),
                      Color(0xFF07575B),
                      Color.fromARGB(255, 84, 167, 173)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: FutureBuilder(
            future:
                Provider.of<ClickedButtonListProvider>(context, listen: false)
                    .loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              "${Provider.of<ClickedButtonListProvider>(context).elementList[Provider.of<ClickedButtonListProvider>(context).indexing]['kalimat']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            _buildTranslationContainer(context),
                            SizedBox(height: 20),
                            _buildAnswerContainer(context),
                            SizedBox(height: 20),
                            _buildCheckButton(
                                context), // Updated button section
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildAnimationOverlay(context),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationContainer(BuildContext context) {
    final dark = Provider.of<SwitchModeProvider>(context);

    return Consumer<ClickedButtonListProvider>(
      builder: (context, clickedProvider, _) {
        return Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: dark.darkMode ? Color(0xFF66A5AD) : Color(0xFF07575B),
                width: 2.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.75),
            child: Column(
              children: [
                Text(
                  "what is the translation in Indonesian of that?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Container(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: clickedProvider.firstContainer.map((item) {
                      return item['cursor']
                          ? AnimatedButton(
                              index: item['id'],
                              onPressed: () {
                                bool access = item['cursor'];
                                clickedProvider.updateElement(
                                    access, item['id']);
                                clickedProvider.updateFirstContainer(
                                    access, item);
                                clickedProvider.updateListAnswer(0, item['id']);
                              },
                              child: Text('${item['word']}',
                                  style: TextStyle(color: Colors.white)),
                            )
                          : SizedBox.shrink();
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerContainer(BuildContext context) {
    return Consumer<ClickedButtonListProvider>(
      builder: (context, clickedProvider, _) {
        return IntrinsicHeight(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: clickedProvider.element.map((item) {
                    return !item['cursor']
                        ? AnimatedButton(
                            index: item['id'],
                            onPressed: () {
                              bool access = item['cursor'];
                              clickedProvider.updateElement(access, item['id']);
                              clickedProvider.updateFirstContainer(
                                  access, item);
                              clickedProvider.updateListAnswer(1, item['id']);
                            },
                            child: Text('${item['word']}',
                                style: TextStyle(color: Colors.white)),
                          )
                        : const SizedBox.shrink();
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              final bool? shouldPop = await _showBackDialog(context);
              if (shouldPop == true) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(25),
              backgroundColor: Colors.red,
            ),
            child: Icon(
              Icons.exit_to_app_outlined,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ClickedButtonListProvider>().updateIndexElement();
              print(context.read<ClickedButtonListProvider>().answer);
              print(context.read<ClickedButtonListProvider>().elementList[0]
                  ['typeAns']);
            },
            label: Text("Check"),
            icon: Icon(Icons.arrow_forward_ios),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              fixedSize: Size(200, 50),
              elevation: 5,
              shadowColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationOverlay(BuildContext context) {
    return Consumer<ClickedButtonListProvider>(
        builder: (context, clickedProvider, _) {
      if (clickedProvider.showAnimation) {
        return Positioned.fill(
          child: Center(
            child: _buildAnimationBox(
              show: clickedProvider.showAnimation,
              color: clickedProvider.showCorrectAnimation
                  ? Color.fromARGB(255, 60, 150, 22)
                  : Colors.red.shade900,
              icon: clickedProvider.showCorrectAnimation
                  ? Icons.check
                  : Icons.close,
            ),
          ),
        );
      } else if (clickedProvider.showAllElementsExplored) {
        Future.delayed(Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pop(context);
            clickedProvider.notify();
          }
        });
        return Center(
          child: Container(
            width: 200,
            height: 100,
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Text(
                'All sentences explored!',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _buildAnimationBox({
    required bool show,
    required Color color,
    required IconData icon,
  }) {
    return Center(
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: color.withOpacity(0.82),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Are you sure you want to leave this page?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final int index;
  final VoidCallback onPressed;
  final Widget child;

  AnimatedButton({
    required this.index,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFBA3356),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}

// class AnimatedButton extends StatelessWidget {
//   final int index;
//   final VoidCallback onPressed;
//   final Widget child;

//   AnimatedButton({
//     required this.index,
//     required this.onPressed,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final dark = Provider.of<SwitchModeProvider>(context);
//     return TweenAnimationBuilder(
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0.0, 50.0 * value),
//           child: Opacity(
//             opacity: value,
//             child: child,
//           ),
//         );
//       },
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: child,
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white,
//           // backgroundColor: Colors.amber[400],
//           backgroundColor: dark.darkMode ? Color(0xFF336B87) : Color(0xFFBA3356),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
//           elevation: 5,
//         ),
//       ),
//     );
//   }
// }
