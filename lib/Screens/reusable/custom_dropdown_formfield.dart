import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loksewa/utils/figmaUtils/design_utils.dart';

import '../../Helper/constants.dart';

import '../../Models/user_model.dart';
import '../get_customer/get_customer_page.dart';
import 'custom_draggable_empty.dart';
import 'icon_button_b.dart';


class CustomDropdownFormField extends StatelessWidget {
  final String name;
  final List<UserModel> items;
  final FormFieldValidator<String>? validator;
  final String? initialValue;

  const CustomDropdownFormField({
    super.key,
    required this.name,
    required this.items,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: name,
      validator: validator,
      initialValue: initialValue,
      builder: (FormFieldState<String?> field) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () {
                _showDraggableSnackbar(context, field);
              },
            ),
            errorText: field.errorText,
          ),
          child: InkWell(
            onTap: () => _showDraggableSnackbar(context, field),
            child: Text(
              field.value != null
                  ? (items.firstWhere((e) {
                      if (e.id == field.value) {
                        return true;
                      } else {
                        return false;
                      }
                    }).name)
                  : 'Select an option',
              style: TextStyle(
                color: field.value == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDraggableSnackbar(
      BuildContext context, FormFieldState<String?> field) {
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CustomDraggableEmpty(
          initialheight: 0.80,
          maxheight: 0.90,
          childWidget: Column(
            children: [
              SizedBox(
                height: height * 0.60, // Adjust the height as needed
                child: ListView(
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Test'),
                      trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return const CustomDraggableEmpty(
                                    initialheight: 0.65,
                                    childWidget: GetCustomerPage());
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      onTap: () {
                        field.didChange(item.id);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              Divider(
                height: 15.adaptSize,
                thickness: 2,
                color: AppColors.lightGrey,
                endIndent: 15.adaptSize,
                indent: 15.adaptSize,
              ),
              const Text(
                'Client not found? You can always create new one.',
                textAlign: TextAlign.center,
              ),
              CustomIconButtonF(
                text: 'Add new client +',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return const CustomDraggableEmpty(
                          initialheight: 0.65, childWidget: GetCustomerPage());
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
