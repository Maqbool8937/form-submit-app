class AppExtension {
  // Email validation regex
  static final RegExp emailExtension = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Phone number validation regex (international format)
  static final RegExp phoneExtension = RegExp(
    r'^\+?[1-9]\d{1,14}$', // Matches E.164 international phone numbers
  );
}
