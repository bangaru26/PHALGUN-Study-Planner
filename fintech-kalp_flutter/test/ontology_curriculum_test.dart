import 'package:flutter_test/flutter_test.dart';
import 'package:fintech_kalp/ontology_curriculum.dart';

void main() {
  group('Finance Ontology curriculum', () {
    test('contains five distinct applied chapters', () {
      expect(ontologyCurriculum, hasLength(5));
      expect(ontologyCurriculum.map((chapter) => chapter.title).toSet(), hasLength(5));
    });

    test('every chapter includes trilingual notes and learning assets', () {
      for (final chapter in ontologyCurriculum) {
        expect(chapter.notes.keys, containsAll(['English', 'Telugu', 'Hindi']));
        expect(chapter.objectives, isNotEmpty);
        expect(chapter.concept, isNotEmpty);
        expect(chapter.example, isNotEmpty);
        expect(chapter.method, isNotEmpty);
        expect(chapter.crossFunctional, isNotEmpty);
        expect(chapter.assignment, isNotEmpty);
        expect(chapter.capstone, isNotEmpty);
        expect(chapter.flashcards, isNotEmpty);
        expect(chapter.questions, hasLength(5));
      }
    });

    test('all answer keys point to a valid option and include explanations', () {
      for (final chapter in ontologyCurriculum) {
        for (final question in chapter.questions) {
          expect(question.options, isNotEmpty);
          expect(question.correct, inInclusiveRange(0, question.options.length - 1));
          expect(question.explanation, isNotEmpty);
        }
      }
    });
  });
}
