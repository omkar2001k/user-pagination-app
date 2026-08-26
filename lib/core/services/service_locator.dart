import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:user_pagination_app/core/constants/api_constants.dart';
import 'package:user_pagination_app/core/network/network_info.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_local_data_source.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_remote_data_source.dart';
import 'package:user_pagination_app/modules/user/data/repositories/user_repository_impl.dart';
import 'package:user_pagination_app/modules/user/domain/repositories/user_repository.dart';
import 'package:user_pagination_app/modules/user/domain/usecases/get_users_usecase.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initServiceLocator({Box? hiveBox}) async {
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());

  if (hiveBox != null) {
    serviceLocator.registerLazySingleton<Box>(() => hiveBox);
  } else {
    final box = await Hive.openBox(ApiConstants.cachedUsersBoxName);
    serviceLocator.registerLazySingleton<Box>(() => box);
  }

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator<Connectivity>()),
  );

  serviceLocator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: serviceLocator<http.Client>()),
  );
  serviceLocator.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(box: serviceLocator<Box>()),
  );

  serviceLocator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: serviceLocator<UserRemoteDataSource>(),
      localDataSource: serviceLocator<UserLocalDataSource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(serviceLocator<UserRepository>()),
  );

  serviceLocator.registerFactory<UserBloc>(
    () => UserBloc(getUsersUseCase: serviceLocator<GetUsersUseCase>()),
  );
}
