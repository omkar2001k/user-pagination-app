import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/common_empty_widget.dart';
import '../../../../core/widgets/common_error_widget.dart';
import '../../../../core/widgets/common_loading_widget.dart';
import '../../../../core/widgets/common_search_bar.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../widgets/user_card_widget.dart';

class UserListView extends StatelessWidget {
  final ValueChanged<UserEntity> onUserSelected;

  const UserListView({
    super.key,
    required this.onUserSelected,
  });

  Future<void> _handlePullToRefresh(BuildContext context) async {
    final bloc = context.read<UserBloc>();
    final refreshCompleted = bloc.stream.firstWhere(
      (state) =>
          (state is UserLoaded && !state.isRefreshing) || state is UserError,
    );
    bloc.add(const RefreshUsersEvent());
    await refreshCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_logo.png',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.people_alt_rounded),
              ),
            ),
            const SizedBox(width: 10),
            const Text('User Directory'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<UserBloc>().add(const RefreshUsersEvent());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: CommonSearchBar(
                hintText: 'Search by name or email...',
                onChanged: (query) {
                  context.read<UserBloc>().add(SearchUsersEvent(query));
                },
              ),
            ),

            // Main Body Content
            Expanded(
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserLoaded && state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: theme.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserLoading || state is UserInitial) {
                    return const CommonLoadingWidget();
                  }

                  if (state is UserError) {
                    return CommonErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<UserBloc>().add(const FetchUsersEvent());
                      },
                    );
                  }

                  if (state is UserLoaded) {
                    final users = state.filteredUsers;

                    if (users.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () => _handlePullToRefresh(context),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: CommonEmptyWidget(
                              title: state.searchQuery.isNotEmpty
                                  ? 'No Matching Users'
                                  : 'No Users Available',
                              message: state.searchQuery.isNotEmpty
                                  ? 'No users match "${state.searchQuery}". Try a different keyword.'
                                  : 'Pull down to refresh and fetch users.',
                            ),
                          ),
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            (scrollInfo.metrics.maxScrollExtent * 0.85)) {
                          context
                              .read<UserBloc>()
                              .add(const FetchNextPageEvent());
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        onRefresh: () => _handlePullToRefresh(context),
                        child: ListView.builder(
                          key: const Key('user_list_view_builder'),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              users.length + (state.isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= users.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.5),
                                  ),
                                ),
                              );
                            }

                            final user = users[index];
                            return UserCardWidget(
                              user: user,
                              onTap: () => onUserSelected(user),
                            );
                          },
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
