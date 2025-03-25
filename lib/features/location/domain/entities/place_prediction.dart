class PlacePrediction {
  final String? placeId;
  final String? mainText;
  final String? secondaryText;

  PlacePrediction({
    this.placeId,
    this.mainText,
    this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    // Extract structured_formatting if available
    final structuredFormatting =
        json['structured_formatting'] as Map<String, dynamic>?;

    return PlacePrediction(
      placeId: json['place_id'] as String?,
      // Use main_text from structured_formatting, or fall back to description
      mainText: structuredFormatting?['main_text'] as String? ??
          json['description'] as String?,
      // Use secondary_text from structured_formatting
      secondaryText: structuredFormatting?['secondary_text'] as String?,
    );
  }
}
