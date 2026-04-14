import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/api_constants.dart';
import 'core/network/api_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/event_repository_impl.dart';
import 'data/sources/remote/auth_api_service.dart';
import 'data/sources/remote/event_api_service.dart';
import 'domain/usecases/fetch_events.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/register.dart';
import 'domain/usecases/update_event.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/event/event_bloc.dart';
import 'presentation/blocs/event/event_event.dart';
import 'presentation/pages/auth/auth_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(baseUrl: ApiConstants.baseUrl);
    final eventApiService = EventApiService(apiClient: apiClient);
    final authApiService = AuthApiService(apiClient: apiClient);
    final eventRepository = EventRepositoryImpl(eventApiService: eventApiService);
    final authRepository = AuthRepositoryImpl(authApiService: authApiService);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: eventRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthBloc(
          login: Login(authRepository),
          register: Register(authRepository),
        ),
        child: MaterialApp(
          title: 'Event App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: AuthWrapper(eventRepository: eventRepository),
        ),
      ),
    );
  }
}
