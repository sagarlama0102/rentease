import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/find_active_booking_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/get_all_booking_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/get_booking_byId_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/update_booking_status_usecase.dart';
import 'package:rentease/features/booking/presentation/state/booking_state.dart';
import 'package:rentease/features/booking/presentation/view_model/booking_view_model.dart';


// Mock UseCases
class MockGetAllBookingsUsecase extends Mock implements GetAllBookingsUsecase {}
class MockCreateBookingUsecase extends Mock implements CreateBookingUsecase {}
class MockGetBookingByidUsecase extends Mock implements GetBookingByidUsecase {}
class MockUpdateBookingStatusUsecase extends Mock implements UpdateBookingStatusUsecase {}
class MockFindActiveBookingUsecase extends Mock implements FindActiveBookingUsecase {}

void main() {
  late ProviderContainer container;
  late MockGetAllBookingsUsecase mockGetAllBookingsUsecase;
  late MockCreateBookingUsecase mockCreateBookingUsecase;
  late MockGetBookingByidUsecase mockGetBookingByidUsecase;
  late MockUpdateBookingStatusUsecase mockUpdateBookingStatusUsecase;
  late MockFindActiveBookingUsecase mockFindActiveBookingUsecase;

  setUpAll(() {
    registerFallbackValue(const GetAllBookingParams(page: 1, size: 10));
    registerFallbackValue(const CreateBookingParams(propertyId: '', userId: ''));
    registerFallbackValue(const UpdateBookingStatusParams(bookingId: '', status: BookingStatus.pending));
    registerFallbackValue(const FindActiveBookingParams(userId: '', propertyId: ''));
    registerFallbackValue(const GetBookingByIdParams(bookingId: ''));
  });

  setUp(() {
    mockGetAllBookingsUsecase = MockGetAllBookingsUsecase();
    mockCreateBookingUsecase = MockCreateBookingUsecase();
    mockGetBookingByidUsecase = MockGetBookingByidUsecase();
    mockUpdateBookingStatusUsecase = MockUpdateBookingStatusUsecase();
    mockFindActiveBookingUsecase = MockFindActiveBookingUsecase();

    container = ProviderContainer(
      overrides: [
        getAllBookingsUsecaseProvider.overrideWithValue(mockGetAllBookingsUsecase),
        createBookingUsecaseProvider.overrideWithValue(mockCreateBookingUsecase),
        getBookingByIdUsecaseProvider.overrideWithValue(mockGetBookingByidUsecase),
        updateBookingByIdUsecaseProvider.overrideWithValue(mockUpdateBookingStatusUsecase),
        findActiveBookingUsecaseProvider.overrideWithValue(mockFindActiveBookingUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  final tBookingList = [
    BookingEntity(
      bookingId: '1',
      propertyId: 'p1',
      userId: 'u1',
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    )
  ];

  group('getAllBookings', () {
    test('should emit loading and then loaded state when successful', () async {
      // Arrange
      when(() => mockGetAllBookingsUsecase(any()))
          .thenAnswer((_) async => Right(tBookingList));

      final viewModel = container.read(bookingViewModelProvider.notifier);
      
      // Act
      await viewModel.getAllBookings();

      // Assert
      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatusState.loaded);
      expect(state.bookings, tBookingList);
      verify(() => mockGetAllBookingsUsecase(any())).called(1);
    });

    test('should emit error state when fetching fails', () async {
      // Arrange
      when(() => mockGetAllBookingsUsecase(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Error')));

      final viewModel = container.read(bookingViewModelProvider.notifier);

      // Act
      await viewModel.getAllBookings();

      // Assert
      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatusState.error);
      expect(state.errorMessage, 'Error');
    });
  });

  group('createBooking', () {
    test('should emit created state and refresh bookings on success', () async {
      // Arrange
      when(() => mockCreateBookingUsecase(any()))
          .thenAnswer((_) async => Right(tBookingList[0]));
      when(() => mockGetAllBookingsUsecase(any()))
          .thenAnswer((_) async => Right(tBookingList));

      final viewModel = container.read(bookingViewModelProvider.notifier);

      // Act
      await viewModel.createBooking(propertyId: 'p1', userId: 'u1');

      // Assert
      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatusState.loaded); // Because it calls getAllBookings() at the end
      verify(() => mockCreateBookingUsecase(any())).called(1);
      verify(() => mockGetAllBookingsUsecase(any())).called(1);
    });
  });

  group('updateBookingStatus', () {
    test('should emit updated status and refresh list', () async {
      // Arrange
      when(() => mockUpdateBookingStatusUsecase(any()))
          .thenAnswer((_) async => Right(tBookingList[0]));
      when(() => mockGetAllBookingsUsecase(any()))
          .thenAnswer((_) async => Right(tBookingList));

      final viewModel = container.read(bookingViewModelProvider.notifier);

      // Act
      await viewModel.updateBookingStatus(bookingId: '1', status: BookingStatus.confirmed);

      // Assert
      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatusState.loaded);
      verify(() => mockUpdateBookingStatusUsecase(any())).called(1);
    });
  });

  test('resetState should return state to initial values', () {
    final viewModel = container.read(bookingViewModelProvider.notifier);
    viewModel.resetState();
    
    final state = container.read(bookingViewModelProvider);
    expect(state.status, BookingStatusState.initial);
    expect(state.bookings, isEmpty);
  });
}