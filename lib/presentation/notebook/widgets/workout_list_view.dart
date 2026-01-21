import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/notebook/widgets/workout_list_view_element.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class WorkoutsListView extends StatelessWidget {
  const WorkoutsListView({
    super.key,
    required this.itemCount,
    required this.height,
  });
  final int itemCount;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotebookBloc, NotebookState>(
      builder: (context, state) {
        if (state is NotebookSuccess) {
          return SizedBox(
            height: height,
            child: ListView.builder(
              itemCount: itemCount + 1,
              scrollDirection: .horizontal,
              itemBuilder: (context, index) {
                if (index < itemCount) {
                  return WorkoutListViewElement(
                    workout: state.savedWorkouts[index],
                    onTap: () {},
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AppDailog(
                          title: AppLocalizations.of(
                            context,
                          )!.dailog_delete_workout,
                          actions: [
                            AppOutlinedButton(
                              padding: EdgeInsetsGeometry.zero,
                              backgrounColor: Colors.blueGrey.shade200,
                              onPressed: () {
                                context.read<NotebookBloc>().add(
                                  NotebookEntityDeleted(
                                    model: state.savedWorkouts[index],
                                  ),
                                );
                                context.pop();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.button_delete,
                                style: TextStyle(fontSize: 20),
                                textAlign: .center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                // Change width to fill more viewport
                return WorkoutListViewElement(
                  onTap: () => context.goNamed(RouterNames.creator.name),
                );
              },
            ),
          );
        }
        return Text('State other than NotebookSuccess');
      },
    );
  }
}
