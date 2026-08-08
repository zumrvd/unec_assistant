enum PaperSkin { plain, ruled, grid, dotted, cream, blue }

class Note {
  final String noteId;
  final String folderId;
  final String title;
  final String content;
  final PaperSkin paperSkin;
  final DateTime updatedAt;

  const Note({
    required this.noteId,
    required this.folderId,
    required this.title,
    required this.content,
    required this.paperSkin,
    required this.updatedAt,
  });

  Note copyWith({
    String? title,
    String? content,
    PaperSkin? paperSkin,
    DateTime? updatedAt
  }) {
    return Note(
      noteId: noteId,
      folderId: folderId,
      title: title ?? this.title,
      content: content ?? this.content,
      paperSkin: paperSkin ?? this.paperSkin,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'folderId': folderId,
      'title': title,
      'content': content,
      'paperSkin': paperSkin.name,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'] as String,
      folderId: json['folderId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      paperSkin: PaperSkin.values.byName(
        json['paperSkin'] as String? ?? 'plain',
      ),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
