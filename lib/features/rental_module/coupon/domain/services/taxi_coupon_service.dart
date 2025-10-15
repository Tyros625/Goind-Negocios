import 'package:sixam_mart_store/features/rental_module/coupon/domain/repositories/taxi_coupon_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/services/taxi_coupon_service_interface.dart';

class TaxiCouponService implements TaxiCouponServiceInterface {
  final TaxiCouponRepositoryInterface taxiCouponRepositoryInterface;
  TaxiCouponService({required this.taxiCouponRepositoryInterface});

}