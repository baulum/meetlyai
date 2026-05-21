import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const textColor = Color(0xFFE7EAEE);
    const muted = Color(0xFFB8C0CC);
    const line = Color(0xFF2B333D);
    const panel = Color(0xFF0D1117);
    return MarkdownBody(
      data: data,
      selectable: true,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: theme.textTheme.bodyMedium?.copyWith(color: textColor, height: 1.45),
        h1: theme.textTheme.titleLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w900,
        ),
        h2: theme.textTheme.titleMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w900,
        ),
        h3: theme.textTheme.titleSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
        strong: const TextStyle(color: textColor, fontWeight: FontWeight.w800),
        em: const TextStyle(color: muted, fontStyle: FontStyle.italic),
        listBullet: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        code: theme.textTheme.bodySmall?.copyWith(
          color: const Color(0xFF9FE7D2),
          backgroundColor: panel,
          fontFamily: 'monospace',
        ),
        tableHead: theme.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w900,
        ),
        tableBody: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          height: 1.35,
        ),
        tableBorder: TableBorder.all(color: line, width: 0.8),
        tableCellsPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        blockquote: theme.textTheme.bodyMedium?.copyWith(
          color: muted,
          height: 1.4,
        ),
        blockquoteDecoration: BoxDecoration(
          color: panel,
          border: const Border(left: BorderSide(color: muted, width: 3)),
          borderRadius: BorderRadius.circular(6),
        ),
        codeblockDecoration: BoxDecoration(
          color: panel,
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
