import 'package:flutter/material.dart';

import 'package:naradaflow/Responsiveness.dart';
import 'package:naradaflow/VIEWS/Customappbar.dart';
import 'package:naradaflow/VIEWS/User/services/SERVICES.dart';
import 'package:naradaflow/constants.dart';
import 'package:naradaflow/VIEWS/User/workorders/WorkOrderDetails.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // key: menuController.scaffoldKey,
      appBar: CustomAppBar(size: size),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // Header(),      addding here doesnot suit so better to add in the admin panel
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        const SERVICES(),
                        const SizedBox(height: defaultPadding),
                        CurrentWorkOrders(),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        // if (Responsive.isMobile(context))
                        //   const StorageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(
                      width: defaultPadding,
                      height: defaultPadding,
                    ),
                  // On Mobile means if the screen is less than 850 we don't want to show it
                  if (!Responsive.isMobile(context))
                    SizedBox(
                      height: size.height * 0.01,
                      width: 10,
                    ),
                  // if (!Responsive.isMobile(context))
                  //   const Expanded(
                  //     flex: 2,
                  //     child: StorageDetails(),
                  //   ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
