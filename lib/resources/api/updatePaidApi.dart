import 'package:firebase_database/firebase_database.dart';
import 'package:practrCompetitions/common/common.dart';

updatePaid(String razorpayId) async {
  Map<String, dynamic> data = {
    'paid': true,
    'razorpay_payment_id': razorpayId,
  };
  try {
    await FirebaseDatabase.instance
        .reference()
        .child('competetion')
        .child(orgCompetetionId)
        .update(data);
  } catch (e) {
    return false;
  }

  return true;
}
