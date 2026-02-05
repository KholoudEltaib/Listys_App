import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleState extends Equatable {
  final Locale locale;
  final bool isRTL;

  const LocaleState({
    required this.locale,
    required this.isRTL,
  });

  LocaleState copyWith({
    Locale? locale,
    bool? isRTL,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
      isRTL: isRTL ?? this.isRTL,
    );
  }

  @override
  List<Object> get props => [locale, isRTL];
}

