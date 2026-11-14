import 'package:flutter_test/flutter_test.dart';
import 'package:fintech_kalp/accounting_curriculum.dart';

void main() {
  group('Accounting Foundations curriculum', () {
    test('contains five distinct authored chapters', () {
      expect(accountingFoundations, hasLength(5));
      expect(accountingFoundations.map((chapter) => chapter.title).toSet(), hasLength(5));
    });

    test('each chapter includes trilingual notes and five assessment questions', () {
      for (final chapter in accountingFoundations) {
        expect(chapter.notes.keys, containsAll(['English', 'Telugu', 'Hindi']));
        expect(chapter.questions, hasLength(5));
        expect(chapter.flashcards, isNotEmpty);
        expect(chapter.objectives, isNotEmpty);
        expect(chapter.example, isNotEmpty);
        expect(chapter.assignment, isNotEmpty);
        expect(chapter.capstone, isNotEmpty);
      }
    });

    test('every assessment answer index is valid', () {
      for (final chapter in accountingFoundations) {
        for (final question in chapter.questions) {
          expect(question.options, isNotEmpty);
          expect(question.correct, inInclusiveRange(0, question.options.length - 1));
          expect(question.explanation, isNotEmpty);
        }
      }
    });
  });
}
