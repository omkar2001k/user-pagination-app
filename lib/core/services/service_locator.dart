import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../network/network_info.dart';

import '../../modules/user/data/datasources/user_local_data_source.dart';
import '../../modules/user/data/datasources/user_remote_data_source.dart';
import '../../modules/user/data/repositories/user_repository_impl.dart';
import '../../modules/user/domain/repositories/user_repository.dart';
import '../../modules/user/domain/usecases/get_users_usecase.dart';
import '../../modules/user/presentation/bloc/user_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initServiceLocator({Box? hiveBox}) async {
  // 1. External Dependencies
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());

  if (hiveBox != null) {
    serviceLocator.registerLazySingleton<Box>(() => hiveBox);
  } else {
    final box = await Hive.openBox(ApiConstants.cachedUsersBoxName);
    serviceLocator.registerLazySingleton<Box>(() => box);
  }

  // 2. Core Infrastructure
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator<Connectivity>()),
  );

  // 3. Data Sources
  serviceLocator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: serviceLocator<http.Client>()),
  );
  serviceLocator.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(box: serviceLocator<Box>()),
  );

  // 4. Repositories
  serviceLocator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: serviceLocator<UserRemoteDataSource>(),
      localDataSource: serviceLocator<UserLocalDataSource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );

  // 5. Use Cases
  serviceLocator.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(serviceLocator<UserRepository>()),
  );

  // 6. Blocs
  serviceLocator.registerFactory<UserBloc>(
    () => UserBloc(getUsersUseCase: serviceLocator<GetUsersUseCase>()),
  );
}
