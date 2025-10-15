import 'package:sixam_mart_store/features/rental_module/profile/domain/repositories/taxi_profile_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/services/taxi_profile_service_interface.dart';

class TaxiProfileService implements TaxiProfileServiceInterface {
  final TaxiProfileRepositoryInterface taxiProfileRepositoryInterface;
  TaxiProfileService({required this.taxiProfileRepositoryInterface});

}