import 'package:flutter_test/flutter_test.dart';
import 'package:meetlyai/src/domain/models/meeting_models.dart';

void main() {
  test('meeting summary JSON round-trips structured AI output', () {
    final summary = MeetingSummary(
      meetingId: 'meeting-1',
      generatedTitle: 'Budget sync',
      overview: 'The team aligned on budget ownership.',
      createdAt: DateTime.utc(2026, 5, 18),
      actionItems: const [
        ActionItem(
          id: 'a1',
          text: 'Send updated budget sheet',
          owner: 'Paul',
          evidenceSegmentIds: ['s1'],
        ),
      ],
      decisions: const [
        DecisionItem(
          id: 'd1',
          text: 'Use local transcription only',
          evidenceSegmentIds: ['s2'],
        ),
      ],
      tags: const ['budget', 'planning'],
    );

    final roundTrip = MeetingSummary.fromJson(summary.toJson());

    expect(roundTrip.generatedTitle, 'Budget sync');
    expect(roundTrip.actionItems.single.owner, 'Paul');
    expect(roundTrip.decisions.single.evidenceSegmentIds, ['s2']);
  });
}
