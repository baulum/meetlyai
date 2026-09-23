import 'dart:io';
import 'dart:math' as math;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

import '../../application/providers.dart';
import '../../data/services/study_ai_service.dart';
import '../../domain/models/meeting_models.dart';
import '../../domain/models/study_models.dart';
import '../widgets/chat_markdown.dart';

class LearningView extends ConsumerStatefulWidget {
  const LearningView({super.key});

  @override
  ConsumerState<LearningView> createState() => _LearningViewState();
}

class _LearningViewState extends ConsumerState<LearningView> {
  final _questionController = TextEditingController();
  final Map<String, ScrollController> _chatScrollControllersByFolder = {};
  bool _busy = false;
  _LearningTab _selectedTab = _LearningTab.materials;
  final Map<String, List<StudyFlashcard>> _flashcardsByFolder = {};
  final Map<String, List<StudyQuizQuestion>> _quizByFolder = {};
  final Map<String, Set<int>> _flippedCardsByFolder = {};
  final Map<String, Map<int, int>> _quizSelectionsByFolder = {};
  final Map<String, Map<int, int>> _quizAnswersByFolder = {};
  final Map<String, int> _currentCardIndexByFolder = {};
  final Map<String, int> _currentQuizIndexByFolder = {};
  final Map<String, String> _studyNotesByFolder = {};

  @override
  void dispose() {
    _questionController.dispose();
    for (final controller in _chatScrollControllersByFolder.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(studyFoldersProvider);
    final selectedFolderId = ref.watch(selectedStudyFolderIdProvider);
    final flashcards = selectedFolderId == null
        ? const <StudyFlashcard>[]
        : _flashcardsByFolder[selectedFolderId] ?? const <StudyFlashcard>[];
    final quiz = selectedFolderId == null
        ? const <StudyQuizQuestion>[]
        : _quizByFolder[selectedFolderId] ?? const <StudyQuizQuestion>[];
    final flippedCards = selectedFolderId == null
        ? <int>{}
        : _flippedCardsByFolder.putIfAbsent(selectedFolderId, () => <int>{});
    final quizSelections = selectedFolderId == null
        ? <int, int>{}
        : _quizSelectionsByFolder.putIfAbsent(
            selectedFolderId,
            () => <int, int>{},
          );
    final quizAnswers = selectedFolderId == null
        ? <int, int>{}
        : _quizAnswersByFolder.putIfAbsent(
            selectedFolderId,
            () => <int, int>{},
          );
    final currentCardIndex = selectedFolderId == null
        ? 0
        : _boundedIndex(
            _currentCardIndexByFolder[selectedFolderId] ?? 0,
            flashcards.length,
          );
    final currentQuizIndex = selectedFolderId == null
        ? 0
        : _boundedIndex(
            _currentQuizIndexByFolder[selectedFolderId] ?? 0,
            quiz.length,
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 24),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            child: _LearningFolders(
              foldersAsync: foldersAsync,
              selectedFolderId: selectedFolderId,
              onCreate: () => _createFolder(),
              onCreateChild: (parentId) => _createFolder(parentId: parentId),
              onEdit: _editFolder,
              onDelete: _deleteFolder,
              onSelect: _selectFolder,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: selectedFolderId == null
                ? const _LearningEmpty()
                : _LearningWorkspace(
                    folderId: selectedFolderId,
                    questionController: _questionController,
                    chatScrollController: _chatScrollController(
                      selectedFolderId,
                    ),
                    busy: _busy,
                    selectedTab: _selectedTab,
                    flashcards: flashcards,
                    flippedCards: flippedCards,
                    quiz: quiz,
                    currentCardIndex: currentCardIndex,
                    currentQuizIndex: currentQuizIndex,
                    quizSelections: quizSelections,
                    quizAnswers: quizAnswers,
                    studyNote: _studyNotesByFolder[selectedFolderId],
                    onTabChanged: (tab) => setState(() => _selectedTab = tab),
                    onFlipCard: (index) => setState(() {
                      if (!flippedCards.add(index)) {
                        flippedCards.remove(index);
                      }
                    }),
                    onPreviousCard: () => setState(() {
                      _currentCardIndexByFolder[selectedFolderId] = math.max(
                        0,
                        currentCardIndex - 1,
                      );
                    }),
                    onNextCard: () => setState(() {
                      _currentCardIndexByFolder[selectedFolderId] = math.min(
                        math.max(0, flashcards.length - 1),
                        currentCardIndex + 1,
                      );
                    }),
                    onSelectQuizAnswer: (questionIndex, optionIndex) =>
                        setState(
                          () => quizSelections[questionIndex] = optionIndex,
                        ),
                    onSubmitQuizAnswer: (questionIndex) => setState(() {
                      final selected = quizSelections[questionIndex];
                      if (selected != null) {
                        quizAnswers[questionIndex] = selected;
                      }
                    }),
                    onPreviousQuiz: () => setState(() {
                      _currentQuizIndexByFolder[selectedFolderId] = math.max(
                        0,
                        currentQuizIndex - 1,
                      );
                    }),
                    onNextQuiz: () => setState(() {
                      _currentQuizIndexByFolder[selectedFolderId] = math.min(
                        math.max(0, quiz.length - 1),
                        currentQuizIndex + 1,
                      );
                    }),
                    onImport: () => _importFiles(selectedFolderId),
                    onLinkMeeting: () => _linkMeeting(selectedFolderId),
                    onAsk: () => _ask(selectedFolderId),
                    onFlashcards: () => _generateStudyAsset(
                      selectedFolderId,
                      mode: _StudyGenerationMode.flashcards,
                    ),
                    onQuiz: () => _generateStudyAsset(
                      selectedFolderId,
                      mode: _StudyGenerationMode.quiz,
                    ),
                    onStudyNote: () => _generateStudyAsset(
                      selectedFolderId,
                      mode: _StudyGenerationMode.note,
                    ),
                    onExportStudyNote: () => _exportStudyNote(
                      selectedFolderId,
                      _studyNotesByFolder[selectedFolderId],
                    ),
                    onDropFiles: (paths) =>
                        _importFiles(selectedFolderId, sourcePaths: paths),
                  ),
          ),
        ],
      ),
    );
  }

  void _selectFolder(String id) {
    ref.read(selectedStudyFolderIdProvider.notifier).select(id);
  }

  Future<void> _createFolder({String? parentId}) async {
    var folderName = '';
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(parentId == null ? 'New learning folder' : 'New subfolder'),
        content: TextFormField(
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            prefixIcon: Icon(Icons.folder_outlined),
          ),
          onChanged: (value) => folderName = value,
          onFieldSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(folderName),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) {
      return;
    }
    final folder = await ref
        .read(studyRepositoryProvider)
        .createFolder(name: name.trim(), parentId: parentId);
    ref.read(selectedStudyFolderIdProvider.notifier).select(folder.id);
  }

  Future<void> _editFolder(StudyFolder folder) async {
    var folderName = folder.name;
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ordner bearbeiten'),
        content: TextFormField(
          initialValue: folder.name,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Ordnername',
            prefixIcon: Icon(Icons.folder_outlined),
          ),
          onChanged: (value) => folderName = value,
          onFieldSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(folderName),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) {
      return;
    }
    await ref
        .read(studyRepositoryProvider)
        .upsertFolder(
          StudyFolder(
            id: folder.id,
            name: name.trim(),
            createdAt: folder.createdAt,
            parentId: folder.parentId,
            description: folder.description,
            color: folder.color,
          ),
        );
  }

  Future<void> _deleteFolder(StudyFolder folder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ordner löschen?'),
        content: Text(
          '"${folder.name}" und alle Unterordner, Unterlagen, Verknüpfungen und Chats darin werden gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    final deletedFolderIds = await _folderAndDescendantIds(folder.id);
    await ref.read(studyRepositoryProvider).deleteFolder(folder.id);
    for (final id in deletedFolderIds) {
      _flashcardsByFolder.remove(id);
      _quizByFolder.remove(id);
      _flippedCardsByFolder.remove(id);
      _quizSelectionsByFolder.remove(id);
      _quizAnswersByFolder.remove(id);
      _currentCardIndexByFolder.remove(id);
      _currentQuizIndexByFolder.remove(id);
      _studyNotesByFolder.remove(id);
      _chatScrollControllersByFolder.remove(id)?.dispose();
    }
    if (deletedFolderIds.contains(ref.read(selectedStudyFolderIdProvider))) {
      ref.read(selectedStudyFolderIdProvider.notifier).select(null);
    }
  }

  Future<void> _importFiles(
    String folderId, {
    List<String>? sourcePaths,
  }) async {
    final paths = await _expandImportPaths(
      sourcePaths ?? await _pickStudyFiles(),
    );
    if (paths.isEmpty) {
      return;
    }

    final pdfVisionPaths = await _selectPdfVisionFiles(paths);
    if (pdfVisionPaths == null) {
      return;
    }

    setState(() => _busy = true);
    try {
      final importer = ref.read(studyDocumentImporterProvider);
      final repository = ref.read(studyRepositoryProvider);
      for (final path in paths) {
        final document = await importer.importFile(
          folderId: folderId,
          sourcePath: path,
          category: _categoryForName(p.basename(path)),
        );
        await repository.upsertDocument(
          document.kind == StudyDocumentKind.pdf &&
                  pdfVisionPaths.contains(path)
              ? await _documentWithPdfVision(document)
              : document,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<List<String>> _pickStudyFiles() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    return result?.files
            .map((file) => file.path)
            .nonNulls
            .toList(growable: false) ??
        const <String>[];
  }

  Future<List<String>> _expandImportPaths(List<String> paths) async {
    final files = <String>[];
    for (final path in paths) {
      final type = await FileSystemEntity.type(path);
      if (type == FileSystemEntityType.file) {
        files.add(path);
      } else if (type == FileSystemEntityType.directory) {
        final directory = Directory(path);
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File) {
            files.add(entity.path);
          }
        }
      }
    }
    return files;
  }

  Future<Set<String>?> _selectPdfVisionFiles(List<String> paths) async {
    final pdfPaths = paths
        .where((path) => p.extension(path).toLowerCase() == '.pdf')
        .toList(growable: false);
    if (pdfPaths.isEmpty || !mounted) {
      return <String>{};
    }

    final selected = <String>{};
    return showDialog<Set<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('PDF-Vision aktivieren?'),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wähle nur die PDFs aus, bei denen Bilder, Diagramme, Tabellen oder Handschrift per Gemini Vision analysiert werden sollen. Reine Text-PDFs können lokal bleiben.',
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final path in pdfPaths)
                        CheckboxListTile(
                          value: selected.contains(path),
                          onChanged: (value) => setDialogState(() {
                            if (value == true) {
                              selected.add(path);
                            } else {
                              selected.remove(path);
                            }
                          }),
                          title: Text(p.basename(path)),
                          subtitle: const Text(
                            'Aus: nur lokale Textextraktion · An: zusätzliche Gemini Vision Analyse',
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => setDialogState(() {
                selected
                  ..clear()
                  ..addAll(pdfPaths);
              }),
              child: const Text('Alle aktivieren'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(Set.of(selected)),
              child: const Text('Importieren'),
            ),
          ],
        ),
      ),
    );
  }

  Future<StudyDocument> _documentWithPdfVision(StudyDocument document) async {
    final mergedText = await _pdfTextWithVision(
      sourcePath: document.sourcePath,
      localText: document.extractedText,
    );
    return StudyDocument(
      id: document.id,
      folderId: document.folderId,
      title: document.title,
      kind: document.kind,
      sourcePath: document.sourcePath,
      category: document.category,
      extractedText: mergedText,
      createdAt: document.createdAt,
    );
  }

  Future<String> _pdfTextWithVision({
    required String sourcePath,
    required String localText,
  }) async {
    try {
      final analysis = await ref
          .read(studyAiServiceProvider)
          .analyzePdfVision(pdfPath: sourcePath, localText: localText);
      return _mergePdfTextAndVision(localText, analysis);
    } catch (error) {
      return _mergePdfTextAndVision(
        localText,
        '${StudyAiService.pdfVisionFailureHeading}\n$error',
      );
    }
  }

  String _mergePdfTextAndVision(String localText, String visualAnalysis) {
    final parts = <String>[];
    final cleanedLocal = _withoutPdfVision(localText).trim();
    if (cleanedLocal.isNotEmpty) {
      parts
        ..add('## Lokal extrahierter PDF-Text')
        ..add(cleanedLocal);
    }
    final cleanedVision = visualAnalysis.trim();
    if (cleanedVision.isNotEmpty) {
      if (cleanedVision.startsWith('## Visuelle PDF-Analyse')) {
        parts.add(cleanedVision);
      } else {
        parts
          ..add(StudyAiService.pdfVisionHeading)
          ..add(cleanedVision);
      }
    }
    return parts.join('\n\n').trim();
  }

  String _withoutPdfVision(String value) {
    final markers = [
      StudyAiService.pdfVisionHeading,
      StudyAiService.pdfVisionFailureHeading,
    ];
    var end = value.length;
    for (final marker in markers) {
      final index = value.indexOf(marker);
      if (index >= 0 && index < end) {
        end = index;
      }
    }
    return value.substring(0, end);
  }

  Future<void> _linkMeeting(String folderId) async {
    final meetings = await ref
        .read(meetingRepositoryProvider)
        .watchMeetings()
        .first;
    if (!mounted) {
      return;
    }
    final selected = await showDialog<Meeting>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add meeting as evidence'),
        children: [
          for (final meeting in meetings)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(meeting),
              child: Text(meeting.title),
            ),
        ],
      ),
    );
    if (selected == null) {
      return;
    }
    await ref.read(studyRepositoryProvider).linkMeeting(folderId, selected.id);
  }

  Future<void> _ask(String folderId) async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      return;
    }
    _questionController.clear();
    setState(() => _busy = true);
    final repository = ref.read(studyRepositoryProvider);
    final now = DateTime.now();
    await repository.saveChatMessage(
      StudyChatMessage(
        id: const Uuid().v7(),
        folderId: folderId,
        role: StudyChatRole.user,
        content: question,
        createdAt: now,
      ),
    );
    try {
      final answer = await ref
          .read(studyAiServiceProvider)
          .answer(
            question: question,
            context: await _buildContext(folderId),
            history: await ref.read(studyChatProvider(folderId).future),
          );
      await repository.saveChatMessage(
        StudyChatMessage(
          id: const Uuid().v7(),
          folderId: folderId,
          role: StudyChatRole.assistant,
          content: answer,
          createdAt: DateTime.now(),
        ),
      );
    } catch (error) {
      await repository.saveChatMessage(
        StudyChatMessage(
          id: const Uuid().v7(),
          folderId: folderId,
          role: StudyChatRole.assistant,
          content: _studyChatErrorMessage(error),
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  String _studyChatErrorMessage(Object error) {
    final text = error.toString().replaceFirst('Bad state: ', '').trim();
    return '''
**Antwort gerade nicht möglich**

- Der KI-Dienst konnte die Anfrage nicht beantworten.
- Ich habe die Anfrage bereits mit kleinerem Kontext erneut versucht.
- Bitte versuche es gleich nochmal oder reduziere die ausgewählten Unterlagen.

**Details**

```text
$text
```
''';
  }

  Future<void> _generateStudyAsset(
    String folderId, {
    required _StudyGenerationMode mode,
  }) async {
    setState(() => _busy = true);
    try {
      final context = await _buildContext(folderId);
      if (mode == _StudyGenerationMode.flashcards) {
        final cards = await ref
            .read(studyAiServiceProvider)
            .createFlashcards(context: context);
        setState(() {
          _flashcardsByFolder[folderId] = cards;
          _flippedCardsByFolder[folderId] = <int>{};
          _currentCardIndexByFolder[folderId] = 0;
          _selectedTab = _LearningTab.cards;
        });
      } else if (mode == _StudyGenerationMode.quiz) {
        final quiz = await ref
            .read(studyAiServiceProvider)
            .createQuiz(context: context);
        setState(() {
          _quizByFolder[folderId] = quiz;
          _quizSelectionsByFolder[folderId] = <int, int>{};
          _quizAnswersByFolder[folderId] = <int, int>{};
          _currentQuizIndexByFolder[folderId] = 0;
          _selectedTab = _LearningTab.quiz;
        });
      } else {
        final note = await ref
            .read(studyAiServiceProvider)
            .createStudyNote(context: context);
        setState(() {
          _studyNotesByFolder[folderId] = note;
          _selectedTab = _LearningTab.notes;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _exportStudyNote(String folderId, String? note) async {
    if (note == null || note.trim().isEmpty) {
      return;
    }
    final folders = await ref.read(studyRepositoryProvider).getFolders();
    final folder = folders.cast<StudyFolder?>().firstWhere(
      (item) => item?.id == folderId,
      orElse: () => null,
    );
    final title = folder?.name ?? 'Lernzettel';
    final bytes = await _StudyNotePdfExporter().export(
      title: title,
      note: note,
    );
    String? selectedDirectory;
    try {
      selectedDirectory = await FilePicker.getDirectoryPath();
    } catch (_) {
      selectedDirectory = null;
    }
    final directory = Directory(
      selectedDirectory ??
          p.join(
            (await getApplicationDocumentsDirectory()).path,
            'MeetlyAI',
            'exports',
          ),
    );
    await directory.create(recursive: true);
    final file = File(
      p.join(directory.path, '${_safeFileName(title)}-lernzettel.pdf'),
    );
    await file.writeAsBytes(bytes, flush: true);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lernzettel exportiert: ${file.path}')),
    );
  }

  static const _chunkSize = 10000;

  Future<List<StudyContextItem>> _buildContext(String folderId) async {
    final repository = ref.read(studyRepositoryProvider);
    final folderIds = await _folderAndDescendantIds(folderId);
    final documents = <StudyDocument>[];
    final links = <StudyMeetingLink>[];
    for (final id in folderIds) {
      documents.addAll(await repository.getDocuments(id));
      links.addAll(await ref.read(studyMeetingLinksProvider(id).future));
    }
    final items = <StudyContextItem>[];
    for (final document in documents) {
      final text = await _resolvedDocumentText(document);
      if (text.trim().isEmpty) {
        items.add(
          StudyContextItem(
            title: 'Datei: ${document.title}',
            kind: 'file/${document.kind.name}',
            content:
                '[Kein Text aus dieser Datei extrahiert: ${document.sourcePath}]',
          ),
        );
      } else {
        final chunks = _chunkText(
          text,
          'Datei: ${document.title}',
          'file/${document.kind.name}',
        );
        items.addAll(chunks);
      }
    }
    for (final link in links) {
      final meeting = await ref
          .read(meetingRepositoryProvider)
          .getMeeting(link.meetingId);
      final transcript = await ref
          .read(meetingRepositoryProvider)
          .getTranscript(link.meetingId);
      final content = transcript
          .map(
            (segment) =>
                '${segment.speakerLabel ?? segment.source.name}: ${segment.text}',
          )
          .join('\n');
      final chunks = _chunkText(
        content,
        meeting?.title ?? 'Meeting',
        'meeting',
      );
      items.addAll(chunks);
    }
    return items;
  }

  List<StudyContextItem> _chunkText(String text, String title, String kind) {
    if (text.length <= _chunkSize) {
      return [StudyContextItem(title: title, kind: kind, content: text)];
    }
    final paragraphs = text.split('\n\n');
    final chunks = <String>[];
    var current = StringBuffer();
    for (final paragraph in paragraphs) {
      if (current.length + paragraph.length > _chunkSize &&
          current.isNotEmpty) {
        chunks.add(current.toString().trim());
        current = StringBuffer();
      }
      if (paragraph.length > _chunkSize) {
        if (current.isNotEmpty) {
          chunks.add(current.toString().trim());
          current = StringBuffer();
        }
        for (final sentence in _splitSentences(paragraph)) {
          if (current.length + sentence.length > _chunkSize &&
              current.isNotEmpty) {
            chunks.add(current.toString().trim());
            current = StringBuffer();
          }
          current.write(sentence);
        }
      } else {
        if (current.isNotEmpty) current.write('\n\n');
        current.write(paragraph);
      }
    }
    if (current.isNotEmpty) {
      chunks.add(current.toString().trim());
    }
    return chunks.asMap().entries.map((entry) {
      final index = entry.key;
      final chunk = entry.value;
      final total = chunks.length;
      final suffix = total == 1 ? '' : ' (${index + 1}/$total)';
      return StudyContextItem(
        title: '$title$suffix',
        kind: kind,
        content: chunk,
      );
    }).toList();
  }

  List<String> _splitSentences(String text) {
    final result = <String>[];
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((text[i] == '.' || text[i] == '!' || text[i] == '?') &&
          (i + 1 >= text.length || text[i + 1] == ' ')) {
        result.add(buffer.toString());
        buffer.clear();
      }
    }
    if (buffer.isNotEmpty) result.add(buffer.toString());
    return result;
  }

  Future<String> _resolvedDocumentText(StudyDocument document) async {
    if (!_shouldRefreshExtractedText(document)) {
      return document.extractedText;
    }
    final extractedText = await ref
        .read(studyDocumentImporterProvider)
        .extractTextFromPath(document.sourcePath);
    final mergedText = extractedText;
    if (mergedText.trim().isEmpty ||
        mergedText.trim() == document.extractedText.trim()) {
      return document.extractedText;
    }
    await ref
        .read(studyRepositoryProvider)
        .upsertDocument(
          StudyDocument(
            id: document.id,
            folderId: document.folderId,
            title: document.title,
            kind: document.kind,
            sourcePath: document.sourcePath,
            category: document.category,
            extractedText: mergedText,
            createdAt: document.createdAt,
          ),
        );
    return mergedText;
  }

  bool _shouldRefreshExtractedText(StudyDocument document) {
    final text = document.extractedText.trim();
    return text.isEmpty;
  }

  Future<List<String>> _folderAndDescendantIds(String folderId) async {
    final folders = await ref.read(studyRepositoryProvider).getFolders();
    final children = <String?, List<StudyFolder>>{};
    for (final folder in folders) {
      children.putIfAbsent(folder.parentId, () => []).add(folder);
    }
    final ids = <String>[folderId];
    void visit(String parentId) {
      for (final child in children[parentId] ?? const <StudyFolder>[]) {
        ids.add(child.id);
        visit(child.id);
      }
    }

    visit(folderId);
    return ids;
  }

  String? _categoryForName(String name) {
    final extension = p.extension(name).replaceFirst('.', '').toUpperCase();
    return extension.isEmpty ? null : extension;
  }

  String _safeFileName(String value) {
    final sanitized = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9äöüß]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return sanitized.isEmpty ? 'lernzettel' : sanitized;
  }

  int _boundedIndex(int index, int length) {
    if (length <= 0) {
      return 0;
    }
    return math.min(math.max(0, index), length - 1);
  }

  ScrollController _chatScrollController(String folderId) {
    return _chatScrollControllersByFolder.putIfAbsent(
      folderId,
      ScrollController.new,
    );
  }
}

enum _StudyGenerationMode { flashcards, quiz, note }

enum _LearningTab { materials, notes, chat, cards, quiz }

class _LearningFolders extends StatelessWidget {
  const _LearningFolders({
    required this.foldersAsync,
    required this.selectedFolderId,
    required this.onCreate,
    required this.onCreateChild,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  final AsyncValue<List<StudyFolder>> foldersAsync;
  final String? selectedFolderId;
  final VoidCallback onCreate;
  final ValueChanged<String> onCreateChild;
  final ValueChanged<StudyFolder> onEdit;
  final ValueChanged<StudyFolder> onDelete;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15191F),
        border: Border.all(color: const Color(0xFF262D36)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lernen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'New folder',
                onPressed: onCreate,
                icon: const Icon(Icons.create_new_folder_outlined),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: foldersAsync.when(
              data: (folders) {
                if (folders.isEmpty) {
                  return const Center(child: Text('Create a folder to start.'));
                }
                final visibleFolders = _folderTree(folders);
                return ListView.separated(
                  itemCount: visibleFolders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = visibleFolders[index];
                    return _FolderTile(
                      folder: item.folder,
                      depth: item.depth,
                      selected: item.folder.id == selectedFolderId,
                      onTap: () => onSelect(item.folder.id),
                      onCreateChild: () => onCreateChild(item.folder.id),
                      onEdit: () => onEdit(item.folder),
                      onDelete: () => onDelete(item.folder),
                    );
                  },
                );
              },
              error: (error, _) => Text('Could not load folders: $error'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  List<_FolderTreeItem> _folderTree(List<StudyFolder> folders) {
    final folderIds = folders.map((folder) => folder.id).toSet();
    final children = <String?, List<StudyFolder>>{};
    for (final folder in folders) {
      final parentId = folderIds.contains(folder.parentId)
          ? folder.parentId
          : null;
      children.putIfAbsent(parentId, () => []).add(folder);
    }
    for (final entry in children.entries) {
      entry.value.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    final result = <_FolderTreeItem>[];
    final visited = <String>{};
    void visit(String? parentId, int depth) {
      for (final folder in children[parentId] ?? const <StudyFolder>[]) {
        if (!visited.add(folder.id)) {
          continue;
        }
        result.add(_FolderTreeItem(folder, depth));
        visit(folder.id, depth + 1);
      }
    }

    visit(null, 0);
    for (final folder in folders) {
      if (visited.add(folder.id)) {
        result.add(_FolderTreeItem(folder, 0));
      }
    }
    return result;
  }
}

class _FolderTreeItem {
  const _FolderTreeItem(this.folder, this.depth);

  final StudyFolder folder;
  final int depth;
}

class _FolderTile extends StatelessWidget {
  const _FolderTile({
    required this.folder,
    required this.depth,
    required this.selected,
    required this.onTap,
    required this.onCreateChild,
    required this.onEdit,
    required this.onDelete,
  });

  final StudyFolder folder;
  final int depth;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onCreateChild;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0),
      child: ListTile(
        selected: selected,
        selectedTileColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          depth == 0 ? Icons.folder_outlined : Icons.folder_copy_outlined,
        ),
        title: Text(folder.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton<_FolderAction>(
          tooltip: 'Ordneroptionen',
          icon: const Icon(Icons.more_horiz, size: 18),
          onSelected: (action) {
            switch (action) {
              case _FolderAction.addChild:
                onCreateChild();
              case _FolderAction.edit:
                onEdit();
              case _FolderAction.delete:
                onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _FolderAction.addChild,
              child: Text('Unterordner erstellen'),
            ),
            PopupMenuItem(value: _FolderAction.edit, child: Text('Umbenennen')),
            PopupMenuItem(value: _FolderAction.delete, child: Text('Löschen')),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

enum _FolderAction { addChild, edit, delete }

class _LearningWorkspace extends ConsumerWidget {
  const _LearningWorkspace({
    required this.folderId,
    required this.questionController,
    required this.chatScrollController,
    required this.busy,
    required this.selectedTab,
    required this.flashcards,
    required this.flippedCards,
    required this.quiz,
    required this.studyNote,
    required this.currentCardIndex,
    required this.currentQuizIndex,
    required this.quizSelections,
    required this.quizAnswers,
    required this.onTabChanged,
    required this.onFlipCard,
    required this.onPreviousCard,
    required this.onNextCard,
    required this.onSelectQuizAnswer,
    required this.onSubmitQuizAnswer,
    required this.onPreviousQuiz,
    required this.onNextQuiz,
    required this.onImport,
    required this.onLinkMeeting,
    required this.onAsk,
    required this.onFlashcards,
    required this.onQuiz,
    required this.onStudyNote,
    required this.onExportStudyNote,
    required this.onDropFiles,
  });

  final String folderId;
  final TextEditingController questionController;
  final ScrollController chatScrollController;
  final bool busy;
  final _LearningTab selectedTab;
  final List<StudyFlashcard> flashcards;
  final Set<int> flippedCards;
  final List<StudyQuizQuestion> quiz;
  final String? studyNote;
  final int currentCardIndex;
  final int currentQuizIndex;
  final Map<int, int> quizSelections;
  final Map<int, int> quizAnswers;
  final ValueChanged<_LearningTab> onTabChanged;
  final ValueChanged<int> onFlipCard;
  final VoidCallback onPreviousCard;
  final VoidCallback onNextCard;
  final void Function(int questionIndex, int optionIndex) onSelectQuizAnswer;
  final ValueChanged<int> onSubmitQuizAnswer;
  final VoidCallback onPreviousQuiz;
  final VoidCallback onNextQuiz;
  final VoidCallback onImport;
  final VoidCallback onLinkMeeting;
  final VoidCallback onAsk;
  final VoidCallback onFlashcards;
  final VoidCallback onQuiz;
  final VoidCallback onStudyNote;
  final VoidCallback onExportStudyNote;
  final ValueChanged<List<String>> onDropFiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(studyDocumentsProvider(folderId));
    final links = ref.watch(studyMeetingLinksProvider(folderId));
    final chat = ref.watch(studyChatProvider(folderId));
    final folders = ref.watch(studyFoldersProvider);

    return Column(
      children: [
        _LearningTabs(
          selected: selectedTab,
          cardCount: flashcards.length,
          quizCount: quiz.length,
          onSelected: onTabChanged,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: switch (selectedTab) {
              _LearningTab.materials => _EvidencePanel(
                documents: documents,
                links: links,
                folders: folders,
                busy: busy,
                onImport: onImport,
                onLinkMeeting: onLinkMeeting,
                onDropFiles: onDropFiles,
              ),
              _LearningTab.notes => _StudyNotePanel(
                key: const ValueKey('notes'),
                note: studyNote,
                busy: busy,
                onGenerate: onStudyNote,
                onExport: onExportStudyNote,
              ),
              _LearningTab.chat => _StudyChatPanel(
                chat: chat,
                controller: questionController,
                scrollController: chatScrollController,
                busy: busy,
                onAsk: onAsk,
              ),
              _LearningTab.cards => _FlashcardPanel(
                key: const ValueKey('cards'),
                cards: flashcards,
                flipped: flippedCards,
                currentIndex: currentCardIndex,
                busy: busy,
                onGenerate: onFlashcards,
                onFlip: onFlipCard,
                onPrevious: onPreviousCard,
                onNext: onNextCard,
              ),
              _LearningTab.quiz => _QuizPanel(
                key: const ValueKey('quiz'),
                questions: quiz,
                currentIndex: currentQuizIndex,
                selections: quizSelections,
                answers: quizAnswers,
                busy: busy,
                onGenerate: onQuiz,
                onSelect: onSelectQuizAnswer,
                onSubmit: onSubmitQuizAnswer,
                onPrevious: onPreviousQuiz,
                onNext: onNextQuiz,
              ),
            },
          ),
        ),
      ],
    );
  }
}

class _LearningTabs extends StatelessWidget {
  const _LearningTabs({
    required this.selected,
    required this.cardCount,
    required this.quizCount,
    required this.onSelected,
  });

  final _LearningTab selected;
  final int cardCount;
  final int quizCount;
  final ValueChanged<_LearningTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xE60F1217),
            border: Border.all(color: const Color(0xFF252B33)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SegmentedButton<_LearningTab>(
            selected: {selected},
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              side: const WidgetStatePropertyAll(BorderSide.none),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            segments: [
              const ButtonSegment(
                value: _LearningTab.materials,
                icon: Icon(Icons.folder_copy_outlined, size: 18),
                label: Text('Unterlagen'),
              ),
              const ButtonSegment(
                value: _LearningTab.chat,
                icon: Icon(Icons.forum_outlined, size: 18),
                label: Text('Chat'),
              ),
              const ButtonSegment(
                value: _LearningTab.notes,
                icon: Icon(Icons.menu_book_outlined, size: 18),
                label: Text('Lernzettel'),
              ),
              ButtonSegment(
                value: _LearningTab.cards,
                icon: const Icon(Icons.style_outlined, size: 18),
                label: Text(cardCount == 0 ? 'Karten' : 'Karten $cardCount'),
              ),
              ButtonSegment(
                value: _LearningTab.quiz,
                icon: const Icon(Icons.quiz_outlined, size: 18),
                label: Text(quizCount == 0 ? 'Quiz' : 'Quiz $quizCount'),
              ),
            ],
            onSelectionChanged: (value) => onSelected(value.first),
          ),
        ),
      ),
    );
  }
}

class _DropImportSurface extends StatefulWidget {
  const _DropImportSurface({
    required this.enabled,
    required this.onDropFiles,
    required this.child,
  });

  final bool enabled;
  final ValueChanged<List<String>> onDropFiles;
  final Widget child;

  @override
  State<_DropImportSurface> createState() => _DropImportSurfaceState();
}

class _DropImportSurfaceState extends State<_DropImportSurface> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: widget.enabled,
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: (detail) {
        setState(() => _dragging = false);
        final paths = detail.files
            .map((file) => file.path)
            .where((path) => path.isNotEmpty)
            .toList(growable: false);
        if (paths.isNotEmpty) {
          widget.onDropFiles(paths);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          IgnorePointer(
            ignoring: !_dragging,
            child: AnimatedOpacity(
              opacity: _dragging ? 1 : 0,
              duration: const Duration(milliseconds: 140),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xE610141A),
                      border: Border.all(color: const Color(0xFF2B333D)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        const Text('Dateien in diesen Ordner importieren'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidencePanel extends ConsumerWidget {
  const _EvidencePanel({
    required this.documents,
    required this.links,
    required this.folders,
    required this.busy,
    required this.onImport,
    required this.onLinkMeeting,
    required this.onDropFiles,
  });

  final AsyncValue<List<StudyDocument>> documents;
  final AsyncValue<List<StudyMeetingLink>> links;
  final AsyncValue<List<StudyFolder>> folders;
  final bool busy;
  final VoidCallback onImport;
  final VoidCallback onLinkMeeting;
  final ValueChanged<List<String>> onDropFiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetings = ref.watch(allMeetingsProvider).value ?? const <Meeting>[];
    final meetingTitles = {
      for (final meeting in meetings) meeting.id: meeting.title,
    };
    return _DropImportSurface(
      enabled: !busy,
      onDropFiles: onDropFiles,
      child: _Panel(
        title: 'Evidence',
        trailing: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              onPressed: busy ? null : onImport,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload'),
            ),
            FilledButton.icon(
              onPressed: busy ? null : onLinkMeeting,
              icon: const Icon(Icons.forum_outlined, size: 18),
              label: const Text('Meeting'),
            ),
          ],
        ),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10141A),
                border: Border.all(color: const Color(0xFF252D37)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.privacy_tip_outlined, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Du kannst Dateien hier hineinziehen. PDF-Vision ist pro PDF optional und sendet nur ausgewählte PDF-Inhalte an Gemini. Meeting-Transkription bleibt lokal.',
                    ),
                  ),
                ],
              ),
            ),
            documents.when(
              data: (items) => Column(
                children: [
                  for (final item in items)
                    _EvidenceTile(
                      icon: _documentIcon(item.kind),
                      title: item.title,
                      subtitle: _documentSubtitle(item),
                      menuItems: [
                        if (item.kind == StudyDocumentKind.pdf)
                          PopupMenuItem(
                            onTap: () {
                              final messenger = ScaffoldMessenger.of(context);
                              Future<void>.delayed(
                                Duration.zero,
                                () => _analyzePdfVision(messenger, ref, item),
                              );
                            },
                            child: const Text('PDF-Vision analysieren'),
                          ),
                        PopupMenuItem(
                          onTap: () => _editDocument(context, ref, item),
                          child: const Text('Edit category / folder'),
                        ),
                        PopupMenuItem(
                          onTap: () => ref
                              .read(studyRepositoryProvider)
                              .deleteDocument(item.id),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                ],
              ),
              error: (error, _) => Text('$error'),
              loading: () => const LinearProgressIndicator(),
            ),
            const SizedBox(height: 10),
            links.when(
              data: (items) => Column(
                children: [
                  for (final item in items)
                    _EvidenceTile(
                      icon: Icons.forum_outlined,
                      title: meetingTitles[item.meetingId] ?? 'Meeting',
                      subtitle: 'Recorded meeting',
                      menuItems: [
                        PopupMenuItem(
                          onTap: () => ref
                              .read(studyRepositoryProvider)
                              .unlinkMeeting(item.id),
                          child: const Text('Remove'),
                        ),
                      ],
                    ),
                ],
              ),
              error: (error, _) => Text('$error'),
              loading: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _documentIcon(StudyDocumentKind kind) {
    return switch (kind) {
      StudyDocumentKind.pdf => Icons.picture_as_pdf_outlined,
      StudyDocumentKind.markdown => Icons.article_outlined,
      StudyDocumentKind.text => Icons.subject_outlined,
      StudyDocumentKind.other => Icons.insert_drive_file_outlined,
    };
  }

  Future<void> _analyzePdfVision(
    ScaffoldMessengerState messenger,
    WidgetRef ref,
    StudyDocument document,
  ) async {
    messenger.showSnackBar(
      SnackBar(content: Text('Analysiere ${document.title} mit PDF-Vision...')),
    );
    try {
      final localText = _withoutPdfVision(document.extractedText);
      final analysis = await ref
          .read(studyAiServiceProvider)
          .analyzePdfVision(pdfPath: document.sourcePath, localText: localText);
      await ref
          .read(studyRepositoryProvider)
          .upsertDocument(
            StudyDocument(
              id: document.id,
              folderId: document.folderId,
              title: document.title,
              kind: document.kind,
              sourcePath: document.sourcePath,
              category: document.category,
              extractedText: _mergePdfTextAndVision(localText, analysis),
              createdAt: document.createdAt,
            ),
          );
      messenger.showSnackBar(
        SnackBar(content: Text('PDF-Vision abgeschlossen: ${document.title}')),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('PDF-Vision fehlgeschlagen: $error')),
      );
    }
  }

  String _mergePdfTextAndVision(String localText, String visualAnalysis) {
    final parts = <String>[];
    final cleanedLocal = _withoutPdfVision(localText).trim();
    if (cleanedLocal.isNotEmpty) {
      parts
        ..add('## Lokal extrahierter PDF-Text')
        ..add(cleanedLocal);
    }
    final cleanedVision = visualAnalysis.trim();
    if (cleanedVision.isNotEmpty) {
      if (cleanedVision.startsWith(StudyAiService.pdfVisionHeading)) {
        parts.add(cleanedVision);
      } else {
        parts
          ..add(StudyAiService.pdfVisionHeading)
          ..add(cleanedVision);
      }
    }
    return parts.join('\n\n').trim();
  }

  String _withoutPdfVision(String value) {
    final markers = [
      StudyAiService.pdfVisionHeading,
      StudyAiService.pdfVisionFailureHeading,
    ];
    var end = value.length;
    for (final marker in markers) {
      final index = value.indexOf(marker);
      if (index >= 0 && index < end) {
        end = index;
      }
    }
    return value.substring(0, end);
  }

  String _documentSubtitle(StudyDocument item) {
    final status = switch (item.kind) {
      StudyDocumentKind.pdf
          when item.extractedText.contains(StudyAiService.pdfVisionHeading) =>
        'Text + visuelle Analyse abgeschlossen',
      StudyDocumentKind.pdf
          when item.extractedText.contains(
            StudyAiService.pdfVisionFailureHeading,
          ) =>
        'Text extrahiert · visuelle Analyse fehlt',
      StudyDocumentKind.pdf when item.extractedText.trim().isNotEmpty =>
        'Text extrahiert',
      StudyDocumentKind.pdf => 'Noch kein analysierbarer PDF-Inhalt',
      _ => 'Text extrahiert',
    };
    return '${item.category ?? item.kind.name} · $status · ${item.extractedText.length} chars';
  }

  Future<void> _editDocument(
    BuildContext context,
    WidgetRef ref,
    StudyDocument document,
  ) async {
    final availableFolders = folders.value ?? const <StudyFolder>[];
    var title = document.title;
    var category = document.category ?? '';
    var folderId = document.folderId;
    final updated = await showDialog<StudyDocument>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit material'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: document.title,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: document.category ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Exam, chapter 2, formulas...',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  onChanged: (value) => category = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: folderId,
                  decoration: const InputDecoration(
                    labelText: 'Folder',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  items: [
                    for (final folder in availableFolders)
                      DropdownMenuItem(
                        value: folder.id,
                        child: Text(folder.name),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => folderId = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                StudyDocument(
                  id: document.id,
                  folderId: folderId,
                  title: title.trim().isEmpty ? document.title : title.trim(),
                  kind: document.kind,
                  sourcePath: document.sourcePath,
                  category: category.trim().isEmpty ? null : category.trim(),
                  extractedText: document.extractedText,
                  createdAt: document.createdAt,
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (updated != null) {
      await ref.read(studyRepositoryProvider).upsertDocument(updated);
    }
  }
}

class _StudyChatPanel extends StatefulWidget {
  const _StudyChatPanel({
    required this.chat,
    required this.controller,
    required this.scrollController,
    required this.busy,
    required this.onAsk,
  });

  final AsyncValue<List<StudyChatMessage>> chat;
  final TextEditingController controller;
  final ScrollController scrollController;
  final bool busy;
  final VoidCallback onAsk;

  @override
  State<_StudyChatPanel> createState() => _StudyChatPanelState();
}

class _StudyChatPanelState extends State<_StudyChatPanel> {
  int _lastMessageCount = 0;
  bool _showJumpToBottom = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(_StudyChatPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScroll);
      widget.scrollController.addListener(_handleScroll);
      _lastMessageCount = 0;
      _showJumpToBottom = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.chat.value ?? const <StudyChatMessage>[];
    _scheduleAutoScroll(messages.length);
    return _Panel(
      title: 'Ask your material',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF10141A),
              border: Border.all(color: const Color(0xFF252D37)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.policy_outlined, size: 18, color: Color(0xFF9AA4B2)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Antworten verwenden nur Dateien und Meetings aus diesem Ordner inklusive Unterordnern.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
              children: [
                widget.chat.when(
                  data: (messages) => ListView.builder(
                    controller: widget.scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Align(
                        alignment: message.role == StudyChatRole.user
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 760),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: message.role == StudyChatRole.user
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.14)
                                : const Color(0xFF111419),
                            border: Border.all(color: const Color(0xFF2B333D)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: message.role == StudyChatRole.assistant
                              ? ChatMarkdown(message.content)
                              : Text(message.content),
                        ),
                      );
                    },
                  ),
                  error: (error, _) => Text('$error'),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
                if (_showJumpToBottom)
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: _JumpToBottomButton(onPressed: _scrollToBottom),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF15191F),
              border: Border(top: BorderSide(color: Color(0xFF262D36))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.enter): () {
                        if (!widget.busy) {
                          widget.onAsk();
                          _scrollToBottom();
                        }
                      },
                    },
                    child: TextField(
                      controller: widget.controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        if (!widget.busy) {
                          widget.onAsk();
                          _scrollToBottom();
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Ask only about these files and meetings...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: widget.busy
                      ? null
                      : () {
                          widget.onAsk();
                          _scrollToBottom();
                        },
                  icon: widget.busy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scheduleAutoScroll(int messageCount) {
    final changed = messageCount != _lastMessageCount;
    _lastMessageCount = messageCount;
    if (changed || !widget.scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  Future<void> _scrollToBottom({int attempt = 0}) async {
    if (!widget.scrollController.hasClients || !mounted) {
      return;
    }
    final position = widget.scrollController.position;
    final target = _safeMaxScrollExtent(position);
    if (target == null) {
      if (attempt >= 8) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToBottom(attempt: attempt + 1),
      );
      return;
    }
    await widget.scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _handleScroll() {
    if (!widget.scrollController.hasClients ||
        _safeMaxScrollExtent(widget.scrollController.position) == null) {
      return;
    }
    final position = widget.scrollController.position;
    final show = _safeMaxScrollExtent(position)! - position.pixels > 120;
    if (show != _showJumpToBottom && mounted) {
      setState(() => _showJumpToBottom = show);
    }
  }

  double? _safeMaxScrollExtent(ScrollPosition position) {
    if (!position.hasContentDimensions) {
      return null;
    }
    try {
      return position.maxScrollExtent;
    } on Object {
      return null;
    }
  }
}

class _StudyNotePanel extends StatelessWidget {
  const _StudyNotePanel({
    super.key,
    required this.note,
    required this.busy,
    required this.onGenerate,
    required this.onExport,
  });

  final String? note;
  final bool busy;
  final VoidCallback onGenerate;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final hasNote = note != null && note!.trim().isNotEmpty;
    return _Panel(
      title: 'Lernzettel',
      trailing: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.tonalIcon(
            onPressed: busy ? null : onGenerate,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: Text(hasNote ? 'Neu erstellen' : 'Erstellen'),
          ),
          FilledButton.icon(
            onPressed: busy || !hasNote ? null : onExport,
            icon: const Icon(Icons.ios_share, size: 18),
            label: const Text('PDF exportieren'),
          ),
        ],
      ),
      child: hasNote
          ? _StudyNoteDocument(note: note!)
          : const _LearningPlaceholder(
              icon: Icons.menu_book_outlined,
              title: 'Noch kein Lernzettel',
              message:
                  'Erstelle aus den Dokumenten in diesem Ordner einen strukturierten Lernzettel. Meetings werden hierfür bewusst nicht verwendet.',
            ),
    );
  }
}

class _JumpToBottomButton extends StatelessWidget {
  const _JumpToBottomButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton.filledTonal(
        tooltip: 'Nach unten',
        onPressed: onPressed,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}

class _StudyNoteDocument extends StatelessWidget {
  const _StudyNoteDocument({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final blocks = _noteBlocks(note);
    return ListView.separated(
      padding: const EdgeInsets.only(right: 4, bottom: 12),
      itemCount: blocks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => blocks[index],
    );
  }

  List<Widget> _noteBlocks(String value) {
    final widgets = <Widget>[];
    final bulletBuffer = <String>[];
    void flushBullets() {
      if (bulletBuffer.isEmpty) {
        return;
      }
      widgets.add(_NoteBulletCard(items: List.of(bulletBuffer)));
      bulletBuffer.clear();
    }

    for (final rawLine in value.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) {
        flushBullets();
        continue;
      }
      final heading = RegExp(r'^(#{1,4})\s+(.+)$').firstMatch(line);
      if (heading != null) {
        flushBullets();
        widgets.add(
          _NoteHeading(
            text: heading.group(2)!.trim(),
            level: heading.group(1)!.length,
          ),
        );
        continue;
      }
      final bullet = line.replaceFirst(RegExp(r'^[-*•]\s+'), '');
      if (bullet != line) {
        bulletBuffer.add(bullet);
        continue;
      }
      flushBullets();
      widgets.add(_NoteParagraph(text: line));
    }
    flushBullets();
    return widgets.isEmpty ? [const _NoteParagraph(text: '-')] : widgets;
  }
}

class _NoteHeading extends StatelessWidget {
  const _NoteHeading({required this.text, required this.level});

  final String text;
  final int level;

  @override
  Widget build(BuildContext context) {
    final style = level <= 1
        ? Theme.of(context).textTheme.headlineSmall
        : Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: EdgeInsets.only(top: level <= 1 ? 4 : 10),
      child: Text(
        text.replaceAll(RegExp(r'\*\*'), ''),
        style: style?.copyWith(fontWeight: FontWeight.w900, height: 1.2),
      ),
    );
  }
}

class _NoteParagraph extends StatelessWidget {
  const _NoteParagraph({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.replaceAll(RegExp(r'\*\*'), ''),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
      ),
    );
  }
}

class _NoteBulletCard extends StatelessWidget {
  const _NoteBulletCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.replaceAll(RegExp(r'\*\*'), ''),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FlashcardPanel extends StatelessWidget {
  const _FlashcardPanel({
    super.key,
    required this.cards,
    required this.flipped,
    required this.currentIndex,
    required this.busy,
    required this.onGenerate,
    required this.onFlip,
    required this.onPrevious,
    required this.onNext,
  });

  final List<StudyFlashcard> cards;
  final Set<int> flipped;
  final int currentIndex;
  final bool busy;
  final VoidCallback onGenerate;
  final ValueChanged<int> onFlip;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Karteikarten',
      trailing: FilledButton.tonalIcon(
        onPressed: busy ? null : onGenerate,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: Text(cards.isEmpty ? 'Generieren' : 'Neu generieren'),
      ),
      child: cards.isEmpty
          ? const _LearningPlaceholder(
              icon: Icons.style_outlined,
              title: 'Noch keine Karten',
              message:
                  'Generiere Karteikarten aus den Unterlagen und verknüpften Meetings in diesem Ordner.',
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 680,
                        maxHeight: 420,
                      ),
                      child: _FlipCard(
                        card: cards[currentIndex],
                        flipped: flipped.contains(currentIndex),
                        onTap: () => onFlip(currentIndex),
                      ),
                    ),
                  ),
                ),
                _StudyStepper(
                  label: '${currentIndex + 1} / ${cards.length}',
                  onPrevious: currentIndex == 0 ? null : onPrevious,
                  onNext: currentIndex >= cards.length - 1 ? null : onNext,
                ),
              ],
            ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  const _FlipCard({
    required this.card,
    required this.flipped,
    required this.onTap,
  });

  final StudyFlashcard card;
  final bool flipped;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: flipped ? math.pi : 0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          final showBack = value > math.pi / 2;
          final visibleValue = showBack ? math.pi - value : value;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(visibleValue),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: showBack
                    ? const Color(0xFF10211F)
                    : const Color(0xFF111419),
                border: Border.all(
                  color: showBack
                      ? const Color(0xFF2B8A78)
                      : const Color(0xFF2B333D),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        showBack ? Icons.lightbulb_outline : Icons.help_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        showBack ? 'Antwort' : 'Frage',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF9AA4B2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Center(
                      child: Text(
                        showBack ? card.answer : card.question,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                      ),
                    ),
                  ),
                  Text(
                    'Quelle: ${card.source}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF9AA4B2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuizPanel extends StatelessWidget {
  const _QuizPanel({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.selections,
    required this.answers,
    required this.busy,
    required this.onGenerate,
    required this.onSelect,
    required this.onSubmit,
    required this.onPrevious,
    required this.onNext,
  });

  final List<StudyQuizQuestion> questions;
  final int currentIndex;
  final Map<int, int> selections;
  final Map<int, int> answers;
  final bool busy;
  final VoidCallback onGenerate;
  final void Function(int questionIndex, int optionIndex) onSelect;
  final ValueChanged<int> onSubmit;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Quiz',
      trailing: FilledButton.tonalIcon(
        onPressed: busy ? null : onGenerate,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: Text(questions.isEmpty ? 'Generieren' : 'Neu generieren'),
      ),
      child: questions.isEmpty
          ? const _LearningPlaceholder(
              icon: Icons.quiz_outlined,
              title: 'Noch kein Quiz',
              message:
                  'Erzeuge Multiple-Choice-Fragen aus genau diesen Unterlagen und Meetings.',
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 780),
                        child: _QuizQuestionCard(
                          index: currentIndex,
                          total: questions.length,
                          question: questions[currentIndex],
                          selected: selections[currentIndex],
                          submitted: answers[currentIndex],
                          onSelect: (option) => onSelect(currentIndex, option),
                          onSubmit: selections[currentIndex] == null
                              ? null
                              : () => onSubmit(currentIndex),
                        ),
                      ),
                    ),
                  ),
                ),
                _StudyStepper(
                  label: '${currentIndex + 1} / ${questions.length}',
                  onPrevious: currentIndex == 0 ? null : onPrevious,
                  onNext: currentIndex >= questions.length - 1 ? null : onNext,
                ),
              ],
            ),
    );
  }
}

class _QuizQuestionCard extends StatelessWidget {
  const _QuizQuestionCard({
    required this.index,
    required this.total,
    required this.question,
    required this.selected,
    required this.submitted,
    required this.onSelect,
    required this.onSubmit,
  });

  final int index;
  final int total;
  final StudyQuizQuestion question;
  final int? selected;
  final int? submitted;
  final ValueChanged<int> onSelect;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final answered = submitted != null;
    final correct = submitted == question.correctIndex;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frage ${index + 1} von $total',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9AA4B2),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.question,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final option in question.options.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _QuizOption(
                text: option.$2,
                selected: selected == option.$1,
                correct: answered && option.$1 == question.correctIndex,
                wrong:
                    answered &&
                    submitted == option.$1 &&
                    submitted != question.correctIndex,
                onTap: answered ? null : () => onSelect(option.$1),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: answered ? null : onSubmit,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Antwort abschicken'),
            ),
          ),
          if (answered) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: correct
                    ? const Color(0xFF0E231B)
                    : const Color(0xFF2A1818),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: correct
                      ? const Color(0xFF2B8A78)
                      : const Color(0xFF8A3A3A),
                ),
              ),
              child: Text(
                correct
                    ? 'Richtig. ${question.explanation}'
                    : 'Nicht ganz. Richtig ist: ${question.options[question.correctIndex]}\n${question.explanation}',
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Quelle: ${question.source}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9AA4B2)),
          ),
        ],
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.text,
    required this.selected,
    required this.correct,
    required this.wrong,
    this.onTap,
  });

  final String text;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = correct
        ? const Color(0xFF2B8A78)
        : wrong
        ? const Color(0xFF8A3A3A)
        : selected
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFF2B333D);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              correct
                  ? Icons.check_circle_outline
                  : wrong
                  ? Icons.cancel_outlined
                  : selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}

class _StudyStepper extends StatelessWidget {
  const _StudyStepper({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Previous',
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          SizedBox(
            width: 86,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            tooltip: 'Next',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _LearningPlaceholder extends StatelessWidget {
  const _LearningPlaceholder({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: const Color(0xFF9AA4B2)),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9AA4B2)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15191F),
        border: Border.all(color: const Color(0xFF262D36)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (trailing != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: trailing!,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _EvidenceTile extends StatelessWidget {
  const _EvidenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.menuItems = const [],
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<PopupMenuEntry<void>> menuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9AA4B2),
                  ),
                ),
              ],
            ),
          ),
          if (menuItems.isNotEmpty)
            PopupMenuButton<void>(
              tooltip: 'More',
              itemBuilder: (context) => menuItems,
              icon: const Icon(Icons.more_horiz, size: 18),
            ),
        ],
      ),
    );
  }
}

class _LearningEmpty extends StatelessWidget {
  const _LearningEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Create or select a learning folder.',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: const Color(0xFF9AA4B2)),
      ),
    );
  }
}

class _StudyNotePdfExporter {
  static const _ink = PdfColor.fromInt(0xFF111827);
  static const _muted = PdfColor.fromInt(0xFF6B7280);
  static const _line = PdfColor.fromInt(0xFFE5E7EB);
  static const _soft = PdfColor.fromInt(0xFFF8FAFC);
  static const _accent = PdfColor.fromInt(0xFF0F766E);

  Future<List<int>> export({
    required String title,
    required String note,
  }) async {
    final regularFont = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        header: (_) => pw.Container(
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(
            'MeetlyAI Lernen',
            style: pw.TextStyle(
              color: _accent,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(color: _muted, fontSize: 9),
          ),
        ),
        build: (_) => [
          _hero(title),
          pw.SizedBox(height: 16),
          ..._noteWidgets(note),
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _hero(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: _ink,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$title - Lernzettel',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            DateTime.now().toIso8601String(),
            style: const pw.TextStyle(
              color: PdfColor.fromInt(0xFFCBD5E1),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _noteWidgets(String note) {
    final widgets = <pw.Widget>[];
    final bullets = <String>[];
    void flushBullets() {
      if (bullets.isEmpty) {
        return;
      }
      widgets.add(_bulletCard(List.of(bullets)));
      bullets.clear();
    }

    for (final rawLine in note.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) {
        flushBullets();
        continue;
      }
      final heading = RegExp(r'^(#{1,4})\s+(.+)$').firstMatch(line);
      if (heading != null) {
        flushBullets();
        widgets.add(
          _heading(
            heading.group(2)!.replaceAll(RegExp(r'\*\*'), '').trim(),
            heading.group(1)!.length,
          ),
        );
        continue;
      }
      final bullet = line.replaceFirst(RegExp(r'^[-*•]\s+'), '');
      if (bullet != line) {
        bullets.add(bullet.replaceAll(RegExp(r'\*\*'), ''));
        continue;
      }
      flushBullets();
      widgets.add(_paragraph(line.replaceAll(RegExp(r'\*\*'), '')));
    }
    flushBullets();
    return widgets;
  }

  pw.Widget _heading(String text, int level) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(top: level <= 1 ? 10 : 14, bottom: 7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: _ink,
          fontSize: level <= 1 ? 18 : 13,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _paragraph(String text) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _soft,
        border: pw.Border.all(color: _line),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(text, style: _bodyStyle()),
    );
  }

  pw.Widget _bulletCard(List<String> bullets) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _soft,
        border: pw.Border.all(color: _line),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (final bullet in bullets)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 4,
                    height: 4,
                    margin: const pw.EdgeInsets.only(top: 5),
                    decoration: const pw.BoxDecoration(
                      color: _accent,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.SizedBox(width: 7),
                  pw.Expanded(child: pw.Text(bullet, style: _bodyStyle())),
                ],
              ),
            ),
        ],
      ),
    );
  }

  pw.TextStyle _bodyStyle() {
    return const pw.TextStyle(color: _ink, fontSize: 10, lineSpacing: 2);
  }
}
